package com.itbank.finalProject.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itbank.finalProject.model.FavoriteDTO;

public interface FavoriteDAO {
	
	FavoriteDTO getFavorite(@Param("hospital_id") int hospital_id, @Param("member_id") int member_id);

	int myFavoriteInsert(@Param("hospital_id") int hospital_id, @Param("member_id") int member_id);

	int myFavoriteDelete(@Param("hospital_id") int hospital_id, @Param("member_id") int member_id);

	List<FavoriteDTO> myFavoritesList(@Param("member_id") int member_id, @Param("selectStart")int selectStart);

	int myFavoritesMaxPage();

}
