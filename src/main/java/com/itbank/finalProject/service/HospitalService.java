package com.itbank.finalProject.service;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.itbank.finalProject.Coordinates;
import com.itbank.finalProject.NaverMapCrawler;
import com.itbank.finalProject.model.HospitalDTO;
import com.itbank.finalProject.model.ReviewDTO;
import com.itbank.finalProject.model.RouteRequest;
import com.itbank.finalProject.repository.HospitalDAO;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class HospitalService {

    @Autowired
    HospitalDAO hospitalDAO;


    // 호준 파트
	public List<HospitalDTO> selectSidoList(int jinryo_code) {
		return hospitalDAO.selectSidoList(jinryo_code);
	}

	public List<HospitalDTO> selectGuList(int jinryo_code, int sido_code) {
		return hospitalDAO.selectGuList(jinryo_code, sido_code);
	}

	public List<HospitalDTO> selectHospitalList(int jinryo_code, int sido_code, int gu_code) {
		return hospitalDAO.selectHospitalList(jinryo_code, sido_code, gu_code);
	}

	public int getHospitalCnt(int jinryo_code, int sido_code, int gu_code) {
		return hospitalDAO.getHospitalCnt(jinryo_code, sido_code, gu_code);
	}

	public List<HospitalDTO> selectPagingHospitalList(int jinryo_code, int sido_code, int gu_code, int offset, int fetch) {
		return hospitalDAO.selectPagingHospitalList(jinryo_code, sido_code, gu_code, offset, fetch);
	}

    private NaverMapCrawler naverMapCrawler;

    public HospitalService(NaverMapCrawler naverMapCrawler) {
        this.naverMapCrawler = naverMapCrawler;
    }

    private static final String KAKAO_API_URL = "https://dapi.kakao.com/v2/local/search/address.json?query=";
    private static final String KAKAO_API_KEY = "KakaoAK 05acd6e5f72b451238de6cdeb951ade0"; // 실제 API 키로 교체해야 합니다.

    private static final String App_Key = "CvOK8yEzRB6thbfmODnO59W5yaDG7y9J4gI1sBLx";
    private static final String API_URL = "https://apis.openapi.sk.com/transit/routes";
    private static RestTemplate restTemplate = new RestTemplate();
    private static ObjectMapper objectMapper = new ObjectMapper();

    public static String getRoutes(RouteRequest routeRequest) throws JsonProcessingException {

        HashMap<String, String> requestBody = new HashMap<>();
        requestBody.put("startX", String.valueOf(routeRequest.getStartX()));
        requestBody.put("startY", String.valueOf(routeRequest.getStartY()));
        requestBody.put("endX", String.valueOf(routeRequest.getEndX()));
        requestBody.put("endY", String.valueOf(routeRequest.getEndY()));
        URI uri = URI.create(API_URL);
        HttpHeaders headers = new HttpHeaders();
        headers.set("accept", "application/json");
        headers.set("content-type", "application/json");
        headers.set("appKey", App_Key);
        RequestEntity<HashMap<String, String>> request = new RequestEntity<>(requestBody, headers, HttpMethod.POST, uri);
        ResponseEntity<String> response = restTemplate.exchange(request, String.class);
        return response.getBody();
    }

    @Transactional
    public List<HospitalDTO> getSearchResult(String search) {
        if (search == null || search.isEmpty()) {
            return null;  // 검색어가 없으면 null 반환
        }

        // 검색어를 분리하고 중복 제거
        List<String> searchList = Arrays.stream(search.split(","))
                .map(String::trim)
                .flatMap(kw -> Stream.of(kw, kw.replace(" ", "")))  //공백 제거
                .distinct()  //중복 제거
                .collect(Collectors.toList());

        // 병원 정보 조회
        List<HospitalDTO> bodyList = hospitalDAO.ContainsBodyList(searchList);
        List<HospitalDTO> finalResult = null;

        if (!bodyList.isEmpty()) {
            // 부위가 포함되어 있으면
            List<HospitalDTO> symptomsList = hospitalDAO.getHospitalsByKeywords(searchList);
            symptomsList.addAll(bodyList);

            // 중복 제거 후 최종 결과 리스트 생성
            Set<HospitalDTO> resultSet = new HashSet<>(symptomsList);
            finalResult = new ArrayList<>(resultSet);
        } else {
            // 부위 결과가 없으면 증상 검색 결과만 가져오기
            finalResult = hospitalDAO.getHospitalsByKeywords(searchList);
        }

        // 검색 결과가 있을 때만 검색어를 DB에 저장
        if (finalResult != null && !finalResult.isEmpty()) {
            for (String kw : searchList) {
                hospitalDAO.insertKeyword(kw);
            }
        }

        // 결과가 없으면 null 반환, 있으면 최종 결과 반환
        return finalResult.isEmpty() ? null : finalResult;
    }


    @Transactional
    public List<HospitalDTO> getSearchResultHospital(String hospital) {
        if (hospital != null && !hospital.isEmpty()) {
            hospitalDAO.insertKeyword(hospital);
            String normalizedHospital = hospital.replaceAll(" ", "");
            return hospitalDAO.getHospitalsByName(normalizedHospital);
        } else {
            return null;
        }
    }

    public void getSetList() throws JsonProcessingException, UnsupportedEncodingException {
        List<HospitalDTO> nullList = hospitalDAO.getNullList();
        for (HospitalDTO hospital : nullList) {
            String[] addressParts = hospital.getAddress().split(" ");
            // 0부터 3까지의 요소를 조합
            String finalAddress = String.join(" ", Arrays.copyOfRange(addressParts, 0, Math.min(addressParts.length, 4)));
            finalAddress = finalAddress.replace(",", "");
            // 최종 주소 사용
//            System.out.println(finalAddress); // 결과 확인
            // 주소를 좌표로 변환
            Coordinates coordinates = getCoordinatesFromAddress(finalAddress);
            if (coordinates != null) {
                // 좌표가 유효한 경우 병원 객체에 저장
                hospital.setLat(coordinates.getLatitude());
                hospital.setLng(coordinates.getLongitude());
                hospitalDAO.updateLatAndLng(hospital);
            }
        }

    }

    private Coordinates getCoordinatesFromAddress(String finalAddress) {
        try {
            String encodedAddress = URLEncoder.encode(finalAddress, "UTF-8");
            String urlString = KAKAO_API_URL + encodedAddress;
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", KAKAO_API_KEY);

            // URL 객체 생성
            URI url = new URI(urlString);

            // RequestEntity 생성: 헤더, HTTP 메서드(GET), URL을 포함
            RequestEntity<String> entity = new RequestEntity<String>(headers, HttpMethod.GET, url);

            // RestTemplate을 사용하여 API 호출 (RequestEntity를 사용)
            ResponseEntity<String> response = restTemplate.exchange(entity, String.class);

//            System.out.println(response.getBody());
            if (response.getStatusCode().is2xxSuccessful()) {
                JsonNode jsonResponse = objectMapper.readTree(response.getBody());
                if (jsonResponse.get("documents").isArray() && jsonResponse.get("documents").size() > 0) {
                    JsonNode location = jsonResponse.get("documents").get(0);
                    double lat = location.get("y").asDouble();
                    double lng = location.get("x").asDouble();
                    return new Coordinates(lat, lng);
                }
            } else {
                // 실패한 경우 로깅 처리
                System.err.println("API 호출 실패: " + response.getStatusCode());
            }
        } catch (Exception e) {
            e.printStackTrace(); // 예외 처리
        }
        return null;
    }

    public List<HospitalDTO> selectAllList() {
        return hospitalDAO.selectAllList();
    }

    // 병원 이미지 조회 메소드
    public String getHospitalImage(int hospitalId, HttpSession session, HttpServletRequest request) throws UnsupportedEncodingException {
        // 세션에서 이미 캐시된 이미지 URL을 가져오기
        String cachedImageUrl = (String) session.getAttribute("hospitalImage_" + hospitalId);
//        System.out.println(hospitalId);
        // 캐시된 이미지 URL이 있으면 반환
        if (cachedImageUrl != null) {
            return cachedImageUrl;  // 세션에서 캐시된 이미지 URL 반환
        }

        // 세션에 캐시된 이미지 URL이 없으면 크롤링
        HospitalDTO hospitalDTO = hospitalDAO.getHospitalInfo(hospitalId);
        String gu_name = hospitalDTO.getGu_name();
        String hospital_name = hospitalDTO.getHospital_name();
        String imageUrl = naverMapCrawler.getImageFromNaverMap(gu_name, hospital_name, request);

        // 세션에 이미지 URL 저장
        session.setAttribute("hospitalImage_" + hospitalId, imageUrl);

        return imageUrl;
    }

    @Transactional
    public HospitalDTO getInfo(int id, HttpSession session, HttpServletRequest request) throws UnsupportedEncodingException {
        hospitalDAO.updateViewCount(id);
        HospitalDTO hospitalDTO = hospitalDAO.getHospitalInfo(id);
//        System.out.println("hospitalDTO : " + hospitalDTO);
        String imageUrl = getHospitalImage(hospitalDTO.getId(), session, request);
//        System.out.println(imageUrl);
        hospitalDTO.setImageUrl(imageUrl);
        return hospitalDTO;
    }

    public List<String> getJinryoNames(int id) {
        return hospitalDAO.getJinryoNames(id);
    }


    public HospitalDTO getHospitalNameAndTreatmentById(int id) {
        HospitalDTO hospitalName = hospitalDAO.findHospitalNameById(id);
        return hospitalName;
    }

    public List<HospitalDTO> getList() {
        return hospitalDAO.getList();
    }

    public String getEmergenncy() throws UnsupportedEncodingException {
        String url = "https://apis.data.go.kr/B552657/ErmctInfoInqireService/getEmrrmRltmUsefulSckbdInfoInqire?";

        // 서비스 키와 다른 파라미터 값을 수동으로 URL에 포함
        String serviceKey = "%2BD%2FWK9AfmebcZS%2FYFo%2B4drtIEYUTdwUAlx5jGj36NLoKY6FNjTMbQAP86hQIModFZjKS6WmFxX%2FMj7J5pewMow%3D%3D";
        int numOfRows = 10000;

        // 쿼리 문자열을 수동으로 생성
        String queryString = "serviceKey=" + serviceKey + "&numOfRows=" + numOfRows;

//        log.info(url + queryString);  // URL 확인용 로그 출력

        // 최종 URL 생성
        URI uri = URI.create(url + queryString);

        // HTTP 요청 준비
        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json");
        RequestEntity<String> request = new RequestEntity<>(headers, HttpMethod.GET, uri);

        // API 요청 보내기
        ResponseEntity<String> response = restTemplate.exchange(request, String.class);

        return response.getBody();
    }

    public List<ReviewDTO> getReviewToHomepage() {
    	List<ReviewDTO> homeReviewList = hospitalDAO.getReviewToHomepage();
    	for(ReviewDTO homeReview : homeReviewList) {
    		String userid = homeReview.getUserid();
			if(userid == null) return null;
			userid = userid.substring(0, 3) + "***";
			homeReview.setUserid(userid);
    	}
		return homeReviewList;
	}
    
}