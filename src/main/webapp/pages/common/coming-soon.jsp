<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin, com.yourcompany.netbarmanager.bean.Member" %>
<%
    String userType = (String) session.getAttribute("userType");
    Object user = session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    String name = "";
    String homeUrl = "";

    if ("admin".equals(userType) && user instanceof Admin) {
        Admin admin = (Admin) user;
        name = admin.getRealName() != null ? admin.getRealName() : admin.getUsername();
        homeUrl = request.getContextPath() + "/pages/admin/index.jsp";
    } else if ("member".equals(userType) && user instanceof Member) {
        Member member = (Member) user;
        name = member.getNickname() != null ? member.getNickname() : member.getUsername();
        homeUrl = request.getContextPath() + "/pages/member/index.jsp";
    } else {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "功能页面";
    String message = (String) request.getAttribute("message");
    if (message == null) message = "功能即将上线，敬请期待！";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - 即将上线</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .coming-soon-container {
            background: white;
            border-radius: 20px;
            padding: 60px 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
            max-width: 500px;
            width: 100%;
            animation: fadeInUp 0.6s ease-out;
        }
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .icon-container {
            width: 120px;
            height: 120px;
            margin: 0 auto 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: pulse 2s ease-in-out infinite;
        }
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }
        .icon-container i {
            font-size: 50px;
            color: white;
        }
        .coming-soon-container h1 {
            color: #333;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .coming-soon-container p {
            color: #666;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .coming-soon-container .user-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
            color: #495057;
        }
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 40px;
            font-size: 16px;
            border-radius: 30px;
            transition: all 0.3s ease;
        }
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
    </style>
</head>
<body>
    <div class="coming-soon-container">
        <div class="icon-container">
            <i class="fas fa-clock"></i>
        </div>
        <h1><%= pageTitle %> - 即将上线</h1>
        <div class="user-info">
            <i class="fas fa-user-circle me-2"></i>
            欢迎您，<strong><%= name %></strong>
        </div>
        <p><%= message %></p>
        <p class="text-muted small">我们正在努力完善该功能，敬请期待...</p>
        <a href="<%= homeUrl %>" class="btn btn-primary btn-home">
            <i class="fas fa-home me-2"></i>返回首页
        </a>
    </div>
</body>
</html>
