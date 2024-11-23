package com.itbank.finalProject.controller;


import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.*;

import com.itbank.finalProject.model.MemberDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itbank.finalProject.component.NotificationMailComponent;
import com.itbank.finalProject.model.BookingDTO;
import com.itbank.finalProject.model.HospitalTimeDTO;
import com.itbank.finalProject.model.NotificationDTO;
import com.itbank.finalProject.repository.BookingDAO;

import lombok.extern.log4j.Log4j;

import javax.servlet.http.HttpSession;

@Controller
@Log4j
public class BookingController {
	
	@Autowired private BookingDAO bookingDAO;
	@Autowired NotificationMailComponent nmc;
	ObjectMapper om = new ObjectMapper();


	
	// 예약하기 post 요청
	@PostMapping(value ="/bookingInsert", produces = "application/json; charset=utf-8")
	@ResponseBody
	public int bookingInsert(@RequestBody BookingDTO bookingDTO) {
		
		// 미국시간이라 9시간 빼는처리 해줘야됨
		Calendar c = Calendar.getInstance();		
		c.setTime(bookingDTO.getBooking_date());
		c.add(Calendar.HOUR, -9);					
		java.util.Date utilDate = c.getTime();
		java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
		bookingDTO.setBooking_date(sqlDate);
		
		// 예약시간이 진료시간에 적합한지 판별 
        String dayName = sqlDate.toLocalDate().getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
        HospitalTimeDTO htDTO = bookingDAO.selectHospitalTime(bookingDTO.getHospital_id());
        if(htDTO == null) return 3;
        Map<String, Object> map = om.convertValue(htDTO, Map.class);
        int cnt = 0;
        int index = 0;
        for (String key : map.keySet()) {
           if(key.toUpperCase().startsWith(dayName.toUpperCase())) {
        	   if(map.get(key) == null) return 2;
        	   LocalTime htTime = LocalTime.parse((String)map.get(key), DateTimeFormatter.ofPattern("HHmm"));
        	   Time sqlTime = new Time(sqlDate.getTime()); // SQL Date에서 시간을 가져옴
               LocalTime inputTime = sqlTime.toLocalTime();
        	   if(((index == 0 && htTime.isBefore(inputTime)) || (index == 1 && htTime.isAfter(inputTime)))) {
        		   cnt++;   
        	   }
        	   index++;
           }
        }
        // 적합하면 예약 실행
        if(cnt == 2) return bookingDAO.bookingInsert(bookingDTO);
       
        // 아니면 빠꾸먹임
        else return 2;
	}	
	
