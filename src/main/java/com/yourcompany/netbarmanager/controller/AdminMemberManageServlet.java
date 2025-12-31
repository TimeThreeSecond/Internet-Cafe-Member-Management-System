package com.yourcompany.netbarmanager.controller;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.bean.Member;
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
import java.util.List;

/**
 * 管理员会员管理控制器
 * 处理会员的查询、添加、编辑、删除等操作
 */
@WebServlet("/admin/memberManage")
public class AdminMemberManageServlet extends HttpServlet {
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

        // 获取搜索参数
        String keyword = request.getParameter("keyword");
        String levelStr = request.getParameter("level");
        String genderStr = request.getParameter("gender");
        String action = request.getParameter("action");

        // 处理查看详情请求
        if ("view".equals(action)) {
            String memberIdStr = request.getParameter("id");
            if (memberIdStr != null) {
                try {
                    int memberId = Integer.parseInt(memberIdStr);
                    Member member = memberService.getMemberById(memberId);
                    if (member != null) {
                        request.setAttribute("member", member);
                        request.getRequestDispatcher("/pages/admin/memberDetail.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // 忽略无效ID
                }
            }
        }

        // 处理删除请求
        if ("delete".equals(action)) {
            String memberIdStr = request.getParameter("id");
            if (memberIdStr != null) {
                try {
                    int memberId = Integer.parseInt(memberIdStr);
                    if (memberService.deleteMember(memberId)) {
                        session.setAttribute("success", "会员删除成功");
                    } else {
                        session.setAttribute("error", "会员删除失败");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "无效的会员ID");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/memberManage");
            return;
        }

        // 处理编辑请求 - 获取会员信息用于编辑
        if ("edit".equals(action)) {
            String memberIdStr = request.getParameter("id");
            if (memberIdStr != null) {
                try {
                    int memberId = Integer.parseInt(memberIdStr);
                    Member member = memberService.getMemberById(memberId);
                    if (member != null) {
                        request.setAttribute("member", member);
                        request.setAttribute("editMode", true);
                    }
                } catch (NumberFormatException e) {
                    // 忽略无效ID
                }
            }
        }

        // 搜索会员
        List<Member> memberList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            memberList = memberService.searchMembers(keyword.trim());
        } else if (levelStr != null && !levelStr.isEmpty()) {
            try {
                int level = Integer.parseInt(levelStr);
                memberList = memberService.getMembersByLevel(level);
            } catch (NumberFormatException e) {
                memberList = memberService.getAllMembers();
            }
        } else if (genderStr != null && !genderStr.isEmpty()) {
            try {
                int gender = Integer.parseInt(genderStr);
                memberList = memberService.getMembersByGender(gender);
            } catch (NumberFormatException e) {
                memberList = memberService.getAllMembers();
            }
        } else {
            memberList = memberService.getAllMembers();
        }

        // 设置数据到request
        request.setAttribute("memberList", memberList);
        request.setAttribute("totalMembers", memberList.size());

        // 保留搜索参数用于回显
        request.setAttribute("keyword", keyword);
        request.setAttribute("level", levelStr);
        request.setAttribute("gender", genderStr);

        // 转发到会员管理页面
        request.getRequestDispatcher("/pages/admin/memberManage.jsp").forward(request, response);
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
            // 添加新会员
            handleAddMember(request, response, session, admin);
        } else if ("edit".equals(action)) {
            // 编辑会员信息
            handleEditMember(request, response, session);
        } else {
            session.setAttribute("error", "无效的操作类型");
            response.sendRedirect(request.getContextPath() + "/admin/memberManage");
        }
    }

    /**
     * 处理添加新会员
     */
    private void handleAddMember(HttpServletRequest request, HttpServletResponse response,
                                  HttpSession session, Admin admin) throws IOException {
        String username = request.getParameter("username");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");
        String genderStr = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String qq = request.getParameter("qq");
        String wechat = request.getParameter("wechat");
        String email = request.getParameter("email");

        // 验证必填字段
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            session.setAttribute("error", "用户名和密码不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/memberManage");
            return;
        }

        // 检查用户名是否已存在
        if (memberService.isUsernameExists(username.trim())) {
            session.setAttribute("error", "用户名已存在");
            response.sendRedirect(request.getContextPath() + "/admin/memberManage");
            return;
        }

        // 创建新会员对象
        Member member = new Member();
        member.setUsername(username.trim());
        member.setNickname(nickname != null ? nickname.trim() : "");
        member.setPassword(password.trim());
        member.setGender(genderStr != null && !genderStr.isEmpty() ? Integer.parseInt(genderStr) : 0);
        member.setPhone(phone != null ? phone.trim() : "");
        member.setQq(qq != null ? qq.trim() : "");
        member.setWechat(wechat != null ? wechat.trim() : "");
        member.setEmail(email != null ? email.trim() : "");
        member.setBalance(BigDecimal.ZERO);
        member.setPoints(0);
        member.setLevel(1);
        member.setTotalConsumption(BigDecimal.ZERO);
        member.setStatus(1);

        // 注册会员
        if (memberService.register(member)) {
            session.setAttribute("success", "会员添加成功");
        } else {
            session.setAttribute("error", "会员添加失败");
        }

        response.sendRedirect(request.getContextPath() + "/admin/memberManage");
    }

    /**
     * 处理编辑会员信息
     */
    private void handleEditMember(HttpServletRequest request, HttpServletResponse response,
                                   HttpSession session) throws IOException {
        String memberIdStr = request.getParameter("memberId");
        String nickname = request.getParameter("nickname");
        String genderStr = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String qq = request.getParameter("qq");
        String wechat = request.getParameter("wechat");
        String email = request.getParameter("email");
        String levelStr = request.getParameter("level");
        String statusStr = request.getParameter("status");

        if (memberIdStr == null || memberIdStr.isEmpty()) {
            session.setAttribute("error", "会员ID不能为空");
            response.sendRedirect(request.getContextPath() + "/admin/memberManage");
            return;
        }

        try {
            int memberId = Integer.parseInt(memberIdStr);
            Member member = memberService.getMemberById(memberId);

            if (member == null) {
                session.setAttribute("error", "会员不存在");
                response.sendRedirect(request.getContextPath() + "/admin/memberManage");
                return;
            }

            // 更新会员信息
            member.setNickname(nickname != null ? nickname.trim() : "");
            member.setGender(genderStr != null && !genderStr.isEmpty() ? Integer.parseInt(genderStr) : 0);
            member.setPhone(phone != null ? phone.trim() : "");
            member.setQq(qq != null ? qq.trim() : "");
            member.setWechat(wechat != null ? wechat.trim() : "");
            member.setEmail(email != null ? email.trim() : "");
            if (levelStr != null && !levelStr.isEmpty()) {
                member.setLevel(Integer.parseInt(levelStr));
            }
            if (statusStr != null && !statusStr.isEmpty()) {
                member.setStatus(Integer.parseInt(statusStr));
            }

            if (memberService.updateMember(member)) {
                session.setAttribute("success", "会员信息更新成功");
            } else {
                session.setAttribute("error", "会员信息更新失败");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "无效的参数");
        }

        response.sendRedirect(request.getContextPath() + "/admin/memberManage");
    }
}
