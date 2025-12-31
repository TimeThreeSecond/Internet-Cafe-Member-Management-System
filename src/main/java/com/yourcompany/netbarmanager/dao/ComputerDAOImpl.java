package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Computer;
import com.yourcompany.netbarmanager.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComputerDAOImpl implements ComputerDAO {

    @Override
    public boolean add(Computer computer) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO computer (computer_no, location, computer_type, hourly_rate, status) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, computer.getComputerNo());
            pstmt.setString(2, computer.getLocation());
            pstmt.setInt(3, computer.getComputerType());
            pstmt.setBigDecimal(4, computer.getHourlyRate());
            pstmt.setInt(5, computer.getStatus());

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
    public boolean update(Computer computer) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE computer SET location = ?, computer_type = ?, hourly_rate = ?, status = ? WHERE computer_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, computer.getLocation());
            pstmt.setInt(2, computer.getComputerType());
            pstmt.setBigDecimal(3, computer.getHourlyRate());
            pstmt.setInt(4, computer.getStatus());
            pstmt.setInt(5, computer.getComputerId());

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
    public boolean delete(int computerId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM computer WHERE computer_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, computerId);

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
    public Computer findById(int computerId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Computer computer = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM computer WHERE computer_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, computerId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                computer = new Computer();
                computer.setComputerId(rs.getInt("computer_id"));
                computer.setComputerNo(rs.getString("computer_no"));
                computer.setLocation(rs.getString("location"));
                computer.setComputerType(rs.getInt("computer_type"));
                computer.setHourlyRate(rs.getBigDecimal("hourly_rate"));
                computer.setStatus(rs.getInt("status"));
                computer.setCreateTime(rs.getTimestamp("create_time"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return computer;
    }

    @Override
    public Computer findByNo(String computerNo) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Computer computer = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM computer WHERE computer_no = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, computerNo);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                computer = new Computer();
                computer.setComputerId(rs.getInt("computer_id"));
                computer.setComputerNo(rs.getString("computer_no"));
                computer.setLocation(rs.getString("location"));
                computer.setComputerType(rs.getInt("computer_type"));
                computer.setHourlyRate(rs.getBigDecimal("hourly_rate"));
                computer.setStatus(rs.getInt("status"));
                computer.setCreateTime(rs.getTimestamp("create_time"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return computer;
    }

    @Override
    public List<Computer> findAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Computer> computerList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM computer ORDER BY computer_no";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Computer computer = new Computer();
                computer.setComputerId(rs.getInt("computer_id"));
                computer.setComputerNo(rs.getString("computer_no"));
                computer.setLocation(rs.getString("location"));
                computer.setComputerType(rs.getInt("computer_type"));
                computer.setHourlyRate(rs.getBigDecimal("hourly_rate"));
                computer.setStatus(rs.getInt("status"));
                computer.setCreateTime(rs.getTimestamp("create_time"));
                computerList.add(computer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return computerList;
    }

    @Override
    public List<Computer> findByStatus(int status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Computer> computerList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM computer WHERE status = ? ORDER BY computer_no";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Computer computer = new Computer();
                computer.setComputerId(rs.getInt("computer_id"));
                computer.setComputerNo(rs.getString("computer_no"));
                computer.setLocation(rs.getString("location"));
                computer.setComputerType(rs.getInt("computer_type"));
                computer.setHourlyRate(rs.getBigDecimal("hourly_rate"));
                computer.setStatus(rs.getInt("status"));
                computer.setCreateTime(rs.getTimestamp("create_time"));
                computerList.add(computer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return computerList;
    }

    @Override
    public List<Computer> findByType(int type) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Computer> computerList = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM computer WHERE computer_type = ? ORDER BY computer_no";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, type);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Computer computer = new Computer();
                computer.setComputerId(rs.getInt("computer_id"));
                computer.setComputerNo(rs.getString("computer_no"));
                computer.setLocation(rs.getString("location"));
                computer.setComputerType(rs.getInt("computer_type"));
                computer.setHourlyRate(rs.getBigDecimal("hourly_rate"));
                computer.setStatus(rs.getInt("status"));
                computer.setCreateTime(rs.getTimestamp("create_time"));
                computerList.add(computer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }

        return computerList;
    }

    @Override
    public boolean updateStatus(int computerId, int status) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE computer SET status = ? WHERE computer_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
            pstmt.setInt(2, computerId);

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