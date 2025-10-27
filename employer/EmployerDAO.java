package dal.employer;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Company;
import model.Employer;

public class EmployerDAO extends DBContext {

    public Employer getEmployerByUserId(int userId) {
        String sql = "SELECT * FROm Employer WHERE userID = ?";
        try (Connection conn = connection; PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Employer e = new Employer();
                e.setEmployerID(rs.getInt("employerID"));
                e.setCompanyID(rs.getInt("companyID"));
                e.setUserID(rs.getInt("userID"));
                e.setFullName(rs.getString("fullName"));
                e.setEmail(rs.getString("email"));
                e.setPhoneNumber(rs.getString("phoneNumber"));
                e.setPosition(rs.getString("position"));
                e.setActive(rs.getBoolean("isActive"));
                return e;
            }
        } catch (SQLException ex) {
            System.out.println("Error at getEmployerByUserId: " + ex.getMessage());
        }
        return null;
    }

    public Company getCompanyByEmployer(int userId) {
        String sql = """
                     SELECT c.* 
                     FROM Company c
                     JOIN Employer e ON c.companyID = e.companyID
                     WHERE e.userID = ?""";
        try (Connection conn = connection; PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Company c = new Company();
                c.setCompanyID(rs.getInt("companyID"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                c.setIndustry(rs.getString("industry"));
                c.setSize(rs.getString("size"));
                c.setCity(rs.getString("city"));
                c.setAddress(rs.getString("address"));
                c.setWebsite(rs.getString("website"));
                c.setLogo(rs.getString("logo"));
                return c;
            }
        } catch (SQLException ex) {
            System.out.println("Error at getCompanyByEmployer: " + ex.getMessage());
        }
        return null;
    }
}
