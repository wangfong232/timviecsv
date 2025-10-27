<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết ứng viên</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background: #f5f7fa;
                margin: 0;
                padding: 20px;
            }
            .container {
                width: 800px;
                margin: auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            h2 {
                color: #1aa94c;
                border-bottom: 2px solid #1aa94c;
                padding-bottom: 8px;
            }
            .section {
                margin-bottom: 20px;
            }
            iframe {
                width: 100%;
                height: 500px;
                border: 1px solid #ccc;
                border-radius: 6px;
            }
            textarea {
                width: 100%;
                height: 80px;
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 8px;
                resize: vertical;
            }
            input[type="submit"] {
                background: #1aa94c;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                margin-right: 10px;
            }
            input[type="submit"]:hover {
                background: #138a3c;
            }
            a.btn {
                background: #ccc;
                padding: 8px 15px;
                border-radius: 5px;
                text-decoration: none;
                color: black;
            }
            a.btn:hover {
                background: #bdbdbd;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Chi tiết ứng viên</h2>

            <div class="section">
                <h3>Thông tin ứng viên</h3>
                <p><b>Tên:</b> ${app.studentName}</p>
                <p><b>Email:</b> ${app.studentEmail}</p>
                <p><b>Công việc ứng tuyển:</b> ${app.jobTitle}</p>
                <p><b>Ngày nộp:</b> ${app.appliedAt}</p>
                <p><b>Trạng thái hiện tại:</b>
                <c:choose>
                    <c:when test="${app.statusID == 1}">Chờ duyệt</c:when>
                    <c:when test="${app.statusID == 2}">Đã duyệt</c:when>
                    <c:when test="${app.statusID == 3}">Từ chối</c:when>
                </c:choose>
                </p>
            </div>

            <div class="section">
                <h3>CV Ứng viên</h3>
                <iframe src="${app.resumePath}" title="CV"></iframe>
            </div>

            <div class="section">
                <h3>Thư ứng tuyển</h3>
                <p>${app.coverLetter}</p>
            </div>

            <div class="section">
                <h3>Đánh giá</h3>
                <form method="post" action="employer/applications">
                    <input type="hidden" name="id" value="${app.applicationID}">
                    <textarea name="note" placeholder="Nhập ghi chú..."></textarea><br><br>
                    <input type="submit" name="action" value="approve">
                    <input type="submit" name="action" value="reject">
                    <a href="view/employer/applications.jsp" class="btn">Quay lại</a>
                </form>
            </div>
        </div>
    </body>
</html>
