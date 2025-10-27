<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý công việc</title>
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
            a {
                text-decoration: none;
                color: #1aa94c;
            }
            a:hover {
                text-decoration: underline;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 1px 5px rgba(0,0,0,0.1);
            }
            th, td {
                padding: 8px;
                border: 1px solid #ddd;
            }
            th {
                background-color: #1aa94c;
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            .btn {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 5px;
                background-color: #1aa94c;
                color: white;
                text-decoration: none;
            }
            .btn:hover {
                background-color: #138a3c;
            }
            .btn-danger {
                background-color: #dc3545;
            }
            .btn-danger:hover {
                background-color: #b02a37;
            }
            .btn-warning {
                background-color: #ffc107;
                color: black;
            }
            .btn-warning:hover {
                background-color: #e0a800;
            }
            form {
                display: inline;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách công việc</h2>

        <p>
            <a class="btn" href="view/employer/job-form.jsp">+ Tạo công việc mới</a>
        </p>

        <table>
            <tr>
                <th>Tiêu đề</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th>Lượt xem</th>
                <th>Ứng tuyển</th>
                <th>Hành động</th>
            </tr>

            <c:forEach var="j" items="${jobs}">
                <tr>
                    <td>${j.title}</td>
                    <td>${j.statusCode}</td>
                    <td>${j.createdAt}</td>
                    <td>${j.viewsCount}</td>
                    <td>${j.applicationCount}</td>
                    <td>
                        <a class="btn btn-warning" href="view/employer/job-form.jsp?id=${j.jobID}">Sửa</a>
                        |
                        <form action="employer/jobs?action=delete" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="${j.jobID}">
                            <input type="submit" class="btn btn-danger" value="Xóa"
                                   onclick="return confirm('Bạn có chắc muốn xóa công việc này?');">
                        </form>
                        |
                        <form action="employer/jobs?action=close" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="${j.jobID}">
                            <input type="submit" class="btn" value="Đóng"
                                   onclick="return confirm('Đóng tin tuyển dụng này?');">
                        </form>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty jobs}">
                <tr><td colspan="6" style="text-align:center;">Không có công việc nào</td></tr>
            </c:if>
        </table>
    </body>
</html>
