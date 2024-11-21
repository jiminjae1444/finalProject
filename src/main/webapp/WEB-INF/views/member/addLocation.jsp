<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
	@keyframes slideBackground {
        0% {
            background-position: 0% 10%;
        }
        50% {
            background-position: 100% 10%;
        }
        100% {
            background-position: 0% 10%;
        }
    }
    body {
        background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)), url('${cpath}/resources/image/side-view-hands-holding-smartphone.jpg');
        background-size: 110% auto;
        background-position: 0% 10%;
        animation: slideBackground 50s ease infinite;
        background-repeat: no-repeat;
        background-attachment: fixed;
    }
    .addlocationModal {
    	position: fixed;
/*         top: -119px; */
/*         left: -193px; */
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
        width: 100%;
/*         height: 100%; */
        display: flex;
        justify-content: center;
        align-items: flex-start;
    }
    .addlocationcontent {
    	width: 380px;
        height: 230px;
        padding: 20px;
        padding-bottom: 43px;
        background-color: rgba(247, 249, 250, 0.8);
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center;
        z-index: 2;
         position: relative; 
         top: 0; 
    }
    .addlocationListcontent {
    	width: 380px;
        height: auto;
        padding-top: 8px;
	    padding-left: 20px;
	    padding-bottom: 8px;
	    padding-right: 20px;
        background-color: rgba(247, 249, 250, 0.8);
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center;
        z-index: 2;
        position: relative; 
        top: 0; 
    }
    .addlocationoverlay {
    	background-color: rgba(0, 0, 0, 0.3);
    	border-radius: 8px;
    	height: 250px;
    }
    .topText {
    	display: flex;
    }
    .text1 {
    	margin-top: 5px;
    	text-align: left;
	    margin-left: 15px;
    }
    .text2 {
    	text-align: left;
	    font-size: 14px;
	    margin-top: 45px;
    }
    .addlocationBtn {
    	padding-left: 62px;
    }
    .addlocationBtn input[type="submit"] {
    	background-color: #2c3e50;
	    font-size: 17px;
	    color: white;
	    width: 177px;
	    height: 32px;
	    margin-bottom: 0;
	    padding-top: 0px;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    text-align: center;
	    border: 0;
	    border-radius: 4px;
	    text-decoration: none;
	    margin-left: 40px;
	    padding-bottom: 3px;
    }
    .addlocationBtn input[type="submit"]:hover {
    	background-color: #34495e;
    }
    .addlocationListModal {
    	position: fixed;
/*         top: -195px; */
/*         left: 229px; */
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    
    .addlocationListoverlay {
    	background-color: rgba(0, 0, 0, 0.3);
    	border-radius: 8px;
    	height: auto;
    }
</style>
<div id="addlocationListModal" class="addlocationListModal" >

</div>
<h3>주소 정보 검색</h3>
<div id="addlocationModal" class="addlocationModal" >
	<div class="addlocationcontent">
		<div class="addlocationoverlay">
		<div class="topText">
			<div><h3 class="text1">AMD, AddLocation Service</h3></div>
			<div><p  class="text2">위치 정보를 추가하고, 효율적으로 의료 서비스 정보를 관리 해보세요.</p></div>
		</div>
		<form method="POST" id="addLocationForm">
			<p><input type="text" name="memberLocation" placeholder="추가 하실 주소를 입력하세요." required></p>
			<p class="addlocationBtn"><input type="submit" value="등록" ></p>
		</form>
		<p style="text-align: center;"><a href="${cpath }/member/info/${login.id}"><button>뒤로가기</button></a></p>
		</div>
	</div>
	
	<div class="addlocationListcontent">
		<div class="addlocationListoverlay">
		<p>[현재 추가된 주소]</p>
		<c:forEach var="dto" items="${list }">
			<ul style="list-style: none;">
				<li>${dto.memberLocation }</li>
			</ul>
		</c:forEach>
		</div>
	</div>
</div>

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