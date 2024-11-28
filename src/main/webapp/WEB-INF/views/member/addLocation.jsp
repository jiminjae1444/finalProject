<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/member/addlocation.css">


<div id="addlocationModal" class="addlocationModal" >
	<div class="addlocationcontent">
		
		<div class="addlocationoverlay">
			<h3 id="addLocationTitle">주소 정보 검색</h3>
			<form method="POST" id="addLocationForm">
				<p><input type="text" name="memberLocation" value="${login.location }" required></p>
				<p><input title="위치 정보의 별칭을 등록" type="text" name="alias" placeholder="위치 정보의 별칭을 등록하세요" required></p>
				<p class="addlocationBtn"><input type="submit" value="등록" ></p>
			</form>
			<p style="text-align: center;">
				<a href=" ${cpath}/member/info/${id}">
					<button class="gotoBackBtn">뒤로가기</button>
				</a>
			</p>
		</div>
	</div>
		
	<div class="addlocationListcontent">
		<div class="addlocationListoverlay">
			<p>[현재 추가된 주소]</p>
			<div class="addlocationListditail">
   <c:forEach var="dto" items="${list}">
                    <div class="addlocationListditails">
                        <span class="location-info">
                            <span class="alias">${dto.alias}</span>
                            (<span class="address">${dto.memberLocation}</span>)
                        </span>
                        <div class="action-buttons">
                            <form method="POST" action="${cpath}/member/updateLocation/${login.id}/${dto.id}" id="updateForm_${dto.id}">
                                <input type="submit" value="선택" class="action-btn select-btn">
                            </form>
                            <form method="POST" action="${cpath}/member/deleteLocation/${login.id}/${dto.id}">
                                <input type="submit" value="삭제" class="action-btn delete-btn">
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
<script src="${cpath}/resources/script/member/addLocation.js"></script>
<script>

	
	document.querySelector('input[name="memberLocation"]').onclick = execDaumPostcode
	
	// swal 코드
	document.addEventListener('DOMContentLoaded', function() {
	    const form = document.getElementById('addLocationForm')
	    form.onsubmit = function(event) {
	        event.preventDefault()
	        
	        const formData = new FormData(form)
	        const url = cpath + '/members/addLocation/${id}' // URL 경로에 {id} 변수를 적용하여 설정
	
	        fetch(url, {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => response.json()) // JSON으로 응답 받기
	        .then(data => {
	            if (data.status === 'fail') {
	                swal({
	                    title: "주소 추가 실패",
	                    text: data.message,
	                    type: "error",
	                    confirmButtonText: "확인"
	                })
	            } else if (data.status === 'success') {
	                swal({
	                    title: "주소 추가 성공",
	                    text: data.message,
	                    type: "success",
	                    confirmButtonText: "확인"
	                }, function() {
	                    location.reload()
	                })
	            } else {
	                swal("알림", "예상치 못한 응답을 받았습니다.", "warning")
	            }
	        })
	        .catch(error => {
// 	            console.error('Error:', error)
	            swal("오류", "처리 중 오류가 발생했습니다.", "error")
	        })
	    }
	})
	// 추가 주소 삭제 sweetAlert
    const SubDletError = '${SubDletError}'
    const SubDletMessage = '${SubDletMessage}'

    if (SubDletError) {
        swal({
            title: "삭제 실패",
            text: SubDletError,
            type: "error",
            button: "확인"
        })
    }
    if (SubDletMessage) {
        swal({
            title: "삭제 성공",
            text: SubDletMessage,
            type: "success",
            button: "확인"
        })
    }
    
 	// 추가 주소 업뎃 sweetAlert
 	const SubUpError = '${SubUpError}'
    const SubUpMessage = '${SubUpMessage}'

    if (SubUpError) {
        swal({
            title: "위치 정보 변경 실패",
            text: SubUpError,
            type: "error",
            button: "확인"
        })
    }
    if (SubUpMessage) {
        swal({
            title: "위치 정보 변경 성공",
            text: SubUpMessage,
            type: "success",
            button: "확인"
        })
    }
	
	const footer = document.getElementById('footer')
   	footer.style.backgroundColor = '#83888d'
</script>


</body>
</html>