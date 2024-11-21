package com.itbank.finalProject.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DailyViewCountDTO {
    private int id;
    private int view_count;
    private int hospital_id;
    private Date view_date;
}
