<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/member/locationUodate.css">
<div id="locationUpdateModal" class="locationUpdateModal" >
	<div class="locationUpdatecontent">
		<h3 class="updateLocationTitle">주소 정보수정</h3>
		
		<div class="mainContent">
			<div>
				<p id="currentAddress">현재 주소 정보: ${login.location }</p>
			</div>
			
			<form method="POST" id="locationForm" >
				<p><input type="text" name="location" placeholder="주소를 검색하세요" autocomplete="off" required></p>
				<p class="locationBtn"><input type="submit" value="등록하기" ></p>
			</form>
		</div>	
		
		<p><a href="${cpath }/member/info/${login.id}"><button class="gotoBackBtn">뒤로가기</button></a></p>
	</div>
</div>

<%@ include file="../footer.jsp" %>

<script>
	// 다음 주소 찾기 함수 
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
	
	 const updateBtn = document.getElementById('locationForm')
	
	// sweetAlert
	updateBtn.addEventListener('submit', async function(event) {
		event.preventDefault()
		const formData = new FormData(updateBtn);
		const url = '${cpath}/members/locationUpdate/' + '${login.id}/' + formData.get('location')
		const opt = {
				method : 'POST'
		}
// 		console.log(formData.get('location'))
		const result = await fetch(url, opt).then(resp => resp.json())
		if(result != 1) {
			swal({
	            title: "주소 변경 실패",
	            text: "주소 업데이트에 실패하였습니다. 다시 시도해주세요.",
	            type: "error",
	            button: "확인"
 	        })
		}
		else {
			swal({
			    title: "주소 변경 성공",
			    text: "주소를 성공적으로 업데이트하였습니다.",
			    type: "success",
			    confirmButtonText: "확인"
			}, function() {
			    // 확인 버튼을 눌렀을 때 실행될 코드
			    window.location.href = "${cpath}/member/info/" + '${login.id}';
			});
		}
	})
	
	const footer = document.getElementById('footer')
   	footer.style.backgroundColor = '#83888d'
</script>

</body>
</html>