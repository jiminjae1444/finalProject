package com.itbank.finalProject.model;


import java.sql.Date;

import lombok.Data;

@Data
public class NotificationDTO {
	private int id;
	private int member_id;
	private int booking_id;
	private String message;
	private int read;
	private Date sent_time;
	private String hospital_name;
	private Date booking_date;
	private String name;
	private String email;
	
}