	// 예약 취소 patch 요청
	@PatchMapping(value = "/bookingCancel/{member_id}/{hospital_id}" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int bookingCancel(@PathVariable("member_id") int member_id, @PathVariable("hospital_id") int hospital_id) {
		BookingDTO dto = bookingDAO.selectBookingInfo(hospital_id, member_id);
		bookingDAO.bookingCancel(member_id, hospital_id);
		return bookingDAO.notificationBookingCancel(dto);
	}
	
	// 예약 시간 만료 patch 요청
	@PatchMapping(value= "/bookingTimeOver/{member_id}/{hospital_id}" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int bookingTimeOver(@PathVariable("member_id") int member_id, @PathVariable("hospital_id") int hospital_id) {
		BookingDTO dto = bookingDAO.selectBookingInfo(hospital_id, member_id);
		bookingDAO.bookingTimeOver(member_id, hospital_id);
		return bookingDAO.notificationBookingTimeOver(dto);
	}
	
	// 예약한 내용을 알림테이블에 추가하는 post 요청
	@PostMapping(value ="/notificationBooking/{member_id}/{hospital_id}" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int notificationBooking(@PathVariable("member_id") int member_id, @PathVariable("hospital_id") int hospital_id) {
		BookingDTO dto = bookingDAO.selectBookingInfo(hospital_id, member_id);
		return bookingDAO.notificationBooking(dto);
	}
	
	// 예약 변경한 내용을 알림테이블에 추가하는 post 요청
	@PostMapping(value ="/notificationBookingUpdate/{member_id}/{hospital_id}" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int notificationBookingUpdate(@PathVariable("member_id") int member_id, @PathVariable("hospital_id") int hospital_id) {
		BookingDTO dto = bookingDAO.selectBookingInfo(hospital_id, member_id);
		return bookingDAO.notificationBookingUpdate(dto);
	}
	
	// 예약 시간이 30분 남았을때 그 내용을 알림테이블에 추가하는 get 요청
	@GetMapping(value= "/notificationBookingOneDay/{member_id}/{hospital_id}" , produces = "application/json; charset=utf-8" )
	
	@ResponseBody
	public int notificationBookingOneDay(@PathVariable("member_id") int member_id, @PathVariable("hospital_id") int hospital_id) {
		BookingDTO dto = bookingDAO.selectBookingInfo(hospital_id, member_id);
		return bookingDAO.notificationBookingOneDay(dto);
	}
	
	// 알림 읽음 처리하는 patch 요청
	@PatchMapping(value = "/readNotification/{thisPage}" ,produces = "application/json; charset=utf-8")
	@ResponseBody
	public void readNotification(@PathVariable("thisPage") int thisPage) {
		int selectStart = (thisPage - 1) * 7;
		int selectEnd = selectStart + 7;
		bookingDAO.readNotification(selectStart, selectEnd);
	}
	
	// 알림 페이지 최대 수 get 요청
	@GetMapping(value="/notificationMaxPage" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int notificationMaxPage() {
		int notificationAllCount = bookingDAO.selectNotificationAllCount();
		return ((notificationAllCount + 6) / 7);
	}
	
	// 알림 페이지별 리스트 get 요청
	@GetMapping(value = "/notificationList/{thisPage}" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public List<NotificationDTO> notificationList(@PathVariable("thisPage") int thisPage, HttpSession session) {
		MemberDTO dto = (MemberDTO) session.getAttribute("login");
		int member_id = dto.getId();
		int selectStart = (thisPage - 1) * 7;
		return bookingDAO.selectNotificationList(selectStart, member_id);
	}


	// 예약 변경 patch 요청
	@PatchMapping(value="/bookingUpdate" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int bookingUpdate(@RequestBody BookingDTO bookingDTO) {
		
		// 미국시간이라 9시간 빼는처리 해줘야됨
		Calendar c = Calendar.getInstance();
		c.setTime(bookingDTO.getBooking_date());
		c.add(Calendar.HOUR, -9);
		java.util.Date utilDate = c.getTime();
		java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
		bookingDTO.setBooking_date(sqlDate);
		
		// 예약시간이 진료시간에 적합한지 판별 
        String dayName = sqlDate.toLocalDate().getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
        HospitalTimeDTO htDTO = bookingDAO.selectHospitalTime(bookingDTO.getHospital_id());
        Map<String, Object> map = om.convertValue(htDTO, Map.class);
        int cnt = 0;
        int index = 0;
        for (String key : map.keySet()) {
           if(key.toUpperCase().startsWith(dayName.toUpperCase())) {
        	   if(map.get(key) == null) return 2;
        	   LocalTime htTime = LocalTime.parse((String)map.get(key), DateTimeFormatter.ofPattern("HHmm"));
        	   Time sqlTime = new Time(sqlDate.getTime()); // SQL Date에서 시간을 가져옴
               LocalTime inputTime = sqlTime.toLocalTime();
        	   if(((index == 0 && htTime.isBefore(inputTime)) || (index == 1 && htTime.isAfter(inputTime)))) {
        		   cnt++;   
        	   }
        	   index++;
           }
        }
        // 적합하면 예약 변경 실행
        if(cnt == 2) return bookingDAO.bookingUpdate(bookingDTO);
        
        // 아니면 빠꾸먹임 
        else return 2;
	}
	
	// 아직 안읽은 알림 개수 get 요청
	@GetMapping(value = "/notificationCount", produces = "application/json; charset=utf-8")
	@ResponseBody
	public int notificationCount(HttpSession session) {
		MemberDTO login = (MemberDTO) session.getAttribute("login");
		if(login == null) return 0;
		int member_id = login.getId();
		return bookingDAO.selectNotificationCount(member_id);
	}
	
	// 알림테이블에 가장 최근에 추가된 내용 메일보내기 post 요청
	@PostMapping(value="/sendNotificationMail" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int sendNotificationMail(HttpSession session) {
		MemberDTO login = (MemberDTO) session.getAttribute("login");
		if(login == null) return 0;
		int member_id = login.getId();
		NotificationDTO dto = bookingDAO.selectNotificationList(0,member_id).get(0);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String content = dto.getName() + "님의 " + dto.getHospital_name() + " " + sdf.format(dto.getBooking_date()) + " " + dto.getMessage();
//		log.info(content);
		// return nmc.sendNotificationMail(dto.getEmail(), "아프지맙시닥 알림", content);
		return 1;
	}

	@DeleteMapping(value = "/deleteNotification/{id}" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int deleteNotification(@PathVariable("id") int id) {
		return bookingDAO.deleteNotification(id);
	}

	@DeleteMapping(value = "/deleteNotificationAll" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int deleteNotificationAll() {
		return bookingDAO.deleteNotificationAll();
	}

	@DeleteMapping(value = "/deleteMyFavorites/{id}" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int deleteMyFavorites(@PathVariable("id") int id) {
		return bookingDAO.deleteMyFavorites(id);
	}

	@DeleteMapping(value = "/deleteMyfavoritesAll" , produces = "application/json; charset=utf-8")
	@ResponseBody
	public int deleteMyfavoritesAll() {
		return bookingDAO.deleteMyfavoritesAll();
	}

}