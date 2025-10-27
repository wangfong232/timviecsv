<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${empty job}">Tạo công việc</c:when>
            <c:otherwise>Sửa công việc</c:otherwise>
        </c:choose>
    </title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 800px;
            margin: 40px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 30px 40px;
        }

        h2 {
            color: #1aa94c;
            border-bottom: 2px solid #1aa94c;
            padding-bottom: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        td {
            padding: 10px 5px;
            vertical-align: top;
        }

        input[type="text"],
        input[type="number"],
        input[type="email"],
        select,
        textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            resize: vertical;
        }

        textarea {
            min-height: 80px;
        }

        input[type="submit"],
        .btn-cancel {
            background-color: #1aa94c;
            color: white;
            border: none;
            padding: 10px 20px;
            margin-right: 10px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 15px;
        }

        input[type="submit"]:hover,
        .btn-cancel:hover {
            background-color: #138a3c;
        }

        .btn-cancel {
            background-color: #ccc;
            color: black;
        }

        tr:nth-child(even) td {
            background-color: #f9f9f9;
        }

        .note {
            color: #888;
            font-size: 13px;
        }

        .topcv-header {
            background-color: #1aa94c;
            color: #fff;
            text-align: center;
            padding: 15px 0;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
    </style>
</head>
<body>
    <div class="topcv-header">
        HỆ THỐNG TUYỂN DỤNG - QUẢN LÝ CÔNG VIỆC
    </div>

    <div class="container">
        <h2>
            <c:choose>
                <c:when test="${empty job}">Tạo công việc mới</c:when>
                <c:otherwise>Sửa công việc</c:otherwise>
            </c:choose>
        </h2>

        <!-- Đường dẫn tĩnh: form gửi trực tiếp về servlet -->
        <form action="employer/jobs?action=${empty job ? 'store' : 'update'}" method="post">
            <c:if test="${not empty job}">
                <input type="hidden" name="id" value="${job.jobID}">
            </c:if>

            <table>
                <tr>
                    <td>Tiêu đề:</td>
                    <td><input type="text" name="title" value="${job.title}" required></td>
                </tr>
                <tr>
                    <td>Mô tả:</td>
                    <td><textarea name="description" rows="5">${job.description}</textarea></td>
                </tr>
                <tr>
                    <td>Yêu cầu:</td>
                    <td><textarea name="requirements" rows="5">${job.requirements}</textarea></td>
                </tr>
                <tr>
                    <td>Phúc lợi:</td>
                    <td><textarea name="benefits" rows="5">${job.benefits}</textarea></td>
                </tr>
                <tr>
                    <td>Thành phố:</td>
                    <td><input type="text" name="city" value="${job.city}"></td>
                </tr>
                <tr>
                    <td>Địa chỉ:</td>
                    <td><input type="text" name="address" value="${job.address}"></td>
                </tr>
                <tr>
                    <td>Email liên hệ:</td>
                    <td><input type="email" name="contactEmail" value="${job.contactEmail}"></td>
                </tr>
                <tr>
                    <td>Số điện thoại:</td>
                    <td><input type="text" name="contactPhone" value="${job.contactPhone}"></td>
                </tr>
                <tr>
                    <td>Lương tối thiểu:</td>
                    <td><input type="number" step="0.01" name="salary_min" value="${job.salaryMin}"></td>
                </tr>
                <tr>
                    <td>Lương tối đa:</td>
                    <td><input type="number" step="0.01" name="salary_max" value="${job.salaryMax}"></td>
                </tr>
                <tr>
                    <td>Trạng thái:</td>
                    <td>
                        <select name="statusID">
                            <option value="1" ${job.statusID == 1 ? 'selected' : ''}>OPEN</option>
                            <option value="2" ${job.statusID == 2 ? 'selected' : ''}>CLOSED</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="Lưu">
                        <a href="view/employer/manage-jobs.jsp" class="btn-cancel">Hủy</a>
                    </td>
                </tr>
            </table>
        </form>
        <p class="note">* Vui lòng điền đầy đủ thông tin để đăng tin tuyển dụng.</p>
    </div>
</body>
</html>
