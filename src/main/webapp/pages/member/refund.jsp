<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Member" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Refund" %>
<%@ page import="java.util.List" %>
<%
    Member member = (Member) session.getAttribute("user");
    if (member == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Refund> refundList = (List<Refund>) request.getAttribute("refundList");
    if (refundList == null) refundList = new java.util.ArrayList<>();
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>退费申请 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .process-step {
            text-align: center;
            position: relative;
        }
        .process-step:not(:last-child)::after {
            content: '';
            position: absolute;
            top: 25px;
            right: -50%;
            width: 100%;
            height: 2px;
            background: #dee2e6;
            z-index: 0;
        }
        .process-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            background: #6c757d;
            color: white;
            position: relative;
            z-index: 1;
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/member/refund">
                            <i class="fas fa-undo me-2"></i>退费申请
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- 主内容区域 -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2"><i class="fas fa-undo me-2"></i>退费申请</h1>
            </div>

            <% if (message != null) { %>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <i class="fas fa-info-circle me-2"></i><%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <!-- 账户余额卡片 -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-success">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">可退余额</p>
                                    <h3 class="mb-0">¥<%= member.getBalance() %></h3>
                                </div>
                                <i class="fas fa-wallet fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-primary">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">总充值</p>
                                    <h3 class="mb-0">¥<%= member.getBalance().add(member.getTotalConsumption()) %></h3>
                                </div>
                                <i class="fas fa-plus-circle fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stat-card text-white bg-danger">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">已消费</p>
                                    <h3 class="mb-0">¥<%= member.getTotalConsumption() %></h3>
                                </div>
                                <i class="fas fa-shopping-cart fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 退费流程说明 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-info-circle me-2"></i>退费流程说明</h6>
                </div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col-md-3 process-step">
                            <div class="process-icon">
                                <i class="fas fa-file-alt"></i>
                            </div>
                            <h6>提交申请</h6>
                            <small class="text-muted">填写退费信息</small>
                        </div>
                        <div class="col-md-3 process-step">
                            <div class="process-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <h6>等待审核</h6>
                            <small class="text-muted">管理员审核中</small>
                        </div>
                        <div class="col-md-3 process-step">
                            <div class="process-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <h6>审核通过</h6>
                            <small class="text-muted">审核通过后处理</small>
                        </div>
                        <div class="col-md-3 process-step">
                            <div class="process-icon">
                                <i class="fas fa-money-bill-wave"></i>
                            </div>
                            <h6>退款到账</h6>
                            <small class="text-muted">1-7个工作日</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 退费政策 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-warning"><i class="fas fa-exclamation-triangle me-2"></i>退费政策</h6>
                </div>
                <div class="card-body">
                    <ul class="mb-0">
                        <li>退费金额不能超过当前账户余额</li>
                        <li>退费申请提交后，需等待管理员审核</li>
                        <li>审核通过后，退款将在1-7个工作日内原路返回</li>
                        <li>已消费的金额无法申请退费</li>
                        <li>如有疑问，请联系网吧客服</li>
                    </ul>
                </div>
            </div>

            <!-- 退费申请表单 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-edit me-2"></i>申请退费</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/member/refund" method="post" id="refundForm">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="amount" class="form-label">退费金额 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">¥</span>
                                    <input type="number" class="form-control" id="amount" name="amount"
                                           min="0.01" max="<%= member.getBalance() %>" step="0.01" required
                                           placeholder="请输入退费金额" value="<%= member.getBalance() %>">
                                </div>
                                <small class="form-text text-muted">最大可退金额：¥<%= member.getBalance() %></small>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">快捷金额</label>
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-outline-primary" onclick="setAmount(<%= member.getBalance() %>)">全额</button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="setAmount(<%= member.getBalance().multiply(new java.math.BigDecimal("0.5")) %>)">一半</button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="setAmount(100)">100元</button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="setAmount(50)">50元</button>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reason" class="form-label">退费原因 <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="reason" name="reason" rows="4" required
                                      placeholder="请详细说明退费原因，便于管理员审核"></textarea>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-danger btn-lg" onclick="return confirmRefund()">
                                <i class="fas fa-paper-plane me-2"></i>提交退费申请
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 退费申请记录 -->
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-history me-2"></i>我的退费申请 (<%= refundList.size() %>)
                    </h6>
                </div>
                <div class="card-body">
                    <% if (refundList.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">暂无退费申请记录</p>
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>申请ID</th>
                                    <th>退费金额</th>
                                    <th>退费原因</th>
                                    <th>申请时间</th>
                                    <th>状态</th>
                                    <th>处理时间</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Refund r : refundList) { %>
                                <tr>
                                    <td>#<%= r.getRefundId() %></td>
                                    <td class="text-danger fw-bold">¥<%= r.getAmount() %></td>
                                    <td><%= r.getReason() != null && r.getReason().length() > 20 ? r.getReason().substring(0, 20) + "..." : r.getReason() %></td>
                                    <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(r.getCreateTime()) %></td>
                                    <td>
                                        <% if (r.getStatus() == 0) { %>
                                            <span class="badge bg-warning">待审核</span>
                                        <% } else if (r.getStatus() == 1) { %>
                                            <span class="badge bg-success">已通过</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">已拒绝</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <%= r.getProcessTime() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(r.getProcessTime()) : "-" %>
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
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
function setAmount(amount) {
    document.getElementById('amount').value = amount;
}

function confirmRefund() {
    var amount = document.getElementById('amount').value;
    var reason = document.getElementById('reason').value;

    if (!amount || amount <= 0) {
        alert('请输入有效的退费金额');
        return false;
    }

    if (!reason || reason.trim() === '') {
        alert('请填写退费原因');
        return false;
    }

    return confirm('确认申请退费 ¥' + amount + ' 吗？\n\n提交后请等待管理员审核，审核通过后退款将在1-7个工作日内到账。');
}
</script>
</body>
</html>
