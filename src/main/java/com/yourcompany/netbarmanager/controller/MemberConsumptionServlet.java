package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.bean.Consumption;
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
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * 会员消费记录查询控制器
 * 处理会员查询历史消费记录的请求
 */
@WebServlet("/member/consumption")
public class MemberConsumptionServlet extends HttpServlet {
    private ConsumptionDAO consumptionDAO = new ConsumptionDAOImpl();
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

        // 获取筛选参数
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String typeStr = request.getParameter("type");

        // 获取会员的所有消费记录
        List<Consumption> consumptions = consumptionDAO.findByMemberId(member.getMemberId());
        List<Consumption> filteredConsumptions = new ArrayList<>();

        // 统计数据
        BigDecimal totalAmount = BigDecimal.ZERO;
        int totalCount = 0;

        for (Consumption c : consumptions) {
            // 按类型筛选
            if (typeStr != null && !typeStr.isEmpty()) {
                int type = Integer.parseInt(typeStr);
                if (c.getConsumptionType() != type) {
                    continue;
                }
            }

            // 按日期筛选
            if (startDateStr != null && !startDateStr.isEmpty()) {
                Date startDate = Date.valueOf(startDateStr);
                if (c.getStartTime() != null && c.getStartTime().before(new java.util.Date(startDate.getTime()))) {
                    continue;
                }
            }

            if (endDateStr != null && !endDateStr.isEmpty()) {
                Date endDate = Date.valueOf(endDateStr);
                // 设置结束时间为当天23:59:59
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(endDate);
                cal.set(java.util.Calendar.HOUR_OF_DAY, 23);
                cal.set(java.util.Calendar.MINUTE, 59);
                cal.set(java.util.Calendar.SECOND, 59);
                if (c.getStartTime() != null && c.getStartTime().after(cal.getTime())) {
                    continue;
                }
            }

            filteredConsumptions.add(c);

            // 统计
            if (c.getAmount() != null) {
                totalAmount = totalAmount.add(c.getAmount());
            }
            totalCount++;
        }

        // 设置数据到request
        request.setAttribute("consumptions", filteredConsumptions);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("type", typeStr);

        // 转发到消费记录页面
        request.getRequestDispatcher("/pages/member/consumption.jsp").forward(request, response);
    }
}
