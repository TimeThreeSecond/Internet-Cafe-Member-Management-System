package com.yourcompany.netbarmanager.service;

import com.yourcompany.netbarmanager.bean.Member;
import com.yourcompany.netbarmanager.dao.MemberDAO;
import com.yourcompany.netbarmanager.dao.MemberDAOImpl;
import java.math.BigDecimal;
import java.util.List;

public class MemberServiceImpl implements MemberService {
    private MemberDAO memberDAO = new MemberDAOImpl();

    @Override
    public boolean register(Member member) {
        if (member == null || member.getUsername() == null || member.getPassword() == null) {
            return false;
        }

        if (isUsernameExists(member.getUsername())) {
            return false;
        }

        member.setBalance(new BigDecimal("0.00"));
        member.setPoints(0);
        member.setLevel(1);
        member.setTotalConsumption(new BigDecimal("0.00"));
        member.setStatus(1);

        return memberDAO.register(member);
    }

    @Override
    public Member login(String username, String password) {
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }

        return memberDAO.login(username.trim(), password.trim());
    }

    @Override
    public Member getMemberById(int memberId) {
        return memberDAO.findById(memberId);
    }

    @Override
    public Member getMemberByUsername(String username) {
        return memberDAO.findByUsername(username);
    }

    @Override
    public List<Member> getAllMembers() {
        return memberDAO.findAll();
    }

    @Override
    public List<Member> searchMembers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllMembers();
        }
        return memberDAO.findByKeyword(keyword.trim());
    }

    @Override
    public List<Member> getMembersByLevel(int level) {
        return memberDAO.findByLevel(level);
    }

    @Override
    public List<Member> getMembersByGender(int gender) {
        return memberDAO.findByGender(gender);
    }

    @Override
    public boolean updateMember(Member member) {
        if (member == null || member.getMemberId() <= 0) {
            return false;
        }
        return memberDAO.update(member);
    }

    @Override
    public boolean deductBalance(int memberId, BigDecimal amount) {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        Member member = memberDAO.findById(memberId);
        if (member == null || member.getBalance().compareTo(amount) < 0) {
            return false;
        }

        BigDecimal newBalance = member.getBalance().subtract(amount);
        BigDecimal newConsumption = member.getTotalConsumption().add(amount);

        member.setBalance(newBalance);
        member.setTotalConsumption(newConsumption);

        if (memberDAO.update(member)) {
            int newPoints = member.getPoints() + amount.intValue();
            memberDAO.updatePoints(memberId, newPoints);

            int level = calculateLevel(newPoints);
            member.setLevel(level);
            return memberDAO.update(member);
        }

        return false;
    }

    @Override
    public boolean updatePoints(int memberId, int points) {
        return memberDAO.updatePoints(memberId, points);
    }

    @Override
    public boolean deleteMember(int memberId) {
        return memberDAO.delete(memberId);
    }

    @Override
    public boolean isUsernameExists(String username) {
        return memberDAO.checkUsernameExists(username);
    }

    private int calculateLevel(int points) {
        if (points >= 1000) return 5;
        if (points >= 500) return 4;
        if (points >= 200) return 3;
        if (points >= 50) return 2;
        return 1;
    }
}