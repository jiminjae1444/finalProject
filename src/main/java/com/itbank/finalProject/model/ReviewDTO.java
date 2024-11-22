package com.itbank.finalProject.model;

import java.sql.Date;

import lombok.Data;

//	create table review (
//	    id              integer         generated as identity primary key,
//	    hospital_id     integer         references hospital(id),
//	    member_id       integer         references member(id) not null,
//	    rating          number          check (rating >= 0 and rating <= 5),
//	    comments        varchar(1000)	,
//	    created_at      date	        default current_timestamp
//	);


@Data
public class ReviewDTO {

	private int id;
	private int hospital_id;
	private int member_id;
	private double rating;
	private String comments;
	private Date created_at;
	
	private String userid;
	private String profile_img;
	
	private String hospital_name;
	
	
	
	
	
}
