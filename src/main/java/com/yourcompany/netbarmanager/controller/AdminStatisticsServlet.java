package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.bean.Refund;
import com.yourcompany.netbarmanager.dao.RefundDAO;
import com.yourcompany.netbarmanager.dao.RefundDAOImpl;
import com.yourcompany.netbarmanager.service.MemberService;
import com.yourcompany.netbarmanager.service.MemberServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 管理员统计报表控制器
 * 处理收入统计、会员等级分布等报表功能
 * 注：充值功能已删除，充值相关统计数据设为0
 */
@WebServlet("/admin/statistics")
public class AdminStatisticsServlet extends HttpServlet {
    private RefundDAO refundDAO = new RefundDAOImpl();
    private MemberService memberService = new MemberServiceImpl();

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

        // 获取筛选参数
        String type = request.getParameter("type"); // daily, monthly
        String dateStr = request.getParameter("date"); // 格式: yyyy-MM-dd

        // 获取当前日期
        Calendar today = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

        // 设置默认日期为今天
        if (dateStr == null || dateStr.isEmpty()) {
            dateStr = dateFormat.format(today.getTime());
        }

        Date targetDate = Date.valueOf(dateStr);

        // 当日统计
        if ("daily".equals(type) || type == null || type.isEmpty()) {
            handleDailyStatistics(request, targetDate);
        }
        // 当月统计
        else if ("monthly".equals(type)) {
            handleMonthlyStatistics(request, targetDate);
        }

        // 会员等级分布
        List<Member> allMembers = memberService.getAllMembers();
        Map<Integer, Integer> levelDistribution = new LinkedHashMap<>();
        levelDistribution.put(1, 0);
        levelDistribution.put(2, 0);
        levelDistribution.put(3, 0);
        levelDistribution.put(4, 0);
        levelDistribution.put(5, 0);

        for (Member m : allMembers) {
            int level = m.getLevel();
            levelDistribution.put(level, levelDistribution.get(level) + 1);
        }

        // 设置数据到request
        request.setAttribute("type", type != null ? type : "daily");
        request.setAttribute("date", dateStr);
        request.setAttribute("levelDistribution", levelDistribution);
        request.setAttribute("totalMembers", allMembers.size());

        // 转发到统计报表页面
        request.getRequestDispatcher("/pages/admin/statistics.jsp").forward(request, response);
    }

    /**
     * 处理当日统计
     * 注：充值功能已删除，充值相关数据设为0
     */
    private void handleDailyStatistics(HttpServletRequest request, Date targetDate) {
        // 当天的开始和结束时间
        Calendar cal = Calendar.getInstance();
        cal.setTime(targetDate);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        Date startTime = new Date(cal.getTimeInMillis());

        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        Date endTime = new Date(cal.getTimeInMillis());

        // 充值功能已删除，充值相关数据设为0
        Map<Integer, BigDecimal> rechargeByType = new LinkedHashMap<>();
        rechargeByType.put(1, BigDecimal.ZERO); // 现金
        rechargeByType.put(2, BigDecimal.ZERO); // 线上
        rechargeByType.put(3, BigDecimal.ZERO); // 其他

        BigDecimal totalRecharge = BigDecimal.ZERO;
        int rechargeCount = 0;

        // 获取当日退费记录（已通过的）
        List<Refund> refunds = refundDAO.findByStatus(1);
        BigDecimal totalRefund = BigDecimal.ZERO;
        int refundCount = 0;

        for (Refund r : refunds) {
            Timestamp processTime = r.getProcessTime();
            if (processTime != null) {
                Date refundDate = new Date(processTime.getTime());
                if (!refundDate.before(startTime) && !refundDate.after(endTime)) {
                    BigDecimal amount = r.getAmount() != null ? r.getAmount() : BigDecimal.ZERO;
                    totalRefund = totalRefund.add(amount);
                    refundCount++;
                }
            }
        }

        // 计算净收入
        BigDecimal netIncome = totalRecharge.subtract(totalRefund);

        // 设置数据到request
        request.setAttribute("rechargeByType", rechargeByType);
        request.setAttribute("totalRecharge", totalRecharge);
        request.setAttribute("totalRefund", totalRefund);
        request.setAttribute("netIncome", netIncome);
        request.setAttribute("rechargeCount", rechargeCount);
        request.setAttribute("refundCount", refundCount);
    }

    /**
     * 处理当月统计
     * 注：充值功能已删除，充值相关数据设为0
     */
    private void handleMonthlyStatistics(HttpServletRequest request, Date targetDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(targetDate);
        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        Date monthStart = new Date(cal.getTimeInMillis());

        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        Date monthEnd = new Date(cal.getTimeInMillis());

        // 按日统计当月收入
        Map<String, BigDecimal> dailyIncome = new LinkedHashMap<>();
        Map<String, Integer> dailyCount = new LinkedHashMap<>();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // 初始化当月所有日期
        Calendar tempCal = Calendar.getInstance();
        tempCal.setTime(monthStart);
        while (!tempCal.getTime().after(monthEnd)) {
            String dateKey = sdf.format(tempCal.getTime());
            dailyIncome.put(dateKey, BigDecimal.ZERO);
            dailyCount.put(dateKey, 0);
            tempCal.add(Calendar.DAY_OF_MONTH, 1);
        }

        // 充值功能已删除，充值相关数据设为0
        BigDecimal totalRecharge = BigDecimal.ZERO;
        int rechargeCount = 0;

        // 获取当月退费
        List<Refund> refunds = refundDAO.findByStatus(1);
        BigDecimal totalRefund = BigDecimal.ZERO;
        int refundCount = 0;

        for (Refund r : refunds) {
            Timestamp processTime = r.getProcessTime();
            if (processTime != null) {
                Date refundDate = new Date(processTime.getTime());
                if (!refundDate.before(monthStart) && !refundDate.after(monthEnd)) {
                    BigDecimal amount = r.getAmount() != null ? r.getAmount() : BigDecimal.ZERO;
                    totalRefund = totalRefund.add(amount);
                    refundCount++;
                }
            }
        }

        BigDecimal netIncome = totalRecharge.subtract(totalRefund);

        // 设置数据到request
        request.setAttribute("dailyIncome", dailyIncome);
        request.setAttribute("dailyCount", dailyCount);
        request.setAttribute("totalRecharge", totalRecharge);
        request.setAttribute("totalRefund", totalRefund);
        request.setAttribute("netIncome", netIncome);
        request.setAttribute("rechargeCount", rechargeCount);
        request.setAttribute("refundCount", refundCount);
    }
}
