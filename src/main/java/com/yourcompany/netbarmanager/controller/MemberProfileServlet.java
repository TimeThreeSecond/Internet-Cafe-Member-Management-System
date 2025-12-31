package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Member;

import com.yourcompany.netbarmanager.service.MemberService;
import com.yourcompany.netbarmanager.service.MemberServiceImpl;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 会员个人资料控制器
 * 处理会员个人信息的显示和修改
 */
@WebServlet("/member/profile")
public class MemberProfileServlet extends HttpServlet {
    private MemberService memberService = new MemberServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 验证登录状态
        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("user");

        if (member == null || !"member".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // 从数据库重新获取最新的会员信息
        member = memberService.getMemberById(member.getMemberId());
        if (member != null) {
            session.setAttribute("user", member);
        }


        // 转发到个人资料页面
        request.getRequestDispatcher("/pages/member/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 验证登录状态
        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("user");

        if (member == null || !"member".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // 获取表单参数
        String nickname = request.getParameter("nickname");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String qq = request.getParameter("qq");
        String wechat = request.getParameter("wechat");
        String email = request.getParameter("email");

        // 验证必填字段
        if (nickname == null || nickname.trim().isEmpty()) {
            request.setAttribute("error", "昵称不能为空");
            request.getRequestDispatcher("/pages/member/profile.jsp").forward(request, response);
            return;
        }

        // 更新会员信息
        member.setNickname(nickname.trim());
        member.setGender(gender != null && !gender.isEmpty() ? Integer.parseInt(gender) : 0);
        member.setPhone(phone != null ? phone.trim() : "");
        member.setQq(qq != null ? qq.trim() : "");
        member.setWechat(wechat != null ? wechat.trim() : "");
        member.setEmail(email != null ? email.trim() : "");

        // 保存更新
        if (memberService.updateMember(member)) {
            session.setAttribute("user", member);
            session.setAttribute("success", "个人信息修改成功");
        } else {
            session.setAttribute("error", "保存失败，请重试");
        }

        // 重定向回个人资料页面
        response.sendRedirect(request.getContextPath() + "/member/profile");
    }
}
