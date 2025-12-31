package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Computer;
import java.util.List;

public interface ComputerDAO {
    boolean add(Computer computer);
    boolean update(Computer computer);
    boolean delete(int computerId);
    Computer findById(int computerId);
    Computer findByNo(String computerNo);
    List<Computer> findAll();
    List<Computer> findByStatus(int status);
    List<Computer> findByType(int type);
    boolean updateStatus(int computerId, int status);
}