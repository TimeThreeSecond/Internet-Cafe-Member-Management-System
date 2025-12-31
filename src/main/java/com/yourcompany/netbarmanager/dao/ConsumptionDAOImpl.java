package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Consumption;
import com.yourcompany.netbarmanager.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsumptionDAOImpl implements ConsumptionDAO {

    @Override
    public boolean add(Consumption consumption) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO consumption (member_id, computer_id, start_time, consumption_type) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, consumption.getMemberId());
            pstmt.setInt(2, consumption.getComputerId());
            pstmt.setTimestamp(3, consumption.getStartTime());
            pstmt.setInt(4, consumption.getConsumptionType());

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
    public boolean update(Consumption consumption) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE consumption SET member_id = ?, computer_id = ?, start_time = ?, end_time = ?, duration = ?, amount = ?, consumption_type = ? WHERE consumption_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, consumption.getMemberId());
            pstmt.setInt(2, consumption.getComputerId());
            pstmt.setTimestamp(3, consumption.getStartTime());
            pstmt.setTimestamp(4, consumption.getEndTime());
            pstmt.setInt(5, consumption.getDuration());
            pstmt.setBigDecimal(6, consumption.getAmount());
            pstmt.setInt(7, consumption.getConsumptionType());
            pstmt.setInt(8, consumption.getConsumptionId());

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
    public Consumption findById(int consumptionId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Consumption consumption = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT c.*, m.username as member_username, m.nickname as member_nick, " +
                       "comp.computer_no, comp.location as computer_location " +
                       "FROM consumption c " +
                       "LEFT JOIN member m ON c.member_id = m.member_id " +
                       "LEFT JOIN computer comp ON c.computer_id = comp.computer_id " +
                       "WHERE c.consumption_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, consumptionId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                consumption = mapResultSetToConsumption(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return consumption;
    }

    @Override
    public List<Consumption> findAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Consumption> consumptionList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT c.*, m.username as member_username, m.nickname as member_nick, " +
                       "comp.computer_no, comp.location as computer_location " +
                       "FROM consumption c " +
                       "LEFT JOIN member m ON c.member_id = m.member_id " +
                       "LEFT JOIN computer comp ON c.computer_id = comp.computer_id " +
                       "ORDER BY c.start_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                consumptionList.add(mapResultSetToConsumption(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return consumptionList;
    }

    @Override
    public List<Consumption> findByMemberId(int memberId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Consumption> consumptionList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT c.*, m.username as member_username, m.nickname as member_nick, " +
                       "comp.computer_no, comp.location as computer_location " +
                       "FROM consumption c " +
                       "LEFT JOIN member m ON c.member_id = m.member_id " +
                       "LEFT JOIN computer comp ON c.computer_id = comp.computer_id " +
                       "WHERE c.member_id = ? " +
                       "ORDER BY c.start_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                consumptionList.add(mapResultSetToConsumption(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return consumptionList;
    }

    @Override
    public List<Consumption> findByComputerId(int computerId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Consumption> consumptionList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT c.*, m.username as member_username, m.nickname as member_nick, " +
                       "comp.computer_no, comp.location as computer_location " +
                       "FROM consumption c " +
                       "LEFT JOIN member m ON c.member_id = m.member_id " +
                       "LEFT JOIN computer comp ON c.computer_id = comp.computer_id " +
                       "WHERE c.computer_id = ? " +
                       "ORDER BY c.start_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, computerId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                consumptionList.add(mapResultSetToConsumption(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return consumptionList;
    }

    @Override
    public List<Consumption> findActiveSessions() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Consumption> consumptionList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT c.*, m.username as member_username, m.nickname as member_nick, " +
                       "comp.computer_no, comp.location as computer_location " +
                       "FROM consumption c " +
                       "LEFT JOIN member m ON c.member_id = m.member_id " +
                       "LEFT JOIN computer comp ON c.computer_id = comp.computer_id " +
                       "WHERE c.end_time IS NULL " +
                       "ORDER BY c.start_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                consumptionList.add(mapResultSetToConsumption(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return consumptionList;
    }

    @Override
    public List<Consumption> findRecentSessions(int limit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Consumption> consumptionList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT c.*, m.username as member_username, m.nickname as member_nick, " +
                       "comp.computer_no, comp.location as computer_location " +
                       "FROM consumption c " +
                       "LEFT JOIN member m ON c.member_id = m.member_id " +
                       "LEFT JOIN computer comp ON c.computer_id = comp.computer_id " +
                       "ORDER BY c.start_time DESC " +
                       "LIMIT ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                consumptionList.add(mapResultSetToConsumption(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return consumptionList;
    }

    @Override
    public boolean updateEndTime(int consumptionId, Timestamp endTime, int duration, java.math.BigDecimal amount) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE consumption SET end_time = ?, duration = ?, amount = ? WHERE consumption_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setTimestamp(1, endTime);
            pstmt.setInt(2, duration);
            pstmt.setBigDecimal(3, amount);
            pstmt.setInt(4, consumptionId);

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    private Consumption mapResultSetToConsumption(ResultSet rs) throws SQLException {
        Consumption consumption = new Consumption();
        consumption.setConsumptionId(rs.getInt("consumption_id"));
        consumption.setMemberId(rs.getInt("member_id"));
        consumption.setComputerId(rs.getInt("computer_id"));
        consumption.setStartTime(rs.getTimestamp("start_time"));
        consumption.setEndTime(rs.getTimestamp("end_time"));
        consumption.setDuration(rs.getInt("duration"));
        consumption.setAmount(rs.getBigDecimal("amount"));
        consumption.setConsumptionType(rs.getInt("consumption_type"));
        consumption.setCreateTime(rs.getTimestamp("create_time"));
        consumption.setMemberUsername(rs.getString("member_username"));
        consumption.setMemberNickname(rs.getString("member_nick"));
        consumption.setComputerNo(rs.getString("computer_no"));
        consumption.setComputerLocation(rs.getString("computer_location"));
        return consumption;
    }
}
