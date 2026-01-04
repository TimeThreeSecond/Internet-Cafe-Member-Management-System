<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Recharge" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Recharge> recentRecharges = (List<Recharge>) request.getAttribute("recentRecharges");
    if (recentRecharges == null) recentRecharges = new java.util.ArrayList<>();
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>充值管理 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
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
        .recharge-type-btn {
            padding: 1.5rem;
            border: 2px solid #dee2e6;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        .recharge-type-btn:hover {
            border-color: #0d6efd;
            background-color: #f8f9fa;
        }
        .recharge-type-btn.active {
            border-color: #0d6efd;
            background-color: #e7f1ff;
        }
        .recharge-type-btn i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        .member-section {
            position: relative;
        }
        #memberSearchResults {
            width: 100%;
            max-height: 250px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-top: none;
            border-radius: 0 0 0.375rem 0.375rem;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15);
            z-index: 1000;
        }
        #memberSearchResults .list-group-item {
            cursor: pointer;
            border: none;
            border-bottom: 1px solid #dee2e6;
        }
        #memberSearchResults .list-group-item:last-child {
            border-bottom: none;
        }
        #memberSearchResults .list-group-item:hover {
            background-color: #f8f9fa;
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
                        <a class="nav-link active" href="#">
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
                <h1 class="h2"><i class="fas fa-credit-card me-2"></i>充值管理</h1>
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
                <div class="col-md-6">
                    <div class="stat-card bg-success bg-opacity-10">
                        <div class="stat-value text-success">¥<%= request.getAttribute("todayTotal") != null ? request.getAttribute("todayTotal") : "0.00" %></div>
                        <div class="text-muted">今日充值总额</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="stat-card bg-primary bg-opacity-10">
                        <div class="stat-value text-primary">¥<%= request.getAttribute("monthTotal") != null ? request.getAttribute("monthTotal") : "0.00" %></div>
                        <div class="text-muted">本月充值总额</div>
                    </div>
                </div>
            </div>

            <!-- 充值表单 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-plus-circle me-2"></i>办理充值</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin/recharge" method="post" id="rechargeForm">
                        <!-- 充值对象选择 -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="recharge-type-btn active" onclick="selectRechargeType('member')">
                                    <i class="fas fa-user text-primary"></i>
                                    <h5>会员充值</h5>
                                    <small class="text-muted">为会员账户充值</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="recharge-type-btn" onclick="selectRechargeType('tempCard')">
                                    <i class="fas fa-id-card text-warning"></i>
                                    <h5>临时卡充值</h5>
                                    <small class="text-muted">为临时卡充值</small>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" id="rechargeTarget" name="rechargeTarget" value="member">

                        <!-- 会员选择 -->
                        <div id="memberSection" class="mb-3 member-section">
                            <label for="memberSearch" class="form-label">会员 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="memberSearch" name="memberSearch"
                                   placeholder="输入会员ID、昵称或用户名搜索" autocomplete="off">
                            <input type="hidden" id="memberId" name="memberId" required>
                            <!-- 搜索结果下拉列表 -->
                            <div id="memberSearchResults" class="list-group" style="display: none;"></div>
                            <!-- 已选会员信息 -->
                            <div id="selectedMemberInfo" class="mt-2 p-2 bg-light rounded" style="display: none;">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="fw-bold" id="selectedMemberName"></span>
                                        <small class="text-muted" id="selectedMemberDetail"></small>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearMember()">清除</button>
                                </div>
                            </div>
                            <small class="form-text text-muted">支持按会员ID、昵称、用户名搜索</small>
                        </div>

                        <!-- 临时卡号输入 -->
                        <div id="tempCardSection" class="mb-3" style="display: none;">
                            <label for="tempCardId" class="form-label">临时卡号 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="tempCardId" name="tempCardId"
                                   placeholder="请输入临时卡号，如：TEMP001">
                        </div>

                        <!-- 充值金额 -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="amount" class="form-label">充值金额 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">¥</span>
                                    <input type="number" class="form-control" id="amount" name="amount"
                                           min="0.01" max="10000" step="0.01" required
                                           placeholder="请输入充值金额">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">快捷金额</label>
                                <div class="d-flex gap-2 flex-wrap">
                                    <button type="button" class="btn btn-outline-primary" onclick="setAmount(10)">10元</button>
                                    <button type="button" class="btn btn-outline-primary" onclick="setAmount(20)">20元</button>
                                    <button type="button" class="btn btn-outline-primary" onclick="setAmount(50)">50元</button>
                                    <button type="button" class="btn btn-outline-primary" onclick="setAmount(100)">100元</button>
                                    <button type="button" class="btn btn-outline-primary" onclick="setAmount(200)">200元</button>
                                    <button type="button" class="btn btn-outline-primary" onclick="setAmount(500)">500元</button>
                                </div>
                            </div>
                        </div>

                        <!-- 充值类型 -->
                        <div class="mb-3">
                            <label class="form-label">支付方式 <span class="text-danger">*</span></label>
                            <div class="btn-group" role="group">
                                <input type="radio" class="btn-check" name="rechargeType" id="type1" value="1" checked>
                                <label class="btn btn-outline-success" for="type1">
                                    <i class="fas fa-money-bill me-1"></i>现金
                                </label>

                                <input type="radio" class="btn-check" name="rechargeType" id="type3" value="3">
                                <label class="btn btn-outline-primary" for="type3">
                                    <i class="fab fa-alipay me-1"></i>支付宝
                                </label>

                                <input type="radio" class="btn-check" name="rechargeType" id="type4" value="4">
                                <label class="btn btn-outline-success" for="type4">
                                    <i class="fab fa-weixin me-1"></i>微信
                                </label>

                                <input type="radio" class="btn-check" name="rechargeType" id="type5" value="5">
                                <label class="btn btn-outline-secondary" for="type5">
                                    <i class="fas fa-ellipsis-h me-1"></i>其他
                                </label>
                            </div>
                        </div>

                        <!-- 备注 -->
                        <div class="mb-3">
                            <label for="remark" class="form-label">备注</label>
                            <input type="text" class="form-control" id="remark" name="remark"
                                   placeholder="选填，如：活动赠送、优惠充值等">
                        </div>

                        <!-- 提交按钮 -->
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-check-circle me-2"></i>确认充值
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 最近充值记录 -->
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-history me-2"></i>最近充值记录 (共 <%= recentRecharges.size() %> 条)
                    </h6>
                </div>
                <div class="card-body">
                    <% if (recentRecharges.isEmpty()) { %>
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
                                    <th>充值对象</th>
                                    <th>金额</th>
                                    <th>支付方式</th>
                                    <th>操作员</th>
                                    <th>充值时间</th>
                                    <th>备注</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Recharge r : recentRecharges) { %>
                                <tr>
                                    <td><%= r.getRechargeId() %></td>
                                    <td>
                                        <% if (r.getMemberId() != null && r.getMemberId() > 0) { %>
                                            <div class="fw-bold"><%= r.getMemberUsername() != null ? r.getMemberUsername() : "会员" + r.getMemberId() %></div>
                                            <small class="text-muted"><%= r.getMemberNickname() != null ? r.getMemberNickname() : "" %></small>
                                        <% } else if (r.getTempCardId() != null) { %>
                                            <span class="badge bg-warning text-dark"><i class="fas fa-id-card me-1"></i><%= r.getTempCardId() %></span>
                                        <% } else { %>
                                            <span class="text-muted">未知</span>
                                        <% } %>
                                    </td>
                                    <td class="text-success fw-bold">+¥<%= r.getAmount() %></td>
                                    <td>
                                        <span class="badge bg-info"><%= r.getRechargeTypeText() %></span>
                                    </td>
                                    <td><%= r.getOperatorName() != null ? r.getOperatorName() : "-" %></td>
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
let currentRechargeType = 'member';

function selectRechargeType(type) {
    currentRechargeType = type;
    document.getElementById('rechargeTarget').value = type;

    // 更新按钮样式
    const buttons = document.querySelectorAll('.recharge-type-btn');
    buttons.forEach(btn => btn.classList.remove('active'));
    event.currentTarget.classList.add('active');

    // 切换显示区域
    if (type === 'member') {
        document.getElementById('memberSection').style.display = 'block';
        document.getElementById('tempCardSection').style.display = 'none';
        document.getElementById('memberId').required = true;
        document.getElementById('tempCardId').required = false;
    } else {
        document.getElementById('memberSection').style.display = 'none';
        document.getElementById('tempCardSection').style.display = 'block';
        document.getElementById('memberId').required = false;
        document.getElementById('tempCardId').required = true;
    }
}

function setAmount(amount) {
    document.getElementById('amount').value = amount;
}

// 会员搜索功能
let searchTimeout;
$(document).ready(function() {
    $('#memberSearch').on('input', function() {
        const keyword = $(this).val().trim();
        const $results = $('#memberSearchResults');

        clearTimeout(searchTimeout);

        if (keyword.length < 1) {
            $results.hide().empty();
            return;
        }

        searchTimeout = setTimeout(function() {
            $.ajax({
                url: '<%= request.getContextPath() %>/api/members/search?keyword=' + encodeURIComponent(keyword),
                method: 'GET',
                dataType: 'json',
                success: function(data) {
                    $results.empty();
                    if (data && data.length > 0) {
                        data.forEach(function(member) {
                            $results.append('<div class="list-group-item list-group-item-action" onclick="selectMember(' +
                                member.memberId + ', \'' + escapeJs(member.username) + '\', \'' +
                                escapeJs(member.nickname || '') + '\', ' + member.balance + ')">' +
                                '<div class="d-flex justify-content-between align-items-center">' +
                                '<div><strong>' + escapeHtml(member.username) + '</strong>' +
                                (member.nickname ? ' <span class="text-muted">(' + escapeHtml(member.nickname) + ')</span>' : '') +
                                '</div>' +
                                '<small class="text-muted">ID: ' + member.memberId + ' | 余额: ¥' + member.balance + '</small>' +
                                '</div></div>');
                        });
                        $results.show();
                    } else {
                        $results.append('<div class="list-group-item text-muted">未找到匹配的会员</div>');
                        $results.show();
                    }
                },
                error: function() {
                    $results.empty().append('<div class="list-group-item text-danger">搜索失败</div>');
                    $results.show();
                }
            });
        }, 300);
    });

    // 点击页面其他地方隐藏搜索结果
    $(document).on('click', function(e) {
        if (!$(e.target).closest('#memberSection').length) {
            $('#memberSearchResults').hide();
        }
    });
});

function selectMember(memberId, username, nickname, balance) {
    $('#memberId').val(memberId);
    $('#memberSearch').val(username);
    $('#memberSearchResults').hide();

    $('#selectedMemberName').text(username + (nickname ? ' (' + nickname + ')' : ''));
    $('#selectedMemberDetail').text('ID: ' + memberId + ' | 余额: ¥' + balance);
    $('#selectedMemberInfo').show();
}

function clearMember() {
    $('#memberId').val('');
    $('#memberSearch').val('');
    $('#selectedMemberInfo').hide();
}

function escapeJs(str) {
    if (!str) return '';
    return str.replace(/\\/g, '\\\\')
              .replace(/'/g, "\\'")
              .replace(/"/g, '\\"')
              .replace(/\n/g, '\\n')
              .replace(/\r/g, '\\r');
}

function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/&/g, '&amp;')
              .replace(/</g, '&lt;')
              .replace(/>/g, '&gt;')
              .replace(/"/g, '&quot;')
              .replace(/'/g, '&#039;');
}

// 表单提交前验证
document.getElementById('rechargeForm').addEventListener('submit', function(e) {
    const amount = document.getElementById('amount').value;
    if (!amount || amount <= 0) {
        e.preventDefault();
        alert('请输入有效的充值金额');
        return false;
    }

    if (currentRechargeType === 'member') {
        const memberId = document.getElementById('memberId').value;
        if (!memberId) {
            e.preventDefault();
            alert('请选择会员');
            return false;
        }
    } else {
        const tempCardId = document.getElementById('tempCardId').value;
        if (!tempCardId) {
            e.preventDefault();
            alert('请输入临时卡号');
            return false;
        }
    }

    return confirm('确认充值 ¥' + amount + ' 吗？');
});
</script>
</body>
</html>
