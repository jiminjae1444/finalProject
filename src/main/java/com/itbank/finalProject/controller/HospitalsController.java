package com.itbank.finalProject.controller;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import com.itbank.finalProject.model.DailyViewCountDTO;
import com.itbank.finalProject.model.HospitalDTO;
import com.itbank.finalProject.model.RouteRequest;
import com.itbank.finalProject.service.DailyViewCountService;
import com.itbank.finalProject.service.HospitalService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/hospitals")
public class HospitalsController {
    @Autowired
    private HospitalService hospitalService;

    @Autowired
    private DailyViewCountService dailyViewCountService;

    @PostMapping(value = "/searchs", produces = "application/json; charset=utf-8")
    public HashMap<String, Object> search(@RequestParam String search, HttpSession session) {
        HashMap<String, Object> response = new HashMap<>();
        List<HospitalDTO> hospitalList = hospitalService.getSearchResult(search);
        response.put("success", !hospitalList.isEmpty());
        response.put("noSearch", hospitalList.isEmpty());
        response.put("result", hospitalList);
        session.setAttribute("hospitals", hospitalList);
        return response;
    }
    @GetMapping(value = "/hospitalLists" , produces = "application/json; charset=utf-8")
    public ResponseEntity<List<HospitalDTO>> getHospitals(HttpSession session) {
        // 세션에서 병원 리스트 가져오기
        List<HospitalDTO> list = (List<HospitalDTO>) session.getAttribute("hospitals");

        if (list != null) {
            return ResponseEntity.ok(list); // JSON 형태로 응답
        } else {
            return ResponseEntity.notFound().build(); // 404 응답
        }
    }


    @PostMapping(value = "/searchs/names"  , produces = "application/json; charset=utf-8")
    public HashMap<String, Object> searchName(@RequestParam String hospital) {
        HashMap<String,Object> response = new HashMap<>();
        List<HospitalDTO> hospitalnameList = hospitalService.getSearchResultHospital(hospital);
        response.put("success" , !hospitalnameList.isEmpty());
        response.put("noSearch", hospitalnameList.isEmpty());
        response.put("hospitals", hospitalnameList);
        return response;
    }
    @PostMapping(value="/getHospitalImage" , produces = "application/json; charset=utf-8" )
    public HashMap<String, Object> getHospitalImage(@RequestBody HospitalDTO request, HttpSession session, HttpServletRequest servletRequest) throws UnsupportedEncodingException {
        int hospitalId = request.getId(); // HospitalDTO에서 ID를 받음

        // 이미지를 세션에서 가져오거나, 없으면 크롤링하여 가져오기
        String imageUrl = hospitalService.getHospitalImage(hospitalId, session, servletRequest);

        // 응답을 위한 HashMap
        HashMap<String, Object> response = new HashMap<>();
        response.put("imageUrl", imageUrl);

        return response;
    }

    @PostMapping(value="/routes" , produces = "application/json; charset=utf-8")
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

    @GetMapping(value="/emergency", produces = "application/json; charset=utf-8")
    public HashMap<String, Object> emergency() throws JsonProcessingException, UnsupportedEncodingException {
        HashMap<String, Object> response = new HashMap<>();

        // XML 데이터를 가져옴
        String resp = hospitalService.getEmergenncy();

        // XmlMapper를 사용해 XML을 JsonNode로 변환
        XmlMapper xmlMapper = new XmlMapper();
        byte[] bytes = resp.getBytes(StandardCharsets.ISO_8859_1);  // 잘못된 인코딩을 수정하기 위해 ISO-8859-1로 처리
        String decodedResponse = new String(bytes, StandardCharsets.UTF_8);  // 다시 UTF-8로 변환

        // XML -> JSON 변환
        JsonNode jsonNode = xmlMapper.readTree(decodedResponse);
        JsonNode item = jsonNode.get("body").get("items").get("item");
        // 로그로 출력
//        log.info(item.toPrettyString());

        // JSON 데이터를 response에 담아서 반환x1
        response.put("emergency", item);
        return response;
    }


    @GetMapping(value = "viewCount/{id}" , produces = "application/json; charset=utf-8")
    public HashMap<String, Object> viewCount(@PathVariable("id") int id) {
        HashMap<String , Object> response = new HashMap<>();
        List<DailyViewCountDTO> dto =  dailyViewCountService.getViewCount(id);
        response.put("viewCount", dto);
        return response;
    }

}
