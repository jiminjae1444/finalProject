package com.itbank.finalProject.repository;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itbank.finalProject.model.ReviewDTO;

public interface ReviewDAO {

	// 리뷰 전체보기 했을 때의 리뷰 목록 (rowNums: 가져올 리뷰 개수)
	List<HashMap<String, Object>> selectList(@Param("id") int id, @Param("offset") int offset, @Param("rowNums") int rowNums);

	// 리뷰 작성
	int insert(ReviewDTO dto);

	// 리뷰 삭제
	int delete(int reviewId);
	
	
	
	// 선택한 병원의 전체 리뷰 개수
	int selectCount(int id);

	// 선택한 병원의 평점 평균
	double selectAvg(int id);

}
