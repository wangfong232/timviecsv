<%-- 
    Document   : login
    Created on : Oct 4, 2025, 2:22:12 PM
    Author     : qp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Timviecsv</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <div>
            <h4>Login</h4>
            <%  
           String error = (String)session.getAttribute("error");
            if(error==null){
                error="";
                } else{
                session.removeAttribute("error");
                }
            String message = (String)session.getAttribute("message");
             
            if(message!=null){
                 session.removeAttribute("message");
             }else{
                 message="";
             }
             
             String email = (String)session.getAttribute("email");
             if(email==null) email="";
            %>
            <div class="alert"><%= message %></div>
            <form action="login" method="post">
                <div>
                    <label for="email">Email: </label>
                    <input type="text" id="email" name="email" value="<%= email %>" required>
                </div>
                <div>
                    <label for="password">Password: </label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div>
                    <input type="submit" value="Login">
                </div>

                <div><%= error %></div>
                <div>
                    <p>Bạn chưa có tài khoản? <a href="view/guest/register.jsp">Đăng ký ngay</a></p>
                </div>
            </form>
        </div>

    </body>
</html>
