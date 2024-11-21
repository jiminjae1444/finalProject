package com.itbank.finalProject.model;

import java.sql.Date;
import java.util.UUID;

import lombok.Data;

//	create table chat_room (
//	    id           integer         generated as identity primary key,  -- 채팅방 고유 id
//	    room_url     varchar2(255)   unique not null,                    -- 랜덤으로 생성된 채팅방 url
//	    member_id    integer         references member(id),              -- 채팅방을 요청한 사용자 id
//	--    counselor_id integer         references member(id),              -- 연결된 상담사 id (자동응답 시 null)
//	    created_at   date            default sysdate                     -- 채팅방 생성일
//	);

@Data
public class RoomDTO {

	private int id;
	private String room_url;
	private int member_id;
	private Date created_at;
	
	private static RoomDTO create() {
		RoomDTO room = new RoomDTO();
		room.room_url = UUID.randomUUID().toString().substring(0, 20);
		return room;
	}
	
}
