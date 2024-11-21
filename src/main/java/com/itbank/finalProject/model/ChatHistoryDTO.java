package com.itbank.finalProject.model;


import java.util.Date;

import jakarta.annotation.Nullable;
import lombok.Data;

//	create table chat_history (
//	    id          integer         generated as identity primary key,
//	    room_id     integer         references chat_room(id) not null,  -- 상담 기록을 불러올 때 필요
//	    sender_id   integer         references member(id),
//	    content     varchar2(2000)  ,                                   -- 사용자와 상담사의 메시지 내용
//	    chat_time   date            default sysdate
//	);


@Data
public class ChatHistoryDTO {

	private int id;
	private int room_id;
	private int sender_id;
	private String content;
	private Date chat_time;
	
	private String room_url;
	private String autoResponse;
	private String messageFilterId;
	
}
