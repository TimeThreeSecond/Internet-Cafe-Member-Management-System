package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.bean.Refund;
import com.yourcompany.netbarmanager.service.MemberService;
import com.yourcompany.netbarmanager.service.MemberServiceImpl;
import com.yourcompany.netbarmanager.service.RefundService;
import com.yourcompany.netbarmanager.service.RefundServiceImpl;
import com.yourcompany.netbarmanager.dao.ComputerDAO;
import com.yourcompany.netbarmanager.dao.ComputerDAOImpl;

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
 * 管理员首页控制器
 * 获取并显示管理员首页的统计数据和列表
 */
@WebServlet("/admin/index")
public class AdminIndexServlet extends HttpServlet {
    private MemberService memberService = new MemberServiceImpl();
    private RefundService refundService = new RefundServiceImpl();
    private ComputerDAO computerDAO = new ComputerDAOImpl();

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

        // 1. 获取会员总数
        List<Member> allMembers = memberService.getAllMembers();
        int totalMembers = allMembers.size();

        // 2. 计算今日收入
        BigDecimal todayIncome = calculateTodayIncome();

        // 3. 获取电脑状态统计
        List<com.yourcompany.netbarmanager.bean.Computer> allComputers = computerDAO.findAll();
        int totalComputers = allComputers.size();
        int inUseComputers = 0;
        for (com.yourcompany.netbarmanager.bean.Computer c : allComputers) {
            if (c.getStatus() == 1) { // 1-使用中
                inUseComputers++;
            }
        }

        // 4. 获取待处理退费数量
        int pendingRefunds = refundService.countByStatus(0);

        // 5. 获取最近注册的会员（最多10个）
        List<Member> recentMembers = getRecentMembers(allMembers, 10);

        // 6. 获取待审批退费列表
        List<Refund> pendingRefundList = refundService.getPendingRefunds();
        // 限制最多显示10个
        if (pendingRefundList.size() > 10) {
            pendingRefundList = pendingRefundList.subList(0, 10);
        }

        // 设置数据到request
        request.setAttribute("totalMembers", totalMembers);
        request.setAttribute("todayIncome", todayIncome);
        request.setAttribute("inUseComputers", inUseComputers);
        request.setAttribute("totalComputers", totalComputers);
        request.setAttribute("pendingRefunds", pendingRefunds);
        request.setAttribute("recentMembers", recentMembers);
        request.setAttribute("pendingRefundList", pendingRefundList);

        // 转发到管理员首页
        request.getRequestDispatcher("/pages/admin/index.jsp").forward(request, response);
    }

    /**
     * 计算今日收入
     * 注：充值功能已删除，当前返回0
     */
    private BigDecimal calculateTodayIncome() {
        // 充值功能已删除，返回0
        // 后续可基于消费记录计算收入
        return BigDecimal.ZERO;
    }

    /**
     * 获取最近注册的会员
     */
    private List<Member> getRecentMembers(List<Member> allMembers, int limit) {
        // 简单实现：按注册时间排序，取前N个
        // 由于Member没有直接的排序方法，这里返回已有的顺序
        // 实际项目应该在DAO层实现排序
        if (allMembers.size() <= limit) {
            return allMembers;
        }
        return allMembers.subList(0, limit);
    }
}
