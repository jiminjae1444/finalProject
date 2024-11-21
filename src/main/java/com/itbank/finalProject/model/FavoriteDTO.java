package com.itbank.finalProject.model;

import lombok.Data;

@Data
public class FavoriteDTO {
	private int id;
	private int member_id;
	private int hospital_id;
	private String hospital_name;
	private String address;
	private String tel;
	
}
