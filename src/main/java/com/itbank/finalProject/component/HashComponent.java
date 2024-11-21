package com.itbank.finalProject.component;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import org.springframework.stereotype.Component;

@Component
public class HashComponent {
	
	private SecureRandom secureRandom = new SecureRandom();
	private MessageDigest md;
	
	public HashComponent() {
		try {
			md = MessageDigest.getInstance("SHA-512");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
	}

	public String getRandomSalt() {	// 8글자
		// 8자리 솔트, 16진수로 8자리
		// 10진수로는 2^32 (int 의 크기와 동일하다)
		int num = secureRandom.nextInt();
		String salt = String.format("%08x", num);
		return salt;
	}

	public String getHash(String salt, String userpw) {
		// 솔트와 비밀번호(평문)을 전달받아서 해시를 생성하고 반환한다
		md.reset();
		md.update((salt + userpw).getBytes());
		String hash = String.format("%0128x", new BigInteger(1, md.digest()));
		return hash;
	}

}
