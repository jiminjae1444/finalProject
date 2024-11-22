package com.itbank.finalProject.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/review")
public class ReviewController {

	
	// 선택한 병원의 리뷰 페이지
	@GetMapping("{id}/view")
	public String view(@PathVariable int id, Model model) {
		model.addAttribute("id", id);
		return "/review/view";
	}
	
	
}
