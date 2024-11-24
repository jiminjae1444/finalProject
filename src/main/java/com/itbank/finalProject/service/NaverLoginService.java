package com.itbank.finalProject.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itbank.finalProject.component.FileComponent;
import com.itbank.finalProject.component.HashComponent;
import com.itbank.finalProject.model.BookingDTO;
import com.itbank.finalProject.model.MemberDTO;
import com.itbank.finalProject.model.ProfileDTO;
import com.itbank.finalProject.model.SubLocationDTO;
import com.itbank.finalProject.repository.MemberDAO;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class NaverLoginService {
	
	@Autowired private HashComponent hashComponent;
	@Autowired private FileComponent fileComponent;
	@Autowired private MemberDAO memberDAO;

	public int naverJoin(MemberDTO dto) {
//		System.out.println("input 입력 데이터 :" + dto.getUserid());
//		System.out.println("input 입력 데이터 :" + dto.getEmail());
//		System.out.println("input 입력 데이터 :" + dto.getLocation());
		String userpw = dto.getUserpw();
		String salt = hashComponent.getRandomSalt();
		String hash = hashComponent.getHash(salt, userpw);
		
		dto.setSalt(salt);
		dto.setHash(hash);
		
		int row = memberDAO.naverInsert(dto);
//		System.out.println("반환값 :" + row);
		
		if(row != 0) {
			int id = memberDAO.getMaxId(); // 최근 유저 아이디를 가져오는 DAO메서드
			SubLocationDTO subDTO = new SubLocationDTO();
			subDTO.setMember_id(id);
			subDTO.setMemberLocation(dto.getLocation());
			subDTO.setAlias("가입시 등록 위치");
			row += memberDAO.insertsubLocation(subDTO);
		}		
		return row;
	}

	public MemberDTO naverSelectLogin(MemberDTO dto) {
		String salt = memberDAO.selectSalt(dto.getUserid());
		String hash = hashComponent.getHash(salt, dto.getUserpw());
		dto.setHash(hash);
		return memberDAO.selectLogin(dto);
	}

	public MemberDTO selectNaverLogin(String naver_id) {
		return memberDAO.selectNaverLogin(naver_id);
	}

	public int selectCount(String userid) {
		return memberDAO.selectCount(userid);
	}

	public String newUserPassword(MemberDTO dto) {
		int count = memberDAO.selectEmailAndUserid(dto);
		
		String password = null;
//		System.out.println(count);
		if(count != 0) {
			password = UUID.randomUUID().toString().substring(0, 8);
			String salt = hashComponent.getRandomSalt();
			String hash = hashComponent.getHash(salt, password);
			dto.setSalt(salt);
			dto.setHash(hash);
			memberDAO.updatePassword(dto);
		}
		return password;
	}

	public String imgUpload(MemberDTO dto) {
		// 기존 파일 삭제 로직 추가
		MemberDTO existingMember = memberDAO.getMemberByeId(dto.getId());
		if(existingMember != null && existingMember.getStoredFileName() != null) {
			fileComponent.deleteFile(existingMember.getStoredFileName());
		}
		
		// 업로드된 파일의 원본 파일 이름과 컨텐츠 타입을 얻어옴
		String originalFileName = dto.getImgUpload().getOriginalFilename();
		String contentType = dto.getImgUpload().getContentType();
		
		// 파일을 저장하고 저장된 파일 이름을 얻어옴
		String storedFileName = fileComponent.upload(dto.getImgUpload());
		
		// ProfileDTO 객체를 생성하고 값 설정
		ProfileDTO profile = new ProfileDTO();
		profile.setContentType(contentType);
		profile.setOriginalFileName(originalFileName);
		profile.setStoredFileName(storedFileName);
		
		// 사진 정보를 데이터 베이스에 삽입
		memberDAO.insertProfile_img(profile);
		
		// 최신 사진 ID를 데이터베이스에서 조회
		int profileId = memberDAO.selectMaxProfileId();
		
		// MemberDTO에 사진 ID를 설정
		dto.setProfile_id(profileId);
		
		// 회원 정보를 업데이트하여 사진 ID를 추가
		memberDAO.updateMemberProfile(dto);
		
		// 저장된 파일 이름을 반환
		return storedFileName;
	}

	public int updateLocation(String location, int id) {
		return memberDAO.updateLocation(location, id);
	}

	public MemberDTO getUserByUserPw(String currentPw, int id) {
		MemberDTO userinfo = memberDAO.selectUserById(id);
	    if (userinfo != null) {
	    	String hash = hashComponent.getHash(userinfo.getSalt(), currentPw);
	    	if(hash.equals(userinfo.getHash())) {
	    		return userinfo;
	    	}
	    }
		return null;
	}

	public int updatePw(MemberDTO userInfo) {
		String salt = hashComponent.getRandomSalt();
	    String hash = hashComponent.getHash(salt, userInfo.getUserpw());  
	    
	    userInfo.setSalt(salt);  
	    userInfo.setHash(hash); 
	    
	    return memberDAO.updatePw(userInfo);  
	}

	public MemberDTO getReCheckUserid(String email) {
		MemberDTO user = memberDAO.checkByUserId(email);
//		System.out.println("User from UserIdDAO: " + user);
		return user;
	}

	public MemberDTO getReCheckEmail(String userid) {
		MemberDTO user = memberDAO.checkByEmail(userid);
//		System.out.println("User from EmailDAO: " + user);
		return user;
	}

	public List<BookingDTO> getMemberByBookingList(int id) {
		return memberDAO.selectMemberByBookingList(id);
	}

	public int insertAddLocation(SubLocationDTO dto) {
		return memberDAO.insertAddLocation(dto);
	}

	public boolean checkDuplicateLocation(SubLocationDTO dto) {
		try {
	        int count = memberDAO.checkDuplicateLocation(dto);
	        return count > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;  
	    }
	}
	
	public List<SubLocationDTO> getAddLocationList(int id) {
		return memberDAO.selectAddLocationList(id);
	}

	public int getDeleteAndLocation(int id) {
		int ret = memberDAO.deleteAddLocation(id);
		return ret;
	}

	public MemberDTO selectOne(int id) {
		return memberDAO.selectOne(id);
	}

	public int updateMemberLocation(SubLocationDTO dto) {
		return memberDAO.updateSubLocation(dto);
	}

	public MemberDTO selectOneBySubLocation(int id) {
		return memberDAO.selectOneBySubLocation(id);
	}	

}
