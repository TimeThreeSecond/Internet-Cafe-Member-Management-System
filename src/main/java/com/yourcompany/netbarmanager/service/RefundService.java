package com.yourcompany.netbarmanager.service;

import com.yourcompany.netbarmanager.bean.Refund;
import java.util.List;

/**
 * 退费业务逻辑接口
 */
public interface RefundService {

    /**
     * 创建退费申请
     * @param memberId 会员ID
     * @param amount 退费金额
     * @param reason 退费原因
     * @return 是否创建成功
     */
    boolean createRefundRequest(int memberId, java.math.BigDecimal amount, String reason);

    /**
     * 获取所有退费记录
     * @return 退费记录列表
     */
    List<Refund> getAllRefunds();

    /**
     * 根据状态获取退费记录
     * @param status 状态
     * @return 退费记录列表
     */
    List<Refund> getRefundsByStatus(int status);

    /**
     * 获取待审批的退费申请
     * @return 待审批退费列表
     */
    List<Refund> getPendingRefunds();

    /**
     * 根据会员ID获取退费记录
     * @param memberId 会员ID
     * @return 退费记录列表
     */
    List<Refund> getRefundsByMemberId(int memberId);

    /**
     * 根据ID获取退费记录
     * @param refundId 退费ID
     * @return 退费记录对象
     */
    Refund getRefundById(int refundId);

    /**
     * 审批退费申请（通过）
     * @param refundId 退费ID
     * @param operatorId 操作员ID
     * @return 是否审批成功
     */
    boolean approveRefund(int refundId, int operatorId);

    /**
     * 拒绝退费申请
     * @param refundId 退费ID
     * @param operatorId 操作员ID
     * @return 是否拒绝成功
     */
    boolean rejectRefund(int refundId, int operatorId);

    /**
     * 统计指定状态的退费记录数量
     * @param status 状态
     * @return 数量
     */
    int countByStatus(int status);
}
