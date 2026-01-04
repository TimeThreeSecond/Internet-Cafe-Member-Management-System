<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Member" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Refund" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    // 从Servlet获取数据
    Integer totalMembers = (Integer) request.getAttribute("totalMembers");
    java.math.BigDecimal todayIncome = (java.math.BigDecimal) request.getAttribute("todayIncome");
    Integer inUseComputers = (Integer) request.getAttribute("inUseComputers");
    Integer totalComputers = (Integer) request.getAttribute("totalComputers");
    Integer pendingRefunds = (Integer) request.getAttribute("pendingRefunds");
    List<Member> recentMembers = (List<Member>) request.getAttribute("recentMembers");
    List<Refund> pendingRefundList = (List<Refund>) request.getAttribute("pendingRefundList");
    if (totalMembers == null) totalMembers = 0;
    if (todayIncome == null) todayIncome = java.math.BigDecimal.ZERO;
    if (inUseComputers == null) inUseComputers = 0;
    if (totalComputers == null) totalComputers = 0;
    if (pendingRefunds == null) pendingRefunds = 0;
    if (recentMembers == null) recentMembers = new java.util.ArrayList<>();
    if (pendingRefundList == null) pendingRefundList = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员首页 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
</head>
<body>
<!-- 顶部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
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
                        <a class="nav-link active" href="#">
                            <i class="fas fa-tachometer-alt me-2"></i>
                            首页
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/memberManage">
                            <i class="fas fa-users me-2"></i>
                            会员管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/recharge">
                            <i class="fas fa-credit-card me-2"></i>
                            充值管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/computerManage">
                            <i class="fas fa-desktop me-2"></i>
                            设备管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/useComputer">
                            <i class="fas fa-power-off me-2"></i>
                            上机管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/refund">
                            <i class="fas fa-undo me-2"></i>
                            退费管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/statistics">
                            <i class="fas fa-chart-bar me-2"></i>
                            统计报表
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- 主内容区域 -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">管理员首页</h1>
            </div>

            <!-- 统计卡片 -->
            <div class="row mb-4">
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">会员总数</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800"><%= totalMembers %></div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-users fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-success shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">今日收入</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800">¥<%= todayIncome %></div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-info shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">上机电脑</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800"><%= inUseComputers %> / <%= totalComputers %></div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-desktop fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-warning shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">待处理退费</div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800"><%= pendingRefunds %></div>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-undo fa-2x text-gray-300"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 快捷操作 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">快捷操作</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="d-grid">
                                <a href="<%= request.getContextPath() %>/admin/memberManage" class="btn btn-outline-primary btn-lg">
                                    <i class="fas fa-user-plus me-2"></i>
                                    会员开户
                                </a>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="d-grid">
                                <a href="<%= request.getContextPath() %>/admin/recharge" class="btn btn-outline-success btn-lg">
                                    <i class="fas fa-credit-card me-2"></i>
                                    会员充值
                                </a>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="d-grid">
                                <a href="<%= request.getContextPath() %>/admin/useComputer" class="btn btn-outline-info btn-lg">
                                    <i class="fas fa-power-off me-2"></i>
                                    开机上机
                                </a>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6 mb-3">
                            <div class="d-grid">
                                <a href="<%= request.getContextPath() %>/admin/statistics" class="btn btn-outline-warning btn-lg">
                                    <i class="fas fa-chart-bar me-2"></i>
                                    查看报表
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 会员搜索区域 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">会员搜索</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin/memberManage" method="get" class="row g-3">
                        <div class="col-md-3">
                            <label for="keyword" class="form-label">关键字</label>
                            <input type="text" class="form-control" id="keyword" name="keyword" placeholder="用户名/昵称/电话">
                        </div>
                        <div class="col-md-2">
                            <label for="level" class="form-label">会员等级</label>
                            <select class="form-select" id="level" name="level">
                                <option value="">全部</option>
                                <option value="1">1级</option>
                                <option value="2">2级</option>
                                <option value="3">3级</option>
                                <option value="4">4级</option>
                                <option value="5">5级</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="gender" class="form-label">性别</label>
                            <select class="form-select" id="gender" name="gender">
                                <option value="">全部</option>
                                <option value="1">男</option>
                                <option value="2">女</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-1"></i>搜索
                            </button>
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <a href="<%= request.getContextPath() %>/admin/memberManage" class="btn btn-secondary w-100">
                                <i class="fas fa-redo me-1"></i>重置
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 会员列表 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">最近会员列表</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>用户名</th>
                                <th>昵称</th>
                                <th>性别</th>
                                <th>电话</th>
                                <th>余额</th>
                                <th>积分</th>
                                <th>等级</th>
                                <th>总消费</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (recentMembers.isEmpty()) { %>
                            <tr><td colspan="8" class="text-center text-muted">暂无会员数据</td></tr>
                            <% } else { %>
                            <% for (Member m : recentMembers) { %>
                            <tr>
                                <td><%= m.getUsername() %></td>
                                <td><%= m.getNickname() != null ? m.getNickname() : "-" %></td>
                                <td>
                                    <% switch(m.getGender()) {
                                        case 1: out.print("男"); break;
                                        case 2: out.print("女"); break;
                                        default: out.print("未知"); break;
                                    } %>
                                </td>
                                <td><%= m.getPhone() != null ? m.getPhone() : "-" %></td>
                                <td class="text-success">¥<%= m.getBalance() %></td>
                                <td><%= m.getPoints() %></td>
                                <td><span class="badge bg-warning">Level <%= m.getLevel() %></span></td>
                                <td>¥<%= m.getTotalConsumption() %></td>
                            </tr>
                            <% } %>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 退费申请待审批列表 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">退费申请待审批列表</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>申请ID</th>
                                <th>会员ID</th>
                                <th>申请时间</th>
                                <th>申请金额</th>
                                <th>退费原因</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (pendingRefundList.isEmpty()) { %>
                            <tr><td colspan="6" class="text-center text-muted">暂无待审批退费申请</td></tr>
                            <% } else { %>
                            <% for (Refund r : pendingRefundList) { %>
                            <tr>
                                <td><%= r.getRefundId() %></td>
                                <td><%= r.getMemberId() %></td>
                                <td><%= r.getCreateTime() %></td>
                                <td class="text-warning">¥<%= r.getAmount() %></td>
                                <td><%= r.getReason() %></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/admin/refund" class="btn btn-sm btn-primary">处理</a>
                                </td>
                            </tr>
                            <% } %>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</body>
</html>
