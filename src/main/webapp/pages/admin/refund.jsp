<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Refund" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Refund> refunds = (List<Refund>) request.getAttribute("refunds");
    if (refunds == null) refunds = new java.util.ArrayList<>();
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    if (pendingCount == null) pendingCount = 0;
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
    <title>退费管理 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .status-badge {
            font-size: 0.85rem;
            padding: 0.35rem 0.65rem;
        }
        .refund-card {
            border-left: 4px solid #667eea;
            transition: all 0.3s;
        }
        .refund-card:hover {
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15);
        }
        .refund-card.pending {
            border-left-color: #ffc107;
        }
        .refund-card.approved {
            border-left-color: #198754;
        }
        .refund-card.rejected {
            border-left-color: #dc3545;
        }
        .stat-card {
            text-align: center;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
        }
        .stat-card .stat-value {
            font-size: 2rem;
            font-weight: bold;
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
                        <a class="nav-link active" href="#">
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
                <h1 class="h2"><i class="fas fa-undo me-2"></i>退费管理</h1>
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
                    <div class="stat-card bg-warning bg-opacity-10">
                        <div class="stat-value text-warning"><%= pendingCount %></div>
                        <div class="text-muted">待审批申请</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card bg-success bg-opacity-10">
                        <div class="stat-value text-success"><%= request.getAttribute("approvedCount") != null ? request.getAttribute("approvedCount") : 0 %></div>
                        <div class="text-muted">已通过</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card bg-danger bg-opacity-10">
                        <div class="stat-value text-danger"><%= request.getAttribute("rejectedCount") != null ? request.getAttribute("rejectedCount") : 0 %></div>
                        <div class="text-muted">已拒绝</div>
                    </div>
                </div>
            </div>

            <!-- 状态筛选 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-filter me-2"></i>状态筛选</h6>
                </div>
                <div class="card-body">
                    <div class="btn-group flex-wrap" role="group">
                        <a href="<%= request.getContextPath() %>/admin/refund"
                           class="btn <%= request.getAttribute("status") == null ? "btn-primary" : "btn-outline-primary" %>">
                            <i class="fas fa-list me-1"></i>全部 (<%= refunds.size() %>)
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/refund?status=0"
                           class="btn <%= "0".equals(request.getAttribute("status")) ? "btn-primary" : "btn-outline-primary" %>">
                            <i class="fas fa-clock me-1"></i>待审批 (<%= pendingCount %>)
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/refund?status=1"
                           class="btn <%= "1".equals(request.getAttribute("status")) ? "btn-primary" : "btn-outline-primary" %>">
                            <i class="fas fa-check-circle me-1"></i>已通过 (<%= request.getAttribute("approvedCount") != null ? request.getAttribute("approvedCount") : 0 %>)
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/refund?status=2"
                           class="btn <%= "2".equals(request.getAttribute("status")) ? "btn-primary" : "btn-outline-primary" %>">
                            <i class="fas fa-times-circle me-1"></i>已拒绝 (<%= request.getAttribute("rejectedCount") != null ? request.getAttribute("rejectedCount") : 0 %>)
                        </a>
                    </div>
                </div>
            </div>

            <!-- 退费申请列表 -->
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-file-alt me-2"></i>退费申请列表 (共 <%= refunds.size() %> 条)
                    </h6>
                </div>
                <div class="card-body">
                    <% if (refunds.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">暂无退费申请</p>
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>申请ID</th>
                                    <th>会员信息</th>
                                    <th>申请时间</th>
                                    <th>退费金额</th>
                                    <th>退费原因</th>
                                    <th>状态</th>
                                    <th>处理时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Refund r : refunds) { %>
                                <tr class="refund-card <%= r.getStatus() == 0 ? "pending" : r.getStatus() == 1 ? "approved" : "rejected" %>">
                                    <td><%= r.getRefundId() %></td>
                                    <td>
                                        <div class="fw-bold"><%= r.getMemberUsername() != null ? r.getMemberUsername() : "会员" + r.getMemberId() %></div>
                                        <small class="text-muted"><%= r.getMemberNickname() != null ? r.getMemberNickname() : "" %></small>
                                    </td>
                                    <td><%= r.getCreateTime() %></td>
                                    <td class="text-warning fw-bold">¥<%= r.getAmount() %></td>
                                    <td><%= r.getReason() %></td>
                                    <td>
                                        <% switch(r.getStatus()) {
                                            case 0: %>
                                                <span class="badge bg-warning status-badge"><i class="fas fa-clock me-1"></i>待审批</span>
                                                <% break;
                                            case 1: %>
                                                <span class="badge bg-success status-badge"><i class="fas fa-check-circle me-1"></i>已通过</span>
                                                <% break;
                                            case 2: %>
                                                <span class="badge bg-danger status-badge"><i class="fas fa-times-circle me-1"></i>已拒绝</span>
                                                <% break;
                                        } %>
                                    </td>
                                    <td>
                                        <%= r.getProcessTime() != null ? r.getProcessTime() : "-" %>
                                    </td>
                                    <td>
                                        <% if (r.getStatus() == 0) { %>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button class="btn btn-success" onclick="processRefund(<%= r.getRefundId() %>, 'approve')">
                                                <i class="fas fa-check me-1"></i>通过
                                            </button>
                                            <button class="btn btn-danger" onclick="processRefund(<%= r.getRefundId() %>, 'reject')">
                                                <i class="fas fa-times me-1"></i>拒绝
                                            </button>
                                        </div>
                                        <% } else { %>
                                        <span class="text-muted small">
                                            <i class="fas fa-check-double me-1"></i>已处理
                                        </span>
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

<!-- 审批确认模态框 -->
<div class="modal fade" id="refundModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">确认审批</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="modalBody">
                <!-- 动态内容 -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="confirmBtn">确认</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
let refundModal;
let currentAction = '';
let currentRefundId = 0;

document.addEventListener('DOMContentLoaded', function() {
    refundModal = new bootstrap.Modal(document.getElementById('refundModal'));
});

function processRefund(refundId, action) {
    currentRefundId = refundId;
    currentAction = action;

    const modalBody = document.getElementById('modalBody');
    const confirmBtn = document.getElementById('confirmBtn');

    if (action === 'approve') {
        modalBody.innerHTML = `
            <div class="text-center">
                <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                <p class="mb-0">确认通过该退费申请？</p>
                <p class="text-muted small">通过后将从会员余额中扣除退费金额</p>
            </div>
        `;
        confirmBtn.className = 'btn btn-success';
        confirmBtn.innerHTML = '<i class="fas fa-check me-2"></i>确认通过';
    } else {
        modalBody.innerHTML = `
            <div class="text-center">
                <i class="fas fa-times-circle fa-3x text-danger mb-3"></i>
                <p class="mb-0">确认拒绝该退费申请？</p>
                <p class="text-muted small">拒绝后会员需重新提交申请</p>
            </div>
        `;
        confirmBtn.className = 'btn btn-danger';
        confirmBtn.innerHTML = '<i class="fas fa-times me-2"></i>确认拒绝';
    }

    refundModal.show();
}

document.getElementById('confirmBtn').addEventListener('click', function() {
    $.post('<%= request.getContextPath() %>/admin/refund', {
        action: currentAction,
        refundId: currentRefundId
    }, function() {
        refundModal.hide();
        location.reload();
    });
});
</script>
</body>
</html>
