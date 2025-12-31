package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Refund;
import com.yourcompany.netbarmanager.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 退费记录数据访问实现类
 */
public class RefundDAOImpl implements RefundDAO {

    @Override
    public boolean add(Refund refund) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO refund (member_id, amount, reason, status, operator_id, create_time) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, refund.getMemberId());
            pstmt.setBigDecimal(2, refund.getAmount());
            pstmt.setString(3, refund.getReason());
            pstmt.setInt(4, refund.getStatus());
            if (refund.getOperatorId() > 0) {
                pstmt.setInt(5, refund.getOperatorId());
            } else {
                pstmt.setNull(5, Types.INTEGER);
            }
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
    public boolean update(Refund refund) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE refund SET member_id=?, amount=?, reason=?, status=?, operator_id=?, process_time=? WHERE refund_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, refund.getMemberId());
            pstmt.setBigDecimal(2, refund.getAmount());
            pstmt.setString(3, refund.getReason());
            pstmt.setInt(4, refund.getStatus());
            if (refund.getOperatorId() > 0) {
                pstmt.setInt(5, refund.getOperatorId());
            } else {
                pstmt.setNull(5, Types.INTEGER);
            }
            if (refund.getProcessTime() != null) {
                pstmt.setTimestamp(6, new Timestamp(refund.getProcessTime().getTime()));
            } else {
                pstmt.setNull(6, Types.TIMESTAMP);
            }
            pstmt.setInt(7, refund.getRefundId());

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
    public Refund findById(int refundId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Refund refund = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM refund WHERE refund_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, refundId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                refund = extractRefundFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return refund;
    }

    @Override
    public List<Refund> findByMemberId(int memberId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Refund> refundList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM refund WHERE member_id = ? ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                refundList.add(extractRefundFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return refundList;
    }

    @Override
    public List<Refund> findByStatus(int status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Refund> refundList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM refund WHERE status = ? ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                refundList.add(extractRefundFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return refundList;
    }

    @Override
    public List<Refund> findAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Refund> refundList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM refund ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                refundList.add(extractRefundFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return refundList;
    }

    @Override
    public int countByStatus(int status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM refund WHERE status = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return count;
    }

    @Override
    public List<Refund> findPendingRefunds() {
        return findByStatus(0);
    }

    @Override
    public boolean approveRefund(int refundId, int status, int operatorId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE refund SET status = ?, operator_id = ?, process_time = ? WHERE refund_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            pstmt.setInt(2, operatorId);
            pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(4, refundId);

            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
    }

    /**
     * 从ResultSet中提取Refund对象
     */
    private Refund extractRefundFromResultSet(ResultSet rs) throws SQLException {
        Refund refund = new Refund();
        refund.setRefundId(rs.getInt("refund_id"));
        refund.setMemberId(rs.getInt("member_id"));
        refund.setAmount(rs.getBigDecimal("amount"));
        refund.setReason(rs.getString("reason"));
        refund.setStatus(rs.getInt("status"));
        refund.setOperatorId(rs.getInt("operator_id"));
        refund.setCreateTime(rs.getTimestamp("create_time"));
        refund.setProcessTime(rs.getTimestamp("process_time"));
        return refund;
    }
}
