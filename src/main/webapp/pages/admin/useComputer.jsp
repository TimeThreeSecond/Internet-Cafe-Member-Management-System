<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Consumption" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Consumption> activeSessions = (List<Consumption>) request.getAttribute("activeSessions");
    if (activeSessions == null) activeSessions = new java.util.ArrayList<>();
    List<Consumption> recentSessions = (List<Consumption>) request.getAttribute("recentSessions");
    if (recentSessions == null) recentSessions = new java.util.ArrayList<>();
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>上机管理 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .session-card {
            border-left: 4px solid #198754;
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
                    <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>个人资料</a></li>
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/memberManage">
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/admin/useComputer">
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
                <h1 class="h2"><i class="fas fa-power-off me-2"></i>上机管理</h1>
            </div>

            <!-- 消息提示 -->
            <% if (success != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i><%= success %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <!-- 统计卡片 -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-warning">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">上机中</p>
                                    <h3 class="mb-0"><%= activeSessions.size() %></h3>
                                </div>
                                <i class="fas fa-user fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-success">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">可用电脑</p>
                                    <h3 class="mb-0"><%= request.getAttribute("totalAvailable") != null ? request.getAttribute("totalAvailable") : 0 %></h3>
                                </div>
                                <i class="fas fa-desktop fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-info">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">今日记录</p>
                                    <h3 class="mb-0"><%= recentSessions.size() %></h3>
                                </div>
                                <i class="fas fa-history fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 上机操作区域 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-play-circle me-2"></i>上机操作</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin/useComputer" method="post" class="row g-3">
                        <input type="hidden" name="action" value="online">
                        <div class="col-md-3">
                            <label for="memberId" class="form-label">会员ID</label>
                            <input type="number" class="form-control" id="memberId" name="memberId"
                                   placeholder="输入会员ID" required>
                        </div>
                        <div class="col-md-3">
                            <label for="computerId" class="form-label">电脑ID</label>
                            <input type="number" class="form-control" id="computerId" name="computerId"
                                   placeholder="输入电脑ID" required>
                        </div>
                        <div class="col-md-3">
                            <label for="consumptionType" class="form-label">上机类型</label>
                            <select class="form-select" id="consumptionType" name="consumptionType">
                                <option value="1">普通上机</option>
                                <option value="2">包房</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-success w-100">
                                <i class="fas fa-play me-1"></i>开始上机
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 进行中的上机 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-clock me-2"></i>进行中的上机 (<%= activeSessions.size() %>)
                    </h6>
                </div>
                <div class="card-body">
                    <% if (activeSessions.isEmpty()) { %>
                    <div class="text-center py-4">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">暂无进行中的上机记录</p>
                    </div>
                    <% } else { %>
                    <div class="row">
                        <% for (Consumption c : activeSessions) { %>
                        <div class="col-md-6 mb-3">
                            <div class="card session-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h5 class="card-title mb-1">
                                                <%= c.getMemberNickname() != null ? c.getMemberNickname() : c.getMemberUsername() %>
                                            </h5>
                                            <p class="text-muted mb-0 small">
                                                <i class="fas fa-desktop me-1"></i><%= c.getComputerNo() %> (<%= c.getComputerLocation() %>)
                                            </p>
                                        </div>
                                        <span class="badge bg-success">上机中</span>
                                    </div>
                                    <hr>
                                    <div class="row text-center">
                                        <div class="col-4">
                                            <p class="mb-0 small text-muted">开始时间</p>
                                            <p class="mb-0 fw-bold">
                                                <%= new java.text.SimpleDateFormat("HH:mm").format(c.getStartTime()) %>
                                            </p>
                                        </div>
                                        <div class="col-4">
                                            <p class="mb-0 small text-muted">时长</p>
                                            <p class="mb-0 fw-bold"><%= c.getDuration() %> 分钟</p>
                                        </div>
                                        <div class="col-4">
                                            <p class="mb-0 small text-muted">当前金额</p>
                                            <p class="mb-0 fw-bold text-danger">¥<%= c.getAmount() %></p>
                                        </div>
                                    </div>
                                    <div class="mt-2">
                                        <button class="btn btn-danger w-100" onclick="offline(<%= c.getConsumptionId() %>)">
                                            <i class="fas fa-stop me-1"></i>下机结算
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- 最近上机记录 -->
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-history me-2"></i>最近上机记录
                    </h6>
                </div>
                <div class="card-body">
                    <% if (recentSessions.isEmpty()) { %>
                    <div class="text-center py-4">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">暂无上机记录</p>
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>会员</th>
                                    <th>电脑</th>
                                    <th>类型</th>
                                    <th>开始时间</th>
                                    <th>结束时间</th>
                                    <th>时长</th>
                                    <th>金额</th>
                                    <th>状态</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Consumption c : recentSessions) { %>
                                <tr>
                                    <td>
                                        <%= c.getMemberNickname() != null ? c.getMemberNickname() : c.getMemberUsername() %>
                                    </td>
                                    <td><%= c.getComputerNo() %></td>
                                    <td><span class="badge bg-info"><%= c.getConsumptionTypeText() %></span></td>
                                    <td><%= new java.text.SimpleDateFormat("MM-dd HH:mm").format(c.getStartTime()) %></td>
                                    <td>
                                        <%= c.getEndTime() != null ? new java.text.SimpleDateFormat("HH:mm").format(c.getEndTime()) : "-" %>
                                    </td>
                                    <td><%= c.getDuration() %> 分钟</td>
                                    <td class="text-danger fw-bold">¥<%= c.getAmount() %></td>
                                    <td>
                                        <% if (c.getEndTime() == null) { %>
                                            <span class="badge bg-success">上机中</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">已结束</span>
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
<script>
// 下机结算
function offline(consumptionId) {
    if (confirm('确定要结束上机并结算吗？系统将自动计算费用并扣除余额。')) {
        window.location.href = '<%= request.getContextPath() %>/admin/useComputer?action=offline&consumptionId=' + consumptionId;
    }
}

// 自动刷新页面（每30秒）
setInterval(function() {
    location.reload();
}, 30000);
</script>
</body>
</html>
