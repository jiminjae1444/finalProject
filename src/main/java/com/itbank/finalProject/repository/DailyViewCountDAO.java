package com.itbank.finalProject.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.itbank.finalProject.model.DailyViewCountDTO;

@Repository
public interface DailyViewCountDAO {

    List<DailyViewCountDTO> getViewCount(int id);
}
