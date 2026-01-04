package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Recharge;
import com.yourcompany.netbarmanager.util.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 充值记录数据访问实现类
 */
public class RechargeDAOImpl implements RechargeDAO {

    @Override
    public boolean add(Recharge recharge) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO recharge (member_id, amount, recharge_type, operator_id, remark, create_time) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            if (recharge.getMemberId() != null && recharge.getMemberId() > 0) {
                pstmt.setInt(1, recharge.getMemberId());
            } else {
                pstmt.setNull(1, Types.INTEGER);
            }

            pstmt.setBigDecimal(2, recharge.getAmount());
            pstmt.setInt(3, recharge.getRechargeType());

            if (recharge.getOperatorId() != null && recharge.getOperatorId() > 0) {
                pstmt.setInt(4, recharge.getOperatorId());
            } else {
                pstmt.setNull(4, Types.INTEGER);
            }

            pstmt.setString(5, recharge.getRemark());
            pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));

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
    public boolean addTempCardRecharge(String tempCardId, BigDecimal amount, int rechargeType, String remark) {
        // 临时卡充值，在remark中记录卡号
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO recharge (member_id, amount, recharge_type, operator_id, remark, create_time) VALUES (NULL, ?, ?, NULL, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setBigDecimal(1, amount);
            pstmt.setInt(2, rechargeType);
            pstmt.setString(3, "临时卡[" + tempCardId + "] " + (remark != null ? remark : ""));
            pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));

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
    public boolean update(Recharge recharge) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE recharge SET member_id=?, amount=?, recharge_type=?, operator_id=?, remark=? WHERE recharge_id=?";
            pstmt = conn.prepareStatement(sql);

            if (recharge.getMemberId() != null && recharge.getMemberId() > 0) {
                pstmt.setInt(1, recharge.getMemberId());
            } else {
                pstmt.setNull(1, Types.INTEGER);
            }

            pstmt.setBigDecimal(2, recharge.getAmount());
            pstmt.setInt(3, recharge.getRechargeType());

            if (recharge.getOperatorId() != null && recharge.getOperatorId() > 0) {
                pstmt.setInt(4, recharge.getOperatorId());
            } else {
                pstmt.setNull(4, Types.INTEGER);
            }

            pstmt.setString(5, recharge.getRemark());
            pstmt.setInt(6, recharge.getRechargeId());

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
    public Recharge findById(int rechargeId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Recharge recharge = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM recharge WHERE recharge_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, rechargeId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                recharge = extractRechargeFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return recharge;
    }

    @Override
    public List<Recharge> findByMemberId(int memberId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Recharge> rechargeList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM recharge WHERE member_id = ? ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                rechargeList.add(extractRechargeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return rechargeList;
    }

    @Override
    public List<Recharge> findByTempCardId(String tempCardId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Recharge> rechargeList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            // 通过remark字段查找临时卡充值记录
            String sql = "SELECT * FROM recharge WHERE remark LIKE ? ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "临时卡[" + tempCardId + "]%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                rechargeList.add(extractRechargeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return rechargeList;
    }

    @Override
    public List<Recharge> findAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Recharge> rechargeList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM recharge ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                rechargeList.add(extractRechargeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return rechargeList;
    }

    @Override
    public List<Recharge> findRecent(int limit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Recharge> rechargeList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM recharge ORDER BY create_time DESC LIMIT ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                rechargeList.add(extractRechargeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return rechargeList;
    }

    @Override
    public BigDecimal getTotalAmountByMemberId(int memberId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BigDecimal total = BigDecimal.ZERO;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COALESCE(SUM(amount), 0) as total FROM recharge WHERE member_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                total = rs.getBigDecimal("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return total;
    }

    @Override
    public BigDecimal getTotalAmountByDateRange(String startDate, String endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BigDecimal total = BigDecimal.ZERO;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COALESCE(SUM(amount), 0) as total FROM recharge WHERE create_time BETWEEN ? AND ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, startDate);
            pstmt.setString(2, endDate);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                total = rs.getBigDecimal("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return total;
    }

    @Override
    public BigDecimal getTodayTotalAmount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BigDecimal total = BigDecimal.ZERO;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COALESCE(SUM(amount), 0) as total FROM recharge WHERE DATE(create_time) = CURDATE()";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                total = rs.getBigDecimal("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return total;
    }

    @Override
    public BigDecimal getMonthTotalAmount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BigDecimal total = BigDecimal.ZERO;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COALESCE(SUM(amount), 0) as total FROM recharge WHERE YEAR(create_time) = YEAR(CURDATE()) AND MONTH(create_time) = MONTH(CURDATE())";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                total = rs.getBigDecimal("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return total;
    }

    /**
     * 从ResultSet中提取Recharge对象
     */
    private Recharge extractRechargeFromResultSet(ResultSet rs) throws SQLException {
        Recharge recharge = new Recharge();
        recharge.setRechargeId(rs.getInt("recharge_id"));

        int memberId = rs.getInt("member_id");
        if (!rs.wasNull()) {
            recharge.setMemberId(memberId);
        }

        recharge.setAmount(rs.getBigDecimal("amount"));
        recharge.setRechargeType(rs.getInt("recharge_type"));

        int operatorId = rs.getInt("operator_id");
        if (!rs.wasNull()) {
            recharge.setOperatorId(operatorId);
        }

        String remark = rs.getString("remark");
        recharge.setRemark(remark);

        // 从remark中解析临时卡号（格式：临时卡[TEMP001] 备注）
        if (remark != null && remark.startsWith("临时卡[")) {
            int endIndex = remark.indexOf("]");
            if (endIndex > 4) {
                String cardId = remark.substring(4, endIndex);
                recharge.setTempCardId(cardId);
            }
        }

        recharge.setCreateTime(rs.getTimestamp("create_time"));
        return recharge;
    }
}
