<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
	.review_view {
		display: flex;
		padding: 10px 0;
		border-bottom: 1px solid #eee;
	}
	.review_profile_img {
		margin: 20px;
	}
	.review_info {
		display: flex;
	}
	.review_userid {
		margin-right: 10px;
	}
	.review_created_at {
		margin-left: 10px;
	}
	.review_rating div {
		display: flex;
		align-items: center;
	}
	.review_rating img {
		width: 23px;
	}
	
	#modal > .modal_content {
		position: fixed;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		background-color: white;
		border-radius: 10px;
		width: 500px;
		height: 350px;
		z-index: 1;
		
		display: flex;
		flex-flow: column;
		justify-content: space-around;
		align-items: center;
	}
	#modal > .overlay {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: rgba(0, 0, 0, 0.5);
	}
	.hidden {
		display: none;
	}
</style>


<div id="modal" class="hidden">
	<div class="modal_content">
		<h4 class="modal_title">리뷰 쓰기</h4>
		<div class="modal_detail">리뷰 내용</div>
		<p><button id="modal_closeBtn">닫기</button></p>
	</div>
	<div class="overlay"></div>
</div>

<p><button id="addReviewBtn">리뷰 쓰기</button></p>

<form id="addReview" class="hidden">
	<p>
		<input type="number" name="hospital_id" value="${id }" required readonly>
		<input type="number" name="member_id" placeholder="1~3 중에 입력하면됨" required>
	</p>
	<p><input type="number" name="rating" placeholder="별점" min="0" max="5" required></p>
	<p><textarea name="comments" placeholder="리뷰를 작성하세요" rows="5" cols="40" required></textarea></p>
	<p><input type="submit" value="등록"></p>
</form>

<h3>리뷰 전체 [${reviewCnt }]</h3>

<div id="reviewListAll">
</div>

<button id="moreReview">더보기</button>

<script>
	const id = '${id}'
	
	// 제목, 내용 전달 받아서 모달 열기
	function openModal(title, detail) {
		const titleElement = document.querySelector('#modal > div.modal_content > .modal_title')
		const detailElement = document.querySelector('#modal > div.modal_content > .modal_detail')
// 		console.log(typeof(detail))
		
		titleElement.innerHTML = title
		
		if(typeof(detail) == 'string') {
			detailElement.innerHTML = detail
		}
		else {
			detailElement.innerHTML = ''
			detail.classList.remove('hidden')
			detailElement.appendChild(detail)
		}
		document.getElementById('modal').classList.remove('hidden')
	}
	
	
	// 모달 닫기 (form 태그 숨기기)
	function closeModal() {
		document.getElementById('modal').classList.add('hidden')
		document.body.appendChild(document.forms[0])
		document.getElementById('addReview').classList.add('hidden')
	}
	const modal_closeBtn = document.getElementById('modal_closeBtn')
	modal_closeBtn.onclick = closeModal
	const overlay = document.querySelector('#modal > .overlay')
	overlay.onclick = closeModal
	
	
	// 리뷰작성 모달 열기
	function addReviewHandler() {
		const addReview = document.forms[0]
		const title = '리뷰 작성'
		const detail = addReview
		addReview.classList.remove('hidden')
		openModal(title, detail)
	}
	const addReviewBtn = document.getElementById('addReviewBtn')
	addReviewBtn.onclick = addReviewHandler
	
	
	// 리뷰작성 작동 함수
	async function reviewSubmitHandler(event) {
		event.preventDefault()
		const formData = new FormData(event.target)
		
		const url = cpath + '/reviews/' + id + '/write'
		const opt = {
			method: 'POST',
			body: formData,
		}
		const row = await fetch(url, opt).then(resp => resp.json())
// 		console.log(row)
		
		if(row != 0) {
			alert('리뷰 작성 완료')
			event.target.reset()
			closeModal()
			pageNo = 1
			reviewContainer.innerHTML = ''
			await loadReviewListHandler()
		}
		else {
			alert('리뷰 작성 실패')
		}
	}
	const addReview = document.getElementById('addReview')
	addReview.onsubmit = reviewSubmitHandler
	
	
	// 초기화면에서 최신 리뷰 10개 불러오기
	let pageNo = 1
	const reviewContainer = document.getElementById('reviewListAll')
	
	async function loadReviewListHandler() {
		const url = cpath + '/reviews/' + id + '?pageNo=' + pageNo
		const view = await fetch(url).then(resp => resp.json())
// 		console.log(view)

		if(view.length < 10) {
			document.getElementById('moreReview').classList.add('hidden')
		}
		
		view.forEach(review => {
// 			console.log(review)
			let tag = '<div class="review_view">'
			tag += '	<div class="review_profile_img">'
			tag += '		<div>' + review.PROFILE_IMG + '</div>'
			tag += '	</div>'
			tag += '	<div class="review_contents">'
			tag += '		<div class="review_info">'
			tag += '			<div class="review_userid">' + review.USERID + '</div>'
			tag += '			<div>|</div>'
			tag += '			<div class="review_created_at">' + review.CREATED_AT + '</div>'
			tag += '		</div>'
			tag += '		<div class="review_rating">'
			tag += '			<div><img src="${cpath }/resources/image/star-icon.png">' + review.RATING + '</div>'
			tag += '		</div>'
			tag += '		<div class="review_comments">'
			tag += '			<div>' + review.COMMENTS + '</div>'
			tag += '		</div>'
			tag += '	</div>'
			tag += '	<div class="review_delete">'
			tag += '		<button class="deleteReviewBtn" data-reviewId="' + review.ID + '">삭제</button>'
			tag += '	</div>'
			tag += '</div><br>'
			reviewContainer.innerHTML += tag
		})
	}
	window.addEventListener('DOMContentLoaded', loadReviewListHandler)
	
	
	// 리뷰 삭제
	async function deleteReviewHandler(event) {
		if(event.target.classList.contains('deleteReviewBtn')) {
			const reviewId = event.target.getAttribute('data-reviewId')
			console.log(reviewId)
			const url = cpath + '/reviews/' + id + '/delete/' + reviewId
			const opt = {
				method: 'DELETE'
			}
			const row = await fetch(url, opt).then(resp => resp.json())
			console.log(row)
			
			if(row != 0) {
				alert('리뷰 삭제 완료')
				pageNo = 1
				reviewContainer.innerHTML = ''
				await loadReviewListHandler()
			}
			else {
				alert('리뷰 삭제 실패')
			}
			
		}
	}
	reviewContainer.addEventListener('click', deleteReviewHandler)
	
	
	// 더보기 클릭할 때마다 리뷰 10개씩 갱신
	async function moreReviewHandler() {
		pageNo++
		await loadReviewListHandler()
	}
	const moreReview = document.getElementById('moreReview')
	moreReview.onclick = moreReviewHandler
	
	
	
</script>




</body>
</html>









