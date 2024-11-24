package com.itbank.finalProject.repository;

import com.itbank.finalProject.model.HospitalDTO;
import com.itbank.finalProject.model.ReviewDTO;

import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface HospitalDAO {
	
	// 호준 파트
	
	// 카테고리, 지역을 선택하고 난 후 해당하는 병원 목록 출력
	List<HospitalDTO> selectSidoList(int jinryo_code);

	List<HospitalDTO> selectGuList(int jinryo_code, int sido_code);

	List<HospitalDTO> selectHospitalList(int jinryo_code, int sido_code, int gu_code);

	int getHospitalCnt(int jinryo_code, int sido_code, int gu_code);

	List<HospitalDTO> selectPagingHospitalList(int jinryo_code, int sido_code, int gu_code, int offset, int fetch); 
	
	
	// 민재 파트
	List<HospitalDTO> getHospitalsByKeywords(@Param("searchList") List<String> searchList);

    List<HospitalDTO> getHospitalsByName(String hospital);

    List<HospitalDTO> getNullList();

    List<HospitalDTO> selectAllList();

    void updateLatAndLng(HospitalDTO hospital);

    HospitalDTO selectOne(String hospitalId);

    void insertKeyword(String kw);

    HospitalDTO getHospitalInfo(int id);

    List<String> getJinryoNames(int id);

    HospitalDTO findHospitalNameById(int id);

    List<HospitalDTO> getList();

    List<HospitalDTO> ContainsBodyList(@Param("searchList") List<String> searchList);

    void updateViewCount(int id);

	List<ReviewDTO> getReviewToHomepage();
}
