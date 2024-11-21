<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<h3>패스워드 수정</h3>

<form method="POST">
	<p><input type="password" name="currentPw" placeholder="현재 등록된 비밀번호 입력" required autocomplete="off"></p>
	<p><input type="password" name="newPw" placeholder="변경할 비밀번호 입력" required></p>
	<p><input type="submit" value="변경하기"></p> 
</form>

<script>
	document.addEventListener('DOMContentLoaded', function() {
	    // 서버에서 전송된 메시지 받기
	    const error = '${error}'
	    const pwMessage = '${pwMessage}'
		console.log(pwMessage)
	    if (error) {
	        swal({
	            title: "변경 실패",
	            text: error,
	            type: "error",
	            button: "확인"
	        })
	    } 
	    if (pwMessage) {
	        swal({
	            title: "변경 성공",
	            text: pwMessage,
	            type: "success",
	            button: "확인"
	        }).then(() => {
	            location.href = "${cpath}/member/login"
	        })
	    }
	})
</script>
</body>
</html>