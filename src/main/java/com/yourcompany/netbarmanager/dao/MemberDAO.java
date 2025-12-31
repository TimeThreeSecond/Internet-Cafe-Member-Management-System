package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.Member;
import java.util.List;
import java.math.BigDecimal;

public interface MemberDAO {
    boolean register(Member member);
    Member login(String username, String password);
    Member findById(int memberId);
    Member findByUsername(String username);
    List<Member> findAll();
    List<Member> findByKeyword(String keyword);
    List<Member> findByLevel(int level);
    List<Member> findByGender(int gender);
    boolean update(Member member);
    boolean updateBalance(int memberId, BigDecimal balance);
    boolean updatePoints(int memberId, int points);
    boolean delete(int memberId);
    boolean checkUsernameExists(String username);
}