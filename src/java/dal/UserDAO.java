package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import model.User;

/**
 *
 * @author qp
 */
public class UserDAO extends DBContext {

    PreparedStatement smt;
    ResultSet rs;

    public User login(String emailx, String passwordx) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try {
            smt = connection.prepareStatement(sql);
            smt.setString(1, emailx);
            smt.setString(2, passwordx);
            rs = smt.executeQuery();
            if (rs.next()) {
                //int userID = rs.getInt("userID");
                String email = rs.getString("email");
                String password = rs.getString("password");
                String fullName = rs.getString("fullName");
                String phone = rs.getString("phone");
                boolean isActive = rs.getBoolean("isActive");
//                Date createdAt = rs.getDate("createdAt");
//                Date updateAt = rs.getDate("updatedAt");
                int roleID = rs.getInt("roleID");
                user = new User(email, password, fullName, phone, roleID);
            }

        } catch (SQLException e) {
            System.out.println("Login error: " + e.getMessage());
        }
        return user;
    }

    public boolean register(String email, String password, String fullName, String phone, int role) {

        String sql = "INSERT INTO users(email,password,fullName,phone,roleID) VALUES (?,?,?,?,?)";
        try {
            smt = connection.prepareStatement(sql);

            smt.setString(1, email);
            smt.setString(2, password);
            smt.setString(3, fullName);
            smt.setString(4, phone);
            smt.setInt(5, role);
            int row = smt.executeUpdate();

            return row > 0;
        } catch (SQLException e) {
            System.out.println("Register error: " + e.getMessage());
            return false;
        }
    }

    public User getUserByEmail(String emailx) {
        String sql = "SELECT * FROM users where email = ?";
        User user = null;
        try {
            smt = connection.prepareStatement(sql);
            smt.setString(1, emailx);
            rs = smt.executeQuery();
            if (rs.next()) {
                int userID = rs.getInt("userID");
                String email = rs.getString("email");
                String password = rs.getString("password");
                String fullName = rs.getString("fullName");
                String phone = rs.getString("phone");
                boolean isActive = rs.getBoolean("isActive");
                Date createdAt = rs.getDate("createdAt");
                Date updateAt = rs.getDate("updatedAt");
                int roleID = rs.getInt("roleID");
                user = new User(email, password, fullName, phone, roleID);
            }
        } catch (SQLException e) {
            System.out.println("Get error: " + e.getMessage());
        }
        return user;
    }
}
