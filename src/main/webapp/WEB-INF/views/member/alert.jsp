<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script>
	document.addEventListener('DOMContentLoaded', function() {
	    const msg = '${msg}'
	    const url = '${url}'
	
	    if (msg && msg.trim() !== "") {
	        swal({
	            title: "알림",
	            text: msg,
	            type: "error",
	            confirmButtonText: "확인"
	        }, function() {
	            // 확인 버튼 클릭 후 실행할 동작
	            if (url === '') {
	                history.go(-1) // 이전 페이지로 돌아가기
	            } else {
	                location.href = '${cpath}' + url // 지정된 URL로 이동
	            }
	        })
	    }
	})
</script>

</body>
</html>