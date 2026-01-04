package com.yourcompany.netbarmanager.service;

import com.yourcompany.netbarmanager.bean.Recharge;

import java.math.BigDecimal;
import java.util.List;

/**
 * 充值服务接口
 */
public interface RechargeService {

    /**
     * 会员充值
     * @param memberId 会员ID
     * @param amount 充值金额
     * @param rechargeType 充值类型（1-现金 2-线上 3-支付宝 4-微信 5-其他）
     * @param operatorId 操作员ID（线上充值时为null）
     * @param remark 备注
     * @return 是否充值成功
     */
    boolean memberRecharge(int memberId, BigDecimal amount, int rechargeType, Integer operatorId, String remark);

    /**
     * 临时卡充值
     * @param tempCardId 临时卡ID
     * @param amount 充值金额
     * @param rechargeType 充值类型
     * @param remark 备注
     * @return 是否充值成功
     */
    boolean tempCardRecharge(String tempCardId, BigDecimal amount, int rechargeType, String remark);

    /**
     * 获取会员充值记录
     * @param memberId 会员ID
     * @return 充值记录列表
     */
    List<Recharge> getRechargesByMemberId(int memberId);

    /**
     * 获取临时卡充值记录
     * @param tempCardId 临时卡ID
     * @return 充值记录列表
     */
    List<Recharge> getRechargesByTempCardId(String tempCardId);

    /**
     * 获取最近的充值记录
     * @param limit 限制数量
     * @return 充值记录列表
     */
    List<Recharge> getRecentRecharges(int limit);

    /**
     * 获取所有充值记录
     * @return 充值记录列表
     */
    List<Recharge> getAllRecharges();

    /**
     * 统计会员总充值金额
     * @param memberId 会员ID
     * @return 总充值金额
     */
    BigDecimal getTotalRechargeByMemberId(int memberId);

    /**
     * 获取今日充值总额
     * @return 今日充值总额
     */
    BigDecimal getTodayTotalAmount();

    /**
     * 获取本月充值总额
     * @return 本月充值总额
     */
    BigDecimal getMonthTotalAmount();

    /**
     * 根据ID获取充值记录
     * @param rechargeId 充值ID
     * @return 充值记录
     */
    Recharge getRechargeById(int rechargeId);
}
