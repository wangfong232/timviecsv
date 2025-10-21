<%-- 
    Document   : register
    Created on : Oct 4, 2025, 2:22:19 PM
    Author     : qp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Timviecsv</title>
    </head>
    <body>
        <div>
            <h4>Register</h4>
            <div>
                <%  
                 String error = (String)request.getAttribute("error");
                 if(error == null) error = "";
                
                 String email = (String)request.getAttribute("email");
                 if(email == null) email = "";
                
                 String fullName = (String)request.getAttribute("fullName");
                 if(fullName == null) fullName = "";
                
                 String phone = (String)request.getAttribute("phone");
                 if(phone == null) phone = "";
                %>

                <% if(!error.isEmpty()) { %>
                <div class="error"><%= error %></div>
                <% } %>
                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div>
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div>
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    <div>
                        <label for="confirmPassword">Confirm password:</label>
                        <input type="confirmPassword" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <div>
                        <label for="fullName">Fullname:</label>
                        <input type="text" id="fullName" name="fullName" required>
                    </div>
                    <div>
                        <label for="phone">Phone:</label>
                        <input type="text" id="phone" name="phone" required>
                    </div>
                    <div>
                        <label for="role">Role:</label>
                        <input type="radio" id="role_user" name="role" value="2" required>
                        <label for="role_user">User</label>
                        <input type="radio" id="role_employer" name="role" value="3" required>
                        <label for="role_employer">Employer</label>
                    </div>
                    <div>
                        <input type="submit" value="Register">
                    </div>
                    <div>
                        <p>Bạn đã có tài khoản? <a href="index.jsp">Đăng nhập ngay</a></p>
                    </div>
                </form>

            </div>
        </div>

    </body>
</html>