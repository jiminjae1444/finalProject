package com.itbank.finalProject.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itbank.finalProject.model.MemberDTO;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/chat")
@Log4j
public class ChatController {
	

	// 챗봇방으로 입장
	@GetMapping("/room/{roomUrl}")
	public String enterChatRoom() {
		return "/chat/room";
	}
	
	// 1:1 상담톡방으로 입장
	@GetMapping("/counselRoom/{clickRoomUrl}")
	public String enterCounselChatRoom(@PathVariable("clickRoomUrl") String clickRoomUrl, Model model) {
		model.addAttribute("clickRoomUrl", clickRoomUrl);
		return "/chat/room";
	}
	
	
	// (상담원) 채팅목록
	@GetMapping("/rooms")
	public String enterRooms() {
		return "/chat/rooms";
	}

	
	
	
}




