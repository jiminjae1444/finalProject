<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/review/view.css">

<div id="reviewModal" class="hidden">
	<div class="reviewModal_content">
		<h4 class="reviewModal_title">리뷰 작성하기</h4>
		<div class="reviewModal_detail">리뷰 내용</div>
		<p><button id="reviewModal_closeBtn">닫기</button></p>
	</div>
	<div class="reviewOverlay"></div>
</div>


<form id="addReview" class="hidden">
    <div class="addRating">
        <input type="radio" id="addStar1" name="rating" value="1"><label for="addStar1" class="addStar">&#9733;</label>
        <input type="radio" id="addStar2" name="rating" value="2"><label for="addStar2" class="addStar">&#9733;</label>
        <input type="radio" id="addStar3" name="rating" value="3"><label for="addStar3" class="addStar">&#9733;</label>
        <input type="radio" id="addStar4" name="rating" value="4"><label for="addStar4" class="addStar">&#9733;</label>
        <input type="radio" id="addStar5" name="rating" value="5"><label for="addStar5" class="addStar">&#9733;</label>
    </div>
	<p><textarea name="comments" placeholder="리뷰를 작성하세요" required></textarea></p>
	<p><input type="submit" value="등록"></p>
</form>

<div id="moveToHospitalInfo">
    <button id="moveToHospitalInfoBtn" onclick="location.href='${cpath}/hospitalInfo/${id}'">병원 페이지로 이동</button>
</div>
<div id="reviewListAll">
	<div id="review_container">
		<div id="review_header">
			<h3></h3>
			<div id="review_write">
				<button id="addReviewBtn">리뷰 작성</button>
			</div>
		</div>
		<div id="review_wrapper">
			<div class="review_none">
				<p>아직 리뷰가 없습니다. 첫 번째 리뷰를 작성해 주세요!</p>
			</div>
		</div>
	</div>
	<div id="review_footer">
		<button id="moreReview">더보기</button>
	</div>
</div>

<script src="${cpath}/resources/script/review/view.js"></script>
<script>
	const id = '${id}'
	const loginId = '${login.id}'
	let pageNo = 1
	const review_wrapper = document.getElementById('review_wrapper')
	const review_none = document.querySelector('.review_none')
	
	
	// 리뷰폼 별점 색상 변경 함수
	const addStars = document.querySelectorAll('.addRating input[type="radio"]')
	const labels = document.querySelectorAll('.addRating .addStar')
	addStars.forEach((star, index) => {
	    star.addEventListener('change', () => {
	        labels.forEach((label, idx) => {
	            // 색상을 기본값으로 초기화
	            if (idx <= index) {
	                label.style.color = '#f39c12' // 선택된 별에 색 추가
	            } else {
	                label.style.color = '#ddd' // 선택되지 않은 별 색상
	            }
	        })
	    })
	})
	const reviewModal_closeBtn = document.getElementById('reviewModal_closeBtn')
	reviewModal_closeBtn.onclick = closereviewModal

	const reviewOverlay = document.querySelector('#reviewModal > .reviewOverlay')
	reviewOverlay.onclick = closereviewModal

	const addReviewBtn = document.querySelector('#reviewListAll #addReviewBtn')
	addReviewBtn.onclick = addReviewHandler

	const addReview = document.getElementById('addReview')
	addReview.onsubmit = reviewSubmitHandler

	window.addEventListener('DOMContentLoaded', loadReviewListHandler)
	review_wrapper.addEventListener('click', deleteReviewHandler)

	const moreReview = document.getElementById('moreReview')
	moreReview.onclick = moreReviewHandler
</script>




</body>
</html>









