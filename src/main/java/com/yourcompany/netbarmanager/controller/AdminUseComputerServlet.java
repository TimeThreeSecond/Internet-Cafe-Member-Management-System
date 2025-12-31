package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.bean.Computer;
import com.yourcompany.netbarmanager.bean.Consumption;
import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.dao.ComputerDAO;
import com.yourcompany.netbarmanager.dao.ComputerDAOImpl;
import com.yourcompany.netbarmanager.dao.ConsumptionDAO;
import com.yourcompany.netbarmanager.dao.ConsumptionDAOImpl;
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
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.List;

/**
 * 管理员上机管理控制器
 * 处理会员上机、下机结算等操作
 */
@WebServlet("/admin/useComputer")
public class AdminUseComputerServlet extends HttpServlet {
    private ComputerDAO computerDAO = new ComputerDAOImpl();
    private ConsumptionDAO consumptionDAO = new ConsumptionDAOImpl();
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

        String action = request.getParameter("action");

        // 处理下机请求
        if ("offline".equals(action)) {
            handleOffline(request, response, session);
            return;
        }

        // 获取所有进行中的上机记录
        List<Consumption> activeSessions = consumptionDAO.findActiveSessions();

        // 计算当前消费金额
        for (Consumption c : activeSessions) {
            if (c.getStartTime() != null) {
                long minutes = (System.currentTimeMillis() - c.getStartTime().getTime()) / 60000;
                c.setDuration((int) minutes);

                // 获取电脑费率
                Computer computer = computerDAO.findById(c.getComputerId());
                if (computer != null) {
                    BigDecimal hourlyRate = computer.getHourlyRate();
                    BigDecimal amount = hourlyRate.multiply(new BigDecimal(minutes))
                            .divide(new BigDecimal(60), 2, RoundingMode.HALF_UP);
                    c.setAmount(amount);
                }
            }
        }

        // 获取最近的上机记录（用于显示历史）
        List<Consumption> recentSessions = consumptionDAO.findRecentSessions(20);

        // 获取所有可用的电脑（空闲状态）
        List<Computer> availableComputers = computerDAO.findByStatus(0);

        // 统计数据
        int totalActive = activeSessions.size();
        int totalAvailable = availableComputers.size();

        // 设置数据到request
        request.setAttribute("activeSessions", activeSessions);
        request.setAttribute("recentSessions", recentSessions);
        request.setAttribute("availableComputers", availableComputers);
        request.setAttribute("totalActive", totalActive);
        request.setAttribute("totalAvailable", totalAvailable);

        // 转发到上机管理页面
        request.getRequestDispatcher("/pages/admin/useComputer.jsp").forward(request, response);
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

        String action = request.getParameter("action");

