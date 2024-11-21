package com.itbank.finalProject.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SearchHistoryDTO {
    private int id;
    private String keyword;
    private int total_count;
    private Date search_date;
    private Date update_date;
}
