package com.itbank.finalProject.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itbank.finalProject.model.HospitalDTO;
import com.itbank.finalProject.model.RouteRequest;
import com.itbank.finalProject.service.HospitalService;

@Controller
public class HospitalAjaxController {

	   @Autowired private HospitalService hospitalService;

	    @PostMapping("/searchs")
	    public HashMap<String, Object> search(@RequestParam String search, HttpSession session) {
	        HashMap<String, Object> response = new HashMap<>();
	        List<HospitalDTO> hospitalList = hospitalService.getSearchResult(search);
	        response.put("success", !hospitalList.isEmpty());
	        response.put("noSearch", hospitalList.isEmpty());
	        response.put("result", hospitalList);
	        session.setAttribute("hospitals", hospitalList);
	        return response;
	    }
	    
	    
	    @GetMapping("/hospitalLists")
	    public ResponseEntity<List<HospitalDTO>> getHospitals(HttpSession session) {
	        // 세션에서 병원 리스트 가져오기
	        List<HospitalDTO> list = (List<HospitalDTO>) session.getAttribute("hospitals");

	        if (list != null) {
	            return ResponseEntity.ok(list); // JSON 형태로 응답
	        } else {
	            return ResponseEntity.notFound().build(); // 404 응답
	        }
	    }


	    @PostMapping("/searchs/names")
	    public HashMap<String, Object> searchName(@RequestParam String hospital) {
	        HashMap<String,Object> response = new HashMap<>();
	        List<HospitalDTO> hospitalnameList = hospitalService.getSearchResultHospital(hospital);
	        response.put("success" , !hospitalnameList.isEmpty());
	        response.put("noSearch", hospitalnameList.isEmpty());
	        response.put("hospitals", hospitalnameList);
	        return response;
	    }
	    @PostMapping("/getHospitalImage")
	    public HashMap<String, Object> getHospitalImage(@RequestBody HospitalDTO request, HttpSession session, HttpServletRequest servletRequest) throws UnsupportedEncodingException {
	        int hospitalId = request.getId(); // HospitalDTO에서 ID를 받음

	        // 이미지를 세션에서 가져오거나, 없으면 크롤링하여 가져오기
	        String imageUrl = hospitalService.getHospitalImage(hospitalId, session, servletRequest);

	        // 응답을 위한 HashMap
	        HashMap<String, Object> response = new HashMap<>();
	        response.put("imageUrl", imageUrl);

	        return response;
	    }

	    @PostMapping("/routes")
	    public HashMap<String, Object> ajaxRoutes(@RequestBody RouteRequest routeRequest) throws JsonProcessingException {
	        HashMap<String, Object> response = new HashMap<>();
	        String resp = HospitalService.getRoutes(routeRequest);
	        ObjectMapper objectMapper = new ObjectMapper();
	        JsonNode jsonNode = objectMapper.readTree(resp);
	        JsonNode itineraries =jsonNode.get("metaData").get("plan").get("itineraries");
	        response.put("itineraries", itineraries);
	        response.put("success", true);
	        return response;
	    }
}






