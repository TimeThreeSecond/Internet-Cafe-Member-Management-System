<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>500 - 服务器错误</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 text-center mt-5">
                <div class="error-template">
                    <h1 class="display-1">500</h1>
                    <h2 class="mb-4">服务器内部错误</h2>
                    <p class="lead">抱歉，服务器遇到了一个错误，无法完成您的请求。</p>
                    <div class="error-details mt-3">
                        <p>请稍后重试，或联系系统管理员。</p>
                    </div>
                    <div class="error-actions mt-4">
                        <a href="<%=request.getContextPath()%>/pages/login.jsp" class="btn btn-primary btn-lg">
                            <i class="fas fa-home me-2"></i>返回首页
                        </a>
                        <button onclick="location.reload()" class="btn btn-warning btn-lg ms-2">
                            <i class="fas fa-redo me-2"></i>重新加载
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>