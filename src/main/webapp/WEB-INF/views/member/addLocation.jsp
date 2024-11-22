<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
	body{
        background: linear-gradient(to bottom,#2c3e50, #a2a3a3);
        width: 100vw;
        height: 100vh;
    }
    .addlocationModal {
        width: 98%;
		height: 91%;
        display: flex;
        justify-content: center;
        align-items: center;
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
        height: 278px;
        padding-top: 8px;
	    padding-left: 20px;
	    padding-bottom: 8px;
	    padding-right: 20px;
	    margin: 10px;
        background-color: rgba(247, 249, 250, 0.8);
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center;
        z-index: 2;
        position: relative; 
        top: 0; 
    }
    .addlocationListcontent p {
    	color: #2c3e50;
        font-size: 25px;
    }
    .addlocationoverlay {
    	background-color: rgba(0, 0, 0, 0.3);
    	border-radius: 8px;
    	height: 250px;
    	padding-top: 20px;
    	box-sizing: border-box;
    }
    .addlocationBtn {
    	text-align: center;
    	display: flex;
    	justify-content: center;
    }
    #addLocationForm input[type="text"] {
       padding: 10px;
       margin: 5px auto;
       border: 1px solid #ddd;
       border-radius: 4px;
    }  
    .addlocationBtn input[type="submit"] {
    	background-color: #2c3e50;
	    font-size: 17px;
	    color: white;
	    width: 190px;
	    height: 36px;
	    border: 0;
	    border-radius: 4px;
	    text-decoration: none;
	    
	    margin-bottom: 0;
	    padding-top: 0px;
	    padding-bottom: 3px;
	    
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    text-align: center;
    }
    .addlocationBtn input[type="submit"]:hover {
    	background-color: #34495e;
    }
    .addlocationListoverlay {
    	background-color: rgba(0, 0, 0, 0.3);
    	border-radius: 8px;
    	height: auto;
    }
    #addLocationTitle {
      color: #2c3e50;
      font-size: 25px;
      margin: 0;
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
   .addlocationListditail {
    	display: flex;
    	flex-direction: column;
    }
    .addlocationListditail p{
    	margin-top: 0;
    	padding-left: 30px;
    	padding-right: 5px;
    }
    .addlocationListditails {
    	display: flex;
	    margin-left: 40px;
	    padding: 5px;
    } 
    .addlocationListditails input[type="submit"] {
    	margin: 5px;
    	margin-top: 0;
    }
</style>


<div id="addlocationModal" class="addlocationModal" >
	<div class="addlocationcontent">
		
		<div class="addlocationoverlay">
			<h3 id="addLocationTitle">주소 정보 검색</h3>
			<form method="POST" id="addLocationForm">
				<p><input type="text" name="memberLocation" placeholder="추가 하실 주소를 입력하세요." required></p>
				<p class="addlocationBtn"><input type="submit" value="등록" ></p>
			</form>
			<p style="text-align: center;">
				<a href="${cpath }/member/info/${login.id}">
					<button class="gotoBackBtn">뒤로가기</button>
				</a>
			</p>
		</div>
	</div>
		
	<div class="addlocationListcontent">
		<div class="addlocationListoverlay">
		<p>[현재 추가된 주소]</p>
		<div class="addlocationListditail">
		<c:forEach var="dto" items="${list}">
            <div class="addlocationListditails">
            	${dto.alias }(${dto.memberLocation})
            <form method="POST" action="${cpath}/member/updateLocation/${login.id}/${dto.id}" id="deleteForm_${dto.id}">
            	<input type="submit" value="선택">                   
            </form>
            <form method="POST" action="${cpath}/member/deleteLocation/${login.id}/${dto.id}">
		    	<input type="submit" value="삭제">       
		    </form>
		    </div>
        </c:forEach>
        </div>
		</div>
	</div>
</div>

<%@ include file="../footer.jsp" %>

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
	// 추가 주소 삭제 sweetAlert
    const SubDletError = '${SubDletError}'
    const SubDletMessage = '${SubDletMessage}'

    if (SubDletError) {
        swal({
            title: "삭제 실패",
            text: SubDletError,
            type: "error",
            button: "확인"
        })
    }
    if (SubDletMessage) {
        swal({
            title: "삭제 성공",
            text: SubDletMessage,
            type: "success",
            button: "확인"
        })
    }
    
 	// 추가 주소 업뎃 sweetAlert
 	const SubUpError = '${SubUpError}'
    const SubUpMessage = '${SubUpMessage}'

    if (SubUpError) {
        swal({
            title: "위치 정보 변경 실패",
            text: SubUpError,
            type: "error",
            button: "확인"
        })
    }
    if (SubUpMessage) {
        swal({
            title: "위치 정보 변경 성공",
            text: SubUpMessage,
            type: "success",
            button: "확인"
        })
    }
	
	const footer = document.getElementById('footer')
   	footer.style.backgroundColor = '#83888d'
</script>

</body>
</html>