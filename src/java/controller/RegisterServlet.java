/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.RegisterValidator;
import utils.ValidationResult;
import utils.Validator;

/**
 *
 * @author qp
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/guest/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        UserDAO dao = new UserDAO();

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String roleStr = request.getParameter("role");

        String error = RegisterValidator.validateRegistration(email, password, confirmPassword, fullName, phone);
        
        //kiem tra trung email
        if (dao.getUserByEmail(email) != null) {
            request.setAttribute("error", "Email đã tồn tại!");
            request.getRequestDispatcher("view/guest/register.jsp").forward(request, response);
            return;
        }
        
        if (error != null && !error.isEmpty()) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("view/guest/register.jsp").forward(request, response);
            return;
        }

        int roleID;
        try {
            roleID = Integer.parseInt(roleStr);
        } catch (NumberFormatException e) {
            roleID = 2;
        }
        boolean ok = dao.register(email, password, fullName, phone, roleID);

        if (ok) {
            // PRG pattern tránh submit lại
            request.getSession().setAttribute("message", "Tạo tài khoản thành công. Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            request.setAttribute("message", "Không thể tạo tài khoản (email có thể đã tồn tại).");
            request.getRequestDispatcher("view/guest/register.jsp").forward(request, response);
        }
    }

}
