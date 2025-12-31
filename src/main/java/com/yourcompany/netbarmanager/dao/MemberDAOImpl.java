package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAOImpl implements MemberDAO {

    @Override
    public boolean register(Member member) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO member (username, password, nickname, gender, phone, qq, wechat, email, balance, points, level) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, member.getUsername());
            pstmt.setString(2, member.getPassword());
            pstmt.setString(3, member.getNickname());
            pstmt.setInt(4, member.getGender());
            pstmt.setString(5, member.getPhone());
            pstmt.setString(6, member.getQq());
            pstmt.setString(7, member.getWechat());
            pstmt.setString(8, member.getEmail());
            pstmt.setBigDecimal(9, member.getBalance());
            pstmt.setInt(10, member.getPoints());
            pstmt.setInt(11, member.getLevel());

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
    public Member login(String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Member member = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM member WHERE username = ? AND password = ? AND status = 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setNickname(rs.getString("nickname"));
                member.setGender(rs.getInt("gender"));
                member.setPhone(rs.getString("phone"));
                member.setQq(rs.getString("qq"));
                member.setWechat(rs.getString("wechat"));
                member.setEmail(rs.getString("email"));
                member.setBalance(rs.getBigDecimal("balance"));
                member.setPoints(rs.getInt("points"));
                member.setLevel(rs.getInt("level"));
                member.setTotalConsumption(rs.getBigDecimal("total_consumption"));
                member.setRegisterTime(rs.getTimestamp("register_time"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setStatus(rs.getInt("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return member;
    }

    @Override
    public Member findById(int memberId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Member member = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM member WHERE member_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setNickname(rs.getString("nickname"));
                member.setGender(rs.getInt("gender"));
                member.setPhone(rs.getString("phone"));
                member.setQq(rs.getString("qq"));
                member.setWechat(rs.getString("wechat"));
                member.setEmail(rs.getString("email"));
                member.setBalance(rs.getBigDecimal("balance"));
                member.setPoints(rs.getInt("points"));
                member.setLevel(rs.getInt("level"));
                member.setTotalConsumption(rs.getBigDecimal("total_consumption"));
                member.setRegisterTime(rs.getTimestamp("register_time"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setStatus(rs.getInt("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return member;
    }

    @Override
    public Member findByUsername(String username) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Member member = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM member WHERE username = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setNickname(rs.getString("nickname"));
                member.setGender(rs.getInt("gender"));
                member.setPhone(rs.getString("phone"));
                member.setQq(rs.getString("qq"));
                member.setWechat(rs.getString("wechat"));
                member.setEmail(rs.getString("email"));
                member.setBalance(rs.getBigDecimal("balance"));
                member.setPoints(rs.getInt("points"));
                member.setLevel(rs.getInt("level"));
                member.setTotalConsumption(rs.getBigDecimal("total_consumption"));
                member.setRegisterTime(rs.getTimestamp("register_time"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setStatus(rs.getInt("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return member;
    }

    @Override
    public List<Member> findAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Member> memberList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM member ORDER BY register_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Member member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setNickname(rs.getString("nickname"));
                member.setGender(rs.getInt("gender"));
                member.setPhone(rs.getString("phone"));
                member.setQq(rs.getString("qq"));
                member.setWechat(rs.getString("wechat"));
                member.setEmail(rs.getString("email"));
                member.setBalance(rs.getBigDecimal("balance"));
                member.setPoints(rs.getInt("points"));
                member.setLevel(rs.getInt("level"));
                member.setTotalConsumption(rs.getBigDecimal("total_consumption"));
                member.setRegisterTime(rs.getTimestamp("register_time"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setStatus(rs.getInt("status"));
                memberList.add(member);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return memberList;
    }

    @Override
    public List<Member> findByKeyword(String keyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Member> memberList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM member WHERE username LIKE ? OR nickname LIKE ? OR phone LIKE ? OR email LIKE ? ORDER BY register_time DESC";
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Member member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setNickname(rs.getString("nickname"));
                member.setGender(rs.getInt("gender"));
                member.setPhone(rs.getString("phone"));
                member.setQq(rs.getString("qq"));
                member.setWechat(rs.getString("wechat"));
                member.setEmail(rs.getString("email"));
                member.setBalance(rs.getBigDecimal("balance"));
                member.setPoints(rs.getInt("points"));
                member.setLevel(rs.getInt("level"));
                member.setTotalConsumption(rs.getBigDecimal("total_consumption"));
                member.setRegisterTime(rs.getTimestamp("register_time"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setStatus(rs.getInt("status"));
                memberList.add(member);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return memberList;
    }

    @Override
    public List<Member> findByLevel(int level) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Member> memberList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM member WHERE level = ? ORDER BY register_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, level);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Member member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setNickname(rs.getString("nickname"));
                member.setGender(rs.getInt("gender"));
                member.setPhone(rs.getString("phone"));
                member.setQq(rs.getString("qq"));
                member.setWechat(rs.getString("wechat"));
                member.setEmail(rs.getString("email"));
                member.setBalance(rs.getBigDecimal("balance"));
                member.setPoints(rs.getInt("points"));
                member.setLevel(rs.getInt("level"));
                member.setTotalConsumption(rs.getBigDecimal("total_consumption"));
                member.setRegisterTime(rs.getTimestamp("register_time"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setStatus(rs.getInt("status"));
                memberList.add(member);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return memberList;
    }

    @Override
    public List<Member> findByGender(int gender) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Member> memberList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM member WHERE gender = ? ORDER BY register_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, gender);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Member member = new Member();
                member.setMemberId(rs.getInt("member_id"));
                member.setUsername(rs.getString("username"));
                member.setPassword(rs.getString("password"));
                member.setNickname(rs.getString("nickname"));
                member.setGender(rs.getInt("gender"));
                member.setPhone(rs.getString("phone"));
                member.setQq(rs.getString("qq"));
                member.setWechat(rs.getString("wechat"));
                member.setEmail(rs.getString("email"));
                member.setBalance(rs.getBigDecimal("balance"));
                member.setPoints(rs.getInt("points"));
                member.setLevel(rs.getInt("level"));
                member.setTotalConsumption(rs.getBigDecimal("total_consumption"));
                member.setRegisterTime(rs.getTimestamp("register_time"));
                member.setLastLogin(rs.getTimestamp("last_login"));
                member.setStatus(rs.getInt("status"));
                memberList.add(member);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return memberList;
    }

    @Override
    public boolean update(Member member) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE member SET nickname = ?, gender = ?, phone = ?, qq = ?, wechat = ?, email = ?, balance = ?, points = ?, level = ?, total_consumption = ?, status = ? WHERE member_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, member.getNickname());
            pstmt.setInt(2, member.getGender());
            pstmt.setString(3, member.getPhone());
            pstmt.setString(4, member.getQq());
            pstmt.setString(5, member.getWechat());
            pstmt.setString(6, member.getEmail());
            pstmt.setBigDecimal(7, member.getBalance());
            pstmt.setInt(8, member.getPoints());
            pstmt.setInt(9, member.getLevel());
            pstmt.setBigDecimal(10, member.getTotalConsumption());
            pstmt.setInt(11, member.getStatus());
            pstmt.setInt(12, member.getMemberId());

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
    public boolean updateBalance(int memberId, java.math.BigDecimal balance) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE member SET balance = ? WHERE member_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setBigDecimal(1, balance);
            pstmt.setInt(2, memberId);

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
    public boolean updatePoints(int memberId, int points) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE member SET points = ? WHERE member_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, points);
            pstmt.setInt(2, memberId);

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
    public boolean delete(int memberId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE member SET status = 0 WHERE member_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);

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
    public boolean checkUsernameExists(String username) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM member WHERE username = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return false;
    }
}