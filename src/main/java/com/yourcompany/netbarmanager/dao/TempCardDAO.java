package com.yourcompany.netbarmanager.dao;

import com.yourcompany.netbarmanager.bean.TempCard;
import java.util.List;

public interface TempCardDAO {
    boolean add(TempCard tempCard);
    boolean update(TempCard tempCard);
    boolean delete(String cardId);
    TempCard findById(String cardId);
    List<TempCard> findAll();
    List<TempCard> findByStatus(int status);
}
