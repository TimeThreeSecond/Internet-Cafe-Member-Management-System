package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Consumption;
import java.util.List;

public interface ConsumptionDAO {
    boolean add(Consumption consumption);
    boolean update(Consumption consumption);
    Consumption findById(int consumptionId);
    List<Consumption> findAll();
    List<Consumption> findByMemberId(int memberId);
    List<Consumption> findByComputerId(int computerId);
    List<Consumption> findActiveSessions(); // 获取所有进行中的上机记录
    List<Consumption> findRecentSessions(int limit); // 获取最近的上机记录
    boolean updateEndTime(int consumptionId, java.sql.Timestamp endTime, int duration, java.math.BigDecimal amount);
}
