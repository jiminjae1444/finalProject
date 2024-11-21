package com.itbank.finalProject.controller;

import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
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
//      String defaultProfileImg = dto.getGender().equals("M") ? "defaultM.png" : "defaultF.png";
//      dto.setOriginalFileName(defaultProfileImg);
      int row = naverLoginService.naverJoin(dto);
      rttr.addFlashAttribute("message", row != 0 ? "회원 가입 성공" : "회원 가입 실패");
      return "redirect:/member/login";
   }
   
   @GetMapping("/login")
   public void login(Model model) {
      String naverLoginURL = naverLoginComponent.getAuthorizationUrl();
      model.addAttribute("naverLoginURL", naverLoginURL);
   }
   
   @PostMapping(value="/login", produces = "application/json; charset=utf-8")
   @ResponseBody
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
   
   @GetMapping("/naverCallback")
   public void naverCallback(String code, String state, Model model) throws JsonMappingException, JsonProcessingException, URISyntaxException {
      String accessToken = naverLoginComponent.getAccessToken(code, state);
      accessToken = objectMapper.readTree(accessToken).get("access_token").asText();
      System.out.println(accessToken);
      String userProfile = naverLoginComponent.getProfile(accessToken);
      System.out.println(userProfile);
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
   
   @GetMapping(value="/resetPassword", produces = "application/json; charset=utf-8")
   public void resetPassword() {}
   
   
   @GetMapping("/info/{id}")
   public String info(@PathVariable int id, HttpSession session) {
      List<SubLocationDTO> list = naverLoginService.getAddLocationList(id);
      session.setAttribute("list", list);
      return "/member/info";
   }
   
   @PostMapping(value="/info/{id}", produces = "application/json; charset=utf-8")
   @ResponseBody
   public Map<String, String> delete(@PathVariable int id, HttpSession session) {
      Map<String, String> response = new HashMap<>();
      
      int deleteLocation = naverLoginService.getDeleteAndLocation(id);
      if(deleteLocation < 0) {
         response.put("status", "fail");
           response.put("message", "삭제 중 오류가 발생하였습니다.");
       } else {
           response.put("status", "success");
           response.put("message", "정상적으로 주소가 삭제되었습니다.");
       }
       return response;
      
   }
   
   @GetMapping("/imgUpdate/{id}")
   public String imgUpdate(@PathVariable int id) {
      return "/member/imgUpdate";
   }
   
   @PostMapping("/imgUpdate/{id}")
   public String imgUpdate(@PathVariable int id, MemberDTO dto, HttpSession session) {
      String storedFileName = naverLoginService.imgUpload(dto);
      MemberDTO login = (MemberDTO) session.getAttribute("login");
      login.setStoredFileName(storedFileName);
      session.setAttribute("login", login);
      return "redirect:/member/info";
   }
   
   @GetMapping("/locationUpdate/{id}")
   public String locationUpdate(@PathVariable int id) {
      return "/member/locationUpdate";
   }
   
   @PostMapping("/locationUpdate/{id}")
   public String locationUpdate(@PathVariable int id, MemberDTO dto,HttpSession session) {
      System.out.println(dto.getLocation());
      int row = naverLoginService.updateLocation(dto);
        if (row > 0) {
              // 데이터베이스 업데이트가 성공한 경우
              MemberDTO currentUser = (MemberDTO) session.getAttribute("login");
              if (currentUser != null) {
                  // 현재 세션의 사용자 정보 업데이트
                  currentUser.setLocation(dto.getLocation());
                  session.setAttribute("login", currentUser);
              }

        }
         return "redirect:/member/info";
   }
   
   @GetMapping("/pwUpdate/{id}")
   public String pwUpdate(@PathVariable int id) {
      return "/member/pwUpdate";
   }
   
   @PostMapping("/pwUpdate/{id}")
   public String pwUpdate(@PathVariable int id, @RequestParam("currentPw") String currentPw, @RequestParam("newPw") String newPw, RedirectAttributes rttr, HttpSession session) {
      System.out.println(currentPw);
       MemberDTO userInfo = naverLoginService.getUserByUserPw(currentPw, id);
       if (userInfo != null) {
           userInfo.setUserpw(newPw);
           int row = naverLoginService.updatePw(userInfo);
           if (row > 0) {
               session.invalidate();
               rttr.addFlashAttribute("pwMessage", "비밀번호가 성공적으로 변경되었습니다.");
           }
       }
       rttr.addFlashAttribute("error", "비밀번호가 일치하지 않습니다.");
       return "redirect:/member/pwUpdate/" + id;
   }
   
   @GetMapping("/reCheckUserid")
   public String reCheckUserid() {
      return "member/reCheckUserid";
   }
   
   @PostMapping(value="/reCheckUserid", produces = "application/json; charset=utf-8")
   @ResponseBody // JSON 형태로 응답하기 위해 추가
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
   
   @GetMapping("/reCheckEmail")
   public String reCheckEmail() {
      return "member/reCheckEmail";
   }
   
   @PostMapping(value="/reCheckEmail", produces = "application/json; charset=utf-8")
   @ResponseBody // JSON 형태로 응답하기 위해 추가
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
   
   @GetMapping("/bookingList/{id}")
   public String bookingList(@PathVariable int id, HttpSession session) {
      List<BookingDTO> list = naverLoginService.getMemberByBookingList(id);
      session.setAttribute("list", list);
       return "member/bookingList";
   }
   
   @GetMapping("/addLocation/{id}")
   public String addLocation(@PathVariable int id) {
      return "member/addLocation";
   }
   
   @PostMapping(value="/addLocation/{id}", produces = "application/json; charset=utf-8")
   @ResponseBody
   public Map<String, String> addLocation(@PathVariable int id, SubLocationDTO dto) {
      Map<String, String> response = new HashMap<>();
      System.out.println(dto.getMemberLocation());
      int row = naverLoginService.insertAddLocation(dto);
      if(row < 0) {
         response.put("status", "fail");
           response.put("message", "주소 추가시 오류가 발생했습니다.");
       } else {
           response.put("status", "success");
           response.put("message", "정상적으로 주소가 추가되었습니다.");
       }
       return response;
   }

}
