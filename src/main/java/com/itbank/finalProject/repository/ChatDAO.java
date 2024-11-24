package com.itbank.finalProject.repository;

import java.util.List;


import com.itbank.finalProject.model.ChatHistoryDTO;
import com.itbank.finalProject.model.ChatRoomDTO;

public interface ChatDAO {

	// DB에서 FAQ 응답 찾아서 반환
	String selectFaqResponse(String contentStr);

	// roomUrl로 chat_room 반환
	ChatRoomDTO getChatRoomByUrl(String roomUrl);

	// DB에 상담내역 저장
	void insertChatHistory(ChatHistoryDTO chatHistoryDTO);

	// roomUrl 받아서 chat_room 생성
	void insertChatRoom(ChatRoomDTO chatRoom);

	// (상담원) 채팅방 목록
	List<ChatRoomDTO> selectChatRoomList();

	// (회원) DB에서 상담내역 불러오기
	List<ChatHistoryDTO> selectChatHistoryList(String roomUrl);

	String getRoomUrlByMemberId(int id);

	// 채팅기록 삭제
	void deleteChatHistory(int roomId);

	// 채팅방 삭제
	void deleteChatRoom(int roomId);




}
