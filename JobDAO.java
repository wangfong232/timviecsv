package dal;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Job;

/**
 *
 * @author qp
 */
public class JobDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    //get all job for student
    public List<Job> getAllApprovedJobs() {
        List<Job> jobs = new ArrayList<>();
        try {
            String sql = "select j.*, c.name as companyName, c.logo as companyLogo, js.statusCode, jt.typeCode from jobs j \n"
                    + "join jobStatuses js \n"
                    + "on j.statusID = js.statusID\n"
                    + "join jobTypes jt on jt.typeID = j.typeID\n"
                    + "join companies c on c.companyID = j.companyID\n"
                    + "where js.statusCode = 'APPROVED' AND j.deadline >= GETDATE()\n"
                    + "ORDER BY j.createdAt DESC";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("getAllApporvedJobs : " + e.getMessage());
        }
        return jobs;
    }

    //get job by id
    public Job getJobByID(int jobID) {
        try {
            String sql = "select j.*, \n"
                    + "c.logo as companyLogo , c.name as companyName,c.description as companyDesc, \n"
                    + "c.industry, c.size, js.statusCode, jt.typeCode, u.fullName as creatorName\n"
                    + "from Jobs j \n"
                    + "join companies c on j.companyID = c.companyID\n"
                    + "join users u on u.userID = j.createdBy\n"
                    + "join jobTypes jt on jt.typeID = j.typeID\n"
                    + "join jobStatuses js on js.statusID = j.statusID";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            if (rs.next()) {
                Job job = extractJobFromResultSet(rs);

                //load categories va tags
                job.setCategories(getJobCategories(jobID));
                job.setTags(getJobTags(jobID));

                return job;
            }
        } catch (SQLException e) {
            System.out.println("Get Job by Id : " + e.getMessage());
        }
        return null;
    }

    //sort by filter
    public List<Job> searchJobs(String keyword, String city, Integer typeID, String sortBy) {
        List<Job> jobs = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT j.*, c.name as companyName, c.logo as companyLogo, \n"
                + "                    js.statusCode, jt.typeCode \n"
                + "                    FROM jobs j \n"
                + "                     INNER JOIN companies c ON j.companyID = c.companyID \n"
                + "                     INNER JOIN jobStatuses js ON j.statusID = js.statusID  \n"
                + "                     INNER JOIN jobTypes jt ON j.typeID = jt.typeID\n"
                + "                     WHERE js.statusCode = 'APPROVED' AND j.deadline >= GETDATE()  ");

        List<Object> param = new ArrayList<>();

        //search keyword by ten cong viec, mieu ta cong viec, ten cong ty 
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (j.title LIKE ? OR j.desciption LIKE ? OR c.companyName LIKE ? )");
            String searchPattern = "%" + keyword + "%";
            param.add(searchPattern);
            param.add(searchPattern);
            param.add(searchPattern);
        }

        //search by locate
        if (city != null && !city.isEmpty()) {
            sql.append("AND (j.city LIKE ?)");
            String searchPattern = "%" + city + "%";
            param.add(searchPattern);
        }

        //search by typeID
        if (typeID != null && typeID > 0) {
            sql.append("AND j.typeID = ?");
            param.add(typeID);
        }

        //sort by 
        if ("salary".equals(sortBy)) {
            sql.append("ORDER BY j.pay_rate DESC, j.salary_max DESC");
        } else if ("lastest".equals(sortBy)) {
            sql.append("ORDER BY j.createdAt DESC");
        } else {
            //default
            sql.append("ORDER BY j.views_count DESC");
        }
        try {
            stm = connection.prepareStatement(sql.toString());

            for (int i = 0; i < param.size(); i++) {
                stm.setObject(i + 1, param.get(i));
            }
            rs = stm.executeQuery();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.out.println("Filter :" + e.getMessage());
        }
        return jobs;
    }

    public List<Job> getJobByCompany(int companyID) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT j.*, c.name as companyName, c.logo as companyLogo, \n"
                + "                    js.statusCode, jt.typeCode \n"
                + "                    FROM jobs j \n"
                + "                     INNER JOIN companies c ON j.companyID = c.companyID \n"
                + "                     INNER JOIN jobStatuses js ON j.statusID = js.statusID  \n"
                + "                     INNER JOIN jobTypes jt ON j.typeID = jt.typeID\n"
                + "                     WHERE j.companyID = ? \n"
                + "                     ORDER BY j.createdAt DESC";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, companyID);
            rs = stm.executeQuery();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("Get Job by company: " + e.getMessage());
        }
        return jobs;
    }

    //increment job view count
    public void incrementViewCount(int jobID) {
        String sql = "UPDATE jobs SET views_count = views_count + 1 WHERE jobID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobID);
            stm.executeUpdate();

        } catch (SQLException e) {
            System.out.println("Increment View : " + e.getMessage());
        }
    }

    //get saved job
    public List<Job> getSavedJobsByStudent(int studentID) {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT j.*, c.name as companyName, c.logo as companyLogo, \n"
                + "                    js.statusCode, jt.typeCode \n"
                + "                    FROM jobs j \n"
                + "                      JOIN companies c ON j.companyID = c.companyID \n"
                + "                      JOIN jobStatuses js ON j.statusID = js.statusID  \n"
                + "                      JOIN jobTypes jt ON j.typeID = jt.typeID\n"
                + "                     join savedJobs sj on sj.jobID = j.jobID\n"
                + "                     WHERE  sj.userID = ?\n"
                + "                     ORDER BY sj.savedAt DESC ";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, studentID);
            rs = stm.executeQuery();
            while (rs.next()) {
                jobs.add(extractJobFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("Get Saved Job by Student: " + e.getMessage());
        }
        return jobs;
    }

    //check if job is saved by student 
    public boolean isJobSaved(int jobID, int studentID) {
        String sql = "SELECT COUNT(*) FROM savedJobs WHERE jobID = ? AND userID = ? ";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobID);
            stm.setInt(2, studentID);
            rs = stm.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("is Job Saved : " + e.getMessage());
        }
        return false;
    }

    //save job
    public boolean saveJob(int jobID, int studentID) {
        String sql = "INSERT INTO savedJobs(userID, jobID) VALUES (?,?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobID);
            stm.setInt(2, studentID);
            int row = stm.executeUpdate();
            return row > 0;

        } catch (SQLException e) {
            System.out.println("saveJob  : " + e.getMessage());
        }
        return false;
    }

    //unsave job 
    public boolean unsaveJob(int jobID, int studentID) {
        String sql = "DELETE FROM savedJobs WHERE jobID = ? and userID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobID);
            stm.setInt(2, studentID);
            int row = stm.executeUpdate();
            return row > 0;

        } catch (SQLException e) {
            System.out.println("unsaveJob : " + e.getMessage());
        }
        return false;
    }

    //get job categoires
    private List<String> getJobCategories(int jobID) {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT c.categoryName FROM jobCategories jc "
                + "INNER JOIN categories c ON jc.categoryID = c.categoryID "
                + "WHERE jc.jobID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobID);
            rs = stm.executeQuery();
            while (rs.next()) {
                categories.add(rs.getString("categoryName"));
            }
        } catch (SQLException e) {
            System.out.println("Get Category: " + e.getMessage());
        }
        return categories;
    }

    //get job tags
    private List<String> getJobTags(int jobID) {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT t.tagName FROM jobTags jt "
                + "INNER JOIN tags t ON jt.tagID = t.tagID "
                + "WHERE jt.jobID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobID);
            rs = stm.executeQuery();
            while (rs.next()) {
                categories.add(rs.getString("tagName"));
            }
        } catch (SQLException e) {
            System.out.println("Get tag name: " + e.getMessage());
        }
        return categories;
    }

    private Job extractJobFromResultSet(ResultSet rs) throws SQLException {
        Job job = new Job();
        job.setJobID(rs.getInt("jobId"));
        job.setCompanyID(rs.getInt("companyID"));
        job.setCompanyName(rs.getString("companyName"));
        job.setCompanyLogo(rs.getString("companyLogo"));
        job.setCreatedBy(rs.getInt("createdBy"));

        job.setTitle(rs.getString("title"));
        job.setDescription(rs.getString("description"));
        job.setRequirements(rs.getString("requirements"));
        job.setBenefits(rs.getString("benefits"));
        job.setCity(rs.getString("city"));
        job.setAddress(rs.getString("address"));

        job.setShiftInfo(rs.getString("shift_info"));
        job.setHoursPerWeekMin((Integer) rs.getObject("hours_per_week_min"));
        job.setHoursPerWeekMax((Integer) rs.getObject("hours_per_week_max"));
        job.setIsEveningShift(rs.getBoolean("is_evening_shift"));
        job.setIsWeekendShift(rs.getBoolean("is_weekend_shift"));
        job.setWorkFormat(rs.getString("word_format"));

        job.setPayType(rs.getString("pay_type"));
        job.setPayRate(rs.getBigDecimal("pay_rate"));
        job.setSalaryMin(rs.getBigDecimal("salary_min"));
        job.setSalaryMax(rs.getBigDecimal("salary_max"));

        job.setNumberOfPositions(rs.getInt("numberOfPositions"));
        job.setApplicationCount(rs.getInt("applicationCount"));
        job.setContactEmail(rs.getString("contactEmail"));
        job.setContactPhone(rs.getString("contactPhone"));
        job.setDeadline(rs.getDate("deadline"));

        job.setStatusID(rs.getInt("statusID"));
        job.setStatusCode(rs.getString("statusCode"));
        job.setTypeID(rs.getInt("typeID"));
        job.setTypeCode(rs.getString("typeCode"));

        job.setViewsCount(rs.getInt("views_count"));
        job.setCreatedAt(rs.getDate("createdAt"));
        job.setUpdatedAt(rs.getDate("updatedAt"));

        return job;
    }
