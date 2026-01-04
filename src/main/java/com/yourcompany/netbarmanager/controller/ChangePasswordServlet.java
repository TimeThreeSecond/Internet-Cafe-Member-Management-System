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

/**
 * 修改密码控制器
 * 处理会员修改密码的请求
 */
@WebServlet("/member/changePassword")
public class ChangePasswordServlet extends HttpServlet {
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

        // 转发到修改密码页面
        request.getRequestDispatcher("/pages/member/changePassword.jsp").forward(request, response);
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

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 验证输入
        if (oldPassword == null || oldPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            session.setAttribute("error", "所有字段不能为空");
            response.sendRedirect(request.getContextPath() + "/member/changePassword");
            return;
        }

        // 验证新密码和确认密码是否一致
        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("error", "新密码和确认密码不一致");
            response.sendRedirect(request.getContextPath() + "/member/changePassword");
            return;
        }

        // 验证旧密码是否正确
        if (!member.getPassword().equals(oldPassword)) {
            session.setAttribute("error", "原密码错误");
            response.sendRedirect(request.getContextPath() + "/member/changePassword");
            return;
        }

        // 验证新密码长度
        if (newPassword.length() < 6 || newPassword.length() > 20) {
            session.setAttribute("error", "新密码长度必须在6-20位之间");
            response.sendRedirect(request.getContextPath() + "/member/changePassword");
            return;
        }

        // 更新密码
        if (memberService.updatePassword(member.getMemberId(), newPassword)) {
            session.setAttribute("success", "密码修改成功，请重新登录");
            // 更新session中的用户信息
            member.setPassword(newPassword);
            session.setAttribute("user", member);
            response.sendRedirect(request.getContextPath() + "/member/changePassword");
        } else {
            session.setAttribute("error", "密码修改失败，请重试");
            response.sendRedirect(request.getContextPath() + "/member/changePassword");
        }
    }
}
