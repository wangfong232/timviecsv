package dal.employer;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Application;

/**
 *
 * @author qp
 */
public class ApplicationDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    /**
     * Lấy danh sách đơn ứng tuyển theo Job ID
     */
    public List<Application> getApplicationsByJob(int jobId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT * FROM Applications WHERE jobID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobId);
            rs = stm.executeQuery();
            while (rs.next()) {
                list.add(extractApplication(rs));
            }
        } catch (SQLException e) {
            System.out.println("getApplicationsByJob: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách đơn ứng tuyển của tất cả job thuộc 1 công ty
     */
    public List<Application> getApplicationsByCompany(int companyId) {
        List<Application> list = new ArrayList<>();
        String sql = """
                     SELECT a.*
                     FROM Applications a
                     JOIN Jobs j ON a.jobID = j.jobID
                     WHERE j.companyID = ?
                     """;
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, companyId);
            rs = stm.executeQuery();
            while (rs.next()) {
                list.add(extractApplication(rs));
            }
        } catch (SQLException e) {
            System.out.println("getApplicationsByCompany: " + e.getMessage());
        }
        return list;
    }

    /**
     * Cập nhật trạng thái và ghi chú của đơn ứng tuyển
     */
    public boolean updateApplicationStatus(int appId, int statusId, String note) {
        String sql = """
                     UPDATE Applications
                     SET statusID = ?, reviewNote = ?, reviewedAt = GETDATE()
                     WHERE applicationID = ?
                     """;
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, statusId);
            stm.setString(2, note);
            stm.setInt(3, appId);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateApplicationStatus: " + e.getMessage());
        }
        return false;
    }

    /**
     * Helper: ánh xạ ResultSet -> Application object
     */
    private Application extractApplication(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationID(rs.getInt("applicationID"));
        a.setJobID(rs.getInt("jobID"));
        a.setStudentID(rs.getInt("studentID"));
        a.setStatusID(rs.getInt("statusID"));
        a.setCoverLetter(rs.getString("coverLetter"));
        a.setAppliedAt(rs.getTimestamp("appliedAt"));
        a.setReviewedAt(rs.getTimestamp("reviewedAt"));
        a.setReviewedBy(rs.getInt("reviewedBy"));
        a.setReviewNote(rs.getString("reviewNote"));
        return a;
    }
}
