<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Hồ sơ công ty</title>
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
            .row {
                display:flex;
                gap:20px;
            }
            .logo {
                width:120px;
                height:120px;
                object-fit:contain;
                border:1px solid #ccc;
                border-radius:10px;
            }
            .info {
                flex:1;
            }
            .label {
                color:#666;
                font-size:13px;
            }
            .value {
                margin-bottom:10px;
            }
            .btn {
                display:inline-block;
                padding:8px 14px;
                background:#1aa94c;
                color:#fff;
                border-radius:8px;
                text-decoration:none;
            }
            .btn-outline {
                background:#eee;
                color:#111;
            }
        </style>
    </head>
    <body>
        <div class="wrap">
            <div class="card">
                <h2>Hồ sơ công ty</h2>
                <div class="row">
                    <img class="logo" src="${empty company.logo ? 'https://via.placeholder.com/120x120?text=Logo' : company.logo}">
                    <div class="info">
                        <div class="label">Tên công ty</div>
                        <div class="value"><b>${company.name}</b></div>

                        <div class="label">Ngành nghề</div>
                        <div class="value">${company.industry}</div>

                        <div class="label">Quy mô</div>
                        <div class="value">${company.size}</div>

                        <a href="employer/company?action=edit" class="btn">Chỉnh sửa</a>
                        <a href="view/employer/dashboard.jsp" class="btn btn-outline">Về Dashboard</a>
                    </div>
                </div>

                <hr>
                <div class="label">Thành phố</div><div class="value">${company.city}</div>
                <div class="label">Địa chỉ</div><div class="value">${company.address}</div>
                <div class="label">Website</div><div class="value"><a href="${company.website}" target="_blank">${company.website}</a></div>
                <div class="label">Mô tả</div><div class="value">${company.description}</div>
            </div>
        </div>
    </body>
</html>
