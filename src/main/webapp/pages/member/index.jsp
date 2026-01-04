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
    // 从Servlet获取数据
    List<Consumption> recentConsumptions = (List<Consumption>) request.getAttribute("recentConsumptions");
    if (recentConsumptions == null) recentConsumptions = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>会员中心 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
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
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/member/profile"><i class="fas fa-user me-2"></i>个人资料</a></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/member/changePassword"><i class="fas fa-lock me-2"></i>修改密码</a></li>
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
                            <a class="nav-link active" href="<%= request.getContextPath() %>/member/index">
                                <i class="fas fa-tachometer-alt me-2"></i>
                                会员中心
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/member/profile">
                                <i class="fas fa-user me-2"></i>
                                个人资料
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/member/consumption">
                                <i class="fas fa-list-alt me-2"></i>
                                消费记录
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/member/recharge">
                                <i class="fas fa-credit-card me-2"></i>
                                在线充值
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/member/refund">
                                <i class="fas fa-undo me-2"></i>
                                退费申请
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- 主内容区域 -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">会员中心</h1>
                </div>

                <!-- 会员信息卡片 -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="card shadow mb-4">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">账户信息</h5>
                            </div>
                            <div class="card-body">
                                <div class="text-center mb-3">
                                    <div class="avatar-circle bg-primary text-white rounded-circle mx-auto d-flex align-items-center justify-content-center" style="width: 100px; height: 100px; font-size: 36px;">
                                        <%= member.getNickname() != null && !member.getNickname().isEmpty() ? member.getNickname().substring(0, 1).toUpperCase() : member.getUsername().substring(0, 1).toUpperCase() %>
                                    </div>
                                </div>
                                <table class="table table-borderless">
                                    <tr>
                                        <td>用户名：</td>
                                        <td><strong><%= member.getUsername() %></strong></td>
                                    </tr>
                                    <tr>
                                        <td>昵称：</td>
                                        <td><%= member.getNickname() != null ? member.getNickname() : "未设置" %></td>
                                    </tr>
                                    <tr>
                                        <td>会员等级：</td>
                                        <td><span class="badge bg-warning">Level <%= member.getLevel() %></span></td>
                                    </tr>
                                    <tr>
                                        <td>积分：</td>
                                        <td><strong><%= member.getPoints() %></strong></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-8">
                        <!-- 余额卡片 -->
                        <div class="card shadow mb-4">
                            <div class="card-header bg-success text-white">
                                <h5 class="mb-0">账户余额</h5>
                            </div>
                            <div class="card-body text-center">
                                <h1 class="display-4 text-success">¥<%= member.getBalance() %></h1>
                                <p class="text-muted">当前可用余额</p>
                                <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                                    <a href="<%= request.getContextPath() %>/member/recharge" class="btn btn-success btn-lg">
                                        <i class="fas fa-credit-card me-2"></i>
                                        立即充值
                                    </a>
                                    <a href="<%= request.getContextPath() %>/member/refund" class="btn btn-outline-secondary btn-lg">
                                        <i class="fas fa-undo me-2"></i>
                                        申请退费
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- 统计信息 -->
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card shadow mb-4">
                                    <div class="card-body text-center">
                                        <h5 class="text-muted">累计消费</h5>
                                        <h3 class="text-danger">¥<%= member.getTotalConsumption() %></h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card shadow mb-4">
                                    <div class="card-body text-center">
                                        <h5 class="text-muted">注册时间</h5>
                                        <h6><%= member.getRegisterTime() %></h6>
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
                                    <a href="<%= request.getContextPath() %>/member/profile" class="btn btn-outline-primary">
                                        <i class="fas fa-user me-2"></i>
                                        完善资料
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6 mb-3">
                                <div class="d-grid">
                                    <a href="<%= request.getContextPath() %>/member/changePassword" class="btn btn-outline-warning">
                                        <i class="fas fa-lock me-2"></i>
                                        修改密码
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6 mb-3">
                                <div class="d-grid">
                                    <a href="<%= request.getContextPath() %>/member/consumption" class="btn btn-outline-info">
                                        <i class="fas fa-list-alt me-2"></i>
                                        消费记录
                                    </a>
                                </div>
                            </div>
                            <div class="col-md-3 col-sm-6 mb-3">
                                <div class="d-grid">
                                    <a href="<%= request.getContextPath() %>/member/recharge" class="btn btn-outline-success">
                                        <i class="fas fa-credit-card me-2"></i>
                                        在线充值
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 消费记录搜索 -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">消费记录查询</h6>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/member/consumption" method="post" class="row g-3">
                            <div class="col-md-4">
                                <label for="startDate" class="form-label">开始日期</label>
                                <input type="date" class="form-control" id="startDate" name="startDate">
                            </div>
                            <div class="col-md-4">
                                <label for="endDate" class="form-label">结束日期</label>
                                <input type="date" class="form-control" id="endDate" name="endDate">
                            </div>
                            <div class="col-md-4">
                                <label for="consumptionType" class="form-label">消费类型</label>
                                <select class="form-select" id="consumptionType" name="consumptionType">
                                    <option value="">全部类型</option>
                                    <option value="1">上机消费</option>
                                    <option value="2">包房消费</option>
                                    <option value="3">商品消费</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search me-1"></i>查询
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 最近消费记录 -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold text-primary">最近消费记录</h6>
                        <a href="<%= request.getContextPath() %>/member/consumption" class="btn btn-sm btn-primary">查看全部</a>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>时间</th>
                                        <th>类型</th>
                                        <th>金额</th>
                                        <th>状态</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (recentConsumptions.isEmpty()) { %>
                                    <tr><td colspan="4" class="text-center text-muted">暂无消费记录</td></tr>
                                    <% } %>
                                    <% for (Consumption c : recentConsumptions) { %>
                                    <tr>
                                        <td><%= c.getStartTime() != null ? c.getStartTime() : "-" %></td>
                                        <td>
                                            <% switch(c.getConsumptionType()) {
                                                case 1: out.print("上机消费"); break;
                                                case 2: out.print("包房消费"); break;
                                                case 3: out.print("商品消费"); break;
                                                default: out.print("其他"); break;
                                            } %>
                                        </td>
                                        <td class="text-danger">-¥<%= c.getAmount() %></td>
                                        <td><span class="badge bg-success">已完成</span></td>
                                    </tr>
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
