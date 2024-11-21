<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<form method="POST" id="reCheckForm">
    <h3>고객님의 ID를 입력하세요.</h3>
    <p><input type="text" name="userid" placeholder="기억하시는 ID를 입력해주세요" required></p>
    <p><input type="submit" value="조회"></p>
</form>

<script>
	document.addEventListener('DOMContentLoaded', function() {
	    const form = document.getElementById('reCheckForm')
	    form.onsubmit = function(event) {
	        event.preventDefault()
	        
	        const formData = new FormData(form)
	        fetch('${cpath}/member/reCheckEmail', {
	            method: 'POST',
	            body: formData
	        })
	        .then(response => response.json()) // JSON으로 응답 받기
	        .then(data => {
	            if (data.status === 'fail') {
	                swal({
	                    title: "조회 실패",
	                    text: data.message,
	                    type: "error",
	                    confirmButtonText: "확인"
	                }, function() {
	                    location.href = '${cpath}/member/reCheckEmail'
	                })
	            } else if (data.status === 'success') {
	                swal({
	                    title: "조회 성공",
	                    text: data.message,
	                    type: "success",
	                    confirmButtonText: "로그인 페이지로"
	                }, function() {
	                    location.href = '${cpath}/member/login'
	                })
	            } else {
	                swal("알림", "예상치 못한 응답을 받았습니다.", "warning");
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