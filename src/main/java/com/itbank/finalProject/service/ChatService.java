package com.itbank.finalProject.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.finalProject.model.ChatHistoryDTO;
import com.itbank.finalProject.model.ChatRoomDTO;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.repository.ChatDAO;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ChatService {
	
	@Autowired private ChatDAO chatDAO;


	
	// 채팅방 목록 불러오기
	public List<ChatRoomDTO> selectChatRoomList(HttpSession session) {
		List<ChatRoomDTO> chatRoomList = new ArrayList<>();
		
		// 회원) DB 채팅방 목록
		List<ChatRoomDTO> memberChatRoomList = chatDAO.selectChatRoomList();
		chatRoomList.addAll(memberChatRoomList);
		
		// 비회원) 세션 채팅방 목록
		List<ChatRoomDTO> guestChatRoomList = (List<ChatRoomDTO>) session.getAttribute("guestChatRoomList");
		if(guestChatRoomList != null) {
			chatRoomList.addAll(guestChatRoomList);
		}
		return chatRoomList;
	}	
	
//	public List<HashMap<String, Object>> selectChatRoomList(HttpSession session) {
//		List<HashMap<String, Object>> chatRoomList = new ArrayList<>();
//		
//		// 회원) DB 채팅방 목록
//		List<ChatRoomDTO> memberChatRooms = chatDAO.selectChatRoomList();
//		for(ChatRoomDTO memberChatRoom : memberChatRooms) {
//			HashMap<String, Object> chatRoom = new HashMap<>();
//			chatRoom.put("id", memberChatRoom.getId());
//			chatRoom.put("room_url", memberChatRoom.getRoom_url());
//			chatRoom.put("memberName", memberChatRoom.getMemberName());
//			chatRoom.put("memberUserid", memberChatRoom.getMemberUserid());
//			chatRoom.put("created_at", memberChatRoom.getCreated_at());
//			chatRoomList.add(chatRoom);
//		}
//		
//		// 비회원) 세션 채팅방 목록
//		List<HashMap<String, Object>> guestChatRooms = (List<HashMap<String,Object>>) session.getAttribute("guestChatRoomList");
//		if(guestChatRooms != null) {
//			chatRoomList.addAll(guestChatRooms);
//		}
//		return chatRoomList;
//	}	
		
	    
	// 비회원의 상담 채팅방을 만들고 세션에 저장
	public ChatRoomDTO addGuestChatRoomToSession(HttpSession session, String roomUrl) {
		ChatRoomDTO guestChatRoom = (ChatRoomDTO) session.getAttribute("guestChatRoom");
		ChatRoomDTO guestChatRoomDTO = new ChatRoomDTO();
		String guestId = generateGuestId();
		
		if(guestChatRoom == null) {
			guestChatRoomDTO.setRoom_url(roomUrl);
			guestChatRoomDTO.setMemberName("guest" + guestId);
			guestChatRoomDTO.setMemberUserid("게스트" + guestId);
			guestChatRoomDTO.setCreated_at(new Date());
			session.setAttribute("guestId", "guest" + guestId);
			session.setAttribute("guestChatRoom", guestChatRoomDTO);
			return guestChatRoomDTO;
		}
		return guestChatRoom;
	}
	

	// 채팅방 URL 생성
	public String createRoomUrl() {
		return UUID.randomUUID().toString().replace("-", "");
	}

	// 회원) roomUrl을 이용해서 chat_room 가져오기
	public ChatRoomDTO getChatRoomByUrl(String roomUrl) {
		ChatRoomDTO chatRoom = chatDAO.getChatRoomByUrl(roomUrl);
		return chatRoom;
	}
	
	// 비회원) roomUrl을 이용해서 chat_room 가져오기
	public ChatRoomDTO getGuestChatRoomByUrl(HttpSession session, String roomUrl) {
		List<HashMap<String, Object>> guestChatRoomList = (List<HashMap<String, Object>>) session.getAttribute("guestChatRoomList");
		ChatRoomDTO chatRoom = new ChatRoomDTO();
		
		for(HashMap<String, Object> guestChatRoom : guestChatRoomList) {
			if(roomUrl.equals(guestChatRoom.get("roomUrl"))) {
				chatRoom.setRoom_url(roomUrl);
				chatRoom.setMemberUserid((String) guestChatRoom.get("memberUserid"));
				chatRoom.setMemberName((String) guestChatRoom.get("memberName"));
				chatRoom.setCreated_at((Date) guestChatRoom.get("createdAt"));
				break;
			}
		}
		return chatRoom;
	}

	// FAQ) DB에서 자동응답 찾아오기
	public String getAutoResponse(ChatHistoryDTO content) {
		String autoResponse = "";
		if (content.getContent() != null && !content.getContent().trim().isEmpty()) { // 문의 내역이 null이나 빈문자열이 아니면 자동응답
																						// 키워드 검색
			String contentStr = content.getContent().replace(" ", ""); // 사용자의 문의 메시지의 띄어쓰기 제거 (키워드와 일치하는 응답을 찾기 위함)
			autoResponse = (String) chatDAO.selectFaqResponse(contentStr);
			if (autoResponse != null && autoResponse != "") { // 일치하는 키워드를 찾았으면
				return autoResponse; // 해당 응답 반환
			} else { // 못 찾았으면
				autoResponse = "해당 질문에 대한 정보를 찾을 수 없습니다. 원하시는 답변을 찾지 못했다면, 상담원에게 문의해 주세요.";
			}
		} else { // 문의 메시지가 null/빈문자열이면
			autoResponse = "문의하실 내용을 다시 입력해 주세요";
		}
		return autoResponse;
	}



	// 만들어진 roomUrl을 받아서 DB의 chat_room에 데이터 추가
	public void insertChatRoom(ChatRoomDTO chatRoom) {
		chatDAO.insertChatRoom(chatRoom);
	}

	
	// 회원) DB에서 상담내역 불러오기
	public List<ChatHistoryDTO> selectChatHistoryList(String roomUrl) {
		return chatDAO.selectChatHistoryList(roomUrl);
	}
	
	
	
	// 비회원이 상담요청할 때 6자리 랜덤 문자열
	public String generateGuestId() {
		return UUID.randomUUID().toString().replace("-", "").substring(0, 6);
	}

	
	// (회원, 비회원) FAQ 메시지 세션에 저장 
	public ChatHistoryDTO addFaqMessage(HttpSession session, ChatHistoryDTO content) {
		ChatHistoryDTO chatHistoryDTO = new ChatHistoryDTO();
		List<ChatHistoryDTO> faqHistoryList = (List<ChatHistoryDTO>) session.getAttribute("faqHistoryList");
		if(faqHistoryList == null) {
			faqHistoryList = new ArrayList<>();
		}
		chatHistoryDTO.setContent(content.getContent());
		chatHistoryDTO.setAutoResponse(getAutoResponse(content));
		chatHistoryDTO.setChat_time(new Date());
		faqHistoryList.add(chatHistoryDTO);
		session.setAttribute("faqHistoryList", faqHistoryList);
		return chatHistoryDTO;
	}

	// 회원이랑) 1:1 상담채팅 메시지 처리
	public void saveChatMessage(HttpSession session, MemberDTO login, String roomUrl, ChatHistoryDTO content) {
		ChatHistoryDTO chatHistoryDTO = new ChatHistoryDTO();
		
		chatHistoryDTO.setRoom_id(getChatRoomByUrl(roomUrl).getId());
		chatHistoryDTO.setSender_id(content.getSender_id());
		chatHistoryDTO.setContent(content.getContent());
		chatHistoryDTO.setRoom_url(roomUrl);
		chatHistoryDTO.setChat_time(content.getChat_time());
		log.info("chatHistoryDTO : " + chatHistoryDTO);
		chatDAO.insertChatHistory(chatHistoryDTO);	// chat_history를 DB에 저장
	}
	
	// 비회원이랑) 1:1 상담채팅 메시지 세션에 저장
	public void addGuestChatMessage(HttpSession session, String roomUrl, ChatHistoryDTO content) {
		ChatHistoryDTO guestChatHistoryDTO = new ChatHistoryDTO();
	    List<ChatHistoryDTO> guestChatHistoryList = (List<ChatHistoryDTO>) session.getAttribute("guestChatHistoryList");
	    if(guestChatHistoryList == null) {
	    	guestChatHistoryList = new ArrayList<>();
	    }
	    
	    guestChatHistoryDTO.setSender_id(content.getSender_id());
	    guestChatHistoryDTO.setRoom_url(roomUrl);
	    guestChatHistoryDTO.setContent(content.getContent());
	    guestChatHistoryDTO.setChat_time(content.getChat_time());
	    
//	    log.info("guestChatHistoryDTO : " + guestChatHistoryDTO);
	    
	    guestChatHistoryList.add(guestChatHistoryDTO);
	    log.info("guestChatHistoryList : " + guestChatHistoryList);
        session.setAttribute("guestChatHistoryList", guestChatHistoryList);
	}


	public String getRoomUrlByMemberId(int id) {
		return chatDAO.getRoomUrlByMemberId(id);
	}

	
	// chat_room 읽음여부 수정
	public int updateChatRoomIsRead(String roomUrl) {
		int row = chatDAO.updateChatRoomIsRead(roomUrl);
		return row;
	}









	


	

}





