
package dal.employer;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Company;

/**
 * Company data access object
 *
 * @author qp
 */
public class CompanyDAO extends DBContext {

	PreparedStatement stm;
	ResultSet rs;

	// get company by id
	public Company getCompanyById(int id) {
		String sql = "SELECT * FROM companies WHERE companyID = ?";
		try {
			stm = connection.prepareStatement(sql);
			stm.setInt(1, id);
			rs = stm.executeQuery();
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
		} catch (SQLException e) {
			System.out.println("getCompanyById: " + e.getMessage());
		}
		return null;
	}

	// update company info (except logo)
	public boolean updateCompany(Company company) {
		String sql = "UPDATE companies SET name = ?, description = ?, industry = ?, size = ?, city = ?, address = ?, website = ? WHERE companyID = ?";
		try {
			stm = connection.prepareStatement(sql);
			stm.setString(1, company.getName());
			stm.setString(2, company.getDescription());
			stm.setString(3, company.getIndustry());
			stm.setString(4, company.getSize());
			stm.setString(5, company.getCity());
			stm.setString(6, company.getAddress());
			stm.setString(7, company.getWebsite());
			stm.setInt(8, company.getCompanyID());
			int row = stm.executeUpdate();
			return row > 0;
		} catch (SQLException e) {
			System.out.println("updateCompany: " + e.getMessage());
		}
		return false;
	}

	// upload or update company logo path
	public boolean uploadLogo(int companyId, String logoPath) {
		String sql = "UPDATE companies SET logo = ? WHERE companyID = ?";
		try {
			stm = connection.prepareStatement(sql);
			stm.setString(1, logoPath);
			stm.setInt(2, companyId);
			int row = stm.executeUpdate();
			return row > 0;
		} catch (SQLException e) {
			System.out.println("uploadLogo: " + e.getMessage());
		}
		return false;
	}

}
