<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
	body{
        background: linear-gradient(to bottom,#2c3e50, #a4a4a4);
    }
    #moveToHospitalInfo {
    	max-width: 800px;
	    text-align: right;
	    margin: 30px auto;
	}
	#moveToHospitalInfoBtn {
	    background-color: #ffffff;
	    color: #2c3e50;
	    font-weight: bold;
	    padding: 10px 20px;
	    border: none;
	    border-radius: 5px;
	    font-size: 14px;
	    cursor: pointer;
	    transition: background-color 0.3s, transform 0.2s;
	}
	#moveToHospitalInfoBtn:hover {
	    background-color: #f7f9fa;
	    transform: translateY(-2px);
	}

    
    #review_write {
    	text-align: right;
    }
    
    #addReviewBtn {
        background-color: #2c3e50;
        color: #ffffff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.3s, transform 0.2s;
        
	    pointer-events: auto;
	    opacity: 1;
    }
    #addReviewBtn:hover {
	    background-color: #34495e;
	    transform: translateY(-2px);
	}
    
    /* 리뷰 리스트 전체 섹션 */
    #reviewListAll {
        margin: auto;
        margin-bottom: 50px;
        padding: 20px;
        background-color: #f7f9fa;
        max-width: 800px;
        border-radius: 10px;
    }
    
    #reviewListAll h3 {
    	font-size: 20px;
    	color: #34495e;
    }
    
    /* 리뷰 없을 때 */
    .review_none {
        text-align: center;
        font-size: 16px;
        color: #666;
        padding: 30px;
        background-color: #f9f9f9;
        border-radius: 10px;
        border: 1px solid #ddd;
        margin-top: 50px;
    }
    
    #review_header {
    	display: flex;
    	align-items: center;
    	line-height: 40px;
    	justify-content: space-between;
    }
    
    #review_header img {
    	width: 25px;
    	align-items: center;
    	vertical-align: middle;
    	margin-bottom: 3px;
    	margin-left: 8px;
    	margin-right: 3px;
    }

    /* 개별 리뷰 카드 */
    .review_view {
        display: flex;
        flex-direction: column;
        background-color: #ffffff;
        padding: 15px;
        margin-bottom: 15px;
        border-radius: 10px;
        box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
    }

    /* 프로필 이미지 섹션 */
    .review_profile_img {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
    }

    .review_profile_img img {
        width: 50px;
        height: 50px;
        border-radius: 50%;
    }

    /* 리뷰 내용 섹션 */
    .review_contents {
        display: flex;
        flex-direction: column;
    }

    /* 리뷰 정보 (아이디, 날짜) */
    .review_info {
        display: flex;
        align-items: center;
        font-size: 14px;
        color: #34495e;
        margin-bottom: 10px;
    }

    .review_userid {
        font-weight: bold;
    }

    .review_created_at {
        margin-left: 5px;
        color: #7f8c8d;
    }

    .review_info div {
        margin-right: 5px;
    }

    /* 별점 섹션 */
    .review_rating {
        font-size: 16px;
        font-weight: bold;
        color: #f39c12;
        margin-bottom: 10px;
    }

    /* 리뷰 댓글 섹션 */
    .review_comments {
        font-size: 16px;
        color: #2c3e50;
        margin-top: 5px;
    }

    /* 삭제 버튼 */
    .review_delete {
        margin-top: 10px;
        display: flex;
        justify-content: flex-end;
    }

    .review_delete .deleteReviewBtn {
        background-color: #e74c3c;
        color: #ffffff;
        padding: 5px 10px;
        border: none;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .review_delete .deleteReviewBtn:hover {
        background-color: #c0392b;
    }

    /* 더보기 버튼 */
    #moreReview {
        display: block;
        margin: 20px auto;
        background-color: #2c3e50;
        color: #ffffff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.3s, transform 0.2s;
    }

    #moreReview:hover {
        background-color: #34495e;
        transform: translateY(-2px);
    }
    
    
    /* 리뷰 모달 스타일 */
    #reviewModal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }    
    
    .reviewOverlay {
        position: absolute;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5); /* 반투명한 검은색 배경 */
    }
    
	.reviewModal_content {
	    position: relative;
	    background-color: white;
	    padding: 30px;
	    border-radius: 15px;
	    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
	    z-index: 5;
	    max-width: 500px;
	    width: 90%;
	    max-height: 80vh;
	    overflow-y: auto;
	    scrollbar-width: none; /* Firefox */
	    -ms-overflow-style: none; /* Internet Explorer 10+ */
	}
	
	.reviewModal_content::-webkit-scrollbar {
	    display: none; /* WebKit */
	}
	
	.reviewModal_title {
	    font-size: 24px;
	    color: #2c3e50;
	    text-align: center;
	    font-weight: 600;
	}
	
	.reviewModal_detail {
	    margin-bottom: 10px;
	}
	
	#reviewModal_closeBtn {
	    position: absolute;
	    top: 10px;
	    right: 10px;
	    background-color: #ff4d4d;
	    color: white;
	    border: none;
	    border-radius: 5px;
	    padding: 5px 10px;
	    font-size: 16px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: background-color 0.3s ease, transform 0.2s ease;
	    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	}
	
	#reviewModal_closeBtn:hover {
	    background-color: #ff3333;
	    transform: translateY(-2px);
	    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
	}
	
	#reviewModal_closeBtn:active {
	    transform: translateY(0);
	    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}
	
	/* 애니메이션 효과 */
	@keyframes fadeIn {
	    from { opacity: 0; transform: translateY(-20px); }
	    to { opacity: 1; transform: translateY(0); }
	}
	
	.reviewModal_content {
	    animation: fadeIn 0.3s ease-out;
	}
	
	/* 반응형 디자인을 위한 미디어 쿼리 */
	@media (max-width: 600px) {
	    .reviewModal_content {
	        padding: 25px;
	        width: 95%;
	    }
	    .reviewModal_title {
	        font-size: 20px;
	    }
	}
	
	
	/* 리뷰 작성 폼 스타일 */
	#addReview input[type="number"],
	#addReview textarea {
		box-sizing: border-box;
	    width: 100%;
	    height: 100px;
	    padding: 10px;s
	    border: 1px solid #ddd;
	    border-radius: 8px;
	    font-size: 16px;
	    color: #333;
	    margin-bottom: 15px;
	}
	
	#addReview input[type="submit"] {
	    width: 100%;
	    padding: 12px;
	    background-color: #2c3e50;
	    color: white;
	    border: none;
	    border-radius: 8px;
	    font-size: 18px;
	    font-weight: 600;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}
	
	#addReview input[type="submit"]:hover {
	    background-color: #34495e;
	}
	
	/* 리뷰 작성 폼 필드 스타일 */
	#addReview textarea {
	    resize: vertical;
	}
	
	
	/* 별 스타일 */
	.addRating {
	    display: flex;
	    justify-content: center;
	    gap: 5px;
	}
	
	input[type="radio"] {
	    display: none; /* 실제 radio 버튼은 숨깁니다 */
	}
	
	.addStar {
	    font-size: 30px;
	    color: #ddd; /* 기본 회색 */
	    cursor: pointer;
	    transition: color 0.3s ease;
	}
	
	/* 체크된 별과 그 전까지의 별을 색칠 */
	input[type="radio"]:checked ~ .addStar,
	input[type="radio"]:checked + .addStar,
	input[type="radio"]:checked + .addStar + .addStar,
	input[type="radio"]:checked + .addStar + .addStar + .addStar,
	input[type="radio"]:checked + .addStar + .addStar + .addStar + .addStar {
	    color: #f39c12; /* 선택된 별 색상 */
	}
	
	/* 마우스 호버 시 색상 변경 */
	input[type="radio"]:not(:checked) ~ .addStar:hover {
	    color: #f39c12; /* 마우스 호버 상태 */
	}
	
	.addStar:hover {
	    color: #f39c12;
	}

