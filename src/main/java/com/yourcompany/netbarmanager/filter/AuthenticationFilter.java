package com.yourcompany.netbarmanager.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthenticationFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();

        // 检查是否是登录或注册页面
        if (requestURI.endsWith("login.jsp") ||
            requestURI.endsWith("register.jsp") ||
            requestURI.contains("/login") ||
            requestURI.contains("/register")) {
            chain.doFilter(request, response);
            return;
        }

        // 检查用户是否已登录
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/pages/login.jsp");
            return;
        }

        // 检查用户类型是否有权限访问对应的页面
        String userType = (String) session.getAttribute("userType");
        if (requestURI.contains("/admin/") && !"admin".equals(userType)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/pages/login.jsp");
            return;
        }

        if (requestURI.contains("/member/") && !"member".equals(userType)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/pages/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}