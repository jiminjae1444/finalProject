package com.itbank.finalProject.controller;


import java.security.Principal;
import java.util.Collections;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.itbank.finalProject.model.ChatHistoryDTO;
import com.itbank.finalProject.model.ChatRoomDTO;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.service.ChatService;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class ChatStompController {
	
	@Autowired private SimpMessagingTemplate messagingTemplate;
	@Autowired private ChatService chatService;
	
	
	// 사용자가 상담요청을 보내면 해당 채팅방 정보를 상담원에게 보냄
	@MessageMapping("/joinUser/{roomUrl}")
	public void joinUser(ChatRoomDTO chatRoomDTO, @DestinationVariable String roomUrl) {
//		log.info("사용자가 입장하는 채팅방 : " + chatRoomDTO);
		
		// 사용자와 상담원이 같은 채팅방에 들어갈 수 있도록 메시지 발송 (상담원이 구독하게 되는 채팅방)
		messagingTemplate.convertAndSend("/broker/room/info/" + roomUrl, chatRoomDTO);
	}
	
	// 상담원이 입장했을 때
	@MessageMapping("/joinCounselor/{roomUrl}")
	public void joinCounselor(@DestinationVariable String roomUrl) {
//		log.info("상담원이 입장하는 채팅방 : " + roomUrl);
		
		// 상담원과 사용자 간 웹소켓 연결을 위해 상담원도 같은 채팅방 구독
		messagingTemplate.convertAndSend("/broker/room/notify/" + roomUrl, "상담원과 연결되었습니다.");
	}
	
	
	// 사용자가 상담요청하면 rooms.jsp의 채팅방목록 갱신
	@MessageMapping("/updateRoomList/{roomUrl}")
	public void updateRoomList(ChatRoomDTO chatRoomDTO, @DestinationVariable String roomUrl) {
//		log.info("상담요청 받은 채팅방 정보 : " + chatRoomDTO);
		
		// 채팅방목록 갱신을 위해 rooms.jsp로 채팅방 정보 전송
		messagingTemplate.convertAndSend("/broker/roomList/", chatRoomDTO);
	}
	
	
	// 메시지 전달
	@MessageMapping("/chat/sendMeassge/{roomUrl}")
	public void sendMessage(@DestinationVariable String roomUrl, ChatHistoryDTO message) {
//		log.info("채팅메시지 : " + message);
		
		messagingTemplate.convertAndSend("/broker/room/message/" + roomUrl, message);
	}


	
}








