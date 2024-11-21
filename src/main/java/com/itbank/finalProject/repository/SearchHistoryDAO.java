package com.itbank.finalProject.repository;

import com.itbank.finalProject.model.SearchHistoryDTO;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SearchHistoryDAO {
    List<SearchHistoryDTO> getRankingList();
}
