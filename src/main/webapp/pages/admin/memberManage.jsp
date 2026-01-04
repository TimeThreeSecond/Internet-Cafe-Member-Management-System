<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Member" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Member> memberList = (List<Member>) request.getAttribute("memberList");
    if (memberList == null) memberList = new java.util.ArrayList<>();
    Integer totalMembers = (Integer) request.getAttribute("totalMembers");
    if (totalMembers == null) totalMembers = memberList.size();
    String keyword = (String) request.getAttribute("keyword");
    String level = (String) request.getAttribute("level");
    String gender = (String) request.getAttribute("gender");
    Member editMember = (Member) request.getAttribute("member");
    Boolean editMode = (Boolean) request.getAttribute("editMode");
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
    <title>会员管理 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .member-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        .status-badge {
            font-size: 0.8rem;
        }
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.8rem;
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/admin/memberManage">
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
                <h1 class="h2"><i class="fas fa-users me-2"></i>会员管理</h1>
                <div class="btn-group">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addMemberModal">
                        <i class="fas fa-plus me-1"></i>添加会员
                    </button>
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

            <!-- 搜索筛选区域 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-filter me-2"></i>搜索筛选</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin/memberManage" method="get" class="row g-3">
                        <div class="col-md-3">
                            <label for="keyword" class="form-label">关键字</label>
                            <input type="text" class="form-control" id="keyword" name="keyword"
                                   value="<%= keyword != null ? keyword : "" %>"
                                   placeholder="用户名/昵称/电话">
                        </div>
                        <div class="col-md-2">
                            <label for="level" class="form-label">会员等级</label>
                            <select class="form-select" id="level" name="level">
                                <option value="">全部</option>
                                <option value="1" <%= "1".equals(level) ? "selected" : "" %>>1级</option>
                                <option value="2" <%= "2".equals(level) ? "selected" : "" %>>2级</option>
                                <option value="3" <%= "3".equals(level) ? "selected" : "" %>>3级</option>
                                <option value="4" <%= "4".equals(level) ? "selected" : "" %>>4级</option>
                                <option value="5" <%= "5".equals(level) ? "selected" : "" %>>5级</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="gender" class="form-label">性别</label>
                            <select class="form-select" id="gender" name="gender">
                                <option value="">全部</option>
                                <option value="1" <%= "1".equals(gender) ? "selected" : "" %>>男</option>
                                <option value="2" <%= "2".equals(gender) ? "selected" : "" %>>女</option>
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
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-list me-2"></i>会员列表 (共 <%= totalMembers %> 条)
                    </h6>
                </div>
                <div class="card-body">
                    <% if (memberList.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">暂无会员数据</p>
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>用户名</th>
                                    <th>昵称</th>
                                    <th>性别</th>
                                    <th>电话</th>
                                    <th>等级</th>
                                    <th>余额</th>
                                    <th>总充值</th>
                                    <th>已消费</th>
                                    <th>积分</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Member m : memberList) { %>
                                <tr>
                                    <td><%= m.getMemberId() %></td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/admin/memberManage?action=view&id=<%= m.getMemberId() %>"
                                           class="text-decoration-none fw-bold">
                                            <%= m.getUsername() %>
                                        </a>
                                    </td>
                                    <td><%= m.getNickname() != null ? m.getNickname() : "-" %></td>
                                    <td>
                                        <% switch(m.getGender()) {
                                            case 1: out.print("男"); break;
                                            case 2: out.print("女"); break;
                                            default: out.print("未知"); break;
                                        } %>
                                    </td>
                                    <td><%= m.getPhone() != null ? m.getPhone() : "-" %></td>
                                    <td><span class="badge bg-warning">Level <%= m.getLevel() %></span></td>
                                    <td class="text-success fw-bold">¥<%= m.getBalance() %></td>
                                    <td class="text-info">
                                        <% java.math.BigDecimal tr = m.getTotalRecharge();
                                           out.print(tr != null ? "¥" + tr : "¥0"); %>
                                    </td>
                                    <td class="text-danger">¥<%= m.getTotalConsumption() %></td>
                                    <td><%= m.getPoints() %></td>
                                    <td>
                                        <% if (m.getStatus() == 1) { %>
                                            <span class="badge bg-success status-badge">正常</span>
                                        <% } else { %>
                                            <span class="badge bg-danger status-badge">冻结</span>
                                        <% } %>
                                    </td>
                                    <td class="action-buttons">
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button class="btn btn-info" data-bs-toggle="modal" data-bs-target="#rechargeModal"
                                                    onclick="setRechargeMember(<%= m.getMemberId() %>, '<%= m.getUsername() %>')">
                                                <i class="fas fa-credit-card"></i>
                                            </button>
                                            <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#editMemberModal"
                                                    onclick='editMember(<%= m.getMemberId() %>, "<%= m.getNickname() != null ? m.getNickname() : "" %>",
                                                    <%= m.getGender() %>, "<%= m.getPhone() != null ? m.getPhone() : "" %>",
                                                    <%= m.getLevel() %>, <%= m.getStatus() %>)'>
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-danger" onclick="deleteMember(<%= m.getMemberId() %>)">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
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