</style>
    

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
	
	
	// 리뷰폼 별점 색상 리셋 함수
	function resetStars() {
	    const addStars = document.querySelectorAll('input[name="rating"]')
	    const labels = document.querySelectorAll('label.addStar')
	    addStars.forEach(star => star.checked = false) 		// 모든 별 초기화
	    labels.forEach(label => label.style.color = '#ddd') // 색상 초기화
	}
	
	
	// 제목, 내용 전달 받아서 모달 열기
	function openReviewModal(title, detail) {
		resetStars()	
		const titleElement = document.querySelector('#reviewModal > div.reviewModal_content > .reviewModal_title')
		const detailElement = document.querySelector('#reviewModal > div.reviewModal_content > .reviewModal_detail')
		titleElement.innerHTML = title
		if(typeof(detail) == 'string') {
			detailElement.innerHTML = detail
		}
		else {
			detailElement.innerHTML = ''
			detail.classList.remove('hidden')
			detailElement.appendChild(detail)
		}
		document.getElementById('reviewModal').classList.remove('hidden')
	}
	
	
	// 모달 닫기 (form 태그 숨기기)
	function closereviewModal() {
		document.getElementById('reviewModal').classList.add('hidden')
		document.body.appendChild(document.getElementById('addReview'))
		document.getElementById('addReview').classList.add('hidden')
	}
	const reviewModal_closeBtn = document.getElementById('reviewModal_closeBtn')
	reviewModal_closeBtn.onclick = closereviewModal
	const reviewOverlay = document.querySelector('#reviewModal > .reviewOverlay')
	reviewOverlay.onclick = closereviewModal
	
	
	// 리뷰 작성
	async function addReviewHandler() {
		if(!loginId) {
			swal({
				title: '비회원 리뷰 작성 불가',
				text: '로그인 화면으로 이동하시겠습니까?',
				type: 'info',
				showCancelButton: true,
				confirmButtonText: '예',
	 			cancelButtonText: '아니오',
	 			closeOnConfirm: false,
	 			closeOnCancel: true,
	 		}, function(isConfirm) {
	 			if(isConfirm) {
	 				location.href = '${cpath}/member/login'
	 			}
	        })
		}
		else {
			const url = cpath + '/reviews/checkReview/' + loginId + '/' + id
			const result = await fetch(url).then(resp => resp.json())
			const visitCount = result.visitCount
			const reviewCount = result.reviewCount
			
	        if(visitCount > 0 && reviewCount < visitCount) {
				
				const addReview = document.getElementById('addReview')
				const title = '리뷰 작성하기'
				const detail = addReview
				addReview.classList.remove('hidden')
				openReviewModal(title, detail)
	        }
	        else if(visitCount == 0) {
	            swal({
	                title: '리뷰 작성 불가',
	                text: '방문 기록이 없습니다. 2주 이내 방문 후 리뷰 작성이 가능합니다.',
	                type: 'error',
	                button: '확인'
	            })
	        }
	        else {
	            swal({
	                title: '리뷰 작성 불가',
	                text: '방문일로부터 2주 이내에만 작성 가능하며, 동일 방문에 대해 1개만 작성하실 수 있습니다.',
	                type: 'error',
	                button: '확인'
	            })
	        }
		}
	}
	const addReviewBtn = document.querySelector('#reviewListAll #addReviewBtn')
	addReviewBtn.onclick = addReviewHandler
	
	
	// 리뷰작성 작동 함수
	async function reviewSubmitHandler(event) {
		event.preventDefault()
		const formData = new FormData(event.target)
		formData.append('hospital_id', id)
		formData.append('member_id', loginId)
		
		const url = cpath + '/reviews/' + id + '/write'
		const opt = {
			method: 'POST',
			body: formData,
		}
		const row = await fetch(url, opt).then(resp => resp.json())
		if(row != 0) {
			event.target.reset()
			closereviewModal()
			pageNo = 1
			review_wrapper.innerHTML = ''
			await loadReviewListHandler()
		    swal({
		        title: '리뷰 작성 성공',
		        text: '리뷰가 성공적으로 등록되었습니다.',
		        type: 'success',
		        button: '확인'
		    })
		}
		else {
			swal({
		        title: '리뷰 작성 실패',
		        text: '리뷰 작성에 실패했습니다. 다시 시도해 주세요.',
		        type: 'error',
		        button: '확인'
		    })
		}
	}
	const addReview = document.getElementById('addReview')
	addReview.onsubmit = reviewSubmitHandler
	
			
	
	// 초기화면에서 최신 리뷰 10개 불러오기
	async function loadReviewListHandler() {
		const listUrl = cpath + '/reviews/' + id + '?pageNo=' + pageNo
		const list = await fetch(listUrl).then(resp => resp.json())
		if(list.length >= 1) {
			review_none.classList.add('hidden')
			if(list.length < 10) {
				document.getElementById('moreReview').classList.add('hidden')
			}
			const url = cpath + '/reviews/reviewCount/' + id
			const result = await fetch(url).then(resp => resp.json())
			const h3 = document.querySelector('#reviewListAll h3')
			h3.innerHTML = '전체 리뷰 (' + result.count + ') <img src="${cpath}/resources/image/star-icon.png">' + result.avg 
			
			list.forEach(review => {
				const profileImg = review.PROFILE_IMG != null ? review.PROFILE_IMG : 'default.png'
				const stars = '★'.repeat(review.RATING) + '☆'.repeat(5 - review.RATING)
				let tag = '<div class="review_view">'
				tag += '	<div class="review_profile_img">'
				tag += '		<div><img src="${cpath}/fpupload/image/' + profileImg + '" width="50" height="50"></div>'
				tag += '	</div>'
				tag += '	<div class="review_contents">'
				tag += '		<div class="review_info">'
				tag += '			<div class="review_userid">' + review.USERID + '</div>'
				tag += '			<div>|</div>'
				tag += '			<div class="review_created_at">' + review.CREATED_AT + '</div>'
				tag += '		</div>'
				tag += '		<div class="review_rating">'
				tag += '			<div>' + stars + '</div>'
				tag += '		</div>'
				tag += '		<div class="review_comments">'
				tag += '			<div>' + review.COMMENTS + '</div>'
				tag += '		</div>'
				tag += '	</div>'
				if(loginId && loginId == review.MEMBER_ID) {
					tag += '	<div class="review_delete">'
	            	tag += '	<button class="deleteReviewBtn" data-reviewId="' + review.ID + '">삭제</button>'
					tag += '	</div>'
		        }
				tag += '</div>'
				review_wrapper.innerHTML += tag
			})
		}
	}
	window.addEventListener('DOMContentLoaded', loadReviewListHandler)
	
	
	// 리뷰 삭제
	async function deleteReviewHandler(event) {
	    if(event.target.classList.contains('deleteReviewBtn')) {
	        const reviewId = event.target.getAttribute('data-reviewId')
	        swal({
	            title: '정말 삭제하시겠습니까?',
	            text: '삭제 후에는 복구할 수 없습니다.',
	            type: 'warning',
	            showCancelButton: true,
	            confirmButtonText: '예',
	            cancelButtonText: '아니오',
	            closeOnConfirm: false,
	            closeOnCancel: true
	        }, async function(isConfirm) {
	            if(isConfirm) {
	                const url = cpath + '/reviews/' + id + '/delete/' + reviewId
	                const opt = {
	                    method: 'DELETE'
	                }
	                const row = await fetch(url, opt).then(resp => resp.json())  // await 사용
	
	                if(row == 1) {
	                    swal({
	                        title: '리뷰 삭제 완료',
	                        text: '리뷰가 성공적으로 삭제되었습니다.',
	                        type: 'success',
	                        confirmButtonText: '확인'
	                    }, function(isConfirm) {
	                    	if(isConfirm) {
		                        pageNo = 1
		                        review_wrapper.innerHTML = ''
		                        loadReviewListHandler()
	                    	}
	                    })
	                }
	                else {
	                    swal({
	                        title: '리뷰 삭제 실패',
	                        text: '리뷰 삭제에 실패했습니다. 다시 시도해 주세요.',
	                        type: 'error',
	                        confirmButtonText: '확인'
	                    })
	                }
	            }
	        })
	    }
	}
	review_wrapper.addEventListener('click', deleteReviewHandler)

	
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









