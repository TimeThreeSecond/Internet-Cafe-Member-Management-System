package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Recharge;

import java.math.BigDecimal;
import java.util.List;

/**
 * 充值记录数据访问接口
 */
public interface RechargeDAO {

    /**
     * 添加充值记录（会员充值）
     * @param recharge 充值记录对象
     * @return 是否添加成功
     */
    boolean add(Recharge recharge);

    /**
     * 添加充值记录（临时卡充值）
     * @param tempCardId 临时卡ID
     * @param amount 充值金额
     * @param rechargeType 充值类型
     * @param remark 备注
     * @return 是否添加成功
     */
    boolean addTempCardRecharge(String tempCardId, BigDecimal amount, int rechargeType, String remark);

    /**
     * 更新充值记录
     * @param recharge 充值记录对象
     * @return 是否更新成功
     */
    boolean update(Recharge recharge);

    /**
     * 根据ID查找充值记录
     * @param rechargeId 充值ID
     * @return 充值记录对象
     */
    Recharge findById(int rechargeId);

    /**
     * 根据会员ID查找充值记录
     * @param memberId 会员ID
     * @return 充值记录列表
     */
    List<Recharge> findByMemberId(int memberId);

    /**
     * 根据临时卡ID查找充值记录
     * @param tempCardId 临时卡ID
     * @return 充值记录列表
     */
    List<Recharge> findByTempCardId(String tempCardId);

    /**
     * 查找所有充值记录
     * @return 充值记录列表
     */
    List<Recharge> findAll();

    /**
     * 查找最近的充值记录
     * @param limit 限制数量
     * @return 充值记录列表
     */
    List<Recharge> findRecent(int limit);

    /**
     * 统计会员总充值金额
     * @param memberId 会员ID
     * @return 总充值金额
     */
    BigDecimal getTotalAmountByMemberId(int memberId);

    /**
     * 统计指定日期范围内的充值总额
     * @param startDate 开始日期（yyyy-MM-dd HH:mm:ss）
     * @param endDate 结束日期（yyyy-MM-dd HH:mm:ss）
     * @return 充值总额
     */
    BigDecimal getTotalAmountByDateRange(String startDate, String endDate);

    /**
     * 统计今日充值总额
     * @return 今日充值总额
     */
    BigDecimal getTodayTotalAmount();

    /**
     * 统计本月充值总额
     * @return 本月充值总额
     */
    BigDecimal getMonthTotalAmount();
}
