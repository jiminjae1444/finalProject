package com.itbank.finalProject.service;

import com.itbank.finalProject.model.DailyViewCountDTO;
import com.itbank.finalProject.repository.DailyViewCountDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DailyViewCountService {

    @Autowired
    private DailyViewCountDAO dailyViewCountDAO;

    public List<DailyViewCountDTO> getViewCount(int id) {
        return dailyViewCountDAO.getViewCount(id);
    }
}
