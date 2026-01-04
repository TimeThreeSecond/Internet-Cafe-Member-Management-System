package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.dao.MemberDAO;
import com.yourcompany.netbarmanager.dao.MemberDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 会员搜索API
 * 提供会员搜索的JSON接口
 */
@WebServlet("/api/members/search")
public class MemberSearchServlet extends HttpServlet {

    private MemberDAO memberDAO = new MemberDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置JSON响应
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 验证登录状态（可选，根据需求决定是否需要）
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"未登录\"}");
            return;
        }

        // 获取搜索关键词
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        keyword = keyword.trim();

        List<Member> members;

        // 判断搜索类型：如果是纯数字，按ID搜索；否则按关键字搜索
        if (keyword.matches("\\d+")) {
            // 按会员ID精确搜索
            Member member = memberDAO.findById(Integer.parseInt(keyword));
            if (member != null) {
                members = java.util.Collections.singletonList(member);
            } else {
                members = java.util.Collections.emptyList();
            }
        } else {
            // 按用户名或昵称模糊搜索
            members = memberDAO.findByKeyword(keyword);
        }

        // 手动构建JSON结果
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < members.size(); i++) {
            if (i > 0) {
                json.append(",");
            }
            Member m = members.get(i);
            json.append("{");
            json.append("\"memberId\":").append(m.getMemberId()).append(",");
            json.append("\"username\":\"").append(escapeJson(m.getUsername())).append("\",");
            json.append("\"nickname\":\"").append(escapeJson(m.getNickname())).append("\",");
            json.append("\"gender\":").append(m.getGender()).append(",");
            json.append("\"phone\":\"").append(escapeJson(m.getPhone())).append("\",");
            json.append("\"balance\":").append(m.getBalance()).append(",");
            json.append("\"points\":").append(m.getPoints()).append(",");
            json.append("\"level\":").append(m.getLevel());
            json.append("}");
        }
        json.append("]");

        response.getWriter().write(json.toString());
    }

    /**
     * 转义JSON字符串中的特殊字符
     */
    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 不支持POST请求
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