        if ("online".equals(action)) {
            // 处理上机操作
            handleOnline(request, response, session, admin);
        } else if ("offline".equals(action)) {
            // 处理下机操作
            handleOffline(request, response, session);
        } else {
            session.setAttribute("error", "无效的操作类型");
            response.sendRedirect(request.getContextPath() + "/admin/useComputer");
        }
    }

    /**
     * 处理上机操作
     */
    private void handleOnline(HttpServletRequest request, HttpServletResponse response,
                               HttpSession session, Admin admin) throws IOException {
        String memberIdStr = request.getParameter("memberId");
        String computerIdStr = request.getParameter("computerId");
        String consumptionTypeStr = request.getParameter("consumptionType");

        // 验证必填字段
        if (memberIdStr == null || memberIdStr.isEmpty() ||
            computerIdStr == null || computerIdStr.isEmpty()) {
            session.setAttribute("error", "会员和电脑不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/useComputer");
            return;
        }

        try {
            int memberId = Integer.parseInt(memberIdStr);
            int computerId = Integer.parseInt(computerIdStr);
            int consumptionType = consumptionTypeStr != null ? Integer.parseInt(consumptionTypeStr) : 1;

            // 验证会员是否存在
            Member member = memberService.getMemberById(memberId);
            if (member == null) {
                session.setAttribute("error", "会员不存在");
                response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                return;
            }

            // 验证会员状态
            if (member.getStatus() != 1) {
                session.setAttribute("error", "会员账户已被冻结");
                response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                return;
            }

            // 验证电脑是否存在且空闲
            Computer computer = computerDAO.findById(computerId);
            if (computer == null) {
                session.setAttribute("error", "电脑不存在");
                response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                return;
            }

            if (computer.getStatus() != 0) {
                session.setAttribute("error", "该电脑正在使用中或维护中");
                response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                return;
            }

            // 检查会员是否已有进行中的上机记录
            List<Consumption> activeSessions = consumptionDAO.findActiveSessions();
            for (Consumption c : activeSessions) {
                if (c.getMemberId() == memberId) {
                    session.setAttribute("error", "该会员已有进行中的上机记录");
                    response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                    return;
                }
            }

            // 创建上机记录
            Consumption consumption = new Consumption();
            consumption.setMemberId(memberId);
            consumption.setComputerId(computerId);
            consumption.setStartTime(new Timestamp(System.currentTimeMillis()));
            consumption.setConsumptionType(consumptionType);
            consumption.setDuration(0);
            consumption.setAmount(BigDecimal.ZERO);

            if (consumptionDAO.add(consumption)) {
                // 更新电脑状态为使用中
                computerDAO.updateStatus(computerId, 1);
                session.setAttribute("success", "上机成功");
            } else {
                session.setAttribute("error", "上机失败");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "无效的参数");
        }

        response.sendRedirect(request.getContextPath() + "/admin/useComputer");
    }

    /**
     * 处理下机操作
     */
    private void handleOffline(HttpServletRequest request, HttpServletResponse response,
                                HttpSession session) throws IOException {
        String consumptionIdStr = request.getParameter("consumptionId");

        if (consumptionIdStr == null || consumptionIdStr.isEmpty()) {
            session.setAttribute("error", "上机记录ID不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/useComputer");
            return;
        }

        try {
            int consumptionId = Integer.parseInt(consumptionIdStr);

            // 获取上机记录
            Consumption consumption = consumptionDAO.findById(consumptionId);
            if (consumption == null) {
                session.setAttribute("error", "上机记录不存在");
                response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                return;
            }

            if (consumption.getEndTime() != null) {
                session.setAttribute("error", "该上机记录已结束");
                response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                return;
            }

            // 计算费用
            Timestamp endTime = new Timestamp(System.currentTimeMillis());
            long minutes = (endTime.getTime() - consumption.getStartTime().getTime()) / 60000;
            int duration = (int) minutes;

            // 获取电脑费率
            Computer computer = computerDAO.findById(consumption.getComputerId());
            BigDecimal hourlyRate = computer != null ? computer.getHourlyRate() : new BigDecimal("5.00");
            BigDecimal amount = hourlyRate.multiply(new BigDecimal(duration))
                    .divide(new BigDecimal(60), 2, RoundingMode.HALF_UP);

            // 检查会员余额
            Member member = memberService.getMemberById(consumption.getMemberId());
            if (member == null) {
                session.setAttribute("error", "会员不存在");
                response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                return;
            }

            if (member.getBalance().compareTo(amount) < 0) {
                session.setAttribute("error", "会员余额不足，当前余额：¥" + member.getBalance() + "，应付：¥" + amount);
                response.sendRedirect(request.getContextPath() + "/admin/useComputer");
                return;
            }

            // 更新上机记录
            consumptionDAO.updateEndTime(consumptionId, endTime, duration, amount);

            // 扣除会员余额并增加积分和消费金额
            memberService.deductBalance(consumption.getMemberId(), amount);

            // 更新电脑状态为空闲
            computerDAO.updateStatus(consumption.getComputerId(), 0);

            session.setAttribute("success", "下机成功，消费时长：" + duration + "分钟，金额：¥" + amount);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "无效的参数");
        }

        response.sendRedirect(request.getContextPath() + "/admin/useComputer");
    }
}
