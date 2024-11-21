package com.itbank.finalProject.model;

import lombok.Data;

//	create table faq (
//	    id          integer         generated as identity primary key,
//	    keyword     varchar2(255)   unique not null,
//	    response    varchar2(2000)  not null
//	);

@Data
public class FaqDTO {

	private int id;
	private String keyword;
	private String response;
	
}
