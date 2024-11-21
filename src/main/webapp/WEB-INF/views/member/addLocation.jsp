<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<h3>주소 정보 검색</h3>
<p>[현재 추가된 주소]</p>
<c:forEach var="dto" items="${list }">
	<p>${dto.memberLocation }</p>
	<hr>
</c:forEach>


<form method="POST" id="addLocationForm">
	<p><input type="text" name="memberLocation" placeholder="추가 하실 주소를 입력하세요." required></p>
	<p><input type="submit" value="등록" ></p>
</form>

<script>
	//다음 주소 찾기 함수
	function onComplete(data) {
	    document.querySelector('input[name="memberLocation"]').value = data.address
	}
	
	function execDaumPostcode() {
	    const postCode = new daum.Postcode({
	        oncomplete: onComplete
	    })
	    postCode.open()
	}
	
	document.querySelector('input[name="memberLocation"]').onclick = execDaumPostcode
	
	// swal 코드
	document.addEventListener('DOMContentLoaded', function() {
	    const form = document.getElementById('addLocationForm')
	    form.onsubmit = function(event) {
	        event.preventDefault()
	        
	        const formData = new FormData(form)
	        const url = '${cpath}/member/addLocation/${id}' // URL 경로에 {id} 변수를 적용하여 설정
	
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
	                    location.href = '${cpath}/member/info/${id}' // 성공 시 이동할 페이지 경로
	                })
	            } else {
	                swal("알림", "예상치 못한 응답을 받았습니다.", "warning")
	            }
	        })
	        .catch(error => {
	            console.error('Error:', error)
	            swal("오류", "처리 중 오류가 발생했습니다.", "error")
	        })
	    }
	})
</script>

</body>
</html>