// Tạo job mới cho company (employer)

    public int createJobForCompany(Job j) {
        String sql = "INSERT INTO jobs (companyID, title, description, city, address, statusID, typeID, createdAt, updatedAt) "
                + "VALUES (?,?,?,?,?,?,?, GETDATE(), GETDATE())";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, j.getCompanyID());
            stm.setString(2, j.getTitle());
            stm.setString(3, j.getDescription());
            stm.setString(4, j.getCity());
            stm.setString(5, j.getAddress());
            stm.setInt(6, j.getStatusID());
            stm.setInt(7, j.getTypeID());
            return stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("createJobForCompany: " + e.getMessage());
        }
        return 0;
    }

    public boolean updateJobForCompany(Job j, int companyID) {
        String sql = "UPDATE jobs SET title=?, description=?, city=?, address=?, statusID=?, typeID=?, updatedAt=GETDATE() "
                + "WHERE jobID=? AND companyID=?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, j.getTitle());
            stm.setString(2, j.getDescription());
            stm.setString(3, j.getCity());
            stm.setString(4, j.getAddress());
            stm.setInt(5, j.getStatusID());
            stm.setInt(6, j.getTypeID());
            stm.setInt(7, j.getJobID());
            stm.setInt(8, companyID);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateJobForCompany: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteJobForCompany(int jobID, int companyID) {
        String sql = "DELETE FROM jobs WHERE jobID=? AND companyID=?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobID);
            stm.setInt(2, companyID);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteJobForCompany: " + e.getMessage());
        }
        return false;
    }

    public boolean closeJobForCompany(int jobID, int companyID) {
        // giả sử statusID trỏ đến bảng jobStatuses, code = 'CLOSED' có id = 3 (ví dụ)
        String sql = "UPDATE jobs SET statusID = (SELECT TOP 1 statusID FROM jobStatuses WHERE statusCode='CLOSED'), "
                + "updatedAt=GETDATE() WHERE jobID=? AND companyID=?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, jobID);
            stm.setInt(2, companyID);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("closeJobForCompany: " + e.getMessage());
        }
        return false;
    }

}
