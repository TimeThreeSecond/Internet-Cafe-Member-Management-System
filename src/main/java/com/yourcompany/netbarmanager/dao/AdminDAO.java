package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Admin;
import java.util.List;

public interface AdminDAO {
    Admin login(String username, String password);
    Admin findById(int adminId);
    List<Admin> findAll();
    boolean update(Admin admin);
    boolean updateLastLogin(int adminId);
}