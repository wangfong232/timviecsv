<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách ứng viên</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f5f7fa;
                margin: 0;
                padding: 20px;
            }
            h2 {
                color: #1aa94c;
                border-bottom: 2px solid #1aa94c;
                padding-bottom: 8px;
            }
            .filter-box {
                background: #fff;
                padding: 10px 15px;
                margin-bottom: 15px;
                border-radius: 6px;
                box-shadow: 0 1px 5px rgba(0,0,0,0.1);
            }
            .filter-box input, .filter-box select {
                padding: 6px;
                margin-right: 10px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 1px 6px rgba(0,0,0,0.1);
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #1aa94c;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            a.btn {
                display: inline-block;
                padding: 4px 8px;
                background: #1aa94c;
                color: white;
                border-radius: 5px;
                text-decoration: none;
                margin-right: 5px;
            }
            a.btn:hover {
                background: #138a3c;
            }
            form {
                display: inline;
            }
            .btn-danger {
                background: #dc3545;
            }
            .btn-danger:hover {
                background: #b02a37;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách ứng viên</h2>

        <div class="filter-box">
            <form action="employer/applications" method="get">
                <input type="hidden" name="action" value="list">
                Job:
                <select name="jobId">
                    <option value="">-- Tất cả công việc --</option>
                    <c:forEach var="j" items="${jobs}">
                        <option value="${j.jobID}">${j.title}</option>
                    </c:forEach>
                </select>
                Trạng thái:
                <select name="statusId">
                    <option value="">-- Tất cả --</option>
                    <option value="1">Chờ duyệt</option>
                    <option value="2">Đã duyệt</option>
                    <option value="3">Từ chối</option>
                </select>
                Ngày:
                <input type="date" name="date">
                <input type="submit" value="Lọc">
            </form>
        </div>

        <table>
            <tr>
                <th>Tên ứng viên</th>
                <th>Công việc</th>
                <th>Ngày nộp</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>

            <c:forEach var="a" items="${apps}">
                <tr>
                    <td>${a.studentName}</td>
                    <td>${a.jobTitle}</td>
                    <td>${a.appliedAt}</td>
                    <td>
                        <c:choose>
                            <c:when test="${a.statusID == 1}">Chờ duyệt</c:when>
                            <c:when test="${a.statusID == 2}">Đã duyệt</c:when>
                            <c:when test="${a.statusID == 3}">Từ chối</c:when>
                        </c:choose>
                    </td>
                    <td>
                        <a class="btn" href="view/employer/application-review.jsp?id=${a.applicationID}">Xem</a>
                        <form action="employer/applications?action=approve&id=${a.applicationID}" method="post">
                            <input type="submit" class="btn" value="Duyệt">
                        </form>
                        <form action="employer/applications?action=reject&id=${a.applicationID}" method="post">
                            <input type="submit" class="btn btn-danger" value="Từ chối">
                        </form>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty apps}">
                <tr><td colspan="5" style="text-align:center;">Chưa có đơn ứng tuyển nào</td></tr>
            </c:if>
        </table>
    </body>
</html>
