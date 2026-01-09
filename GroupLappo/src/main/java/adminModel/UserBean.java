package adminModel;

import java.io.Serializable;
import java.util.Date;

// 1. Must implement Serializable
public class UserBean implements Serializable {
    
    // 2. Private properties (Encapsulation)
    private int userid;
    private String username;
    private String email;
    private String password;
    private String role;
    private String status;
    private Date joinedDate;

    // 3. Public No-Argument Constructor (Required for JavaBeans)
    public UserBean() {
    }

    // 4. Public Getters and Setters (Required for JSTL/EL)
    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getJoinedDate() {
        return joinedDate;
    }

    public void setJoinedDate(Date joinedDate) {
        this.joinedDate = joinedDate;
    }
}