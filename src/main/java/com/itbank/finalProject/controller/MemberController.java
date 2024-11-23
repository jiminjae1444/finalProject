package com.itbank.finalProject.controller;

import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itbank.finalProject.component.NaverLoginComponent;
import com.itbank.finalProject.model.BookingDTO;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.model.SubLocationDTO;
import com.itbank.finalProject.service.NaverLoginService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/member")
public class MemberController {
	
	@Autowired NaverLoginComponent naverLoginComponent;
	@Autowired NaverLoginService naverLoginService;
	
	private ObjectMapper objectMapper = new ObjectMapper();
	
	@GetMapping("/join")
	public void join(Model model) {
		String naverLoginURL = naverLoginComponent.getAuthorizationUrl();
		System.out.println(naverLoginURL);
		model.addAttribute("naverLoginURL", naverLoginURL);
	}
	
	@PostMapping("/join")
	public String join(MemberDTO dto, RedirectAttributes rttr) {
		// 회원가입 처리
		int row = naverLoginService.naverJoin(dto);
		
		// 결과 메시지 설정
		rttr.addFlashAttribute("message", row != 0 ? "회원 가입 성공" : "회원 가입 실패");
		return "redirect:/member/login";
	}
	
	// 네이버 로그인
	   @GetMapping("/login")
	   public void login(Model model, @RequestParam(value = "redirectUrl", defaultValue = "") String redirectUrl) {
	      String naverLoginURL = naverLoginComponent.getAuthorizationUrl();
	      model.addAttribute("redirectUrl", redirectUrl);
	      model.addAttribute("naverLoginURL", naverLoginURL);
	   }
	
	@GetMapping("/naverCallback")
	public void naverCallback(String code, String state, Model model) throws JsonMappingException, JsonProcessingException, URISyntaxException {
		String accessToken = naverLoginComponent.getAccessToken(code, state);
		accessToken = objectMapper.readTree(accessToken).get("access_token").asText();
		String userProfile = naverLoginComponent.getProfile(accessToken);
		model.addAttribute("userProfile", userProfile);
	}
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	@PostMapping("birth")
	public String birth(@RequestParam String birth, Model model) {
		if(birth.length() != 6) {
			model.addAttribute("birthMessage", "생년 월일 6자리를 입력해주세요.");
			return "redirect:/member/join";
		}
		model.addAttribute("birthMessage", "정상적으로 정보가 등록되었습니다. 회원가입을 계속 진행해주세요.");
		return "redirect:/member/join";
	}
	
	@GetMapping("/resetPassword")
	public void resetPassword() {}
	
	
	@GetMapping("/info/{memberId}")
	public String info(@PathVariable int memberId, HttpSession session) {
		List<SubLocationDTO> list = naverLoginService.getAddLocationList(memberId);
		session.setAttribute("list", list);
		return "/member/info";
	}
	
	@PostMapping("/imgUpdate/{id}")
	public String imgUpdate(@PathVariable int id, MemberDTO dto, HttpSession session, RedirectAttributes redirectAttributes) {
	    try {
	        String storedFileName = naverLoginService.imgUpload(dto);
	        MemberDTO login = (MemberDTO) session.getAttribute("login");
	        login.setStoredFileName(storedFileName);
	        session.setAttribute("login", login);

	        // 성공 메시지 설정
	        redirectAttributes.addFlashAttribute("message", "프로필 이미지가 성공적으로 변경되었습니다!");
	    } catch (Exception e) {
	        // 실패 메시지 설정
	        redirectAttributes.addFlashAttribute("error", "이미지 업로드 중 오류가 발생했습니다.");
	    }
	    return "redirect:/member/info/" + id;
	}
	
	// 주소 수정 
	@GetMapping("/locationUpdate/{id}")
	public String locationUpdate(@PathVariable int id) {
		return "/member/locationUpdate";
	}

	
	@GetMapping("/pwUpdate/{id}")
	public String pwUpdate(@PathVariable int id) {
		return "/member/pwUpdate";
	}
	
