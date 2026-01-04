<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Admin admin = (Admin) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    String type = (String) request.getAttribute("type");
    String date = (String) request.getAttribute("date");
    Map<Integer, Integer> levelDistribution = (Map<Integer, Integer>) request.getAttribute("levelDistribution");
    Integer totalMembers = (Integer) request.getAttribute("totalMembers");

    Map<Integer, BigDecimal> rechargeByType = (Map<Integer, BigDecimal>) request.getAttribute("rechargeByType");
    BigDecimal totalRecharge = (BigDecimal) request.getAttribute("totalRecharge");
    BigDecimal totalRefund = (BigDecimal) request.getAttribute("totalRefund");
    BigDecimal netIncome = (BigDecimal) request.getAttribute("netIncome");

    Map<String, BigDecimal> dailyIncome = (Map<String, BigDecimal>) request.getAttribute("dailyIncome");
    Map<String, Integer> dailyCount = (Map<String, Integer>) request.getAttribute("dailyCount");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>统计报表 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    <style>
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .chart-container {
            position: relative;
            height: 300px;
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/admin/statistics">
                            <i class="fas fa-chart-bar me-2"></i>统计报表
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- 主内容区域 -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2"><i class="fas fa-chart-bar me-2"></i>统计报表</h1>
            </div>

            <!-- 筛选区域 -->
            <div class="card shadow mb-4">
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin/statistics" method="get" class="row g-3">
                        <div class="col-md-3">
                            <label for="type" class="form-label">统计类型</label>
                            <select class="form-select" id="type" name="type" onchange="this.form.submit()">
                                <option value="daily" <%= "daily".equals(type) ? "selected" : "" %>>当日统计</option>
                                <option value="monthly" <%= "monthly".equals(type) ? "selected" : "" %>>当月统计</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="date" class="form-label">日期</label>
                            <input type="date" class="form-control" id="date" name="date"
                                   value="<%= date != null ? date : "" %>" onchange="this.form.submit()">
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <a href="<%= request.getContextPath() %>/admin/statistics" class="btn btn-secondary">
                                <i class="fas fa-redo me-1"></i>重置为今天
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 收入统计卡片 -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-success">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">总收入</p>
                                    <h3 class="mb-0">¥<%= totalRecharge != null ? totalRecharge : "0.00" %></h3>
                                </div>
                                <i class="fas fa-wallet fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-danger">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">总退费</p>
                                    <h3 class="mb-0">¥<%= totalRefund != null ? totalRefund : "0.00" %></h3>
                                </div>
                                <i class="fas fa-undo fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-primary">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">净收入</p>
                                    <h3 class="mb-0">¥<%= netIncome != null ? netIncome : "0.00" %></h3>
                                </div>
                                <i class="fas fa-chart-line fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-info">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">充值笔数</p>
                                    <h3 class="mb-0"><%= request.getAttribute("rechargeCount") != null ? request.getAttribute("rechargeCount") : 0 %></h3>
                                </div>
                                <i class="fas fa-receipt fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <% if ("daily".equals(type) || type == null) { %>
            <!-- 当日统计 -->
            <div class="row">
                <div class="col-md-6">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-money-bill-wave me-2"></i>收入方式分布</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="rechargeTypeChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-list me-2"></i>收入明细</h6>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>支付方式</th>
                                        <th>金额</th>
                                        <th>占比</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>现金</td>
                                        <td class="text-success">¥<%= rechargeByType != null && rechargeByType.get(1) != null ? rechargeByType.get(1) : "0.00" %></td>
                                        <td><%= rechargeByType != null && totalRecharge != null && totalRecharge.compareTo(BigDecimal.ZERO) > 0 ? String.format("%.1f%%", rechargeByType.get(1).multiply(new BigDecimal("100")).divide(totalRecharge, 1, java.math.RoundingMode.HALF_UP)) : "0.0%" %></td>
                                    </tr>
                                    <tr>
                                        <td>线上支付</td>
                                        <td class="text-success">¥<%= rechargeByType != null && rechargeByType.get(2) != null ? rechargeByType.get(2) : "0.00" %></td>
                                        <td><%= rechargeByType != null && totalRecharge != null && totalRecharge.compareTo(BigDecimal.ZERO) > 0 ? String.format("%.1f%%", rechargeByType.get(2).multiply(new BigDecimal("100")).divide(totalRecharge, 1, java.math.RoundingMode.HALF_UP)) : "0.0%" %></td>
                                    </tr>
                                    <tr>
                                        <td>其他</td>
                                        <td class="text-success">¥<%= rechargeByType != null && rechargeByType.get(3) != null ? rechargeByType.get(3) : "0.00" %></td>
                                        <td><%= rechargeByType != null && totalRecharge != null && totalRecharge.compareTo(BigDecimal.ZERO) > 0 ? String.format("%.1f%%", rechargeByType.get(3).multiply(new BigDecimal("100")).divide(totalRecharge, 1, java.math.RoundingMode.HALF_UP)) : "0.0%" %></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <!-- 当月统计 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-chart-line me-2"></i>当月收入趋势</h6>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="dailyIncomeChart"></canvas>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- 会员等级分布 -->
            <div class="row">
                <div class="col-md-6">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-users me-2"></i>会员等级分布</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="levelChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-list me-2"></i>会员等级明细</h6>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>等级</th>
                                        <th>人数</th>
                                        <th>占比</th>
                                        <th>进度</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (int i = 1; i <= 5; i++) { %>
                                    <tr>
                                        <td><span class="badge bg-warning text-dark">Level <%= i %></span></td>
                                        <td><%= levelDistribution != null ? levelDistribution.get(i) : 0 %> 人</td>
                                        <td><%= totalMembers != null && totalMembers > 0 ? String.format("%.1f%%", levelDistribution.get(i) * 100.0 / totalMembers) : "0.0%" %></td>
                                        <td>
                                            <div class="progress" style="height: 20px;">
                                                <div class="progress-bar bg-warning" role="progressbar"
                                                     style="width: <%= totalMembers != null && totalMembers > 0 ? levelDistribution.get(i) * 100.0 / totalMembers : 0 %>%"
                                                     aria-valuenow="<%= levelDistribution.get(i) %>" aria-valuemin="0" aria-valuemax="<%= totalMembers %>">
                                                    <%= totalMembers != null && totalMembers > 0 ? String.format("%.1f%%", levelDistribution.get(i) * 100.0 / totalMembers) : "0.0%" %>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script>
<% if ("daily".equals(type) || type == null) { %>
// 收入方式饼图
const rechargeTypeCtx = document.getElementById('rechargeTypeChart').getContext('2d');
new Chart(rechargeTypeCtx, {
    type: 'pie',
    data: {
        labels: ['现金', '线上支付', '其他'],
        datasets: [{
            data: [
                <%= rechargeByType != null ? rechargeByType.get(1) : 0 %>,
                <%= rechargeByType != null ? rechargeByType.get(2) : 0 %>,
                <%= rechargeByType != null ? rechargeByType.get(3) : 0 %>
            ],
            backgroundColor: ['#198754', '#0dcaf0', '#6c757d']
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    }
});

// 会员等级饼图
const levelCtx = document.getElementById('levelChart').getContext('2d');
new Chart(levelCtx, {
    type: 'pie',
    data: {
        labels: ['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'],
        datasets: [{
            data: [
                <%= levelDistribution != null ? levelDistribution.get(1) : 0 %>,
                <%= levelDistribution != null ? levelDistribution.get(2) : 0 %>,
                <%= levelDistribution != null ? levelDistribution.get(3) : 0 %>,
                <%= levelDistribution != null ? levelDistribution.get(4) : 0 %>,
                <%= levelDistribution != null ? levelDistribution.get(5) : 0 %>
            ],
            backgroundColor: ['#ffc107', '#fd7e14', '#dc3545', '#0d6efd', '#6610f2']
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    }
});
<% } else { %>
// 当月收入趋势柱状图
const dailyIncomeCtx = document.getElementById('dailyIncomeChart').getContext('2d');
new Chart(dailyIncomeCtx, {
    type: 'bar',
    data: {
        labels: [
            <% if (dailyIncome != null) { %>
                <%= String.join("', '", dailyIncome.keySet()) %>
            <% } %>
        ],
        datasets: [{
            label: '收入 (元)',
            data: [
                <% if (dailyIncome != null) { %>
                    <%= dailyIncome.values().stream().map(v -> v.toString()).collect(java.util.stream.Collectors.joining(", ")) %>
                <% } %>
            ],
            backgroundColor: '#198754'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: false
            }
        },
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});

// 会员等级饼图
const levelCtx = document.getElementById('levelChart').getContext('2d');
new Chart(levelCtx, {
    type: 'pie',
    data: {
        labels: ['Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'],
        datasets: [{
            data: [
                <%= levelDistribution != null ? levelDistribution.get(1) : 0 %>,
                <%= levelDistribution != null ? levelDistribution.get(2) : 0 %>,
                <%= levelDistribution != null ? levelDistribution.get(3) : 0 %>,
                <%= levelDistribution != null ? levelDistribution.get(4) : 0 %>,
                <%= levelDistribution != null ? levelDistribution.get(5) : 0 %>
            ],
            backgroundColor: ['#ffc107', '#fd7e14', '#dc3545', '#0d6efd', '#6610f2']
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    }
});
<% } %>
</script>
</body>
</html>
