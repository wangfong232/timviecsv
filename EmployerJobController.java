package controller.employer;

import dal.JobDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Job; // dùng đúng package model.* như bạn

/**
 * URL Patterns:
 *  - GET  /employer/jobs                      -> list
 *  - GET  /employer/jobs?action=create        -> form tạo
 *  - GET  /employer/jobs?action=edit&id=1     -> form sửa
 *  - POST /employer/jobs?action=store         -> lưu job mới
 *  - POST /employer/jobs?action=update        -> cập nhật job
 *  - POST /employer/jobs?action=delete        -> xóa job
 *  - POST /employer/jobs?action=close         -> đóng tuyển
 *
 * Yêu cầu session có: companyID (Integer)
 */
public class EmployerJobController extends HttpServlet {

    private Integer sessionCompanyId(HttpServletRequest request) {
        HttpSession s = request.getSession();
        Object v = s.getAttribute("companyID");
        return (v instanceof Integer) ? (Integer) v : null;
    }

    private int toInt(String s) { try { return Integer.parseInt(s); } catch (Exception e) { return -1; } }

    // ---------- GET ----------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer companyID = sessionCompanyId(request);
        if (companyID == null) {
            response.sendRedirect("EmployerLogin"); // đổi path nếu khác
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        JobDAO dao = new JobDAO();

        switch (action) {
            case "create": {
                // form tạo mới
                RequestDispatcher rd = request.getRequestDispatcher("views/employer/job-form.jsp");
                rd.forward(request, response);
                break;
            }
            case "edit": {
                int id = toInt(request.getParameter("id"));
                Job job = dao.getJobByID(id); // dùng đúng tên hàm trong DAO của bạn
                request.setAttribute("job", job);
                RequestDispatcher rd = request.getRequestDispatcher("views/employer/job-form.jsp");
                rd.forward(request, response);
                break;
            }
            default: { // list
                List<Job> jobs = dao.getJobByCompany(companyID);
                request.setAttribute("jobs", jobs);
                RequestDispatcher rd = request.getRequestDispatcher("views/employer/job-list.jsp");
                rd.forward(request, response);
                break;
            }
        }
    }

    // ---------- POST ----------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer companyID = sessionCompanyId(request);
        if (companyID == null) {
            response.sendRedirect("EmployerLogin");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        JobDAO dao = new JobDAO();

        switch (action) {
            case "store": {
                Job j = new Job();
                j.setCompanyID(companyID);
                j.setTitle(request.getParameter("title"));
                j.setDescription(request.getParameter("description"));
                j.setCity(request.getParameter("city"));
                j.setAddress(request.getParameter("address"));
                j.setStatusID( /* ví dụ: 1 = DRAFT/OPEN tùy schema của bạn */ 1 );
                j.setTypeID(  toInt(request.getParameter("typeID"))  ); // nếu có
                // set thêm các field cần thiết khác nếu form có: salary_min, salary_max, deadline,...

                dao.createJobForCompany(j); // <- hàm mới thêm trong JobDAO (bên dưới)
                response.sendRedirect("employer/jobs");
                break;
            }
            case "update": {
                int id = toInt(request.getParameter("id"));
                Job j = dao.getJobByID(id);
                if (j != null && j.getCompanyID() == companyID) {
                    j.setTitle(request.getParameter("title"));
                    j.setDescription(request.getParameter("description"));
                    j.setCity(request.getParameter("city"));
                    j.setAddress(request.getParameter("address"));
                    String statusIdStr = request.getParameter("statusID");
                    if (statusIdStr != null && !statusIdStr.isBlank()) {
                        j.setStatusID(toInt(statusIdStr));
                    }
                    String typeIdStr = request.getParameter("typeID");
                    if (typeIdStr != null && !typeIdStr.isBlank()) {
                        j.setTypeID(toInt(typeIdStr));
                    }
                    dao.updateJobForCompany(j, companyID);
                }
                response.sendRedirect("employer/jobs");
                break;
            }
            case "delete": {
                int id = toInt(request.getParameter("id"));
                dao.deleteJobForCompany(id, companyID);
                response.sendRedirect("employer/jobs");
                break;
            }
            case "close": {
                int id = toInt(request.getParameter("id"));
                dao.closeJobForCompany(id, companyID); // set status về CLOSED
                response.sendRedirect("employer/jobs");
                break;
            }
            default: {
                response.sendRedirect("employer/jobs");
                break;
            }
        }
    }
}
