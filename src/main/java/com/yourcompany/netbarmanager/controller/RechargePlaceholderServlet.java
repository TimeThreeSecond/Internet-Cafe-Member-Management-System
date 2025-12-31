package com.yourcompany.netbarmanager.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 充值功能占位控制器
 * 充值功能正在重写中，暂时显示"即将上线"页面
 */
@WebServlet({"/admin/recharge", "/member/recharge"})
public class RechargePlaceholderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("pageTitle", "充值功能");
        request.setAttribute("message", "充值功能正在重写中，即将上线，敬请期待！");
        request.getRequestDispatcher("/pages/common/coming-soon.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
