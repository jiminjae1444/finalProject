package com.itbank.finalProject.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.itbank.finalProject.model.HospitalDTO;
import com.itbank.finalProject.model.HospitalPaging;
import com.itbank.finalProject.model.HospitalTimeDTO;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.model.SearchHistoryDTO;
import com.itbank.finalProject.repository.BookingDAO;
import com.itbank.finalProject.service.HospitalService;
import com.itbank.finalProject.service.HospitalTimeService;
import com.itbank.finalProject.service.ReviewService;
import com.itbank.finalProject.service.SearchHistoryService;

import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Log4j
@Controller
public class HospitalController {

    @Autowired HospitalService hospitalService;
    @Autowired HospitalTimeService hospitalTimeService;
    @Autowired SearchHistoryService searchHistoryService;
    @Autowired BookingDAO bookingDAO;
    @Autowired private ReviewService reviewService;

    
    // 호준 파트
    private static final String RECENT_HOSPITALS_SESSION_ATTRIBUTE = "recentHospitals";
    private static final int MAX_RECENT_HOSPITALS = 3; // 최근 본 병원 최대 개수
    
	@GetMapping
	public void view() {}
	
	@GetMapping("/hospital/selectLocation/{jinryo_code}")
	public String view(@PathVariable int jinryo_code, Model model) {
		List<HospitalDTO> sido_List = hospitalService.selectSidoList(jinryo_code);
		model.addAttribute("sido_List", sido_List);
		return "redirect:/hospital/selectLocation/{jinryo_code}/110000";
	}
	
	@GetMapping("/hospital/selectLocation/{jinryo_code}/{sido_code}")
	public String view(@PathVariable int jinryo_code, @PathVariable int sido_code, Model model) {
		List<HospitalDTO> sido_List = hospitalService.selectSidoList(jinryo_code);
		model.addAttribute("sido_List", sido_List);
		List<HospitalDTO> gu_List = hospitalService.selectGuList(jinryo_code, sido_code);
		model.addAttribute("gu_List", gu_List);
		return "/hospital/selectLocation";
	}
	
	@GetMapping("/hospital/selectLocation/{jinryo_code}/{sido_code}/{gu_code}")
	public String view(@PathVariable int jinryo_code, @PathVariable int sido_code, @PathVariable int gu_code, Model model) {
		List<HospitalDTO> hospital_List = hospitalService.selectHospitalList(jinryo_code, sido_code, gu_code);
		model.addAttribute("hospital_List", hospital_List);
		return "redirect:/hospital/selectLocation/{jinryo_code}/{sido_code}/{gu_code}/pageNo=1";
	}
	
	@GetMapping("/hospital/selectLocation/{jinryo_code}/{sido_code}/{gu_code}/pageNo={pageNo}")
	public String paging(@PathVariable int jinryo_code, @PathVariable int sido_code, @PathVariable int gu_code, @PathVariable int pageNo, Model model) {
		int hospitalCnt = hospitalService.getHospitalCnt(jinryo_code, sido_code, gu_code);
		HospitalPaging paging = new HospitalPaging(pageNo, hospitalCnt);
		model.addAttribute("paging", paging);
		
		List<HospitalDTO> hospital_List = hospitalService.selectPagingHospitalList(jinryo_code, sido_code, gu_code, paging.getOffset(), paging.getFetch());
		model.addAttribute("hospital_List", hospital_List);
		return "/hospital/hospitalInfo";
	}
    
	
	
    // 민재 파트
	 @GetMapping("/search")
	public void search(Model model) {
	    List<SearchHistoryDTO> rankingList = searchHistoryService.getRankingList();
	    model.addAttribute("rankings",rankingList);
	}
	
	@GetMapping("/result")
	public void result() {}
	
	
	@GetMapping("/hospitalInfo/{id}")
	public String hospitalInfo(@PathVariable int id, Model model, HttpSession session, HttpServletRequest request) throws UnsupportedEncodingException {
		HospitalDTO hospitalDTO = hospitalService.getInfo(id,session, request);
		HospitalTimeDTO hospitalTimeDTO = hospitalTimeService.getTime(id);
		List<String> jinryoNames = hospitalService.getJinryoNames(id);
		MemberDTO login =  (MemberDTO) session.getAttribute("login");
		Integer member_id = (login != null) ? login.getId() : null;
		
		// 세션에서 최근 본 병원 목록 가져오기
		List<HospitalDTO> recentHospitals = (List<HospitalDTO>) session.getAttribute(RECENT_HOSPITALS_SESSION_ATTRIBUTE);
		if (recentHospitals == null) {
		    recentHospitals = new ArrayList<>();
		}
		
		// 병원 정보 가져오기 (예: 병원 이름과 진료 이름)
		HospitalDTO hospitalInfo = hospitalService.getHospitalNameAndTreatmentById(id);
		String imageUrl = hospitalService.getHospitalImage(hospitalInfo.getId(),session, request);
		//	        System.out.println(imageUrl);
		hospitalInfo.setImageUrl(imageUrl);
		// 병원 ID가 목록에 이미 있으면 해당 병원을 맨 앞으로 이동
		boolean isAlreadyInList = false;
		int existingIndex = -1;
		
		for (int i = 0; i < recentHospitals.size(); i++) {
		    if (recentHospitals.get(i).getId() == hospitalInfo.getId()) {
		        isAlreadyInList = true;
		        existingIndex = i;
		        break;
		    }
		}
		
		if (isAlreadyInList) {
		    // 이미 목록에 있으면 해당 병원을 삭제하고 맨 앞에 추가
		    recentHospitals.remove(existingIndex);
		}
		
		// 병원 정보를 맨 앞에 추가
		recentHospitals.add(0, hospitalInfo);
		
		// 최근 본 병원 수가 최대치를 넘지 않도록 제한
		if (recentHospitals.size() > MAX_RECENT_HOSPITALS) {
		    recentHospitals.remove(recentHospitals.size() - 1); // 가장 오래된 병원 삭제
		}
		
		if (member_id != null) {
		    model.addAttribute("bookingInfo", bookingDAO.selectBookingInfo(id, member_id));
		}
		// 세션에 최근 본 병원 목록을 저장
		session.setAttribute(RECENT_HOSPITALS_SESSION_ATTRIBUTE, recentHospitals);
		model.addAttribute("hospital", hospitalDTO);
		model.addAttribute("jinryoNames", jinryoNames);
		model.addAttribute("hospitalTime", hospitalTimeDTO);
		// 리뷰 파트
		model.addAttribute("reviewList", reviewService.selectList(id, 0, 3));	// 리뷰 3개 가져오기
		model.addAttribute("reviewCount", reviewService.selectTotalReviewCount(id));	// 전체 리뷰 개수
		model.addAttribute("reviewAvg", reviewService.selectReviewAvg(id));		// 평점 평균
		return "/hospital/view";
		}

}
