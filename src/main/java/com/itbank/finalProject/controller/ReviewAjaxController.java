package com.itbank.finalProject.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.itbank.finalProject.model.ReviewDTO;
import com.itbank.finalProject.repository.ReviewDAO;
import com.itbank.finalProject.service.ReviewService;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/reviews")
@Log4j
public class ReviewAjaxController {
	
	@Autowired private ReviewDAO reviewDAO;
	@Autowired private ReviewService reviewService;

	
	// 리뷰 불러오기 (10개씩)
	@GetMapping(value = "/{id}" , produces = "application/json; charset=utf-8")
	public List<HashMap<String, Object>> selectList(@PathVariable("id") int id, @RequestParam int pageNo) {
		int offset = (pageNo - 1) * 10;
		List<HashMap<String, Object>> map = reviewService.selectList(id, offset, 10);
		return map;
	}
	
	// 병원의 리뷰개수, 평균 평점
	@GetMapping(value = "/reviewCount/{id}" , produces = "application/json; charset=utf-8")
	public HashMap<String, Object> selectReviewCountAndAvg(@PathVariable int id) {
		HashMap<String, Object> map = new HashMap<>();
		int totalReviewCount = reviewService.selectTotalReviewCount(id);
		Double reviewAvg = reviewService.selectReviewAvg(id);
		map.put("count", totalReviewCount);
		map.put("avg", reviewAvg);
		return map;
	}
	
	// 리뷰 작성 가능 여부 확인
	@GetMapping(value = "/checkReview/{memberId}/{id}", produces = "application/json; charset=utf-8")
	public HashMap<String, Object> checkReview(@PathVariable("memberId") int memberId, @PathVariable("id") int id) {
		HashMap<String, Object> map = new HashMap<>();
		int visitCount = reviewService.selectVisitCount(memberId, id);		// 2주 내 해당 병원 방문 횟수
		int reviewCount = reviewService.selectWriteReviewCount(memberId, id);	// 2주 내 해당 병원에 작성한 리뷰 개수
		
		map.put("visitCount", visitCount);
		map.put("reviewCount", reviewCount);
		return map;
	}
	
	// 리뷰 작성
	@PostMapping(value = "/{id}/write", produces = "application/json; charset=utf-8")
	public int write(ReviewDTO dto) {
		return reviewDAO.insertReview(dto);
	}
	
	// 리뷰 삭제
	@DeleteMapping(value = "/{id}/delete/{reviewId}", produces = "application/json; charset=utf-8")
	public int deleteReview(@PathVariable("reviewId") int reviewId) {
		return reviewDAO.deleteReview(reviewId);
	}
	
}




