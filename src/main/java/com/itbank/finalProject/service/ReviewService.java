package com.itbank.finalProject.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.finalProject.repository.ReviewDAO;

@Service
public class ReviewService {

	@Autowired private ReviewDAO reviewDAO;
	

	// 리뷰 전체보기 했을 때의 리뷰 목록 (rowNums: 가져올 리뷰 개수)
	public List<HashMap<String, Object>> selectList(int id, int offset, int rowNums) {
		List<HashMap<String, Object>> reviewMap = reviewDAO.selectList(id, offset, rowNums);

		for(HashMap<String, Object> review : reviewMap) {
			// CREATED_AT -> yyyy.MM.dd. 형태로 변환
			Date date = (Date) review.get("CREATED_AT");
			if(date == null) return null;
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd.");
			String created_at = dateFormat.format(date);
			review.put("CREATED_AT", created_at);
			
			// USERID -> 첫 세글자 이후로는 모두 *로 변경
			String userid = (String) review.get("USERID");
			if(userid == null) return null;
			userid = userid.substring(0, 3) + userid.substring(3).replaceAll(".", "*");
			review.put("USERID", userid);
		}
		return reviewMap;
	}


	// 2주 내 해당 병원 방문 횟수
	public int selectVisitCount(int memberId, int id) {
		return reviewDAO.selectVisitCount(memberId, id);
	}


	// 2주 내 해당 병원 리뷰 작성 개수
	public int selectWriteReviewCount(int memberId, int id) {
		return reviewDAO.selectWriteReviewCount(memberId, id);
	}

	// 조회한 병원의 전체 리뷰 개수
	public int selectTotalReviewCount(int id) {
		return reviewDAO.selectTotalReviewCount(id);
	}

	// 조회한 병원의 리뷰 평균 평점
	public Double selectReviewAvg(int id) {
		return reviewDAO.selectReviewAvg(id);
	}
	
	

	
	
}
