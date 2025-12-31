package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Refund;
import java.util.List;

/**
 * 退费记录数据访问接口
 */
public interface RefundDAO {

    /**
     * 添加退费申请
     * @param refund 退费记录对象
     * @return 是否添加成功
     */
    boolean add(Refund refund);

    /**
     * 更新退费记录
     * @param refund 退费记录对象
     * @return 是否更新成功
     */
    boolean update(Refund refund);

    /**
     * 根据ID查找退费记录
     * @param refundId 退费ID
     * @return 退费记录对象
     */
    Refund findById(int refundId);

    /**
     * 根据会员ID查找退费记录
     * @param memberId 会员ID
     * @return 退费记录列表
     */
    List<Refund> findByMemberId(int memberId);

    /**
     * 根据状态查找退费记录
     * @param status 状态（0-待审批 1-已通过 2-已拒绝）
     * @return 退费记录列表
     */
    List<Refund> findByStatus(int status);

    /**
     * 查找所有退费记录
     * @return 退费记录列表
     */
    List<Refund> findAll();

    /**
     * 统计指定状态的退费记录数量
     * @param status 状态
     * @return 数量
     */
    int countByStatus(int status);

    /**
     * 获取待审批的退费申请列表
     * @return 待审批退费列表
     */
    List<Refund> findPendingRefunds();

    /**
     * 审批退费申请
     * @param refundId 退费ID
     * @param status 审批状态（1-通过 2-拒绝）
     * @param operatorId 操作员ID
     * @return 是否操作成功
     */
    boolean approveRefund(int refundId, int status, int operatorId);
}