<!-- 添加会员模态框 -->
<div class="modal fade" id="addMemberModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/admin/memberManage" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-user-plus me-2"></i>添加新会员</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="addUsername" class="form-label">用户名 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="addUsername" name="username" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="addPassword" class="form-label">密码 <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="addPassword" name="password" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="addNickname" class="form-label">昵称</label>
                            <input type="text" class="form-control" id="addNickname" name="nickname">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="addGender" class="form-label">性别</label>
                            <select class="form-select" id="addGender" name="gender">
                                <option value="0">保密</option>
                                <option value="1">男</option>
                                <option value="2">女</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="addPhone" class="form-label">电话</label>
                            <input type="text" class="form-control" id="addPhone" name="phone">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="addQq" class="form-label">QQ</label>
                            <input type="text" class="form-control" id="addQq" name="qq">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="addWechat" class="form-label">微信</label>
                            <input type="text" class="form-control" id="addWechat" name="wechat">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="addEmail" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="addEmail" name="email">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i>保存
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 编辑会员模态框 -->
<div class="modal fade" id="editMemberModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/admin/memberManage" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="memberId" id="editMemberId">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit me-2"></i>编辑会员信息</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="editNickname" class="form-label">昵称</label>
                            <input type="text" class="form-control" id="editNickname" name="nickname">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="editGender" class="form-label">性别</label>
                            <select class="form-select" id="editGender" name="gender">
                                <option value="0">保密</option>
                                <option value="1">男</option>
                                <option value="2">女</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="editPhone" class="form-label">电话</label>
                            <input type="text" class="form-control" id="editPhone" name="phone">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="editLevel" class="form-label">会员等级</label>
                            <select class="form-select" id="editLevel" name="level">
                                <option value="1">1级</option>
                                <option value="2">2级</option>
                                <option value="3">3级</option>
                                <option value="4">4级</option>
                                <option value="5">5级</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="editQq" class="form-label">QQ</label>
                            <input type="text" class="form-control" id="editQq" name="qq">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="editWechat" class="form-label">微信</label>
                            <input type="text" class="form-control" id="editWechat" name="wechat">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="editEmail" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="editEmail" name="email">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="editStatus" class="form-label">账户状态</label>
                        <select class="form-select" id="editStatus" name="status">
                            <option value="1">正常</option>
                            <option value="0">冻结</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i>更新
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 充值模态框 -->
<div class="modal fade" id="rechargeModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/admin/memberManage" method="post">
                <input type="hidden" name="action" value="recharge">
                <input type="hidden" name="memberId" id="rechargeMemberId">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-credit-card me-2"></i>会员充值</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info">
                        为会员 <strong id="rechargeMemberUsername"></strong> 充值
                    </div>
                    <div class="mb-3">
                        <label for="rechargeAmount" class="form-label">充值金额 <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text">¥</span>
                            <input type="number" class="form-control" id="rechargeAmount" name="amount"
                                   min="0.01" step="0.01" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="rechargeType" class="form-label">支付方式</label>
                        <select class="form-select" id="rechargeType" name="rechargeType">
                            <option value="1">现金</option>
                            <option value="2">支付宝</option>
                            <option value="3">微信</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="rechargeRemark" class="form-label">备注</label>
                        <input type="text" class="form-control" id="rechargeRemark" name="remark"
                               placeholder="可选填写备注信息">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-check me-1"></i>确认充值
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
// 设置充值会员信息
function setRechargeMember(memberId, username) {
    document.getElementById('rechargeMemberId').value = memberId;
    document.getElementById('rechargeMemberUsername').textContent = username;
}

// 编辑会员
function editMember(memberId, nickname, gender, phone, level, status) {
    document.getElementById('editMemberId').value = memberId;
    document.getElementById('editNickname').value = nickname;
    document.getElementById('editGender').value = gender;
    document.getElementById('editPhone').value = phone;
    document.getElementById('editLevel').value = level;
    document.getElementById('editStatus').value = status;
}

// 删除会员
function deleteMember(memberId) {
    if (confirm('确定要删除该会员吗？此操作不可恢复！')) {
        window.location.href = '<%= request.getContextPath() %>/admin/memberManage?action=delete&id=' + memberId;
    }
}
</script>
</body>
</html>
