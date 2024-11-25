package com.itbank.finalProject.service;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class NaverCaptchaService {
	
	private String clientId = "mHWAzHvCNQgc7mFSG8sN";
	private String clientSecret = "H6s74E3Trm";
	private String saveDirectory = "D:\\fpupload\\captcha";
	private RestTemplate restTemplate = new RestTemplate();

	public NaverCaptchaService() {
		File dir = new File(saveDirectory);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
	}
	
	public String getCaptchakey() throws URISyntaxException {
		String url = "https://openapi.naver.com/v1/captcha/nkey?code=0";
		URI uri = new URI(url);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("X-Naver-Client-Id", clientId);
		headers.set("X-Naver-Client-Secret", clientSecret);
		
		RequestEntity<String> request = new RequestEntity<String>(headers, HttpMethod.GET, uri);
		ResponseEntity<String> response = restTemplate.exchange(request, String.class);
		
		String body = response.getBody();
		return body;
	}

	public File getCaptchaImage(String captchakey) throws URISyntaxException, IOException {
		String fileName = UUID.randomUUID().toString().replace("-", "") + ".jpg";
		File f = new File(saveDirectory, fileName);
		
		String url = "https://openapi.naver.com/v1/captcha/ncaptcha.bin?key=" + captchakey;
		URI uri = new URI(url);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("X-Naver-Client-Id", clientId);
		headers.set("X-Naver-Client-Secret", clientSecret);
		
		RequestEntity<String> request = new RequestEntity<String>(headers, HttpMethod.GET, uri);
		ResponseEntity<byte[]> response = restTemplate.exchange(request, byte[].class);
		byte[] arr = response.getBody();
		
		Files.write(Paths.get(f.getAbsolutePath()), arr);
		return f;
	}

	public String verifyCapcha(String key, String value) throws URISyntaxException {
		String url = "https://openapi.naver.com/v1/captcha/nkey?code=1&key=" + key + "&value=" + value;
		URI uri = new URI(url);
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("X-Naver-Client-Id", clientId);
		headers.set("X-Naver-Client-Secret", clientSecret);
		
		RequestEntity<String> request = new RequestEntity<String>(headers, HttpMethod.GET, uri);
		ResponseEntity<String> response = restTemplate.exchange(request, String.class);
		return response.getBody();
	}

}
