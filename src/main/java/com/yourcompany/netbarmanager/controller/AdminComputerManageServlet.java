package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.bean.Computer;
import com.yourcompany.netbarmanager.dao.ComputerDAO;
import com.yourcompany.netbarmanager.dao.ComputerDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 管理员设备管理控制器
 * 处理电脑设备的查询、添加、编辑、删除、状态更新等操作
 */
@WebServlet("/admin/computerManage")
public class AdminComputerManageServlet extends HttpServlet {
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

        // 获取筛选参数
        String statusStr = request.getParameter("status");
        String typeStr = request.getParameter("type");
        String action = request.getParameter("action");

        // 处理删除请求
        if ("delete".equals(action)) {
            String computerIdStr = request.getParameter("id");
            if (computerIdStr != null) {
                try {
                    int computerId = Integer.parseInt(computerIdStr);
                    if (computerDAO.delete(computerId)) {
                        session.setAttribute("success", "设备删除成功");
                    } else {
                        session.setAttribute("error", "设备删除失败");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "无效的设备ID");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/computerManage");
            return;
        }

        // 处理编辑请求 - 获取设备信息用于编辑
        if ("edit".equals(action)) {
            String computerIdStr = request.getParameter("id");
            if (computerIdStr != null) {
                try {
                    int computerId = Integer.parseInt(computerIdStr);
                    Computer computer = computerDAO.findById(computerId);
                    if (computer != null) {
                        request.setAttribute("computer", computer);
                        request.setAttribute("editMode", true);
                    }
                } catch (NumberFormatException e) {
                    // 忽略无效ID
                }
            }
        }

        // 查询设备列表
        List<Computer> computerList;
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                int status = Integer.parseInt(statusStr);
                computerList = computerDAO.findByStatus(status);
            } catch (NumberFormatException e) {
                computerList = computerDAO.findAll();
            }
        } else if (typeStr != null && !typeStr.isEmpty()) {
            try {
                int type = Integer.parseInt(typeStr);
                computerList = computerDAO.findByType(type);
            } catch (NumberFormatException e) {
                computerList = computerDAO.findAll();
            }
        } else {
            computerList = computerDAO.findAll();
        }

        // 统计各状态设备数量
        int totalCount = computerList.size();
        int idleCount = 0;
        int inUseCount = 0;
        int maintenanceCount = 0;

        for (Computer c : computerList) {
            switch (c.getStatus()) {
                case 0: idleCount++; break;
                case 1: inUseCount++; break;
                case 2: maintenanceCount++; break;
            }
        }

        // 设置数据到request
        request.setAttribute("computerList", computerList);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("idleCount", idleCount);
        request.setAttribute("inUseCount", inUseCount);
        request.setAttribute("maintenanceCount", maintenanceCount);

        // 保留筛选参数用于回显
        request.setAttribute("status", statusStr);
        request.setAttribute("type", typeStr);

        // 转发到设备管理页面
        request.getRequestDispatcher("/pages/admin/computerManage.jsp").forward(request, response);
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

