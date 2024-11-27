<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<link rel="stylesheet" href="${cpath}/resources/css/member/pwUpdate.css">
<div id="pwUpdateModal" class="pwUpdateModal" >
<div class="pwUpdatecontent">
	<div class="pwUpdateoverlay">
	<div class="topText">
		<div><h3 class="pwUpdateTitle">비밀번호 변경</h3></div>
	</div>
	<form method="POST" id="pwUpdateForm">
		<p><input type="password" name="currentPw" placeholder="현재 등록된 비밀번호 입력" required autocomplete="off"></p>
		<p><input type="password" name="newPw" placeholder="변경할 비밀번호 입력" required></p>
		<p class="pwUpdateBtn"><input type="submit" value="변경하기"></p> 
	</form>
		<p><a href="${cpath }/member/info/${login.id}"><button class="gotoBackBtn">뒤로가기</button></a></p>
	</div>	
	</div>
</div>

<%@ include file="../footer.jsp" %>

<script>
	document.addEventListener('DOMContentLoaded', function() {
	    // 서버에서 전송된 메시지 받기
	    const error = '${error}'
	    const message2 = '${message2}'
	
	    if (error) {
	        swal({
	            title: "변경 실패",
	            text: error,
	            type: "error",
	            button: "확인"
	        })
	    }
	    if (message2) {
	        swal({
	            title: "변경 성공",
	            text: message2,
	            type: "success",
	            button: "확인",
	        }, function() {
	            location.href = '${cpath}/member/login'
	        })
	    }
	})
	
	const footer = document.getElementById('footer')
   	footer.style.backgroundColor = '#83888d'
</script>
</body>
</html>