package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.service.AdminService;
import com.yourcompany.netbarmanager.service.AdminServiceImpl;
import com.yourcompany.netbarmanager.service.MemberService;
import com.yourcompany.netbarmanager.service.MemberServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    AdminService adminService = new AdminServiceImpl();
    MemberService memberService = new MemberServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "用户名和密码不能为空");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();

        if ("admin".equals(userType)) {
            Admin admin = adminService.login(username.trim(), password.trim());
            if (admin != null) {
                session.setAttribute("user", admin);
                session.setAttribute("userType", "admin");
                response.sendRedirect(request.getContextPath() + "/pages/admin/index.jsp");
            } else {
                request.setAttribute("error", "用户名或密码错误");
                request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            }

        } else if ("member".equals(userType)) {
            Member member = memberService.login(username.trim(), password.trim());
            if (member != null) {
                session.setAttribute("user", member);
                session.setAttribute("userType", "member");
                response.sendRedirect(request.getContextPath() + "/pages/member/index.jsp");
            } else {
                request.setAttribute("error", "用户名或密码错误");
                request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "请选择用户类型");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    }
}