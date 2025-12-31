package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.bean.Refund;
import com.yourcompany.netbarmanager.service.RefundService;
import com.yourcompany.netbarmanager.service.RefundServiceImpl;

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
 * 会员退费申请控制器
 */
@WebServlet("/member/refund")
public class MemberRefundServlet extends HttpServlet {

    private RefundService refundService = new RefundServiceImpl();

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

        // 获取会员最新的信息（确保余额最新）
        // 这里应该重新从数据库获取，简化处理直接使用session中的

        // 获取该会员的退费申请记录
        List<Refund> refundList = refundService.getRefundsByMemberId(member.getMemberId());
        request.setAttribute("refundList", refundList);

        // 检查是否有待处理的消息
        String message = (String) session.getAttribute("message");
        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("message");
        }

        // 转发到退费申请页面
        request.getRequestDispatcher("/pages/member/refund.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 验证会员登录状态
        HttpSession session = request.getSession();
        Member member = (Member) session.getAttribute("user");
        if (member == null || !"member".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // 设置请求编码
        request.setCharacterEncoding("UTF-8");

        // 获取表单参数
        String amountStr = request.getParameter("amount");
        String reason = request.getParameter("reason");

        // 数据验证
        if (amountStr == null || amountStr.trim().isEmpty()) {
            session.setAttribute("message", "请输入退费金额");
            response.sendRedirect(request.getContextPath() + "/member/refund");
            return;
        }

        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("message", "请填写退费原因");
            response.sendRedirect(request.getContextPath() + "/member/refund");
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amountStr);
        } catch (NumberFormatException e) {
            session.setAttribute("message", "退费金额格式不正确");
            response.sendRedirect(request.getContextPath() + "/member/refund");
            return;
        }

        // 验证金额范围
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            session.setAttribute("message", "退费金额必须大于0");
            response.sendRedirect(request.getContextPath() + "/member/refund");
            return;
        }

        // 验证金额不能超过余额
        if (amount.compareTo(member.getBalance()) > 0) {
            session.setAttribute("message", "退费金额不能超过账户余额");
            response.sendRedirect(request.getContextPath() + "/member/refund");
            return;
        }

        // 创建退费申请
        boolean success = refundService.createRefundRequest(member.getMemberId(), amount, reason);

        if (success) {
            session.setAttribute("message", "退费申请提交成功，请等待管理员审核");
        } else {
            session.setAttribute("message", "退费申请提交失败，请稍后重试");
        }

        // 重定向回退费申请页面
        response.sendRedirect(request.getContextPath() + "/member/refund");
    }
}
