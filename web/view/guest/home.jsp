<%-- 
    Document   : home
    Created on : Oct 4, 2025, 2:22:03 PM
    Author     : qp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Timviecsv</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="../../assets/css/style.css">
    </head>
    <body>
        <% User user = (User)session.getAttribute("user"); %>
        <% if(user==null){ %>
        <jsp:include page="../common/headerNew.jsp" />
        <% }else{ %>   
        <jsp:include page="../common/header.jsp" />
        <%}%>
        <jsp:include page="../common/footer.jsp" />
    </body>
</html>
