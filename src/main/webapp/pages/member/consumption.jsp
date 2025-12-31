<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Member" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Consumption" %>
<%@ page import="java.util.List" %>
<%
    Member member = (Member) session.getAttribute("user");
    if (member == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Consumption> consumptions = (List<Consumption>) request.getAttribute("consumptions");
    if (consumptions == null) consumptions = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>消费记录 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<!-- 顶部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/member/index">
            <i class="fas fa-gamepad me-2"></i>
            网吧会员管理系统
        </a>
        <div class="navbar-nav ms-auto">
            <div class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                    <i class="fas fa-user-circle me-1"></i>
                    <%= member.getNickname() != null ? member.getNickname() : member.getUsername() %>
                </a>
                <ul class="dropdown-menu">
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
                <div class="text-center mb-4">
                    <div class="avatar-circle" style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: bold; margin: 0 auto;">
                        <%= member.getNickname() != null && !member.getNickname().isEmpty() ? member.getNickname().substring(0, 1) : member.getUsername().substring(0, 1) %>
                    </div>
                    <h5 class="mt-2"><%= member.getNickname() != null ? member.getNickname() : member.getUsername() %></h5>
                    <span class="badge bg-warning text-dark">Level <%= member.getLevel() %></span>
                    <p class="text-muted small mb-1">积分: <%= member.getPoints() %></p>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/member/index">
                            <i class="fas fa-home me-2"></i>会员中心
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/member/profile">
                            <i class="fas fa-user me-2"></i>个人资料
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/member/consumption">
                            <i class="fas fa-list-alt me-2"></i>消费记录
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/member/recharge">
                            <i class="fas fa-credit-card me-2"></i>在线充值
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/member/refund">
                            <i class="fas fa-undo me-2"></i>退费申请
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- 主内容区域 -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2"><i class="fas fa-list-alt me-2"></i>消费记录</h1>
            </div>

            <!-- 统计卡片 -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-primary">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">账户余额</p>
                                    <h3 class="mb-0">¥<%= member.getBalance() %></h3>
                                </div>
                                <i class="fas fa-wallet fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-danger">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">总消费</p>
                                    <h3 class="mb-0">¥<%= request.getAttribute("totalAmount") != null ? request.getAttribute("totalAmount") : "0.00" %></h3>
                                </div>
                                <i class="fas fa-shopping-cart fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-info">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">消费笔数</p>
                                    <h3 class="mb-0"><%= request.getAttribute("totalCount") != null ? request.getAttribute("totalCount") : 0 %></h3>
                                </div>
                                <i class="fas fa-receipt fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 筛选表单 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-filter me-2"></i>筛选条件</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/member/consumption" method="get" class="row g-3">
                        <div class="col-md-3">
                            <label for="startDate" class="form-label">开始日期</label>
                            <input type="date" class="form-control" id="startDate" name="startDate"
                                   value="<%= request.getAttribute("startDate") != null ? request.getAttribute("startDate") : "" %>">
                        </div>
                        <div class="col-md-3">
                            <label for="endDate" class="form-label">结束日期</label>
                            <input type="date" class="form-control" id="endDate" name="endDate"
                                   value="<%= request.getAttribute("endDate") != null ? request.getAttribute("endDate") : "" %>">
                        </div>
                        <div class="col-md-3">
                            <label for="type" class="form-label">消费类型</label>
                            <select class="form-select" id="type" name="type">
                                <option value="">全部</option>
                                <option value="1" <%= "1".equals(request.getAttribute("type")) ? "selected" : "" %>>上机</option>
                                <option value="2" <%= "2".equals(request.getAttribute("type")) ? "selected" : "" %>>包房</option>
                                <option value="3" <%= "3".equals(request.getAttribute("type")) ? "selected" : "" %>>商品</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-1"></i>查询
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 消费记录列表 -->
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-list me-2"></i>消费记录列表 (<%= consumptions.size() %>)
                    </h6>
                </div>
                <div class="card-body">
                    <% if (consumptions.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">暂无消费记录</p>
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>消费时间</th>
                                    <th>消费类型</th>
                                    <th>设备</th>
                                    <th>时长(分钟)</th>
                                    <th>金额</th>
                                    <th>状态</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Consumption c : consumptions) { %>
                                <tr>
                                    <td>
                                        <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(c.getStartTime()) %>
                                    </td>
                                    <td>
                                        <span class="badge bg-info"><%= c.getConsumptionTypeText() %></span>
                                    </td>
                                    <td>
                                        <%= c.getComputerNo() != null ? c.getComputerNo() : "-" %>
                                        <%= c.getComputerLocation() != null ? "(" + c.getComputerLocation() + ")" : "" %>
                                    </td>
                                    <td><%= c.getDuration() > 0 ? c.getDuration() : "-" %></td>
                                    <td class="text-danger fw-bold">
                                        <% if (c.getAmount() != null && c.getAmount().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                                            -¥<%= c.getAmount() %>
                                        <% } else { %>
                                            ¥<%= c.getAmount() != null ? c.getAmount() : "0.00" %>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (c.getEndTime() == null) { %>
                                            <span class="badge bg-warning">进行中</span>
                                        <% } else { %>
                                            <span class="badge bg-success">已完成</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
</body>
</html>
