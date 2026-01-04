package com.yourcompany.netbarmanager.service;

import com.yourcompany.netbarmanager.bean.Recharge;
import com.yourcompany.netbarmanager.dao.MemberDAO;
import com.yourcompany.netbarmanager.dao.MemberDAOImpl;
import com.yourcompany.netbarmanager.dao.RechargeDAO;
import com.yourcompany.netbarmanager.dao.RechargeDAOImpl;
import com.yourcompany.netbarmanager.dao.TempCardDAO;
import com.yourcompany.netbarmanager.dao.TempCardDAOImpl;
import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.bean.TempCard;

import java.math.BigDecimal;
import java.util.List;

/**
 * 充值服务实现类
 */
public class RechargeServiceImpl implements RechargeService {

    private RechargeDAO rechargeDAO = new RechargeDAOImpl();
    private MemberDAO memberDAO = new MemberDAOImpl();
    private TempCardDAO tempCardDAO = new TempCardDAOImpl();

    @Override
    public boolean memberRecharge(int memberId, BigDecimal amount, int rechargeType, Integer operatorId, String remark) {
        // 验证金额
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        // 获取会员信息
        Member member = memberDAO.findById(memberId);
        if (member == null) {
            return false;
        }

        // 更新会员余额
        BigDecimal newBalance = member.getBalance().add(amount);
        boolean updateSuccess = memberDAO.updateBalance(memberId, newBalance);

        if (!updateSuccess) {
            return false;
        }

        // 增加积分（1元=1积分）
        int newPoints = member.getPoints() + amount.intValue();
        memberDAO.updatePoints(memberId, newPoints);

        // 记录充值流水
        Recharge recharge = new Recharge();
        recharge.setMemberId(memberId);
        recharge.setAmount(amount);
        recharge.setRechargeType(rechargeType);
        recharge.setOperatorId(operatorId);
        recharge.setRemark(remark);

        return rechargeDAO.add(recharge);
    }

    @Override
    public boolean tempCardRecharge(String tempCardId, BigDecimal amount, int rechargeType, String remark) {
        // 验证金额
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        // 获取临时卡信息
        TempCard tempCard = tempCardDAO.findById(tempCardId);
        if (tempCard == null) {
            return false;
        }

        // 更新临时卡余额
        BigDecimal newBalance = tempCard.getBalance().add(amount);
        boolean updateSuccess = tempCardDAO.updateBalance(tempCardId, newBalance);

        if (!updateSuccess) {
            return false;
        }

        // 记录充值流水
        return rechargeDAO.addTempCardRecharge(tempCardId, amount, rechargeType, remark);
    }

    @Override
    public List<Recharge> getRechargesByMemberId(int memberId) {
        List<Recharge> recharges = rechargeDAO.findByMemberId(memberId);
        // 附加会员信息
        Member member = memberDAO.findById(memberId);
        if (member != null) {
            for (Recharge r : recharges) {
                r.setMemberUsername(member.getUsername());
                r.setMemberNickname(member.getNickname());
            }
        }
        return recharges;
    }

    @Override
    public List<Recharge> getRechargesByTempCardId(String tempCardId) {
        return rechargeDAO.findByTempCardId(tempCardId);
    }

    @Override
    public List<Recharge> getRecentRecharges(int limit) {
        List<Recharge> recharges = rechargeDAO.findRecent(limit);
        // 附加会员/操作员信息
        for (Recharge r : recharges) {
            if (r.getMemberId() != null && r.getMemberId() > 0) {
                Member member = memberDAO.findById(r.getMemberId());
                if (member != null) {
                    r.setMemberUsername(member.getUsername());
                    r.setMemberNickname(member.getNickname());
                }
            }
        }
        return recharges;
    }

    @Override
    public List<Recharge> getAllRecharges() {
        return rechargeDAO.findAll();
    }

    @Override
    public BigDecimal getTotalRechargeByMemberId(int memberId) {
        return rechargeDAO.getTotalAmountByMemberId(memberId);
    }

    @Override
    public BigDecimal getTodayTotalAmount() {
        return rechargeDAO.getTodayTotalAmount();
    }

    @Override
    public BigDecimal getMonthTotalAmount() {
        return rechargeDAO.getMonthTotalAmount();
    }

    @Override
    public Recharge getRechargeById(int rechargeId) {
        return rechargeDAO.findById(rechargeId);
    }
}
