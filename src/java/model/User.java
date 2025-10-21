package model;

import java.util.Date;

/**
 *
 * @author qp
 */
public class User {

    private int userID;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private int roleID;
    private Date createdAt;
    private Date updatedAt;
    private boolean isActive;

    public User() {
    }

    public User(String email, String password, String fullName, String phone, int roleID) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.roleID = roleID;
        this.isActive = true;
    }

    

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
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

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }

}
