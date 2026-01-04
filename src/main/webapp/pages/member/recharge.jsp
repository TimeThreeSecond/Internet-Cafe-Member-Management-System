<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Member" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Recharge" %>
<%@ page import="java.util.List" %>
<%
    Member member = (Member) session.getAttribute("user");
    if (member == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Recharge> rechargeList = (List<Recharge>) request.getAttribute("rechargeList");
    if (rechargeList == null) rechargeList = new java.util.ArrayList<>();
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>在线充值 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .amount-card {
            border: 2px solid #dee2e6;
            border-radius: 0.5rem;
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .amount-card:hover {
            border-color: #0d6efd;
            background-color: #f8f9fa;
        }
        .amount-card.selected {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }
        .amount-card .amount {
            font-size: 1.5rem;
            font-weight: bold;
            color: #0d6efd;
        }
        .payment-method {
            border: 2px solid #dee2e6;
            border-radius: 0.5rem;
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .payment-method:hover {
            border-color: #28a745;
        }
        .payment-method.selected {
            border-color: #28a745;
            background-color: #d4edda;
        }
        .payment-method i {
            font-size: 2.5rem;
        }
        .payment-method.wechat i { color: #07c160; }
        .payment-method.alipay i { color: #1677ff; }
        .payment-method.card i { color: #6c757d; }
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
                        <a class="nav-link active" href="#">
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
                <h1 class="h2"><i class="fas fa-credit-card me-2"></i>在线充值</h1>
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

            <!-- 账户余额卡片 -->
            <div class="card shadow mb-4">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <p class="mb-1 text-muted">当前账户余额</p>
                            <h2 class="mb-0 text-success">¥<%= member.getBalance() %></h2>
                        </div>
                        <div class="col-md-4 text-end">
                            <span class="badge bg-warning text-dark fs-6">Level <%= member.getLevel() %></span>
                            <p class="mb-0 text-muted">积分: <%= member.getPoints() %></p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 充值表单 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-plus-circle me-2"></i>选择充值金额</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/member/recharge" method="post" id="rechargeForm">
                        <!-- 快捷金额选择 -->
                        <div class="row mb-4">
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <div class="amount-card" onclick="selectAmount(this, 10)">
                                    <div class="amount">¥10</div>
                                    <small class="text-muted">入门</small>
                                </div>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <div class="amount-card" onclick="selectAmount(this, 20)">
                                    <div class="amount">¥20</div>
                                    <small class="text-muted">基础</small>
                                </div>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <div class="amount-card" onclick="selectAmount(this, 50)">
                                    <div class="amount">¥50</div>
                                    <small class="text-muted">标准</small>
                                </div>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <div class="amount-card selected" onclick="selectAmount(this, 100)">
                                    <div class="amount">¥100</div>
                                    <small class="text-muted">推荐</small>
                                </div>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <div class="amount-card" onclick="selectAmount(this, 200)">
                                    <div class="amount">¥200</div>
                                    <small class="text-muted">超值</small>
                                </div>
                            </div>
                            <div class="col-md-2 col-sm-4 col-6 mb-3">
                                <div class="amount-card" onclick="selectAmount(this, 500)">
                                    <div class="amount">¥500</div>
                                    <small class="text-muted">尊享</small>
                                </div>
                            </div>
                        </div>

                        <!-- 自定义金额 -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <label for="customAmount" class="form-label">自定义金额</label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text">¥</span>
                                    <input type="number" class="form-control" id="customAmount" name="amount"
                                           min="10" max="10000" step="1" value="100" required
                                           placeholder="请输入充值金额" onchange="clearSelection()">
                                </div>
                                <small class="form-text text-muted">充值金额范围：10-10000元</small>
                            </div>
                        </div>

                        <!-- 支付方式选择 -->
                        <div class="mb-4">
                            <label class="form-label mb-3">选择支付方式</label>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <div class="payment-method wechat selected" onclick="selectPayment(this, 4)">
                                        <i class="fab fa-weixin"></i>
                                        <h6 class="mt-2">微信支付</h6>
                                        <small class="text-muted">推荐使用</small>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <div class="payment-method alipay" onclick="selectPayment(this, 3)">
                                        <i class="fab fa-alipay"></i>
                                        <h6 class="mt-2">支付宝</h6>
                                        <small class="text-muted">快捷支付</small>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <div class="payment-method card" onclick="selectPayment(this, 5)">
                                        <i class="fas fa-credit-card"></i>
                                        <h6 class="mt-2">银行卡</h6>
                                        <small class="text-muted">网银支付</small>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" id="paymentMethod" name="paymentMethod" value="4">
                        </div>

                        <!-- 充值说明 -->
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>充值说明：</strong>
                            <ul class="mb-0 mt-2">
                                <li>充值成功后，金额将立即到账</li>
                                <li>充值金额可兑换积分，1元=1积分</li>
                                <li>积分可提升会员等级，享受更多优惠</li>
                                <li>如有疑问，请联系网吧客服</li>
                            </ul>
                        </div>

                        <!-- 提交按钮 -->
                        <div class="d-grid">
                            <button type="submit" class="btn btn-success btn-lg" onclick="return confirmRecharge()">
                                <i class="fas fa-lock me-2"></i>立即充值
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 充值记录 -->
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-history me-2"></i>充值记录 (共 <%= rechargeList.size() %> 条)
                    </h6>
                </div>
                <div class="card-body">
                    <% if (rechargeList.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">暂无充值记录</p>
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>充值ID</th>
                                    <th>充值金额</th>
                                    <th>支付方式</th>
                                    <th>充值时间</th>
                                    <th>备注</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Recharge r : rechargeList) { %>
                                <tr>
                                    <td>#<%= r.getRechargeId() %></td>
                                    <td class="text-success fw-bold">+¥<%= r.getAmount() %></td>
                                    <td>
                                        <span class="badge bg-info"><%= r.getRechargeTypeText() %></span>
                                    </td>
                                    <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(r.getCreateTime()) %></td>
                                    <td><%= r.getRemark() != null ? r.getRemark() : "-" %></td>
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
let selectedPaymentMethod = 4;

function selectAmount(element, amount) {
    // 移除其他选中状态
    document.querySelectorAll('.amount-card').forEach(card => {
        card.classList.remove('selected');
    });
    // 添加选中状态
    element.classList.add('selected');
    // 设置金额
    document.getElementById('customAmount').value = amount;
}

function clearSelection() {
    document.querySelectorAll('.amount-card').forEach(card => {
        card.classList.remove('selected');
    });
}

function selectPayment(element, method) {
    // 移除其他选中状态
    document.querySelectorAll('.payment-method').forEach(p => {
        p.classList.remove('selected');
    });
    // 添加选中状态
    element.classList.add('selected');
    // 设置支付方式
    selectedPaymentMethod = method;
    document.getElementById('paymentMethod').value = method;
}

function confirmRecharge() {
    const amount = document.getElementById('customAmount').value;

    if (!amount || amount < 10) {
        alert('最低充值金额为10元');
        return false;
    }

    if (amount > 10000) {
        alert('单次充值金额不能超过10000元');
        return false;
    }

    let paymentName = '微信支付';
    if (selectedPaymentMethod === 3) paymentName = '支付宝';
    else if (selectedPaymentMethod === 5) paymentName = '银行卡';

    return confirm('确认充值 ¥' + amount + ' ？\n\n支付方式：' + paymentName + '\n\n点击确认后将跳转到支付页面');
}

// 初始化默认选中
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('customAmount').value = 100;
});
</script>
</body>
</html>
