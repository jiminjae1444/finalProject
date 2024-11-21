package com.itbank.finalProject.repository;

import com.itbank.finalProject.model.HospitalTimeDTO;
import org.springframework.stereotype.Repository;

@Repository
public interface HospitalTimeDAO {
    HospitalTimeDTO getTime(int id);
}
