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
                location.href = cpath + '/member/login'
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
        h3.innerHTML = '전체 리뷰 (' + result.count + ') <img src="' +cpath +'/resources/image/star-icon.png">' + result.avg

        list.forEach(review => {
            const profileImg = review.PROFILE_IMG != null ? review.PROFILE_IMG : 'default.png'
            const stars = '★'.repeat(review.RATING) + '☆'.repeat(5 - review.RATING)
            let tag = '<div class="review_view">'
            tag += '	<div class="review_profile_img">'
            tag += '		<div><img src="' + cpath + '/fpupload/image/' + profileImg + '" width="50" height="50"></div>'
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

// 더보기 클릭할 때마다 리뷰 10개씩 갱신
async function moreReviewHandler() {
    pageNo++
    await loadReviewListHandler()
}