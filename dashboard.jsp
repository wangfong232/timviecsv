<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Employer Dashboard</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background:#f5f7fa;
                margin:0;
            }
            .wrap {
                max-width:1100px;
                padding:24px;
                margin:0 auto;
            }
            .header {
                color:#1aa94c;
                font-size:22px;
                font-weight:700;
                margin:8px 0 16px;
            }
            .grid {
                display:grid;
                gap:14px;
            }
            .grid.cards {
                grid-template-columns: repeat(4, 1fr);
            }
            .card {
                background:#fff;
                border-radius:12px;
                box-shadow:0 2px 8px rgba(0,0,0,.06);
                padding:16px;
            }
            .stat-value {
                font-size:24px;
                font-weight:700;
                color:#111;
            }
            .stat-label {
                color:#6b7280;
                font-size:13px;
                margin-top:4px;
            }
            .section {
                margin-top:18px;
            }
            .section .header {
                margin:0 0 10px;
            }
            table {
                width:100%;
                border-collapse:collapse;
                background:#fff;
                border-radius:10px;
                overflow:hidden;
            }
            th, td {
                padding:10px 12px;
                border-bottom:1px solid #eee;
                text-align:left;
            }
            th {
                background:#1aa94c;
                color:#fff;
            }
            tr:nth-child(even) td {
                background:#fafafa;
            }
            .actions form {
                display:inline;
            }
            .btn {
                display:inline-block;
                padding:6px 10px;
                border-radius:6px;
                text-decoration:none;
                border:none;
                cursor:pointer;
            }
            .btn-primary {
                background:#1aa94c;
                color:#fff;
            }
            .btn-outline {
                background:#fff;
                color:#1aa94c;
                border:1px solid #1aa94c;
            }
            .btn-danger {
                background:#dc3545;
                color:#fff;
            }
            .btn-warning {
                background:#ffc107;
                color:#111;
            }
            .toolbar {
                display:flex;
                gap:8px;
                justify-content:flex-end;
                margin-bottom:10px;
            }
            .muted {
                color:#6b7280;
                font-size:12px;
            }
            .status-pill {
                padding:4px 8px;
                border-radius:999px;
                font-size:12px;
            }
            .status-open {
                background:#e8f7ee;
                color:#1aa94c;
            }
            .status-closed {
                background:#fdecea;
                color:#b02a37;
            }
            .progress {
                height:12px;
                background:#e5e7eb;
                border-radius:999px;
                overflow:hidden;
            }
            .progress > div {
                height:100%;
                background:#1aa94c;
            }
            .flex {
                display:flex;
                gap:14px;
            }
            .col {
                flex:1;
            }
            @media (max-width: 980px) {
                .grid.cards {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            @media (max-width: 640px) {
                .grid.cards {
                    grid-template-columns: 1fr;
                }
                .toolbar {
                    flex-direction:column;
                    align-items:stretch;
                }
            }
        </style>
    </head>
    <body>
        <div class="wrap">

            <!-- Top toolbar -->
            <div class="toolbar">
                <a class="btn btn-outline" href="view/employer/applications.jsp">Xem tất cả ứng tuyển</a>
                <a class="btn btn-primary" href="view/employer/job-form.jsp">+ Đăng tin mới</a>
                <a class="btn btn-outline" href="view/employer/manage-jobs.jsp">Quản lý tin</a>
            </div>

            <!-- Statistics -->
            <div class="grid cards">
                <div class="card">
                    <div class="stat-value">${activeJobCount}</div>
                    <div class="stat-label">Tin đang hoạt động</div>
                </div>
                <div class="card">
                    <div class="stat-value">${totalApplicationCount}</div>
                    <div class="stat-label">Tổng số đơn ứng tuyển</div>
                </div>
                <div class="card">
                    <div class="stat-value">${pendingReviewCount}</div>
                    <div class="stat-label">Đơn chờ duyệt</div>
                </div>
                <div class="card">
                    <div class="stat-value">
                        <c:choose>
                            <c:when test="${companyCompletion >= 0}">${companyCompletion}%</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="stat-label">Độ hoàn thiện hồ sơ công ty</div>
                </div>
            </div>

            <div class="flex section">
                <!-- Recent Applications -->
                <div class="col">
                    <div class="header">Ứng tuyển gần đây</div>
                    <table>
                        <thead>
                            <tr>
                                <th>Ứng viên</th>
                                <th>Công việc</th>
                                <th>Ngày nộp</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="a" items="${recentApps}">
                                <tr>
                                    <td>${a.studentName}</td>
                                    <td>${a.jobTitle}</td>
                                    <td>${a.appliedAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${a.statusID == 1}">Chờ duyệt</c:when>
                                            <c:when test="${a.statusID == 2}">Đã duyệt</c:when>
                                            <c:when test="${a.statusID == 3}">Từ chối</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="actions">
                                        <a class="btn btn-outline" href="view/employer/application-review.jsp?id=${a.applicationID}">Xem</a>
                                        <form action="employer/applications?action=approve&id=${a.applicationID}" method="post">
                                            <button class="btn btn-primary" type="submit">Duyệt</button>
                                        </form>
                                        <form action="employer/applications?action=reject&id=${a.applicationID}" method="post">
                                            <button class="btn btn-danger" type="submit">Từ chối</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty recentApps}">
                                <tr><td colspan="5" style="text-align:center;" class="muted">Chưa có ứng tuyển nào</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Active Jobs Summary -->
                <div class="col">
                    <div class="header">Tin đang hoạt động</div>
                    <table>
                        <thead>
                            <tr>
                                <th>Tiêu đề</th>
                                <th>Ngày tạo</th>
                                <th>View</th>
                                <th>Ứng tuyển</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="j" items="${activeJobs}">
                                <tr>
                                    <td><a class="btn btn-outline" href="view/employer/job-form.jsp?id=${j.jobID}">${j.title}</a></td>
                                    <td>${j.createdAt}</td>
                                    <td>${j.viewsCount}</td>
                                    <td>${j.applicationCount}</td>
                                    <td>
                                        <span class="status-pill ${j.statusCode == 'OPEN' ? 'status-open' : 'status-closed'}">
                                            ${j.statusCode}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty activeJobs}">
                                <tr><td colspan="5" style="text-align:center;" class="muted">Chưa có tin đang hoạt động</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Company profile completion -->
            <div class="section">
                <div class="card">
                    <div class="header">Hoàn thiện hồ sơ công ty</div>
                    <div class="progress"><div style="width:${companyCompletion}%;"></div></div>
                    <p class="muted" style="margin-top:6px;">Mức độ hoàn thiện: 
                        <b><c:out value="${companyCompletion}"/>%</b>
                    </p>
                    <c:if test="${not empty companyMissingFields}">
                        <p class="muted">Thiếu thông tin:</p>
                        <ul>
                            <c:forEach var="m" items="${companyMissingFields}">
                                <li>${m}</li>
                                </c:forEach>
                        </ul>
                    </c:if>
                    <div style="margin-top:8px;">
                        <a class="btn btn-primary" href="view/employer/company-profile.jsp">Cập nhật hồ sơ</a>
                    </div>
                </div>
            </div>

        </div>
    </body>
</html>
