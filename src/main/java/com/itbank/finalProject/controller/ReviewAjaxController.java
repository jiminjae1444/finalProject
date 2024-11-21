package com.itbank.finalProject.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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
	
	// 리뷰 작성
	@PostMapping("/{id}/write")
	public int write(ReviewDTO dto) {
		return reviewDAO.insert(dto);
	}
	
	// 리뷰 삭제
	@DeleteMapping("/{id}/delete/{reviewId}")
	public int delete(@PathVariable("reviewId") int reviewId) {
		return reviewDAO.delete(reviewId);
	}
	
}




