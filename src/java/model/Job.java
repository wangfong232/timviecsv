package model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Job {

    private int jobID;
    private int companyID;
    private int createdBy;
    private String title;
    private String description;
    private String requirements;
    private String benefits;
    private String city;
    private String address;
    private String shiftInfo;
    private Integer hoursPerWeekMin;
    private Integer hoursPerWeekMax;
    private boolean isEveningShift;
    private boolean isWeekendShift;
    private String workFormat;
    private String payType;
    private BigDecimal payRate;
    private BigDecimal salaryMin;
    private BigDecimal salaryMax;
    private int numberOfPositions;
    private int applicationCount;
    private String contactEmail;
    private String contactPhone;
    private Date deadline;
    private int statusID;
    private int typeID;
    private int viewsCount;
    private Date createdAt;
    private Date updatedAt;

    private String companyName;
    private String companyLogo;
    private String statusCode;
    private String typeCode;

    private List<String> tags;
    private List<String> categories;

    public Job() {
    }

    public int getJobID() {
        return jobID;
    }

    public void setJobID(int jobID) {
        this.jobID = jobID;
    }

    public int getCompanyID() {
        return companyID;
    }

    public void setCompanyID(int companyID) {
        this.companyID = companyID;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public String getBenefits() {
        return benefits;
    }

    public void setBenefits(String benefits) {
        this.benefits = benefits;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getShiftInfo() {
        return shiftInfo;
    }

    public void setShiftInfo(String shiftInfo) {
        this.shiftInfo = shiftInfo;
    }

    public Integer getHoursPerWeekMin() {
        return hoursPerWeekMin;
    }

    public void setHoursPerWeekMin(Integer hoursPerWeekMin) {
        this.hoursPerWeekMin = hoursPerWeekMin;
    }

    public Integer getHoursPerWeekMax() {
        return hoursPerWeekMax;
    }

    public void setHoursPerWeekMax(Integer hoursPerWeekMax) {
        this.hoursPerWeekMax = hoursPerWeekMax;
    }

    public boolean isIsEveningShift() {
        return isEveningShift;
    }

    public void setIsEveningShift(boolean isEveningShift) {
        this.isEveningShift = isEveningShift;
    }

    public boolean isIsWeekendShift() {
        return isWeekendShift;
    }

    public void setIsWeekendShift(boolean isWeekendShift) {
        this.isWeekendShift = isWeekendShift;
    }

    public String getWorkFormat() {
        return workFormat;
    }

    public void setWorkFormat(String workFormat) {
        this.workFormat = workFormat;
    }

    public String getPayType() {
        return payType;
    }

    public void setPayType(String payType) {
        this.payType = payType;
    }

    public BigDecimal getPayRate() {
        return payRate;
    }

    public void setPayRate(BigDecimal payRate) {
        this.payRate = payRate;
    }

    public BigDecimal getSalaryMin() {
        return salaryMin;
    }

    public void setSalaryMin(BigDecimal salaryMin) {
        this.salaryMin = salaryMin;
    }

    public BigDecimal getSalaryMax() {
        return salaryMax;
    }

    public void setSalaryMax(BigDecimal salaryMax) {
        this.salaryMax = salaryMax;
    }

    public int getNumberOfPositions() {
        return numberOfPositions;
    }

    public void setNumberOfPositions(int numberOfPositions) {
        this.numberOfPositions = numberOfPositions;
    }

    public int getApplicationCount() {
        return applicationCount;
    }

    public void setApplicationCount(int applicationCount) {
        this.applicationCount = applicationCount;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public int getStatusID() {
        return statusID;
    }

    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }

    public int getTypeID() {
        return typeID;
    }

    public void setTypeID(int typeID) {
        this.typeID = typeID;
    }

    public int getViewsCount() {
        return viewsCount;
    }

    public void setViewsCount(int viewsCount) {
        this.viewsCount = viewsCount;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyLogo() {
        return companyLogo;
    }

    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }

    public String getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(String statusCode) {
        this.statusCode = statusCode;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public List<String> getCategories() {
        return categories;
    }

    public void setCategories(List<String> categories) {
        this.categories = categories;
    }

}
