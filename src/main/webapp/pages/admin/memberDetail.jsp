<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Member" %>
<%@ page import="com.yourcompany.netbarmanager.service.MemberService" %>
<%@ page import="com.yourcompany.netbarmanager.service.MemberServiceImpl" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Consumption" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    Member member = (Member) request.getAttribute("member");
    if (member == null) {
        String memberIdStr = request.getParameter("id");
        if (memberIdStr != null) {
            try {
                int memberId = Integer.parseInt(memberIdStr);
                MemberService memberService = new MemberServiceImpl();
                member = memberService.getMemberById(memberId);
            } catch (NumberFormatException e) {
                // 忽略无效ID
            }
        }
    }

    if (member == null) {
        response.sendRedirect(request.getContextPath() + "/admin/memberManage");
        return;
    }

%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>会员详情 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .detail-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 48px;
            margin: 0 auto;
        }
        .info-card {
            border-left: 4px solid #667eea;
        }
    </style>
</head>
<body>
<!-- 顶部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/admin/index">
            <i class="fas fa-gamepad me-2"></i>
            网吧会员管理系统
        </a>
        <div class="navbar-nav ms-auto">
            <div class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                    <i class="fas fa-user-circle me-1"></i>
                    <%= admin.getRealName() != null ? admin.getRealName() : admin.getUsername() %>
                </a>
                <ul class="dropdown-menu">
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt me-2"></i>退出登录</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <!-- 侧边栏 -->
        <nav class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/index">
                            <i class="fas fa-tachometer-alt me-2"></i>首页
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/admin/memberManage">
                            <i class="fas fa-users me-2"></i>会员管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/recharge">
                            <i class="fas fa-credit-card me-2"></i>充值管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/computerManage">
                            <i class="fas fa-desktop me-2"></i>设备管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/useComputer">
                            <i class="fas fa-power-off me-2"></i>上机管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/refund">
                            <i class="fas fa-undo me-2"></i>退费管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/statistics">
                            <i class="fas fa-chart-bar me-2"></i>统计报表
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- 主内容区域 -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">
                    <i class="fas fa-user me-2"></i>会员详情
                </h1>
                <div class="btn-group">
                    <a href="<%= request.getContextPath() %>/admin/memberManage" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i>返回列表
                    </a>
                </div>
            </div>

            <!-- 会员基本信息卡片 -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card shadow h-100">
                        <div class="card-body text-center">
                            <div class="detail-avatar mb-3">
                                <%= member.getNickname() != null && !member.getNickname().isEmpty() ? member.getNickname().substring(0, 1).toUpperCase() : member.getUsername().substring(0, 1).toUpperCase() %>
                            </div>
                            <h4><%= member.getNickname() != null ? member.getNickname() : "未设置昵称" %></h4>
                            <p class="text-muted">@<%= member.getUsername() %></p>
                            <div class="mt-3">
                                <span class="badge bg-warning fs-6">Level <%= member.getLevel() %></span>
                                <% if (member.getStatus() == 1) { %>
                                    <span class="badge bg-success ms-1">正常</span>
                                <% } else { %>
                                    <span class="badge bg-danger ms-1">冻结</span>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="card shadow h-100">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>基本信息</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <div class="info-card p-3 bg-light rounded">
                                        <small class="text-muted">会员ID</small>
                                        <h5 class="mb-0">#<%= member.getMemberId() %></h5>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="info-card p-3 bg-light rounded">
                                        <small class="text-muted">用户名</small>
                                        <h5 class="mb-0"><%= member.getUsername() %></h5>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="info-card p-3 bg-light rounded">
                                        <small class="text-muted">昵称</small>
                                        <h5 class="mb-0"><%= member.getNickname() != null ? member.getNickname() : "-" %></h5>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="info-card p-3 bg-light rounded">
                                        <small class="text-muted">性别</small>
                                        <h5 class="mb-0">
                                            <% switch(member.getGender()) {
                                                case 1: out.print("男"); break;
                                                case 2: out.print("女"); break;
                                                default: out.print("保密"); break;
                                            } %>
                                        </h5>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="info-card p-3 bg-light rounded">
                                        <small class="text-muted">电话</small>
                                        <h5 class="mb-0"><%= member.getPhone() != null ? member.getPhone() : "-" %></h5>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="info-card p-3 bg-light rounded">
                                        <small class="text-muted">注册时间</small>
                                        <h5 class="mb-0"><%= member.getRegisterTime() %></h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 联系方式 -->
            <div class="card shadow mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-address-book me-2"></i>联系方式</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <p><strong><i class="fas fa-phone me-2 text-primary"></i>电话：</strong><%= member.getPhone() != null ? member.getPhone() : "未填写" %></p>
                        </div>
                        <div class="col-md-4">
                            <p><strong><i class="fab fa-qq me-2 text-primary"></i>QQ：</strong><%= member.getQq() != null ? member.getQq() : "未填写" %></p>
                        </div>
                        <div class="col-md-4">
                            <p><strong><i class="fab fa-weixin me-2 text-primary"></i>微信：</strong><%= member.getWechat() != null ? member.getWechat() : "未填写" %></p>
                        </div>
                        <div class="col-md-12">
                            <p><strong><i class="fas fa-envelope me-2 text-primary"></i>邮箱：</strong><%= member.getEmail() != null ? member.getEmail() : "未填写" %></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 账户信息 -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card shadow text-center">
                        <div class="card-body">
                            <h6 class="text-muted">账户余额</h6>
                            <h3 class="text-success">¥<%= member.getBalance() %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow text-center">
                        <div class="card-body">
                            <h6 class="text-muted">累计消费</h6>
                            <h3 class="text-danger">¥<%= member.getTotalConsumption() %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow text-center">
                        <div class="card-body">
                            <h6 class="text-muted">积分</h6>
                            <h3 class="text-primary"><%= member.getPoints() %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow text-center">
                        <div class="card-body">
                            <h6 class="text-muted">会员等级</h6>
                            <h3 class="text-warning">Level <%= member.getLevel() %></h3>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
