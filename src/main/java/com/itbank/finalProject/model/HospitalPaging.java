package com.itbank.finalProject.model;

// 게시글의 페이징을 처리하기 위한 값을 생성하는 객체 (스프링빈이 아님)

public class HospitalPaging {
	
	private int pageNo;				// 쿼리스트링 pageNo
	private int offset;				// 전체에서 시작부분 레코드 건너뛸 개수
	private int fetch = 6;			// 불러올 데이터의 개수
	private int hospitalCnt;			// 전체 데이터 개수
	private int pageCnt;			// 페이지로 나누었을 때, 페이지의 개수
	
	private int pagePerPage = 10;	// 한 페이지에 출력할 페이지 번호의 개수
	private int section;			// 현재 페이지 번호 몇번째 섹션에 위치하는지
	private int begin;				// 화면에 출력할 페이지 번호의 시작
	private int end;				// 화면에 출력할 페이지 번호의 끝
	private boolean prev;			// 이전 페이지 버튼 출력 여부
	private boolean next;			// 다음 페이지 버튼 출력 여부
	
	private String search;			// 검색어

	public HospitalPaging(int pageNo, int hospitalCnt) {
		this.pageNo = pageNo;
		this.offset = fetch * (pageNo - 1);
		
		this.hospitalCnt = hospitalCnt;
		this.pageCnt = hospitalCnt / fetch;
		if(hospitalCnt % fetch != 0) {
			pageCnt += 1;
		}
		
		section = (pageNo - 1) / pagePerPage;
		begin = section * pagePerPage + 1;
		end = begin + pagePerPage - 1;
		if(end > pageCnt) {
			end = pageCnt;
		}
		prev = section != 0;
		next = end != pageCnt; 
	}
	
	public int gethospitalCnt() {
		return hospitalCnt;
	}

	public void sethospitalCnt(int hospitalCnt) {
		this.hospitalCnt = hospitalCnt;
	}

	public int getPageCnt() {
		return pageCnt;
	}

	public void setPageCnt(int pageCnt) {
		this.pageCnt = pageCnt;
	}
	public int getPageNo() {
		return pageNo;
	}
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	public int getOffset() {
		return offset;
	}
	public void setOffset(int offset) {
		this.offset = offset;
	}
	public int getFetch() {
		return fetch;
	}
	public void setFetch(int fetch) {
		this.fetch = fetch;
	}

	public int getPagePerPage() {
		return pagePerPage;
	}

	public void setPagePerPage(int pagePerPage) {
		this.pagePerPage = pagePerPage;
	}

	public int getSection() {
		return section;
	}

	public void setSection(int section) {
		this.section = section;
	}

	public int getBegin() {
		return begin;
	}

	public void setBegin(int begin) {
		this.begin = begin;
	}

	public int getEnd() {
		return end;
	}

	public void setEnd(int end) {
		this.end = end;
	}

	public boolean isPrev() {
		return prev;
	}

	public void setPrev(boolean prev) {
		this.prev = prev;
	}

	public boolean isNext() {
		return next;
	}

	public void setNext(boolean next) {
		this.next = next;
	}

	public String getSearch() {
		return search;
	}

	public void setSearch(String search) {
		this.search = search;
	}
	
	
}
