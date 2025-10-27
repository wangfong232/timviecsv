<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa thông tin công ty</title>
        <style>
            body {
                font-family:'Segoe UI',sans-serif;
                background:#f5f7fa;
                margin:0;
                padding:20px;
            }
            .wrap {
                max-width:900px;
                margin:auto;
            }
            .card {
                background:#fff;
                padding:20px;
                border-radius:10px;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
            }
            h2 {
                color:#1aa94c;
                border-bottom:2px solid #1aa94c;
                padding-bottom:8px;
            }
            input,textarea,select {
                width:100%;
                padding:8px;
                margin:4px 0;
                border:1px solid #ccc;
                border-radius:6px;
            }
            textarea {
                min-height:100px;
            }
            .btn {
                padding:8px 14px;
                border:none;
                border-radius:8px;
                background:#1aa94c;
                color:#fff;
                cursor:pointer;
            }
            .btn-cancel {
                background:#ccc;
                color:#111;
                text-decoration:none;
                padding:8px 14px;
                border-radius:8px;
            }
            .logo-preview {
                width:120px;
                height:120px;
                object-fit:contain;
                border:1px solid #ccc;
                border-radius:8px;
                margin-top:8px;
            }
        </style>
    </head>
    <body>
        <div class="wrap">
            <div class="card">
                <h2>Chỉnh sửa thông tin công ty</h2>

                <!-- Form cập nhật logo -->
                <form method="post" action="employer/company">
                    <input type="hidden" name="action" value="logo">
                    <label>Logo URL:</label>
                    <input type="text" name="logo" value="${company.logo}">
                    <img class="logo-preview" src="${empty company.logo ? 'https://via.placeholder.com/120x120?text=Logo' : company.logo}">
                    <button type="submit" class="btn">Cập nhật logo</button>
                </form>

                <hr>

                <!-- Form cập nhật thông tin công ty -->
                <form method="post" action="employer/company">
                    <input type="hidden" name="action" value="update">

                    <label>Tên công ty:</label>
                    <input type="text" name="name" value="${company.name}" required>

                    <label>Ngành:</label>
                    <input type="text" name="industry" value="${company.industry}">

                    <label>Quy mô:</label>
                    <select name="size">
                        <option value="">-- Chọn --</option>
                        <option value="1-10" ${company.size == '1-10' ? 'selected' : ''}>1-10</option>
                        <option value="11-50" ${company.size == '11-50' ? 'selected' : ''}>11-50</option>
                        <option value="51-200" ${company.size == '51-200' ? 'selected' : ''}>51-200</option>
                        <option value="201-500" ${company.size == '201-500' ? 'selected' : ''}>201-500</option>
                        <option value="500+" ${company.size == '500+' ? 'selected' : ''}>500+</option>
                    </select>

                    <label>Thành phố:</label>
                    <input type="text" name="city" value="${company.city}">

                    <label>Địa chỉ:</label>
                    <input type="text" name="address" value="${company.address}">

                    <label>Website:</label>
                    <input type="text" name="website" value="${company.website}">

                    <label>Mô tả:</label>
                    <textarea name="description">${company.description}</textarea>

                    <button type="submit" class="btn">Lưu</button>
                    <a href="employer/company" class="btn-cancel">Hủy</a>
                </form>
            </div>
        </div>
    </body>
</html>
