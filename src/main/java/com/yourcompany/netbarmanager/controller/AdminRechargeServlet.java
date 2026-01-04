package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.bean.Recharge;
import com.yourcompany.netbarmanager.dao.MemberDAO;
import com.yourcompany.netbarmanager.dao.MemberDAOImpl;
import com.yourcompany.netbarmanager.dao.TempCardDAO;
import com.yourcompany.netbarmanager.dao.TempCardDAOImpl;
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
 * 管理员充值管理控制器
 * 支持会员充值和临时卡充值
 */
@WebServlet("/admin/recharge")
public class AdminRechargeServlet extends HttpServlet {

    private RechargeService rechargeService = new RechargeServiceImpl();
    private MemberDAO memberDAO = new MemberDAOImpl();
    private TempCardDAO tempCardDAO = new TempCardDAOImpl();

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

        // 获取最近的充值记录
        List<Recharge> recentRecharges = rechargeService.getRecentRecharges(20);
        request.setAttribute("recentRecharges", recentRecharges);

        // 获取统计数据
        request.setAttribute("todayTotal", rechargeService.getTodayTotalAmount());
        request.setAttribute("monthTotal", rechargeService.getMonthTotalAmount());

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

        // 转发到充值管理页面
        request.getRequestDispatcher("/pages/admin/recharge.jsp").forward(request, response);
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

        // 获取充值类型
        String rechargeTarget = request.getParameter("rechargeTarget"); // member 或 tempCard
        String amountStr = request.getParameter("amount");
        String rechargeTypeStr = request.getParameter("rechargeType");
        String remark = request.getParameter("remark");

        // 数据验证
        if (amountStr == null || amountStr.trim().isEmpty()) {
            session.setAttribute("error", "请输入充值金额");
            response.sendRedirect(request.getContextPath() + "/admin/recharge");
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amountStr);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "充值金额格式不正确");
            response.sendRedirect(request.getContextPath() + "/admin/recharge");
            return;
        }

        // 验证金额范围
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            session.setAttribute("error", "充值金额必须大于0");
            response.sendRedirect(request.getContextPath() + "/admin/recharge");
            return;
        }

        if (amount.compareTo(new BigDecimal("10000")) > 0) {
            session.setAttribute("error", "单次充值金额不能超过10000元");
            response.sendRedirect(request.getContextPath() + "/admin/recharge");
            return;
        }

        int rechargeType;
        try {
            rechargeType = Integer.parseInt(rechargeTypeStr);
        } catch (NumberFormatException e) {
            rechargeType = 1; // 默认现金
        }

        boolean success = false;

        if ("tempCard".equals(rechargeTarget)) {
            // 临时卡充值
            String tempCardId = request.getParameter("tempCardId");
            if (tempCardId == null || tempCardId.trim().isEmpty()) {
                session.setAttribute("error", "请输入临时卡号");
                response.sendRedirect(request.getContextPath() + "/admin/recharge");
                return;
            }

            // 检查临时卡是否存在
            if (tempCardDAO.findById(tempCardId) == null) {
                session.setAttribute("error", "临时卡不存在");
                response.sendRedirect(request.getContextPath() + "/admin/recharge");
                return;
            }

            success = rechargeService.tempCardRecharge(tempCardId, amount, rechargeType, remark);

        } else {
            // 会员充值
            String memberIdStr = request.getParameter("memberId");
            if (memberIdStr == null || memberIdStr.trim().isEmpty()) {
                session.setAttribute("error", "请选择会员");
                response.sendRedirect(request.getContextPath() + "/admin/recharge");
                return;
            }

            int memberId;
            try {
                memberId = Integer.parseInt(memberIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("error", "无效的会员ID");
                response.sendRedirect(request.getContextPath() + "/admin/recharge");
                return;
            }

            // 检查会员是否存在
            if (memberDAO.findById(memberId) == null) {
                session.setAttribute("error", "会员不存在");
                response.sendRedirect(request.getContextPath() + "/admin/recharge");
                return;
            }

            success = rechargeService.memberRecharge(memberId, amount, rechargeType, admin.getAdminId(), remark);
        }

        // 设置操作结果消息
        if (success) {
            session.setAttribute("success", "充值成功！金额：¥" + amount);
        } else {
            session.setAttribute("error", "充值失败，请稍后重试");
        }

        // 重定向回充值管理页面
        response.sendRedirect(request.getContextPath() + "/admin/recharge");
    }
}
