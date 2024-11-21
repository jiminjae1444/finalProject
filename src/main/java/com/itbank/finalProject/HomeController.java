package com.itbank.finalProject;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.itbank.finalProject.model.HospitalDTO;
import com.itbank.finalProject.model.SearchHistoryDTO;
import com.itbank.finalProject.service.HospitalService;
import com.itbank.finalProject.service.SearchHistoryService;

import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.mail.MessagingException;
import javax.servlet.http.HttpSession;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

@Log4j
@Controller
public class HomeController {
	@Autowired HospitalService hospitalService;
	@Autowired SearchHistoryService searchHistoryService;

    @RequestMapping("/")
    public String home(Model model , HttpSession session) throws JsonProcessingException, UnsupportedEncodingException, MessagingException {
//        log.info("좌표 없는 병원 업데이트");
        //이건 병원 목록 불러올때 좌표값없는 병원 DB에 업데이트 하는데 사용
        hospitalService.getSetList();
        // 세션에서 최근 본 병원 목록 가져오기
        List<HospitalDTO> recentHospitals = (List<HospitalDTO>) session.getAttribute("recentHospitals");
//        log.info(recentHospitals);

        if (recentHospitals == null) {
            recentHospitals = new ArrayList<>();
        }

        List<SearchHistoryDTO> rankingList = searchHistoryService.getRankingList();
        model.addAttribute("rankings",rankingList);
        
        // 홈 페이지로 최근 본 병원 목록을 전달
        model.addAttribute("recentHospitals", recentHospitals);
        return "home";
    }
    
    @GetMapping("/healthInfo/healthInfo")
   	public String healthInfo() {
   		return "healthInfo/healthInfo";
   	}
    
    

}