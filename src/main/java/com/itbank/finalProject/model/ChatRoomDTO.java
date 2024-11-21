package com.itbank.finalProject.model;


import java.util.Date;

import lombok.Data;

//	create table chat_room (
//	    id           integer         generated as identity primary key,  -- 채팅방 고유 id
//	    room_url     varchar2(255)   unique not null,                    -- 랜덤으로 생성된 채팅방 url
//	    member_id    integer         references member(id),              -- 채팅방을 요청한 사용자 id
//	    counselor_id integer         references member(id),              -- 연결된 상담사 id
//	    created_at   date            default sysdate                     -- 채팅방 생성일
//	);

@Data
public class ChatRoomDTO {

	private int id;
	private String room_url;
	private int member_id;
	private Date created_at;
	
	private String memberUserid;
	private String memberName;
	
}
