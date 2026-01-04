package com.yourcompany.netbarmanager.service;

import com.yourcompany.netbarmanager.bean.Member;
import java.util.List;
import java.math.BigDecimal;

public interface MemberService {
    boolean register(Member member);
    Member login(String username, String password);
    Member getMemberById(int memberId);
    Member getMemberByUsername(String username);
    List<Member> getAllMembers();
    List<Member> searchMembers(String keyword);
    List<Member> getMembersByLevel(int level);
    List<Member> getMembersByGender(int gender);
    boolean updateMember(Member member);
    boolean updatePassword(int memberId, String password);
    boolean deductBalance(int memberId, BigDecimal amount);
    boolean updatePoints(int memberId, int points);
    boolean deleteMember(int memberId);
    boolean isUsernameExists(String username);
}