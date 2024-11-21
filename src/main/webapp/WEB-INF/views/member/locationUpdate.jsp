<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<h3>주소 정보 수정</h3>
<div>
	<p>현재 주소 정보: ${login.location }</p>
</div>

<form method="POST">
	<p><input type="text" name="location" placeholder="주소를 검색하세요" autocomplete="off" required></p>
	<p><input type="submit" value="등록하기" ></p>
</form>

<script>
	//다음 주소 찾기 함수 
	function onComplete(data) {
		document.querySelector('input[name="location"]').value = data.address
	}
	
	function execDaumPostcode() {
		const postCode = new daum.Postcode({
	        oncomplete: onComplete
	    })
	    postCode.open()
	}
	document.querySelector('input[name="location"]').onclick = execDaumPostcode
</script>

</body>
</html>