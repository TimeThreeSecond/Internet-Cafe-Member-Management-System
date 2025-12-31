<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Admin" %>
<%@ page import="com.yourcompany.netbarmanager.bean.Computer" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("user");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    List<Computer> computerList = (List<Computer>) request.getAttribute("computerList");
    if (computerList == null) computerList = new java.util.ArrayList<>();
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    if (totalCount == null) totalCount = computerList.size();
    Integer idleCount = (Integer) request.getAttribute("idleCount");
    if (idleCount == null) idleCount = 0;
    Integer inUseCount = (Integer) request.getAttribute("inUseCount");
    if (inUseCount == null) inUseCount = 0;
    Integer maintenanceCount = (Integer) request.getAttribute("maintenanceCount");
    if (maintenanceCount == null) maintenanceCount = 0;
    String status = (String) request.getAttribute("status");
    String type = (String) request.getAttribute("type");
    Computer editComputer = (Computer) request.getAttribute("computer");
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
    <title>设备管理 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .status-badge {
            font-size: 0.8rem;
        }
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.8rem;
        }
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
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
                        <a class="nav-link active" href="<%= request.getContextPath() %>/admin/computerManage">
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
                <h1 class="h2"><i class="fas fa-desktop me-2"></i>设备管理</h1>
                <div class="btn-group">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addComputerModal">
                        <i class="fas fa-plus me-1"></i>添加设备
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

            <!-- 统计卡片 -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-primary">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">设备总数</p>
                                    <h3 class="mb-0"><%= totalCount %></h3>
                                </div>
                                <i class="fas fa-desktop fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-success">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">空闲</p>
                                    <h3 class="mb-0"><%= idleCount %></h3>
                                </div>
                                <i class="fas fa-check-circle fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-warning">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">使用中</p>
                                    <h3 class="mb-0"><%= inUseCount %></h3>
                                </div>
                                <i class="fas fa-user fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stat-card text-white bg-danger">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="mb-0">维护中</p>
                                    <h3 class="mb-0"><%= maintenanceCount %></h3>
                                </div>
                                <i class="fas fa-tools fa-2x opacity-50"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 筛选区域 -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary"><i class="fas fa-filter me-2"></i>搜索筛选</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin/computerManage" method="get" class="row g-3">
                        <div class="col-md-4">
                            <label for="status" class="form-label">设备状态</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">全部</option>
                                <option value="0" <%= "0".equals(status) ? "selected" : "" %>>空闲</option>
                                <option value="1" <%= "1".equals(status) ? "selected" : "" %>>使用中</option>
                                <option value="2" <%= "2".equals(status) ? "selected" : "" %>>维护中</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="type" class="form-label">设备类型</label>
                            <select class="form-select" id="type" name="type">
                                <option value="">全部</option>
                                <option value="1" <%= "1".equals(type) ? "selected" : "" %>>普通</option>
                                <option value="2" <%= "2".equals(type) ? "selected" : "" %>>包房</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-1"></i>筛选
                            </button>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <a href="<%= request.getContextPath() %>/admin/computerManage" class="btn btn-secondary w-100">
                                <i class="fas fa-redo me-1"></i>重置
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 设备列表 -->
            <div class="card shadow">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-list me-2"></i>设备列表 (共 <%= totalCount %> 台)
                    </h6>
                </div>
                <div class="card-body">
                    <% if (computerList.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <p class="text-muted">暂无设备数据</p>
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>设备编号</th>
                                    <th>位置</th>
                                    <th>类型</th>
                                    <th>费率(元/小时)</th>
                                    <th>状态</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Computer c : computerList) { %>
                                <tr>
                                    <td><%= c.getComputerId() %></td>
                                    <td class="fw-bold"><%= c.getComputerNo() %></td>
                                    <td><%= c.getLocation() != null ? c.getLocation() : "-" %></td>
                                    <td><span class="badge bg-info"><%= c.getComputerTypeText() %></span></td>
                                    <td class="text-primary fw-bold">¥<%= c.getHourlyRate() %></td>
                                    <td>
                                        <% if (c.getStatus() == 0) { %>
                                            <span class="badge bg-success status-badge">空闲</span>
                                        <% } else if (c.getStatus() == 1) { %>
                                            <span class="badge bg-warning status-badge">使用中</span>
                                        <% } else { %>
                                            <span class="badge bg-danger status-badge">维护中</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (c.getCreateTime() != null) { %>
                                            <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(c.getCreateTime()) %>
                                        <% } else { %>
                                            -
                                        <% } %>
                                    </td>
                                    <td class="action-buttons">
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button class="btn btn-info" onclick="updateStatus(<%= c.getComputerId() %>, 0)" title="设为空闲">
                                                <i class="fas fa-check"></i>
                                            </button>
                                            <button class="btn btn-warning" onclick="updateStatus(<%= c.getComputerId() %>, 2)" title="设为维护">
                                                <i class="fas fa-tools"></i>
                                            </button>
                                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editComputerModal"
                                                    onclick='editComputer(<%= c.getComputerId() %>, "<%= c.getComputerNo() %>",
                                                    "<%= c.getLocation() != null ? c.getLocation() : "" %>",
                                                    <%= c.getComputerType() %>, <%= c.getHourlyRate() %>, <%= c.getStatus() %>)'>
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-danger" onclick="deleteComputer(<%= c.getComputerId() %>)">
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

<!-- 添加设备模态框 -->
<div class="modal fade" id="addComputerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/admin/computerManage" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-desktop me-2"></i>添加新设备</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="addComputerNo" class="form-label">设备编号 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="addComputerNo" name="computerNo" required>
                    </div>
                    <div class="mb-3">
                        <label for="addLocation" class="form-label">位置</label>
                        <input type="text" class="form-control" id="addLocation" name="location" placeholder="如：大厅A区">
                    </div>
                    <div class="mb-3">
                        <label for="addComputerType" class="form-label">设备类型</label>
                        <select class="form-select" id="addComputerType" name="computerType">
                            <option value="1">普通</option>
                            <option value="2">包房</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="addHourlyRate" class="form-label">费率(元/小时)</label>
                        <input type="number" class="form-control" id="addHourlyRate" name="hourlyRate"
                               min="0" step="0.5" value="5.00">
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

<!-- 编辑设备模态框 -->
<div class="modal fade" id="editComputerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="<%= request.getContextPath() %>/admin/computerManage" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="computerId" id="editComputerId">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit me-2"></i>编辑设备信息</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="editComputerNo" class="form-label">设备编号</label>
                        <input type="text" class="form-control" id="editComputerNo" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="editLocation" class="form-label">位置</label>
                        <input type="text" class="form-control" id="editLocation" name="location">
                    </div>
                    <div class="mb-3">
                        <label for="editComputerType" class="form-label">设备类型</label>
                        <select class="form-select" id="editComputerType" name="computerType">
                            <option value="1">普通</option>
                            <option value="2">包房</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="editHourlyRate" class="form-label">费率(元/小时)</label>
                        <input type="number" class="form-control" id="editHourlyRate" name="hourlyRate"
                               min="0" step="0.5">
                    </div>
                    <div class="mb-3">
                        <label for="editStatus" class="form-label">设备状态</label>
                        <select class="form-select" id="editStatus" name="status">
                            <option value="0">空闲</option>
                            <option value="1">使用中</option>
                            <option value="2">维护中</option>
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

<!-- 状态更新表单（隐藏） -->
<form id="statusForm" action="<%= request.getContextPath() %>/admin/computerManage" method="post" style="display:none;">
    <input type="hidden" name="action" value="updateStatus">
    <input type="hidden" name="computerId" id="statusComputerId">
    <input type="hidden" name="status" id="statusValue">
</form>

<script src="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
// 编辑设备
function editComputer(computerId, computerNo, location, computerType, hourlyRate, status) {
    document.getElementById('editComputerId').value = computerId;
    document.getElementById('editComputerNo').value = computerNo;
    document.getElementById('editLocation').value = location;
    document.getElementById('editComputerType').value = computerType;
    document.getElementById('editHourlyRate').value = hourlyRate;
    document.getElementById('editStatus').value = status;
}

// 更新状态
function updateStatus(computerId, status) {
    if (confirm('确定要更改设备状态吗？')) {
        document.getElementById('statusComputerId').value = computerId;
        document.getElementById('statusValue').value = status;
        document.getElementById('statusForm').submit();
    }
}

// 删除设备
function deleteComputer(computerId) {
    if (confirm('确定要删除该设备吗？此操作不可恢复！')) {
        window.location.href = '<%= request.getContextPath() %>/admin/computerManage?action=delete&id=' + computerId;
    }
}
</script>
</body>
</html>
