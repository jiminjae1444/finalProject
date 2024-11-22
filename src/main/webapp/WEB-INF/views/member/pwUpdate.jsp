<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
	body{
        background: linear-gradient(to bottom,#2c3e50, #a2a3a3);
        width: 100vw;
        height: 100vh;
    }
	.pwUpdateModal {
        height: 91%;
        display: flex;
        justify-content: center;
        align-items: center;
	}
	.pwUpdatecontent {
		width: 480px;
        height: 300px;
        padding: 20px;
        background-color: rgba(247, 249, 250, 0.8);
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center;
        padding-top: 25px;
	}
	.pwUpdateoverlay {
		background-color: rgba(0, 0, 0, 0.3);
    	border-radius: 8px;
    	height: 288px;
	}
	.topText {
    	text-align: center;
    }
    .topText h3 {
    	margin: 0;
    	padding-top: 8px;
    }
    .pwUpdateTitle {
    	color: #2c3e50;
      	font-size: 25px;
    }
    .pwUpdateBtn {
    	display: flex;
    	justify-content: center;
    }
    #pwUpdateForm input[type="password"]{
       padding: 10px;
       margin: 5px auto;
       border: 1px solid #ddd;
       border-radius: 4px;
    }
    .pwUpdateBtn input[type="submit"]{
    	background-color: #2c3e50;
	    font-size: 17px;
	    color: white;
	    width: 187px;
	    height: 37px;
	    margin-bottom: 0;
	    padding-top: 0px;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    text-align: center;
	    border: 0;
	    border-radius: 4px;
	    text-decoration: none;
	    padding-bottom: 3px;
    }
    .pwUpdateBtn input[type="submit"]:hover {
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
</style>
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
   	footer.style.backgroundColor = '#a2a3a3'
</script>
</body>
</html>