<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
	body{
        background: linear-gradient(to bottom,#2c3e50, #a2a3a3);
        width: 100vw;
        height: 100vh;
    }
    .locationUpdateModal {
        width: 98%;
        height: 91%;
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
    .mainContent {
    	text-align: center;
    }
    #locationForm input[type="text"] {
       padding: 10px;
       border: 1px solid #ddd;
       border-radius: 4px;
    }
    .locationBtn {
    	display: flex;
    	justify-content: center;
    	padding: 0;
    }
    .locationBtn input[type="submit"]{
    	background-color: #2c3e50;
	    font-size: 17px;
	    color: white;
	    width: 185px;
	    height: 36px;
	    margin-bottom: 0;
	    padding-top: 0px;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    text-align: center;
	    border: 0;
	    border-radius: 4px;
	    text-decoration: none;
	    padding: 0;
    }
    .locationBtn input[type="submit"]:hover {
    	background-color: #34495e;
    }
    .gotoBackBtn {
	    width: 183px;
	    padding: 8px; /* 여백 축소 */
	    background: none;
	    border: 1px solid #2c3e50;
	    border-radius: 4px; /* 둥글기 축소 */
	    color: #2c3e50;
	    cursor: pointer;
	    transition: background 0.3s ease, color 0.3s ease;
	    font-size: 0.9rem; /* 텍스트 크기 축소 */
   }
   .gotoBackBtn:hover {
       background: #2c3e50;
       color: white;
   }
   .updateLocationTitle {
   	   color: #2c3e50;
       font-size: 25px;
   }
   #currentAddress {
   	   font-size: 15px;
   }
</style>
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