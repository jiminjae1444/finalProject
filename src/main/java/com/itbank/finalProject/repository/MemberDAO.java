package com.itbank.finalProject.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itbank.finalProject.model.BookingDTO;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.model.ProfileDTO;
import com.itbank.finalProject.model.SubLocationDTO;

public interface MemberDAO {

	int naverInsert(MemberDTO dto);

	String selectSalt(String userid);

	MemberDTO selectLogin(MemberDTO dto);

	MemberDTO selectNaverLogin(String naver_id);

	int selectCount(String userid);

	int selectEmailAndUserid(MemberDTO dto);

	int updatePassword(MemberDTO dto);

	MemberDTO getMemberByeId(int id);

	int insertProfile_img(ProfileDTO profile);

	int selectMaxProfileId();

	int updateMemberProfile(MemberDTO dto);

	int updateLocation(@Param("location") String location, @Param("id") int id);

	MemberDTO selectUserById(int id);

	int updatePw(MemberDTO userInfo);

	MemberDTO checkByUserId(String email);

	MemberDTO checkByEmail(String userid);

	List<BookingDTO> selectMemberByBookingList(int id);

	int insertAddLocation(SubLocationDTO dto);

	int checkDuplicateLocation(SubLocationDTO dto);
	
	List<SubLocationDTO> selectAddLocationList(int id);

	int deleteAddLocation(int id);

	MemberDTO selectOne(int id);

	int getMaxId();

	int insertsubLocation(SubLocationDTO subDTO);

	int updateSubLocation(SubLocationDTO dto);

	MemberDTO selectOneBySubLocation(int id);

}
