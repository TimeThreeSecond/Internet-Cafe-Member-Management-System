package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.TempCard;
import com.yourcompany.netbarmanager.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TempCardDAOImpl implements TempCardDAO {

    @Override
    public boolean add(TempCard tempCard) {
        String sql = "INSERT INTO temp_card (card_id, balance, deposit, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, tempCard.getCardId());
            pstmt.setBigDecimal(2, tempCard.getBalance());
            pstmt.setBigDecimal(3, tempCard.getDeposit());
            pstmt.setInt(4, tempCard.getStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(TempCard tempCard) {
        String sql = "UPDATE temp_card SET balance = ?, deposit = ?, status = ? WHERE card_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBigDecimal(1, tempCard.getBalance());
            pstmt.setBigDecimal(2, tempCard.getDeposit());
            pstmt.setInt(3, tempCard.getStatus());
            pstmt.setString(4, tempCard.getCardId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean delete(String cardId) {
        String sql = "DELETE FROM temp_card WHERE card_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, cardId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public TempCard findById(String cardId) {
        String sql = "SELECT * FROM temp_card WHERE card_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, cardId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractTempCard(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<TempCard> findAll() {
        List<TempCard> list = new ArrayList<>();
        String sql = "SELECT * FROM temp_card ORDER BY create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extractTempCard(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<TempCard> findByStatus(int status) {
        List<TempCard> list = new ArrayList<>();
        String sql = "SELECT * FROM temp_card WHERE status = ? ORDER BY create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, status);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extractTempCard(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private TempCard extractTempCard(ResultSet rs) throws SQLException {
        TempCard tempCard = new TempCard();
        tempCard.setCardId(rs.getString("card_id"));
        tempCard.setBalance(rs.getBigDecimal("balance"));
        tempCard.setDeposit(rs.getBigDecimal("deposit"));
        tempCard.setCreateTime(rs.getTimestamp("create_time"));
        tempCard.setStatus(rs.getInt("status"));
        return tempCard;
    }
}
