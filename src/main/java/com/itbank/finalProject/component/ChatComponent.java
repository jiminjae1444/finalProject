package com.itbank.finalProject.component;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import lombok.extern.log4j.Log4j;

@Log4j
public class ChatComponent extends TextWebSocketHandler {

	private List<WebSocketSession> sessionList = new ArrayList<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
//		log.info("연결 생성 : " + session);
		sessionList.add(session);
	}
	
}
