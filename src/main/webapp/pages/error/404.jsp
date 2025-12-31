<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>404 - 页面未找到</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 text-center mt-5">
                <div class="error-template">
                    <h1 class="display-1">404</h1>
                    <h2 class="mb-4">页面未找到</h2>
                    <p class="lead">抱歉，您访问的页面不存在或已被移动。</p>
                    <div class="error-actions mt-4">
                        <a href="<%=request.getContextPath()%>/pages/login.jsp" class="btn btn-primary btn-lg">
                            <i class="fas fa-home me-2"></i>返回首页
                        </a>
                        <button onclick="history.back()" class="btn btn-secondary btn-lg ms-2">
                            <i class="fas fa-arrow-left me-2"></i>返回上一页
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>