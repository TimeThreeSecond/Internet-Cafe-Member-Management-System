package com.yourcompany.netbarmanager.bean;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * 充值记录实体类
 * 支持会员充值和临时卡充值
 */
public class Recharge {
    private int rechargeId;
    private Integer memberId;
    private String tempCardId;
    private BigDecimal amount;
    private int rechargeType;
    private Integer operatorId;
    private String remark;
    private Timestamp createTime;

    // 关联字段 - 不映射到数据库
    private String memberUsername;
    private String memberNickname;
    private String operatorName;

    public Recharge() {
        this.amount = new BigDecimal("0.00");
        this.rechargeType = 1;
    }

    public int getRechargeId() {
        return rechargeId;
    }

    public void setRechargeId(int rechargeId) {
        this.rechargeId = rechargeId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getTempCardId() {
        return tempCardId;
    }

    public void setTempCardId(String tempCardId) {
        this.tempCardId = tempCardId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public int getRechargeType() {
        return rechargeType;
    }

    public void setRechargeType(int rechargeType) {
        this.rechargeType = rechargeType;
    }

    public Integer getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(Integer operatorId) {
        this.operatorId = operatorId;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
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

    public String getOperatorName() {
        return operatorName;
    }

    public void setOperatorName(String operatorName) {
        this.operatorName = operatorName;
    }

    /**
     * 获取充值类型文本
     * @return 充值类型文本
     */
    public String getRechargeTypeText() {
        switch (rechargeType) {
            case 1: return "现金";
            case 2: return "线上";
            case 3: return "支付宝";
            case 4: return "微信";
            case 5: return "其他";
            default: return "未知";
        }
    }

    /**
     * 获取充值对象类型文本（会员/临时卡）
     * @return 充值对象类型文本
     */
    public String getTargetTypeText() {
        if (memberId != null && memberId > 0) {
            return "会员";
        } else if (tempCardId != null && !tempCardId.isEmpty()) {
            return "临时卡";
        }
        return "未知";
    }
}