        if ("add".equals(action)) {
            // 添加新设备
            handleAddComputer(request, response, session);
        } else if ("edit".equals(action)) {
            // 编辑设备信息
            handleEditComputer(request, response, session);
        } else if ("updateStatus".equals(action)) {
            // 更新设备状态
            handleUpdateStatus(request, response, session);
        } else {
            session.setAttribute("error", "无效的操作类型");
            response.sendRedirect(request.getContextPath() + "/admin/computerManage");
        }
    }

    /**
     * 处理添加新设备
     */
    private void handleAddComputer(HttpServletRequest request, HttpServletResponse response,
                                    HttpSession session) throws IOException {
        String computerNo = request.getParameter("computerNo");
        String location = request.getParameter("location");
        String typeStr = request.getParameter("computerType");
        String rateStr = request.getParameter("hourlyRate");

        // 验证必填字段
        if (computerNo == null || computerNo.trim().isEmpty()) {
            session.setAttribute("error", "设备编号不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/computerManage");
            return;
        }

        // 检查设备编号是否已存在
        if (computerDAO.findByNo(computerNo.trim()) != null) {
            session.setAttribute("error", "设备编号已存在");
            response.sendRedirect(request.getContextPath() + "/admin/computerManage");
            return;
        }

        // 创建新设备对象
        Computer computer = new Computer();
        computer.setComputerNo(computerNo.trim());
        computer.setLocation(location != null ? location.trim() : "");
        computer.setComputerType(typeStr != null && !typeStr.isEmpty() ? Integer.parseInt(typeStr) : 1);
        try {
            computer.setHourlyRate(rateStr != null && !rateStr.isEmpty()
                ? new java.math.BigDecimal(rateStr) : new java.math.BigDecimal("5.00"));
        } catch (NumberFormatException e) {
            computer.setHourlyRate(new java.math.BigDecimal("5.00"));
        }
        computer.setStatus(0);

        // 添加设备
        if (computerDAO.add(computer)) {
            session.setAttribute("success", "设备添加成功");
        } else {
            session.setAttribute("error", "设备添加失败");
        }

        response.sendRedirect(request.getContextPath() + "/admin/computerManage");
    }

    /**
     * 处理编辑设备信息
     */
    private void handleEditComputer(HttpServletRequest request, HttpServletResponse response,
                                     HttpSession session) throws IOException {
        String computerIdStr = request.getParameter("computerId");
        String location = request.getParameter("location");
        String typeStr = request.getParameter("computerType");
        String rateStr = request.getParameter("hourlyRate");
        String statusStr = request.getParameter("status");

        if (computerIdStr == null || computerIdStr.isEmpty()) {
            session.setAttribute("error", "设备ID不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/computerManage");
            return;
        }

        try {
            int computerId = Integer.parseInt(computerIdStr);
            Computer computer = computerDAO.findById(computerId);

            if (computer == null) {
                session.setAttribute("error", "设备不存在");
                response.sendRedirect(request.getContextPath() + "/admin/computerManage");
                return;
            }

            // 更新设备信息
            computer.setLocation(location != null ? location.trim() : "");
            computer.setComputerType(typeStr != null && !typeStr.isEmpty() ? Integer.parseInt(typeStr) : 1);
            try {
                computer.setHourlyRate(rateStr != null && !rateStr.isEmpty()
                    ? new java.math.BigDecimal(rateStr) : new java.math.BigDecimal("5.00"));
            } catch (NumberFormatException e) {
                computer.setHourlyRate(new java.math.BigDecimal("5.00"));
            }
            if (statusStr != null && !statusStr.isEmpty()) {
                computer.setStatus(Integer.parseInt(statusStr));
            }

            if (computerDAO.update(computer)) {
                session.setAttribute("success", "设备信息更新成功");
            } else {
                session.setAttribute("error", "设备信息更新失败");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "无效的参数");
        }

        response.sendRedirect(request.getContextPath() + "/admin/computerManage");
    }

    /**
     * 处理更新设备状态
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response,
                                      HttpSession session) throws IOException {
        String computerIdStr = request.getParameter("computerId");
        String statusStr = request.getParameter("status");

        if (computerIdStr == null || computerIdStr.isEmpty() ||
            statusStr == null || statusStr.isEmpty()) {
            session.setAttribute("error", "设备ID和状态不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/computerManage");
            return;
        }

        try {
            int computerId = Integer.parseInt(computerIdStr);
            int status = Integer.parseInt(statusStr);

            if (computerDAO.updateStatus(computerId, status)) {
                session.setAttribute("success", "设备状态更新成功");
            } else {
                session.setAttribute("error", "设备状态更新失败");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "无效的参数");
        }

        response.sendRedirect(request.getContextPath() + "/admin/computerManage");
    }
}
