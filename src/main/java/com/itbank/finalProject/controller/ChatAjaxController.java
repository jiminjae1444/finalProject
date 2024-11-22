package com.itbank.finalProject.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.itbank.finalProject.model.ChatHistoryDTO;
import com.itbank.finalProject.model.ChatRoomDTO;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.repository.ChatDAO;
import com.itbank.finalProject.service.ChatService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/chats")
@Log4j
public class ChatAjaxController {
	
	@Autowired private ChatService chatService;
	
	
	// (상담원) 채팅방 목록 불러오기
	@GetMapping(value ="/roomList", produces = "application/json; charset=utf-8")
	public List<ChatRoomDTO> selectChatRoomList(HttpSession session) {
		return chatService.selectChatRoomList(session);
	}
	
	
	// 1:1 상담요청
	@GetMapping(value ="/counsel/{roomUrl}", produces = "application/json; charset=utf-8")
	public ChatRoomDTO startCounselChat(@PathVariable String roomUrl, HttpSession session, Model model) {
		MemberDTO login = (MemberDTO) session.getAttribute("login");
//		String storedroomUrl = (String) session.getAttribute("roomUrl");
		ChatRoomDTO chatRoom = new ChatRoomDTO();
		
		ChatRoomDTO guestChatRoom = (ChatRoomDTO) session.getAttribute("guestChatRoom");
//	    log.info("guestChatRoom : " + guestChatRoom);
		
		if(login != null) {	// 회원
			String loginRoomUrl = chatService.getRoomUrlByMemberId(login.getId());
			if(loginRoomUrl != null) {	// 채팅방이 있으면
				roomUrl = loginRoomUrl;
				chatRoom = chatService.getChatRoomByUrl(roomUrl);
			}
			else {	// 채팅방이 없으면
				login.setRoomUrl(roomUrl);
				chatRoom.setRoom_url(roomUrl);
				chatRoom.setMember_id(login.getId());
				chatRoom.setCreated_at(new Date());
				chatRoom.setMemberUserid(login.getUserid());
				chatRoom.setMemberName(login.getName());
				chatService.insertChatRoom(chatRoom);
			}
			login.setRoomUrl(roomUrl);
		}
	    else {  // 비회원
	        chatRoom = chatService.addGuestChatRoomToSession(session, roomUrl);
	    }
		session.setAttribute("roomUrl", roomUrl);
		model.addAttribute("chatMode", "counsel");
		return chatRoom;
	}
	
	
	// chat_room 읽음여부 수정
	@GetMapping("/room/isRead/{roomUrl}")
	public int switchChatRoomIsRead(@PathVariable String roomUrl, HttpSession session) {
		MemberDTO login = (MemberDTO) session.getAttribute("login");
		int row = 0;
		if(login != null && chatService.getChatRoomByUrl(roomUrl) != null) {
			row = chatService.updateChatRoomIsRead(roomUrl);
		}
		log.info("is_read 수정 : " + row);
		return row;
	}
	

	
	// header에서 채팅방 입장
	@GetMapping("/room")
	public String enterChatRoom(HttpSession session) {
		MemberDTO login = (MemberDTO) session.getAttribute("login");
		String faqRoomUrl = (String) session.getAttribute("roomUrl");
//		log.info("세션에 저장돼있는 roomUrl : " + faqRoomUrl);
		String roomUrl = "";
		
		if(login == null) {		// 비회원
			if(faqRoomUrl == null) {
				roomUrl = chatService.createRoomUrl();
			}
			else {
				roomUrl = faqRoomUrl;
			}
		}
		else {	// 회원
			roomUrl = chatService.getRoomUrlByMemberId(login.getId());
			if(roomUrl == null) {
				roomUrl = chatService.createRoomUrl();
			}
		}
		session.setAttribute("roomUrl", roomUrl);
		return roomUrl;
	}
	
	
	// FAQ 메시지 전송
	@PostMapping(value ="/faqChat", produces = "application/json; charset=utf-8")
	public ChatHistoryDTO sendFaqMessage(HttpSession session, ChatHistoryDTO content) {
	    ChatHistoryDTO chatHistoryDTO = new ChatHistoryDTO();
	    
	    chatHistoryDTO = chatService.addFaqMessage(session, content);
	    return chatHistoryDTO;
	}
	
	// 1:1 상담 메시지 저장
	@PostMapping(value ="/counselChat/{roomUrl}", produces = "application/json; charset=utf-8")
	public void sendCounselMessage(@RequestBody ChatHistoryDTO content, HttpSession session, @PathVariable String roomUrl) {
	    MemberDTO login = (MemberDTO) session.getAttribute("login");
	    
	    // 회원이랑 상담할 때 (로그인 되어있고 / 상담원이거나 roomUrl이랑 같은 채팅방이 DB에 있는 회원이면)
	    if(login != null && ((login.getRole() != 1 && chatService.getRoomUrlByMemberId(content.getSender_id()) == roomUrl)
	    		|| (login.getRole() == 1 && chatService.getChatRoomByUrl(roomUrl) != null))) {
    		chatService.saveChatMessage(session, login, roomUrl, content);	// DB에 저장
	    }
	    else { // 비회원이랑 상담할 때
	        chatService.addGuestChatMessage(session, roomUrl, content);	// 세션에 저장
	    }
	}
	
	
	// 채팅내역이 있으면 chatHistoryList 불러오기
	@GetMapping(value ="/history/{roomUrl}", produces = "application/json; charset=utf-8")
	public List<ChatHistoryDTO> selectChatHistoryList(HttpSession session, @PathVariable String roomUrl) {
//		log.info("faqHistoryList : " + session.getAttribute("faqHistoryList"));
		List<ChatHistoryDTO> chatHistoryList = new ArrayList<>();
		List<ChatHistoryDTO> faqHistoryList = (List<ChatHistoryDTO>) session.getAttribute("faqHistoryList");
		List<ChatHistoryDTO> guestChatHistoryList = (List<ChatHistoryDTO>) session.getAttribute("guestChatHistoryList");
		MemberDTO login = (MemberDTO) session.getAttribute("login");
		
		log.info("guestChatHistoryList : " + guestChatHistoryList);
		if(guestChatHistoryList != null && guestChatHistoryList.size() > 0) {
			chatHistoryList = guestChatHistoryList;
		}
		else if(faqHistoryList != null && faqHistoryList.size() > 0) {
			chatHistoryList = faqHistoryList;
		}
		else if(login != null) {
			chatHistoryList = chatService.selectChatHistoryList(roomUrl);
		}
		log.info("chatHistoryList : " + chatHistoryList);
		return chatHistoryList;
	}
	
	
	// FAQ 채팅내역 없애기 (세션 만료)
	@PostMapping("/removeFaqHistory")
	public void chatRoomOut(HttpSession session) {
//		session.removeAttribute("roomUrl");
		session.removeAttribute("faqHistoryList");
	}
	
	
}





