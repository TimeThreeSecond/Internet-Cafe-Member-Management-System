package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.bean.Recharge;
import com.yourcompany.netbarmanager.dao.MemberDAO;
import com.yourcompany.netbarmanager.dao.MemberDAOImpl;
import com.yourcompany.netbarmanager.service.MemberService;
import com.yourcompany.netbarmanager.service.MemberServiceImpl;
import com.yourcompany.netbarmanager.service.RechargeService;
import com.yourcompany.netbarmanager.service.RechargeServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * 会员在线充值控制器
 */
@WebServlet("/member/recharge")
public class MemberRechargeServlet extends HttpServlet {

    private RechargeService rechargeService = new RechargeServiceImpl();
    private MemberService memberService = new MemberServiceImpl();
    private MemberDAO memberDAO = new MemberDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 验证会员登录状态
        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("user");

        if (member == null || !"member".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // 刷新session中的会员信息（确保余额最新）
        member = memberService.getMemberById(member.getMemberId());
        session.setAttribute("user", member);

        // 获取该会员的充值记录
        List<Recharge> rechargeList = rechargeService.getRechargesByMemberId(member.getMemberId());
        request.setAttribute("rechargeList", rechargeList);

        // 检查是否有消息
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }

        // 转发到充值页面
        request.getRequestDispatcher("/pages/member/recharge.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 验证会员登录状态
        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("user");

        if (member == null || !"member".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // 获取表单参数
        String amountStr = request.getParameter("amount");
        String rechargeTypeStr = request.getParameter("paymentMethod"); // 支付方式

        // 数据验证
        if (amountStr == null || amountStr.trim().isEmpty()) {
            session.setAttribute("error", "请输入充值金额");
            response.sendRedirect(request.getContextPath() + "/member/recharge");
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amountStr);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "充值金额格式不正确");
            response.sendRedirect(request.getContextPath() + "/member/recharge");
            return;
        }

        // 验证金额范围
        if (amount.compareTo(new BigDecimal("10")) < 0) {
            session.setAttribute("error", "最低充值金额为10元");
            response.sendRedirect(request.getContextPath() + "/member/recharge");
            return;
        }

        if (amount.compareTo(new BigDecimal("10000")) > 0) {
            session.setAttribute("error", "单次充值金额不能超过10000元");
            response.sendRedirect(request.getContextPath() + "/member/recharge");
            return;
        }

        // 解析充值类型
        int rechargeType = 2; // 默认线上支付
        if (rechargeTypeStr != null) {
            try {
                rechargeType = Integer.parseInt(rechargeTypeStr);
            } catch (NumberFormatException e) {
                rechargeType = 2;
            }
        }

        // 直接执行充值
        boolean success = rechargeService.memberRecharge(
                member.getMemberId(),
                amount,
                rechargeType,
                null, // 线上充值没有操作员
                "线上充值"
        );

        if (success) {
            // 更新session中的会员信息
            member = memberService.getMemberById(member.getMemberId());
            session.setAttribute("user", member);

            session.setAttribute("success", "充值成功！充值金额：¥" + amount);
        } else {
            session.setAttribute("error", "充值失败，请稍后重试");
        }

        // 重定向回充值页面
        response.sendRedirect(request.getContextPath() + "/member/recharge");
    }
}