	@PostMapping("/pwUpdate/{id}")
	public String pwUpdate(@PathVariable int id, @RequestParam("currentPw") String currentPw, @RequestParam("newPw") String newPw, RedirectAttributes rttr, HttpSession session) {
	    MemberDTO userInfo = naverLoginService.getUserByUserPw(currentPw, id);
	    if (userInfo != null) {
	        userInfo.setUserpw(newPw);
	        int row = naverLoginService.updatePw(userInfo);
	        if (row > 0) {
	            session.invalidate();
	            rttr.addFlashAttribute("message2", "비밀번호가 성공적으로 변경되었습니다.\\n새로운 비밀번호로 재로그인 부탁드립니다.");
	        }
	    }
	    rttr.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
	    return "redirect:/member/pwUpdate/" + id;
	}
	
	// 이메일 조회 (아이디를 통한)
	@GetMapping("/reCheckUserid")
	public String reCheckUserid() {
		return "member/reCheckUserid";
	}
	
	// 아이디 조회(이메일을 통한)
	@GetMapping("/reCheckEmail")
	public String reCheckEmail() {
		return "member/reCheckEmail";
	}	
	
	@GetMapping("/bookingList/{id}")
	public String bookingList(@PathVariable int id, Model model) {
		List<BookingDTO> list = naverLoginService.getMemberByBookingList(id);
		log.info(list);
		model.addAttribute("list", list);
	    return "member/bookingList";
	}
	
	// 주소 추가
	@GetMapping("/addLocation/{id}")
	public String addLocation(@PathVariable int id, Model model) {
		List<SubLocationDTO> list = naverLoginService.getAddLocationList(id);
		model.addAttribute("list", list);
		return "member/addLocation";
	}
	
	@PostMapping("/deleteLocation/{id}/{locationId}")	// 식별해야하는 값이 많으면 변수이름을 명확히 구분해야한다
	public String delete(@PathVariable int id, @PathVariable int locationId, RedirectAttributes rttr, HttpSession session) {
		// 세션에서 로그인 정보 확인
	    MemberDTO loginMember = (MemberDTO) session.getAttribute("login");
	    if (loginMember == null || loginMember.getId() != id) {
	        rttr.addFlashAttribute("error2", "로그인이 필요합니다.");
	        return "redirect:/login"; // 로그인 페이지로 리다이렉트
	    }
	    // 삭제 처리
	    try {
	        int deleteLocation = naverLoginService.getDeleteAndLocation(locationId);
	        if (deleteLocation > 0) {
	            rttr.addFlashAttribute("SubDletMessage", "정상적으로 주소가 삭제되었습니다.");
	        } else {
	            rttr.addFlashAttribute("SubDletError", "삭제 중 오류가 발생하였습니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); // 디버깅용 로그
	        rttr.addFlashAttribute("SubDletError", "서버 오류로 인해 삭제에 실패했습니다.");
	    } 

	    // 리다이렉트
	    return "redirect:/member/addLocation/" + id;
	}
	
	@PostMapping("/updateLocation/{member_id}/{id}")
	public String updateLocation(@PathVariable int member_id, 
	                         SubLocationDTO dto, 
	                         RedirectAttributes rttr,
	                         HttpSession session) {
	      
		  try {
		       int row = naverLoginService.updateMemberLocation(dto); // 회원 정보 수정후
		   if (row > 0) {
		      MemberDTO location = naverLoginService.selectOne(member_id);  // 단일 조회를 이용하여 새로운 회원 정보를 불러온다
		      MemberDTO login = (MemberDTO) session.getAttribute("login");
		      login.setLocation(location.getLocation());
		      session.setAttribute("login", login);   // 그리고 이전 회원 정보에 덮어 씌운다
		       rttr.addFlashAttribute("SubUpMessage", "위치 정보가 성공적으로 업데이트되었습니다.");
		   } else {
		       rttr.addFlashAttribute("SubUpError", "위치 정보 업데이트에 실패했습니다.");
		       }
		   } catch (Exception e) {
		       e.printStackTrace();
		       rttr.addFlashAttribute("SubUpError", "서버 오류가 발생했습니다.");
		   }
		   return "redirect:/member/info/" + member_id;
	}

	
		
	@GetMapping({"", "/", "/{tmp}"})
	public String tmp() {
		return "redirect:/";
	}
	

}













