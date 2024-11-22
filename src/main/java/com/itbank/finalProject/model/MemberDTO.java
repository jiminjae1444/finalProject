package com.itbank.finalProject.model;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

//create table member (
//	    id          integer         generated as identity primary key,
//	    userid      varchar2(255)   unique not null,
//	    name        varchar2(50)    not null,
//	    hash        varchar2(255)   not null,
//	    salt        varchar2(255)   not null,
//	    gender      varchar2(10)    check(gender in('M','F')) not null,
//	    location    varchar2(255)   not null,
//	    naver_id    varchar2(255)   unique,
//	    kakao_id    varchar2(255)   unique,
//	    birth       varchar2(255)   check (
//	                                        length (to_char(birth)) = 6
//	                                        and to_number(SUBSTR(TO_CHAR(birth), 3, 2)) BETWEEN 1 AND 12
//	                                        and to_number(SUBSTR(TO_CHAR(birth), 5, 2)) BETWEEN 1 AND 31
//	                                        ),
//	    profile_img varchar2(255)   DEFAULT 'default.png',
//	    profileId   integer         references profile(id),
//	    email       varchar2(255)   not null
//	);

/*@Getter 
@Setter 
@RequiredArgsConstructor*/
@Data
public class MemberDTO {
	
	private int id;
	private String userid;
	private String userpw;
	private String name;
	private String hash;
	private String salt;
	private String gender;
	private String location;
	private String naver_id;
	private String kakao_id;
	private String birth;
	private int profile_id;
	
	private String originalFileName;
	private String storedFileName;
	private String contentType;
	private MultipartFile imgUpload;
	
	private String email;
	
	private int role;
	private String roomUrl;
	
}
