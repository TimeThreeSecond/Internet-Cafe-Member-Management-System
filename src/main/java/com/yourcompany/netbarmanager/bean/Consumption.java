package com.yourcompany.netbarmanager.bean;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Consumption {
    private int consumptionId;
    private int memberId;
    private int computerId;
    private Timestamp startTime;
    private Timestamp endTime;
    private int duration;
    private BigDecimal amount;
    private int consumptionType;
    private Timestamp createTime;

    private String memberUsername;
    private String memberNickname;
    private String computerNo;
    private String computerLocation;

    public Consumption() {
        this.amount = new BigDecimal("0.00");
        this.consumptionType = 1;
    }

    public int getConsumptionId() {
        return consumptionId;
    }

    public void setConsumptionId(int consumptionId) {
        this.consumptionId = consumptionId;
    }

    public int getMemberId() {
        return memberId;
    }

    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

    public int getComputerId() {
        return computerId;
    }

    public void setComputerId(int computerId) {
        this.computerId = computerId;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public int getConsumptionType() {
        return consumptionType;
    }

    public void setConsumptionType(int consumptionType) {
        this.consumptionType = consumptionType;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public String getMemberUsername() {
        return memberUsername;
    }

    public void setMemberUsername(String memberUsername) {
        this.memberUsername = memberUsername;
    }

    public String getMemberNickname() {
        return memberNickname;
    }

    public void setMemberNickname(String memberNickname) {
        this.memberNickname = memberNickname;
    }

    public String getComputerNo() {
        return computerNo;
    }

    public void setComputerNo(String computerNo) {
        this.computerNo = computerNo;
    }

    public String getComputerLocation() {
        return computerLocation;
    }

    public void setComputerLocation(String computerLocation) {
        this.computerLocation = computerLocation;
    }

    public String getConsumptionTypeText() {
        switch (consumptionType) {
            case 1: return "上机";
            case 2: return "包房";
            case 3: return "商品";
            default: return "其他";
        }
    }
}