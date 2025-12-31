package com.yourcompany.netbarmanager.bean;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Computer {
    private int computerId;
    private String computerNo;
    private String location;
    private int computerType;
    private BigDecimal hourlyRate;
    private int status;
    private Timestamp createTime;

    public Computer() {
        this.hourlyRate = new BigDecimal("5.00");
        this.status = 0;
        this.computerType = 1;
    }

    public int getComputerId() {
        return computerId;
    }

    public void setComputerId(int computerId) {
        this.computerId = computerId;
    }

    public String getComputerNo() {
        return computerNo;
    }

    public void setComputerNo(String computerNo) {
        this.computerNo = computerNo;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getComputerType() {
        return computerType;
    }

    public void setComputerType(int computerType) {
        this.computerType = computerType;
    }

    public BigDecimal getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(BigDecimal hourlyRate) {
        this.hourlyRate = hourlyRate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public String getStatusText() {
        switch (status) {
            case 0: return "空闲";
            case 1: return "使用中";
            case 2: return "维护中";
            default: return "未知";
        }
    }

    public String getComputerTypeText() {
        switch (computerType) {
            case 1: return "普通";
            case 2: return "包房";
            default: return "未知";
        }
    }
}