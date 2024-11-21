package com.itbank.finalProject.model;

import lombok.Data;

//ID	NUMBER(38,0)
//ORIGINALFILENAME	VARCHAR2(255 BYTE)
//STOREDFILENAME	VARCHAR2(255 BYTE)
//CONTENTTYPE	VARCHAR2(255 BYTE)

@Data	// lombok maven디펜던시를 추가시 적용할 수 있는 어노테이션이다.
public class ProfileDTO {
	
	private int id;
	private String originalFileName;
	private String storedFileName;
	private String contentType;
	

}
