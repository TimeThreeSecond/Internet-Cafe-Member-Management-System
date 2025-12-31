package com.yourcompany.netbarmanager.service;

import com.yourcompany.netbarmanager.bean.Admin;
import java.util.List;

public interface AdminService {
    Admin login(String username, String password);
    Admin getAdminById(int adminId);
    List<Admin> getAllAdmins();
    boolean updateAdmin(Admin admin);
    boolean updateLastLogin(int adminId);
}