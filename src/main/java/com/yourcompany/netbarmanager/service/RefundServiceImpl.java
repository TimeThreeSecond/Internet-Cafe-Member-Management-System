package com.yourcompany.netbarmanager.service;

import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.bean.Refund;
import com.yourcompany.netbarmanager.dao.MemberDAO;
import com.yourcompany.netbarmanager.dao.MemberDAOImpl;
import com.yourcompany.netbarmanager.dao.RefundDAO;
import com.yourcompany.netbarmanager.dao.RefundDAOImpl;
import java.math.BigDecimal;
import java.util.List;

/**
 * 退费业务逻辑实现类
 */
public class RefundServiceImpl implements RefundService {

    private RefundDAO refundDAO = new RefundDAOImpl();
    private MemberDAO memberDAO = new MemberDAOImpl();

    @Override
    public boolean createRefundRequest(int memberId, BigDecimal amount, String reason) {
        // 验证会员是否存在
        Member member = memberDAO.findById(memberId);
        if (member == null) {
            return false;
        }

        // 验证退费金额不能超过余额
        if (amount.compareTo(member.getBalance()) > 0) {
            return false;
        }

        // 验证退费金额必须大于0
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        // 创建退费申请
        Refund refund = new Refund();
        refund.setMemberId(memberId);
        refund.setAmount(amount);
        refund.setReason(reason);
        refund.setStatus(0); // 待审批状态
        refund.setOperatorId(0);

        return refundDAO.add(refund);
    }

    @Override
    public List<Refund> getAllRefunds() {
        return refundDAO.findAll();
    }

    @Override
    public List<Refund> getRefundsByStatus(int status) {
        return refundDAO.findByStatus(status);
    }

    @Override
    public List<Refund> getPendingRefunds() {
        return refundDAO.findPendingRefunds();
    }

    @Override
    public List<Refund> getRefundsByMemberId(int memberId) {
        return refundDAO.findByMemberId(memberId);
    }

    @Override
    public Refund getRefundById(int refundId) {
        return refundDAO.findById(refundId);
    }

    @Override
    public boolean approveRefund(int refundId, int operatorId) {
        // 获取退费记录
        Refund refund = refundDAO.findById(refundId);
        if (refund == null || refund.getStatus() != 0) {
            return false; // 记录不存在或已处理
        }

        // 获取会员信息
        Member member = memberDAO.findById(refund.getMemberId());
        if (member == null) {
            return false;
        }

        // 验证余额是否足够
        if (member.getBalance().compareTo(refund.getAmount()) < 0) {
            return false; // 余额不足
        }

        // 从会员余额中扣除退费金额（退款到会员账户，实际是减少余额）
        BigDecimal newBalance = member.getBalance().subtract(refund.getAmount());
        member.setBalance(newBalance);

        // 更新会员余额
        if (!memberDAO.update(member)) {
            return false;
        }

        // 更新退费记录状态为已通过
        return refundDAO.approveRefund(refundId, 1, operatorId);
    }

    @Override
    public boolean rejectRefund(int refundId, int operatorId) {
        // 获取退费记录
        Refund refund = refundDAO.findById(refundId);
        if (refund == null || refund.getStatus() != 0) {
            return false; // 记录不存在或已处理
        }

        // 更新退费记录状态为已拒绝
        return refundDAO.approveRefund(refundId, 2, operatorId);
    }

    @Override
    public int countByStatus(int status) {
        return refundDAO.countByStatus(status);
    }
}
