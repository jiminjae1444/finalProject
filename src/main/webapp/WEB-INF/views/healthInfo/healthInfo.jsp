<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@	include file="../header.jsp" %>

<link rel="stylesheet" href="${cpath}/resources/css/healthInfo.css">

<div class="search-container">
	<!-- 카테고리 영역 -->
	<div class="category-section">
		<h3>카테고리</h3>
		<div class="category-list">
			<div class="item" data-id="${login.location.substring(0, 6) } 내과">
				<img src="${cpath }/resources/healthCategory/내과.png">
				<h4>내과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 신경과">
				<img src="${cpath }/resources/healthCategory/신경과.png">
				<h4>신경과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 정신건강의학과">
				<img src="${cpath }/resources/healthCategory/정신건강의학과.png">
				<h4>정신건강의학과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 외과">
				<img src="${cpath }/resources/healthCategory/외과.png">
				<h4>외과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 정형외과">
				<img src="${cpath }/resources/healthCategory/정형외과.png">
				<h4>정형외과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 신경외과">
				<img src="${cpath }/resources/healthCategory/신경외과.png">
				<h4>신경외과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 성형외과">
				<img src="${cpath }/resources/healthCategory/성형외과.png">
				<h4>성형외과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 마취통증의학과">
				<img src="${cpath }/resources/healthCategory/마취통증의학과.png">
				<h4>마취통증의학과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 산부인과">
				<img src="${cpath }/resources/healthCategory/산부인과.png">
				<h4>산부인과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 소아청소년과">
				<img src="${cpath }/resources/healthCategory/소아청소년과.png">
				<h4>소아청소년과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 안과">
				<img src="${cpath }/resources/healthCategory/안과.png">
				<h4>안과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 이비인후과">
				<img src="${cpath }/resources/healthCategory/이비인후과.png">
				<h4>이비인후과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6)} 피부과">
				<img src="${cpath }/resources/healthCategory/피부과.png">
				<h4>피부과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 비뇨기과">
				<img src="${cpath }/resources/healthCategory/비뇨기과.png">
				<h4>비뇨기과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 치과">
				<img src="${cpath }/resources/healthCategory/치과.png">
				<h4>치과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 한의원">
				<img src="${cpath }/resources/healthCategory/한의원.png">
				<h4>한의원</h4>
			</div>
		</div>
	</div>

	<!-- 검색 결과 영역 -->
	<div class="results-section">
		<h3>검색 결과</h3>
		<div id="results">
			<p>카테고리를 선택하면 결과가 표시됩니다.</p>
		</div>
	</div>
</div>

<%@ include file="../footer.jsp" %>
<script src="${cpath}/resources/script/healthInfo.js"></script>
<script>
    const results = document.getElementById('results')
    const categoryItems = document.querySelectorAll('.category-list .item')
    categoryItems.forEach((item) => {
        item.onclick = (event) => {
            // 모든 카테고리에서 'selected' 클래스 제거
            categoryItems.forEach(i => i.classList.remove('selected'));
            
            // 클릭된 카테고리에 'selected' 클래스 추가
            event.currentTarget.classList.add('selected');
            
            const search = event.currentTarget.dataset.id
            fetchBlogResults(search, 10)
        }
    })
    results.addEventListener('click', (event) => {
        if (event.target.id === 'moreBlog') {
            const search = event.target.dataset.id
            const number = parseInt(event.target.dataset.number) + 10
            fetchBlogResults(search, number)
        }
    })
</script>

</body>
</html>