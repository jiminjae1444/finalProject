package com.itbank.finalProject.service;

import com.itbank.finalProject.model.SearchHistoryDTO;
import com.itbank.finalProject.repository.SearchHistoryDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SearchHistoryService {
	
    @Autowired private SearchHistoryDAO searchHistoryDAO;

    public List<SearchHistoryDTO> getRankingList() {
        return searchHistoryDAO.getRankingList();
    }
}
