package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAOImpl implements AdminDAO {

    @Override
    public Admin login(String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Admin admin = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM admin WHERE username = ? AND password = ? AND status = 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setRealName(rs.getString("real_name"));
                admin.setPhone(rs.getString("phone"));
                admin.setEmail(rs.getString("email"));
                admin.setCreateTime(rs.getTimestamp("create_time"));
                admin.setLastLogin(rs.getTimestamp("last_login"));
                admin.setStatus(rs.getInt("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return admin;
    }

    @Override
    public Admin findById(int adminId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Admin admin = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM admin WHERE admin_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, adminId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setRealName(rs.getString("real_name"));
                admin.setPhone(rs.getString("phone"));
                admin.setEmail(rs.getString("email"));
                admin.setCreateTime(rs.getTimestamp("create_time"));
                admin.setLastLogin(rs.getTimestamp("last_login"));
                admin.setStatus(rs.getInt("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return admin;
    }

    @Override
    public List<Admin> findAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Admin> adminList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM admin ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setRealName(rs.getString("real_name"));
                admin.setPhone(rs.getString("phone"));
                admin.setEmail(rs.getString("email"));
                admin.setCreateTime(rs.getTimestamp("create_time"));
                admin.setLastLogin(rs.getTimestamp("last_login"));
                admin.setStatus(rs.getInt("status"));
                adminList.add(admin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return adminList;
    }

    @Override
    public boolean update(Admin admin) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE admin SET real_name = ?, phone = ?, email = ?, status = ? WHERE admin_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, admin.getRealName());
            pstmt.setString(2, admin.getPhone());
            pstmt.setString(3, admin.getEmail());
            pstmt.setInt(4, admin.getStatus());
            pstmt.setInt(5, admin.getAdminId());

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    @Override
    public boolean updateLastLogin(int adminId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE admin SET last_login = CURRENT_TIMESTAMP WHERE admin_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, adminId);

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }
}