package com.itbank.finalProject.model;

import java.sql.Date;

import lombok.Data;


@Data
public class BookingDTO {
	private int id;
	private int member_id;
	private int hospital_id;
	private Date booking_date;
	private Date booked_at;
	private String status;

	private String hospital_name;
	private String address;
	
}
