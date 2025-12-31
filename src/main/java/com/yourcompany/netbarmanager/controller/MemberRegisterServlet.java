package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.service.MemberService;
import com.yourcompany.netbarmanager.service.MemberServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/register")
public class MemberRegisterServlet extends HttpServlet {
    private MemberService memberService = new MemberServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String nickname = request.getParameter("nickname");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String qq = request.getParameter("qq");
        String wechat = request.getParameter("wechat");
        String email = request.getParameter("email");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "用户名和密码不能为空");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        if (memberService.isUsernameExists(username.trim())) {
            request.setAttribute("error", "用户名已存在");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        Member member = new Member();
        member.setUsername(username.trim());
        member.setPassword(password.trim());
        member.setNickname(nickname != null ? nickname.trim() : "");
        member.setGender(gender != null && !gender.isEmpty() ? Integer.parseInt(gender) : 0);
        member.setPhone(phone != null ? phone.trim() : "");
        member.setQq(qq != null ? qq.trim() : "");
        member.setWechat(wechat != null ? wechat.trim() : "");
        member.setEmail(email != null ? email.trim() : "");

        if (memberService.register(member)) {
            request.setAttribute("success", "注册成功，请登录");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "注册失败，请重试");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
        }
    }
}