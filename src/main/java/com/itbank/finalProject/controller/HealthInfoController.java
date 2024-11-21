package com.itbank.finalProject.controller;


import java.net.URI;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import org.springframework.http.HttpHeaders;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.log4j.Log4j;

@RestController
@Log4j
public class HealthInfoController {
	
	private final String clientId = "F_vKvpTdCT1lV1F44aXr";
	private final String clientSecret = "fhTzEHrlD3";
	private RestTemplate template = new RestTemplate();
	ObjectMapper mapper = new ObjectMapper();
	
	@GetMapping(value="/naverBlogSearch/{search}/{number}", produces = "application/json; charset=utf-8")
	public ResponseEntity<Map<String, Object>> naverBlogSearch(@PathVariable("search") String search, @PathVariable("number") int number) throws Exception {
		String encodedQuery = URLEncoder.encode(search, "UTF-8");
	    String url = "https://openapi.naver.com/v1/search/blog.json?query=" + encodedQuery + "&display=" + number + "&start=1&sort=sim";
	    URI uri = new URI(url);
	    log.info(search);
	    HttpHeaders headers = new HttpHeaders();
	    headers.set("X-Naver-Client-Id", clientId);
	    headers.set("X-Naver-Client-Secret", clientSecret);
	    headers.set("Content-Type", "application/json; charset=utf-8");
	    
	    RequestEntity<?> request = RequestEntity
	    	    .get(uri)
	    	    .headers(headers)
	    	    .build();
	    ResponseEntity<String> response = template.exchange(request, String.class);
	    
	    ObjectMapper mapper = new ObjectMapper();
	    JsonNode root = mapper.readTree(response.getBody());
	    
	    // Extract total count and items
	    int totalCount = root.get("total").asInt(); // Get total count
	    JsonNode items = root.get("items"); // Get items

	    // Create a response map to return both total count and items
	    Map<String, Object> responseMap = new HashMap<>();
	    responseMap.put("total", totalCount);
	    responseMap.put("items", items);

	    return ResponseEntity.ok(responseMap);
	}
	
}
