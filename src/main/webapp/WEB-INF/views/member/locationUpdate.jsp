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
        background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)), url('${cpath}/resources/image/defocused-map-with-pinpoints.jpg');
        background-size: 110% auto;
        background-position: 0% 10%;
        animation: slideBackground 50s ease infinite;
        background-repeat: no-repeat;
        background-attachment: fixed;
    }
    .locationUpdateModal {
    	position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .locationUpdatecontent {
    	width: 350px;
        height: 273px;
        padding: 20px;
        padding-bottom: 43px;
        background-color: rgba(247, 249, 250, 0.8);
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center;
        z-index: 2;
        position: relative;
    }
    .locationUpdateoverlay {
    	background-color: rgba(0, 0, 0, 0.3);
    	border-radius: 8px;
    	height: 288px;
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
    	text-align: justify;
	    margin-top: 39px;
	    padding-right: 17px;
    }
    .mainContent {
    	text-align: center;
    }
    .locationBtn {
    	padding-left: 47px;
    }
    .locationBtn input[type="submit"]{
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
    .locationBtn input[type="submit"]:hover {
    	background-color: #34495e;
    }
</style>
<div id="locationUpdateModal" class="locationUpdateModal" >
<div class="locationUpdatecontent">
	<div class="locationUpdateoverlay">
	<div class="topText">
		<div><h3 class="text1">AMD, Location Update</h3></div>
		<div><p  class="text2">현재 위치를 수정하여 최적의 의료 서비스를 제공받으세요.</p></div>
	</div>
	<div class="mainContent">
		<div>
			<p>현재 주소 정보: ${login.location }</p>
		</div>
		<form method="POST" id="locationForm" >
			<p><input type="text" name="location" placeholder="주소를 검색하세요" autocomplete="off" required></p>
			<p class="locationBtn"><input type="submit" value="등록하기" ></p>
		</form>
	</div>	
		<p><a href="${cpath }/member/info/${login.id}"><button>뒤로가기</button></a></p>
	</div>
</div>
</div>
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
		const url = '${cpath}/member/locationUpdate/' + '${login.id}/' + formData.get('location')
		const opt = {
				method : 'POST'
		}
		console.log(formData.get('location'))
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
</script>

</body>
</html>