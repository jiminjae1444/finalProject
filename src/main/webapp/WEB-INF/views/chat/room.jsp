<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cpath" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>chat</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"></script>
<%-- sweetalert --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"
        integrity="sha512-7VTiy9AhpazBeKQAlhaLRUk+kAMAb8oczljuyJHPsVPWox/QIXDFOnT9DUk1UC8EbnHKRdQowT7sOBe7LAjajQ=="
        crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css"
      integrity="sha512-gOQQLjHRpD3/SEOtalVq50iDn4opLVup2TF8c4QPI3/NmUPNZOk2FG0ihi8oCU/qYEsw4P6nuEZT2lAG0UNYaw=="
      crossorigin="anonymous" referrerpolicy="no-referrer"/>
	<link rel="stylesheet" href="${cpath}/resources/css/chat/room.css">

</head>
<body>


<div class="chat_container">
	<c:if test="${empty login || (not empty login && login.role == 0)}">
		<div class="requestChat_container">
		    <img id="requestChatBtn" src="${cpath }/resources/image/counsel-icon.png">
		</div>
	</c:if>
	<div class="chat_frame">
	    <div class="chat_header">FAQ 자동응답</div>
	    <div class="chat_messages"></div>
	    <div class="chat_footer">
	    	<form id="faqInputContainer">
	    		<p>
			        <input id="faqInput" type="text" name="content" placeholder="메시지를 입력하세요" required autofocus autocomplete="off">
			        <input type="submit" value="전송">
		        </p>
	    	</form>
	    	<form id="counselInputContainer" class="hidden">
	    		<p>
			        <input id="counselInput" type="text" name="content" placeholder="메시지를 입력하세요" required autofocus autocomplete="off">
			        <input type="submit" value="전송">
		        </p>
	    	</form>
	    </div>
	</div>
	<c:if test="${empty login || (not empty login && login.role == 0)}">
		<div class="chatOut_container">
		    <img id="chatOutBtn" src="${cpath }/resources/image/delete-icon.png">
		</div>
	</c:if>
</div>

<script src="${cpath}/resources/script/chat/room.js"></script>
<script>
	const cpath = '${cpath}'
	let roomUrl = '${roomUrl}'
	let clickRoomUrl = '${clickRoomUrl}'	// 상담원이 채팅방목록에서 클릭으로 입장한 채팅방 roomUrl
	const faqHistoryList = '${faqHistoryList}'
	const guestCounselHistoryList = '${guestCounselHistoryList}'
// 	console.log(faqHistoryList)
// 	console.log('roomUrl : ', roomUrl)
	
	const sockJS = new SockJS(cpath + '/counselChatConnection')	// 웹소켓 생성
	const stomp = Stomp.over(sockJS)
	let stompConnected = false
	
	// 채팅 모드 구분
	let chatMode = '${chatMode}'	// 'counsel' / 'faq'
	
	// 사용자/상담원 구분
	const login = '${login}'
	const loginId = '${login.id}'
	const guestId = '${guestId}'
	const myFilterId = login ? loginId : guestId
	let role = ''
	if(login) {
		role = '${login.role}'
// 		console.log('role : ', role)
	}

	// 페이지가 로드되면 스톰프 연결 시도
	stomp.connect({}, function() {
		// 상담원이 사용자한테 보낸 메시지
		stomp.subscribe('/broker/room/message/' + roomUrl, onReceive)
	})

	// 상담원/사용자 여부에 따라 다른 환경 제공
	if(login && role == 1) {
		roomUrl = clickRoomUrl
// 		console.log('상담원임')
// 		console.log('clickRoomUrl : ', clickRoomUrl)
		joinCounselor(clickRoomUrl)		// stomp 연결
	}

	const requestChat = document.getElementById('requestChatBtn')
	if(requestChat) {
		requestChat.onclick = requestCounselChat
	}

	const chatOutBtn = document.getElementById('chatOutBtn')
	if(chatOutBtn) {
		chatOutBtn.onclick = faqHistoryRemoveHandler
	}

	const faqForm = document.getElementById('faqInputContainer')
	faqForm.onsubmit = faqSubmitHandler

	const counselForm = document.getElementById('counselInputContainer')
	counselForm.onsubmit = counselSubmitHandler
	

	window.addEventListener('DOMContentLoaded', loadChatHistoryHandler)

	// 안먹힘
	if(!roomUrl) {
		alert('세션이 만료되어 채팅이 종료됩니다.')
		window.close()
	}
</script>


</body>
</html>












