package com.itbank.finalProject.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class ChatConfig implements WebSocketMessageBrokerConfigurer {

	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) {
		
		// @MessageMapping 어노테이션을 연결하는 주소의 접두사
		registry.setApplicationDestinationPrefixes("/app");
		
		// 구독 설정 및 메시지 수신 중개하는 브로커의 주소
		registry.enableSimpleBroker("/broker");
	}
	
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/counselChatConnection")
				.setAllowedOriginPatterns("*")
				.withSockJS();
		
		registry.addEndpoint("/chatRoomListReload")		// 웹소켓 최초 접속 주소
				.setAllowedOriginPatterns("*")	// 모든 주소로부터의 접근 허용
				.withSockJS();					// sockJS 를 함께 사용한다
	}
	
}
