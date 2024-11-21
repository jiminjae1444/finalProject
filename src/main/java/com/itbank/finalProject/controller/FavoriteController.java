package com.itbank.finalProject.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.itbank.finalProject.model.FavoriteDTO;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.repository.FavoriteDAO;

import lombok.extern.log4j.Log4j;

@RestController
@Log4j
public class FavoriteController {
	
	@Autowired private FavoriteDAO favoriteDAO;
	
	@GetMapping(value="/getFavorite/{id}" , produces = "application/json; charset=utf-8")
    public int getFavorite(HttpSession session, @PathVariable("id") int hospital_id) {
    	MemberDTO dto = (MemberDTO) session.getAttribute("login");
    	if(dto!=null) {
    		int member_id = dto.getId();
    		return favoriteDAO.getFavorite(hospital_id, member_id) == null ? 0 : 1;
    	}else {
    		return -1;
    	}
    }
	
	@GetMapping(value="/myFavoritesList/{thisPage}" , produces = "application/json; charset=utf-8")
	public List<FavoriteDTO> myFavoritesList(@PathVariable("thisPage") int thisPage, HttpSession session){
		MemberDTO dto = (MemberDTO) session.getAttribute("login");
		int member_id = dto.getId();
		int selectStart = (thisPage - 1) * 5;
		return favoriteDAO.myFavoritesList(member_id, selectStart);
	}
	
	@GetMapping(value="/myFavoritesMaxPage" , produces = "application/json; charset=utf-8")
	public int myFavoritesMaxPage() {
		return (favoriteDAO.myFavoritesMaxPage() + 4) / 5;
	} 
	
	@GetMapping(value="/myFavorite/{id}", produces = "application/json; charset=utf-8")
    public int myFavorite(HttpSession session, @PathVariable("id") int hospital_id) {
    	MemberDTO dto = (MemberDTO) session.getAttribute("login");
    	int member_id = dto.getId();
    	if(favoriteDAO.getFavorite(hospital_id, member_id) == null) {
    		favoriteDAO.myFavoriteInsert(hospital_id, member_id);
    		return 1;
    	}
    	else {
    		favoriteDAO.myFavoriteDelete(hospital_id, member_id);
    		return 2;
    	}
    }
}
