package com.yourcompany.netbarmanager.service;

import com.yourcompany.netbarmanager.bean.Admin;
import com.yourcompany.netbarmanager.dao.AdminDAO;
import com.yourcompany.netbarmanager.dao.AdminDAOImpl;
import java.util.List;

public class AdminServiceImpl implements AdminService {
    private AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    public Admin login(String username, String password) {
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }

        Admin admin = adminDAO.login(username.trim(), password.trim());
        if (admin != null) {
            adminDAO.updateLastLogin(admin.getAdminId());
        }
        return admin;
    }

    @Override
    public Admin getAdminById(int adminId) {
        return adminDAO.findById(adminId);
    }

    @Override
    public List<Admin> getAllAdmins() {
        return adminDAO.findAll();
    }

    @Override
    public boolean updateAdmin(Admin admin) {
        if (admin == null || admin.getAdminId() <= 0) {
            return false;
        }
        return adminDAO.update(admin);
    }

    @Override
    public boolean updateLastLogin(int adminId) {
        return adminDAO.updateLastLogin(adminId);
    }
}