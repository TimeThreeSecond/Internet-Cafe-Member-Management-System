<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录错误</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card mt-5">
                    <div class="card-header bg-danger text-white">
                        <h4 class="mb-0">登录失败</h4>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            用户名或密码错误，请重试！
                        </div>
                        <div class="d-grid gap-2">
                            <a href="<%=request.getContextPath()%>/pages/login.jsp" class="btn btn-primary">
                                <i class="fas fa-sign-in-alt me-2"></i>重新登录
                            </a>
                            <a href="<%=request.getContextPath()%>/pages/register.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-user-plus me-2"></i>注册新账号
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>