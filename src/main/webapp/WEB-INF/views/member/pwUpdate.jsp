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
	    background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)), url('${cpath}/resources/image/network-security-system-perforated-paper-padlock.jpg');
	    background-size: 110% auto;
	    background-position: 0% 10%;
	    animation: slideBackground 50s ease infinite;
	    background-repeat: no-repeat;
	    background-attachment: fixed;
	}
	.pwUpdateModal {
	/* 	position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center; */
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
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
	    margin-top: 22px;
    }
    .pwUpdateBtn {
    	padding-left: 112px;
    }
    .pwUpdateBtn input[type="submit"]{
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
    .pwUpdateBtn input[type="submit"]:hover {
    	background-color: #34495e;
    }
</style>
<div id="pwUpdateModal" class="pwUpdateModal" >
<div class="pwUpdatecontent">
	<div class="pwUpdateoverlay">
	<div class="topText">
		<div><h3 class="text1">AMD, Password Update</h3></div>
		<div><p  class="text2">비밀번호를 수정하여 개인보안을 관리할 수 있습니다.</p></div>
	</div>
	<form method="POST">
		<p><input type="password" name="currentPw" placeholder="현재 등록된 비밀번호 입력" required autocomplete="off"></p>
		<p><input type="password" name="newPw" placeholder="변경할 비밀번호 입력" required></p>
		<p class="pwUpdateBtn"><input type="submit" value="변경하기"></p> 
	</form>
		<p><a href="${cpath }/member/info/${login.id}"><button>뒤로가기</button></a></p>
	</div>	
	</div>
</div>
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
</script>
</body>
</html>