package controller.employer;

import dal.employer.ApplicationDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Application;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "EmployerApplicationController", urlPatterns = {"/employer/applications"})
public class EmployerApplicationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        ApplicationDAO dao = new ApplicationDAO();

        switch (action) {
            case "detail" -> showDetail(request, response, dao);
            case "list" -> listApplications(request, response, dao);
            default -> listApplications(request, response, dao);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ApplicationDAO dao = new ApplicationDAO();

        switch (action) {
            case "approve" -> updateStatus(request, response, dao, 2, "Đơn đã được duyệt");
            case "reject" -> updateStatus(request, response, dao, 3, "Đơn bị từ chối");
            default -> response.sendRedirect("view/employer/applications-list.jsp");
        }
    }

    // ================= HELPER METHODS =================

    private void listApplications(HttpServletRequest request, HttpServletResponse response, ApplicationDAO dao)
            throws ServletException, IOException {
        try {
            // Giả sử employer đang quản lý công ty ID = 1 (sau này bạn thay bằng session)
            int companyId = 1;
            List<Application> apps = dao.getApplicationsByCompany(companyId);
            request.setAttribute("apps", apps);

            RequestDispatcher rd = request.getRequestDispatcher("view/employer/applications-list.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response, ApplicationDAO dao)
            throws ServletException, IOException {
        try {
            int appId = Integer.parseInt(request.getParameter("id"));
            // Giả sử bạn đã có method getApplicationById (bạn có thể thêm vào DAO nếu cần)
            List<Application> list = dao.getApplicationsByJob(appId);
            Application app = list.isEmpty() ? null : list.get(0);

            request.setAttribute("app", app);
            RequestDispatcher rd = request.getRequestDispatcher("view/employer/application-detail.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response,
            ApplicationDAO dao, int statusId, String defaultNote)
            throws IOException {
        try {
            int appId = Integer.parseInt(request.getParameter("id"));
            String note = request.getParameter("note");
            if (note == null || note.trim().isEmpty()) {
                note = defaultNote;
            }

            boolean updated = dao.updateApplicationStatus(appId, statusId, note);
            if (updated) {
                response.sendRedirect("applications?action=list");
            } else {
                response.getWriter().println("Cập nhật thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
