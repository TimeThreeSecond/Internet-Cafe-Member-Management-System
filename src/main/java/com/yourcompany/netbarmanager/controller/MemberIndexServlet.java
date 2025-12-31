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
 * 会员中心首页控制器
 * 获取并显示会员中心的数据
 */
@WebServlet("/member/index")
public class MemberIndexServlet extends HttpServlet {
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

        // 充值功能已删除，充值记录设置为空列表
        // 消费记录暂时为空（ConsumptionDAO尚未实现）
        // 设置数据到request
        request.setAttribute("recentRecharges", new java.util.ArrayList<>());
        request.setAttribute("recentConsumptions", new java.util.ArrayList<>());

        // 转发到会员中心首页
        request.getRequestDispatcher("/pages/member/index.jsp").forward(request, response);
    }
}
