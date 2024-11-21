package com.itbank.finalProject.component;

import java.io.IOException;
import java.util.Properties;
import java.util.Scanner;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

@Component
public class NotificationMailComponent {
	@Value("classpath:mailAccount.txt")
	private Resource account;

	private final String host = "smtp.naver.com";
	private final int port = 465;
	private String serverId;
	private String serverPw;
	
	private Properties props;
	
	public NotificationMailComponent() {
		init();
	}
	public void init() {
		props = new Properties();
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", port);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.enable", "true");
		props.put("mail.smtp.ssl.trust", host);
	}
	
	public int sendNotificationMail(String address, String title, String content) {
		// 받는사람의 주소, 제목, 내용을 매개변수로 받는다
		
		// 0) 메일 서버에 접속하기 위한 계정정보를 불러온다
		System.out.println("account : " + account);
		try {
			Scanner sc = new Scanner(account.getFile());
			for(int i = 0; sc.hasNextLine(); i++) {
				if(i == 0) serverId = sc.nextLine();
				if(i == 1) serverPw = sc.nextLine();
			}
			sc.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		// 1) 메일 서버 인증 (로그인)
		Session mailSession = Session.getDefaultInstance(props, new Authenticator() {
			String un = serverId;
			String pw = serverPw;
			
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(un, pw);
			}
		});
		mailSession.setDebug(true); 	// 메일 전송과정을 로그로 출력하게 설정한다
		
		// 2) 보낼 메시지 작성
		Message message = new MimeMessage(mailSession);
		try {
			message.setFrom(new InternetAddress(serverId + "@naver.com"));	// 보내는 사람
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(address)); // 받는 사람
			message.setSubject(title);	// 제목
			message.setText(content);		// 내용
			Transport.send(message);	// 보내기
			return 1;					// 성공하면 1을 반환
			
		} catch(MessagingException e) {		// 예외가 발생하면
			e.printStackTrace();			// 예외 스택을 출력하고
			return 0;						// 0을 반환
		}
	}
	
//	public static void main(String[] args) {
//		MailComponent instance = new MailComponent();
//		instance.sendSimpleMessage("wonkey1222@naver.com", "제목", "내용");
//	}
}
