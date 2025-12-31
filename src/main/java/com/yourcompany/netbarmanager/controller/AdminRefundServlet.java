package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.bean.Refund;
import com.yourcompany.netbarmanager.service.RefundService;
import com.yourcompany.netbarmanager.service.RefundServiceImpl;
import com.yourcompany.netbarmanager.dao.MemberDAO;
import com.yourcompany.netbarmanager.dao.MemberDAOImpl;
import com.yourcompany.netbarmanager.bean.Member;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 管理员退费管理控制器
 * 处理退费申请的查询、审批等操作
 */
@WebServlet("/admin/refund")
public class AdminRefundServlet extends HttpServlet {
    private RefundService refundService = new RefundServiceImpl();
    private MemberDAO memberDAO = new MemberDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 验证登录状态
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("user");

        if (admin == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // 获取筛选状态参数
        String statusParam = request.getParameter("status");
        Integer statusFilter = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                statusFilter = Integer.parseInt(statusParam);
                request.setAttribute("status", statusParam);
            } catch (NumberFormatException e) {
                // 忽略无效参数
            }
        }

        // 根据状态筛选获取退费列表
        List<Refund> refunds;
        if (statusFilter != null) {
            refunds = refundService.getRefundsByStatus(statusFilter);
        } else {
            refunds = refundService.getAllRefunds();
        }

        // 为每个退费记录附加会员信息
        for (Refund refund : refunds) {
            Member member = memberDAO.findById(refund.getMemberId());
            if (member != null) {
                refund.setMemberUsername(member.getUsername());
                refund.setMemberNickname(member.getNickname());
            }
        }

        // 设置数据到request
        request.setAttribute("refunds", refunds);
        request.setAttribute("pendingCount", refundService.countByStatus(0));
        request.setAttribute("approvedCount", refundService.countByStatus(1));
        request.setAttribute("rejectedCount", refundService.countByStatus(2));

        // 转发到退费管理页面
        request.getRequestDispatcher("/pages/admin/refund.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 验证登录状态
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("user");

        if (admin == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        // 获取操作类型
        String action = request.getParameter("action");
        String refundIdParam = request.getParameter("refundId");

        if (refundIdParam == null || refundIdParam.isEmpty()) {
            session.setAttribute("error", "退费ID不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/refund");
            return;
        }

        int refundId;
        try {
            refundId = Integer.parseInt(refundIdParam);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "无效的退费ID");
            response.sendRedirect(request.getContextPath() + "/admin/refund");
            return;
        }

        boolean success = false;
        String message = "";

        if ("approve".equals(action)) {
            // 审批通过
            success = refundService.approveRefund(refundId, admin.getAdminId());
            message = success ? "退费申请已通过，资金已退回会员账户" : "退费处理失败，可能余额不足";
        } else if ("reject".equals(action)) {
            // 拒绝申请
            success = refundService.rejectRefund(refundId, admin.getAdminId());
            message = success ? "退费申请已拒绝" : "操作失败";
        } else {
            session.setAttribute("error", "无效的操作类型");
            response.sendRedirect(request.getContextPath() + "/admin/refund");
            return;
        }

        // 设置操作结果消息
        if (success) {
            session.setAttribute("success", message);
        } else {
            session.setAttribute("error", message);
        }

        // 重定向回退费管理页面
        response.sendRedirect(request.getContextPath() + "/admin/refund");
    }
}
