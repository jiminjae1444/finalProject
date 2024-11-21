package com.itbank.finalProject.service;

import com.itbank.finalProject.model.HospitalTimeDTO;
import com.itbank.finalProject.repository.HospitalTimeDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class HospitalTimeService {

    @Autowired
    HospitalTimeDAO hospitalTimeDAO;

    public HospitalTimeDTO getTime(int id) {
        return hospitalTimeDAO.getTime(id);
    }
}
