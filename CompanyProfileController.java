package controller.employer;

import dal.employer.CompanyDAO; // <-- dùng đúng package bạn đang có
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Company;

@WebServlet(name = "CompanyProfileController", urlPatterns = {"/employer/company"})
public class CompanyProfileController extends HttpServlet {

    private Integer sessionCompanyId(HttpServletRequest request) {
        HttpSession s = request.getSession();
        Object v = s.getAttribute("companyID");
        return (v instanceof Integer) ? (Integer) v : null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer companyID = sessionCompanyId(request);
        if (companyID == null) {
            response.sendRedirect("EmployerLogin");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        CompanyDAO dao = new CompanyDAO();
        Company c = dao.getCompanyById(companyID);
        request.setAttribute("company", c);

        String jsp = "view/employer/company-profile.jsp";
        if ("edit".equals(action)) {
            jsp = "view/employer/company-edit.jsp";
        }

        RequestDispatcher rd = request.getRequestDispatcher(jsp);
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer companyID = sessionCompanyId(request);
        if (companyID == null) {
            response.sendRedirect("EmployerLogin");
            return;
        }

        String action = request.getParameter("action");
        CompanyDAO dao = new CompanyDAO();

        if ("update".equals(action)) {
            Company c = new Company();
            c.setCompanyID(companyID);
            c.setName(request.getParameter("name"));
            c.setDescription(request.getParameter("description"));
            c.setIndustry(request.getParameter("industry"));
            c.setSize(request.getParameter("size"));
            c.setCity(request.getParameter("city"));
            c.setAddress(request.getParameter("address"));
            c.setWebsite(request.getParameter("website"));
            // logo KHÔNG cập nhật ở đây theo đúng DAO của bạn

            dao.updateCompany(c);
            response.sendRedirect("employer/company"); // quay lại view
            return;
        }

        if ("logo".equals(action)) {
            // cập nhật logo qua 1 input text (URL/đường dẫn)
            String logoPath = request.getParameter("logo");
            if (logoPath != null && !logoPath.isBlank()) {
                dao.uploadLogo(companyID, logoPath);
            }
            response.sendRedirect("employer/company?action=edit"); // ở lại trang edit để xem preview
            return;
        }

        // mặc định
        response.sendRedirect("employer/company");
    }
}
