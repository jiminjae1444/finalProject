 package com.itbank.finalProject.controller;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itbank.finalProject.component.MailComponent;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.model.SubLocationDTO;
import com.itbank.finalProject.service.NaverCaptchaService;
import com.itbank.finalProject.service.NaverLoginService;

@RestController
@RequestMapping("/members")
public class MemberAjaxController {
	
	@Autowired private NaverLoginService naverLoginService;
	@Autowired private NaverCaptchaService naverCaptchaService;
	@Autowired private MailComponent mailComponent;
	
	private ObjectMapper objectMapper = new ObjectMapper();
	
	@PostMapping("/naverLogin")
	public String naverLogin(String naver_id, HttpSession session) {
		String form = "{\"success\": %s}";
		MemberDTO login = naverLoginService.selectNaverLogin(naver_id);
		form = String.format(form, login != null);
		session.setAttribute("login", login);
		return form;
	}
	
	@GetMapping(value="/captcha", produces = "application/json; charset=utf-8")
	@ResponseBody
	public HashMap<String, Object> captcha(HttpSession session) throws URISyntaxException, IOException {
	    // 키 발급받기 (세션에 저장)
	    String response = naverCaptchaService.getCaptchakey();
	    
	    JsonNode tree = objectMapper.readTree(response);
	    
	    String captchakey = tree.get("key").asText();
	    
	    // 세션에 저장 시, "captchaKey"라는 일관된 이름을 사용해야 합니다.
	    session.setAttribute("captchaKey", captchakey);

	    // 키를 사용하여 이미지 파일 생성
	    File image = naverCaptchaService.getCaptchaImage(captchakey);

	    // 반환할 JSON 데이터 구성
	    HashMap<String, Object> result = new HashMap<>();
	    result.put("captchaImage", image.getName());
	    return result;
	}

	@PostMapping(value="/captcha", produces = "application/json; charset=utf-8")
	@ResponseBody
	public String captcha(String user, HttpSession session) throws URISyntaxException {
	    // 세션에서 키를 가져올 때도 동일하게 "captchaKey"를 사용해야 합니다.
	    String captchakey = (String) session.getAttribute("captchaKey");
	    // 네이버 API로 캡차 인증 요청을 보내고, 결과를 JSON으로 반환
	    String json = naverCaptchaService.verifyCapcha(captchakey, user);
	    return json;
	}
	
	@GetMapping(value="/idCheck", produces = "application/json; charset=utf-8")
	public HashMap<String, Object> idCheck(String userid) {
		HashMap<String, Object> ret = new HashMap<>();
		int count = naverLoginService.selectCount(userid);
		ret.put("title", "ID 중복 확인 결과");
		ret.put("content", count == 0 ? "사용 가능한 아이디 입니다" : "이미 사용중인 아이디 입니다");
		ret.put("type", count == 0 ? "success" : "error");
		ret.put("success", count == 0 );
		return ret;
	}
	
	   @PostMapping(value="/resetPassword", produces = "application/json; charset=utf-8")
	   @ResponseBody
	   public Map<String, Object> resetPassword(MemberDTO dto) {
	       Map<String, Object> response = new HashMap<>();
	       
	       String password = naverLoginService.newUserPassword(dto);
	       if (password != null) {
	           // 비밀번호 재설정 성공 시
	           String contentForm = String.format("새로운 비밀번호 : [%s]\n\n안내 받은 비밀번호는 개인정보에서 변경 가능합니다.", password);
	           mailComponent.sendMassage(dto.getEmail(), "비밀번호 재발급", contentForm);
	           
	           response.put("success", true);
	           response.put("message", "이메일로 변경된 비밀번호를 전송했습니다.");
	       } else {
	           // 비밀번호 재설정 실패 시
	           response.put("success", false);
	           response.put("message", "일치하는 계정 혹은 이메일을 찾을 수 없습니다.");
	       }
	       
	       return response;
	   }
	   
	    // 일반 로그인
		@PostMapping(value="/login" , produces = "application/json; charset=utf-8")
		public Map<String, String> login(MemberDTO dto, HttpSession session)  {
			Map<String, String> response = new HashMap<>();
			MemberDTO login = naverLoginService.naverSelectLogin(dto);
			
			if (login != null) {
		        session.setAttribute("login", login);
		        response.put("status", "success");
		    } else {
		        response.put("status", "fail");
		        response.put("message", "회원 정보를 다시 확인하세요");
		    }
		    return response;
		}
		
		// 아이디 조회(이메일 입력)
		@PostMapping(value ="/reCheckEmail" , produces = "application/json; charset=utf-8")
		public Map<String, String> reCheckEmail(@RequestParam("userid") String userid) {
		    Map<String, String> response = new HashMap<>();
		    
		    MemberDTO user = naverLoginService.getReCheckEmail(userid);
		    if (user == null) {
		        response.put("status", "fail");
		        response.put("message", "조회 결과 해당 ID와 연결된 E-mail이 없습니다.");
		    } else {
		        response.put("status", "success");
		        response.put("message", "조회 결과 당신의 E-mail는 " + user.getEmail() + "입니다");
		    }
		    return response;
		}
		// 이메일 조회 (아이디를 통한)
		@PostMapping(value ="/reCheckUserid" , produces = "application/json; charset=utf-8")
		public Map<String, String> reCheckUserid(@RequestParam("email") String email) {
		    Map<String, String> response = new HashMap<>();
		    
		    MemberDTO user = naverLoginService.getReCheckUserid(email);
		    if (user == null) {
		        response.put("status", "fail");
		        response.put("message", "조회 결과 해당 E-mail로 등록된 사용자가 없습니다.");
		    } else {
		        response.put("status", "success");
		        response.put("message", "조회 결과 당신의 ID는 " + user.getUserid() + "입니다");
		    }
		    return response;
		}
		// 주소 추가 입력
		@PostMapping(value="/addLocation/{id}" , produces = "application/json; charset=utf-8")
		public Map<String, String> addLocation(@PathVariable int id, SubLocationDTO dto) {
			Map<String, String> response = new HashMap<>();
			
			boolean isDuplicate = naverLoginService.checkDuplicateLocation(dto);
		    if (isDuplicate) {
		        response.put("status", "fail");
		        response.put("message", "이미 동일한 주소가 있습니다. 주소를 다시 확인하여 주세요.");
		    } else {
		    	
		    	int row = naverLoginService.insertAddLocation(dto);
		    	if(row < 0) {
		    		response.put("status", "fail");
		    		response.put("message", "주소 추가시 오류가 발생했습니다.");
		    	} else {
		    		response.put("status", "success");
		    		response.put("message", "정상적으로 주소가 추가되었습니다.");
		    	} 
			}
		    return response;
		}
		// 주소 수정
		@PostMapping(value="/locationUpdate/{id}/{location}" , produces = "application/json; charset=utf-8")
		public int locationUpdate(@PathVariable int id, @PathVariable String location, HttpSession session, Model model) {
		    if(naverLoginService.updateLocation(location, id) == 1) {
		    	MemberDTO dto = (MemberDTO) session.getAttribute("login");
		    	dto.setLocation(location);
		    	session.setAttribute("login", dto);
		    	return 1;
		    }
		    else return 0;
		}

}
