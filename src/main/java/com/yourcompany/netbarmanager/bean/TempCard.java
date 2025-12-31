package com.yourcompany.netbarmanager.bean;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class TempCard {
    private String cardId;
    private BigDecimal balance;
    private BigDecimal deposit;
    private Timestamp createTime;
    private int status;

    public TempCard() {
        this.balance = new BigDecimal("0.00");
        this.deposit = new BigDecimal("10.00");
        this.status = 1;
    }

    public String getCardId() {
        return cardId;
    }

    public void setCardId(String cardId) {
        this.cardId = cardId;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getStatusText() {
        switch (status) {
            case 0: return "已退还";
            case 1: return "正常";
            default: return "未知";
        }
    }

    public BigDecimal getTotalAmount() {
        return balance.add(deposit);
    }
}