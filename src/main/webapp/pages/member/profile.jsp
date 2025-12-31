<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Member" %>
<%
    Member member = (Member) session.getAttribute("user");
    if (member == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    // 获取总充值金额
    Double totalRecharge = (Double) request.getAttribute("totalRecharge");
    if (totalRecharge == null) totalRecharge = 0.0;

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
    <title>个人资料 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .avatar-circle {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            font-weight: bold;
            margin: 0 auto;
        }
        .info-card {
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
            margin-bottom: 1.5rem;
        }
        .info-card .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
        }
        .stat-card {
            text-align: center;
            padding: 1.5rem;
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
            margin-bottom: 1rem;
        }
        .stat-card .stat-value {
            font-size: 1.8rem;
            font-weight: bold;
            color: #667eea;
        }
        .stat-card .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .quick-action-btn {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1.5rem;
            text-decoration: none;
            color: #495057;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
            transition: all 0.3s;
        }
        .quick-action-btn:hover {
            background-color: #667eea;
            color: white;
            border-color: #667eea;
        }
        .quick-action-btn i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        .readonly-field {
            background-color: #f8f9fa;
            cursor: not-allowed;
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
                        <li><a class="dropdown-item active" href="<%= request.getContextPath() %>/member/profile"><i class="fas fa-user me-2"></i>个人资料</a></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/member/index"><i class="fas fa-tachometer-alt me-2"></i>会员中心</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/logout" onclick="return confirm('确定要退出登录吗？');"><i class="fas fa-sign-out-alt me-2"></i>退出登录</a></li>
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
                            <a class="nav-link" href="<%= request.getContextPath() %>/member/index">
                                <i class="fas fa-tachometer-alt me-2"></i>会员中心
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="<%= request.getContextPath() %>/member/profile">
                                <i class="fas fa-user me-2"></i>个人资料
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/member/consumption">
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
                <!-- 个人信息头部 -->
                <div class="profile-header rounded-3 mb-4">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-md-2 text-center">
                                <div class="avatar-circle">
                                    <%= member.getNickname() != null && !member.getNickname().isEmpty()
                                        ? member.getNickname().substring(0, 1).toUpperCase()
                                        : member.getUsername().substring(0, 1).toUpperCase() %>
                                </div>
                            </div>
                            <div class="col-md-10">
                                <h2 class="mb-1"><%= member.getNickname() != null ? member.getNickname() : "未设置昵称" %></h2>
                                <p class="mb-0 opacity-75">
                                    <i class="fas fa-id-card me-2"></i>会员ID: <%= member.getMemberId() %>
                                    <span class="ms-3"><i class="fas fa-crown me-2"></i>Level <%= member.getLevel() %></span>
                                    <span class="ms-3"><i class="fas fa-coins me-2"></i><%= member.getPoints() %> 积分</span>
                                </p>
                            </div>
                        </div>
                    </div>
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

                <!-- 账户资产总览 -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-value">¥<%= String.format("%.2f", member.getBalance()) %></div>
                            <div class="stat-label">账户余额</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-value text-success">¥<%= String.format("%.2f", totalRecharge) %></div>
                            <div class="stat-label">总充值金额</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-value text-danger">¥<%= String.format("%.2f", member.getTotalConsumption()) %></div>
                            <div class="stat-label">已消费金额</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- 个人信息编辑 -->
                    <div class="col-lg-8">
                        <div class="card info-card">
                            <div class="card-header">
                                <i class="fas fa-user-edit me-2"></i>个人信息
                            </div>
                            <div class="card-body">
                                <form action="<%= request.getContextPath() %>/member/profile" method="post">
                                    <div class="row">
                                        <!-- 会员账号（只读） -->
                                        <div class="col-md-6 mb-3">
                                            <label for="username" class="form-label">会员账号</label>
                                            <input type="text" class="form-control readonly-field" id="username"
                                                   value="<%= member.getUsername() %>" readonly>
                                        </div>
                                        <!-- 会员ID（只读） -->
                                        <div class="col-md-6 mb-3">
                                            <label for="memberId" class="form-label">会员ID</label>
                                            <input type="text" class="form-control readonly-field" id="memberId"
                                                   value="<%= member.getMemberId() %>" readonly>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- 昵称（可编辑） -->
                                        <div class="col-md-6 mb-3">
                                            <label for="nickname" class="form-label">昵称 <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="nickname" name="nickname"
                                                   value="<%= member.getNickname() != null ? member.getNickname() : "" %>"
                                                   placeholder="请输入昵称" required>
                                        </div>
                                        <!-- 性别（可编辑） -->
                                        <div class="col-md-6 mb-3">
                                            <label for="gender" class="form-label">性别</label>
                                            <select class="form-select" id="gender" name="gender">
                                                <option value="0" <%= member.getGender() == 0 ? "selected" : "" %>>保密</option>
                                                <option value="1" <%= member.getGender() == 1 ? "selected" : "" %>>男</option>
                                                <option value="2" <%= member.getGender() == 2 ? "selected" : "" %>>女</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- 电话（可编辑） -->
                                        <div class="col-md-6 mb-3">
                                            <label for="phone" class="form-label">电话</label>
                                            <input type="text" class="form-control" id="phone" name="phone"
                                                   value="<%= member.getPhone() != null ? member.getPhone() : "" %>"
                                                   placeholder="请输入电话号码">
                                        </div>
                                        <!-- QQ（可编辑） -->
                                        <div class="col-md-6 mb-3">
                                            <label for="qq" class="form-label">QQ</label>
                                            <input type="text" class="form-control" id="qq" name="qq"
                                                   value="<%= member.getQq() != null ? member.getQq() : "" %>"
                                                   placeholder="请输入QQ号">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- 微信（可编辑） -->
                                        <div class="col-md-6 mb-3">
                                            <label for="wechat" class="form-label">微信</label>
                                            <input type="text" class="form-control" id="wechat" name="wechat"
                                                   value="<%= member.getWechat() != null ? member.getWechat() : "" %>"
                                                   placeholder="请输入微信号">
                                        </div>
                                        <!-- 邮箱（可编辑） -->
                                        <div class="col-md-6 mb-3">
                                            <label for="email" class="form-label">邮箱</label>
                                            <input type="email" class="form-control" id="email" name="email"
                                                   value="<%= member.getEmail() != null ? member.getEmail() : "" %>"
                                                   placeholder="请输入邮箱地址">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">注册时间</label>
                                            <input type="text" class="form-control readonly-field"
                                                   value="<%= member.getRegisterTime() %>" readonly>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">最后登录</label>
                                            <input type="text" class="form-control readonly-field"
                                                   value="<%= member.getLastLogin() != null ? member.getLastLogin() : "首次登录" %>" readonly>
                                        </div>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>保存修改
                                        </button>
                                        <button type="reset" class="btn btn-secondary">
                                            <i class="fas fa-undo me-2"></i>重置
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- 核心功能入口 -->
                    <div class="col-lg-4">
                        <div class="card info-card">
                            <div class="card-header">
                                <i class="fas fa-th-large me-2"></i>快捷功能
                            </div>
                            <div class="card-body">
                                <a href="<%= request.getContextPath() %>/member/recharge" class="quick-action-btn">
                                    <i class="fas fa-credit-card text-success"></i>
                                    <span>在线充值</span>
                                </a>
                                <a href="<%= request.getContextPath() %>/member/consumption" class="quick-action-btn">
                                    <i class="fas fa-list-alt text-info"></i>
                                    <span>消费清单</span>
                                </a>
                                <a href="<%= request.getContextPath() %>/member/refund" class="quick-action-btn">
                                    <i class="fas fa-undo text-warning"></i>
                                    <span>退费申请</span>
                                </a>
                                <a href="<%= request.getContextPath() %>/member/index" class="quick-action-btn">
                                    <i class="fas fa-tachometer-alt text-primary"></i>
                                    <span>会员中心</span>
                                </a>
                            </div>
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
