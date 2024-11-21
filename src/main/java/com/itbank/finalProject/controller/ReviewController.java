package com.itbank.finalProject.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itbank.finalProject.repository.ReviewDAO;


@Controller
@RequestMapping("/review")
public class ReviewController {

	@Autowired private ReviewDAO reviewDAO;
	
	// 선택한 병원의 리뷰 페이지
	@GetMapping("{id}/view")
	public String view(@PathVariable int id, Model model) {
		model.addAttribute("id", id);
		
		model.addAttribute("reviewCnt", reviewDAO.selectCount(id));		// 조회한 병원의 전체 리뷰 개수
		return "/review/view";
	}
	
	
}
