package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.LoginValidator;

/**
 *
 * @author qp
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String error = LoginValidator.validateLogin(email, password);
        if (!error.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("error", error);
            session.setAttribute("email", email);
            response.sendRedirect("index.jsp");
            return;
        }

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);
        if (user != null) {
            //login thanh cong
            HttpSession session = request.getSession();
            session.removeAttribute("email");
            session.setAttribute("acc", user);
            response.sendRedirect("view/guest/home.jsp");
        } else {
            //login fail
            HttpSession session = request.getSession();
            session.setAttribute("error", "Invalid email or password! Please try again!");
            session.setAttribute("email", email);
            response.sendRedirect("index.jsp");
        }
    }

}
