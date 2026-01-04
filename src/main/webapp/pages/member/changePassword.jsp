<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.yourcompany.netbarmanager.bean.Member" %>
<%
    Member member = (Member) session.getAttribute("user");
    if (member == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
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
    <title>修改密码 - 网吧会员管理系统</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <style>
        .password-container {
            max-width: 500px;
            margin: 0 auto;
        }
        .password-strength {
            height: 5px;
            border-radius: 3px;
            margin-top: 10px;
            transition: all 0.3s;
        }
        .strength-weak { background-color: #dc3545; width: 33%; }
        .strength-medium { background-color: #ffc107; width: 66%; }
        .strength-strong { background-color: #198754; width: 100%; }
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
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/member/profile"><i class="fas fa-user me-2"></i>个人资料</a></li>
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
                            <a class="nav-link" href="<%= request.getContextPath() %>/member/index">
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
                    <h1 class="h2"><i class="fas fa-lock me-2"></i>修改密码</h1>
                    <a href="<%= request.getContextPath() %>/member/index" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i>返回会员中心
                    </a>
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

                <!-- 修改密码表单 -->
                <div class="password-container">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-key me-2"></i>修改登录密码</h5>
                        </div>
                        <div class="card-body">
                            <form action="<%= request.getContextPath() %>/member/changePassword" method="post" id="passwordForm">
                                <div class="mb-3">
                                    <label for="username" class="form-label">用户名</label>
                                    <input type="text" class="form-control" id="username" value="<%= member.getUsername() %>" readonly>
                                </div>

                                <div class="mb-3">
                                    <label for="oldPassword" class="form-label">原密码 <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                        <input type="password" class="form-control" id="oldPassword" name="oldPassword"
                                               placeholder="请输入原密码" required>
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('oldPassword')">
                                            <i class="fas fa-eye" id="oldPasswordIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="newPassword" class="form-label">新密码 <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-key"></i></span>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword"
                                               placeholder="请输入新密码（6-20位）" required minlength="6" maxlength="20">
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('newPassword')">
                                            <i class="fas fa-eye" id="newPasswordIcon"></i>
                                        </button>
                                    </div>
                                    <div id="passwordStrength" class="password-strength"></div>
                                    <small class="text-muted">密码长度为6-20位，建议包含字母、数字和特殊字符</small>
                                </div>

                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">确认新密码 <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-check"></i></span>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                               placeholder="请再次输入新密码" required>
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('confirmPassword')">
                                            <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                                        </button>
                                    </div>
                                    <div id="confirmMessage" class="form-text"></div>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-save me-2"></i>确认修改
                                    </button>
                                    <a href="<%= request.getContextPath() %>/member/index" class="btn btn-secondary">
                                        取消
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- 安全提示 -->
                <div class="card shadow mt-4">
                    <div class="card-header bg-warning">
                        <h6 class="mb-0"><i class="fas fa-shield-alt me-2"></i>安全提示</h6>
                    </div>
                    <div class="card-body">
                        <ul class="mb-0">
                            <li><i class="fas fa-check text-success me-2"></i>建议使用包含字母、数字和特殊字符的组合密码</li>
                            <li><i class="fas fa-check text-success me-2"></i>密码长度建议不少于8位</li>
                            <li><i class="fas fa-check text-success me-2"></i>不要使用过于简单的密码如：123456、password等</li>
                            <li><i class="fas fa-check text-success me-2"></i>定期更换密码以保障账户安全</li>
                            <li><i class="fas fa-check text-success me-2"></i>不要在多个网站使用相同的密码</li>
                        </ul>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        // 切换密码显示/隐藏
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = document.getElementById(fieldId + 'Icon');
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // 密码强度检测
        document.getElementById('newPassword').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrength');

            // 移除所有强度类
            strengthBar.className = 'password-strength';

            if (password.length === 0) {
                strengthBar.style.width = '0';
                return;
            }

            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;

            if (strength <= 2) {
                strengthBar.classList.add('strength-weak');
            } else if (strength <= 3) {
                strengthBar.classList.add('strength-medium');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        });

        // 确认密码验证
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;
            const confirmMessage = document.getElementById('confirmMessage');

            if (confirmPassword.length === 0) {
                confirmMessage.textContent = '';
                confirmMessage.className = 'form-text';
                return;
            }

            if (newPassword === confirmPassword) {
                confirmMessage.textContent = '<i class="fas fa-check-circle text-success me-1"></i>密码一致';
                confirmMessage.className = 'form-text text-success';
            } else {
                confirmMessage.textContent = '<i class="fas fa-times-circle text-danger me-1"></i>密码不一致';
                confirmMessage.className = 'form-text text-danger';
            }
        });

        // 表单提交验证
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('新密码和确认密码不一致，请重新输入！');
                return false;
            }

            if (newPassword.length < 6 || newPassword.length > 20) {
                e.preventDefault();
                alert('密码长度必须在6-20位之间！');
                return false;
            }
        });
    </script>
</body>
</html>
