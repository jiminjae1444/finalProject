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

<style>
	body {
	    justify-content: center;
	    align-items: center;
	    margin: 0;
	    padding: 0;
	    width: 100vw;
 	    height: 100vh;
	    font-family: Arial, sans-serif;
	    overflow: hidden;
	}
	
	.chat_container {
		width: 450px;
		margin: 80px auto;
		align-items: center;
	    position: relative;
	}
	
	.requestChat_container {
		position: absolute;
		top: 11px;
		left: 44px;
	}
	
	#requestChatBtn {
		width: 33px;
        cursor: pointer;
        opacity: 90%;
	}
	
	.chat_frame {
	    width: 400px;
	    height: 720px;
	    margin: auto;
	    border-radius: 20px;
	    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	    overflow: hidden;
	    background-color: white;
	    display: flex;
	    flex-direction: column;
	}
	
	.chat_header {
	    padding: 15px;
	    background-color: #2c3e50;
	    color: #ffffff;
	    text-align: center;
	    font-weight: bold;
	    font-size: 1.2em;
	}
	
	.chat_messages {
	    flex-grow: 1;
	    padding: 10px;
	    overflow-y: auto;
	    background-color: #f5f5f5;
	    display: flex;
	    flex-direction: column;
	}
	
	.chatRoomNotice {
		text-align: center;
		background-color: #eee;
		font-size: 13px;
		padding: 5px;
		margin: 5px 0;
		border-radius: 5px;
	}
	
	/* 메시지와 시간을 감쌀 컨테이너 */
	.chat_content_wrapper {
	    display: flex;
	    flex-direction: column;
	    align-items: flex-start; /* 기본은 왼쪽 정렬 */
	    margin-bottom: 10px;
	}
	
	/* 상담원과 사용자 메시지에 따라 정렬 변경 */
	.my_message_wrapper {
	    align-items: flex-end; /* 사용자 메시지 오른쪽 정렬 */
	}
	
	.chat_content {
	    margin: 5px;
	    padding: 8px 12px;
	    border-radius: 12px;
	    max-width: 65%;
	    font-size: 0.9em;
	    word-wrap: break-word;
	}
	
	/* 상담원 메시지 스타일 */
	.other_message {
	    background-color: #ffffff;
	}
	
	/* 사용자 메시지 스타일 */
	.my_message {
	    background-color: #d5dde6;
	}
	
	/* 시간 스타일 */
	.chat_time {
	    font-size: 12px;
	    color: #888;
	    margin: 1px 5px;
	}
	
	/* 상담원 메시지 시간 왼쪽 정렬 */
	.other_message .chat_time {
	    text-align: left;
	    margin-left: 5px;
	}
	
	/* 사용자 메시지 시간 오른쪽 정렬 */
	.my_message .chat_time {
	    text-align: right;
	    margin-right: 5px;
	}
	
	.chat_footer {
	    padding: 10px;
	    background-color: white;
	    align-items: center;
	    text-align: center;
	}
	
	/* FAQ 입력창 */
	#faqInputContainer p {
	    display: flex;
	    margin: 0 auto;
	}
	#faqInputContainer input[type="text"] {
	    flex-grow: 1;
	    padding: 8px;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	    margin-right: 8px;
	    font-size: 0.9em;
	    width: 250px;
	}
	#faqInputContainer input[type="submit"] {
	    padding: 8px 16px;
	    background-color: #2c3e50;
	    color: #ffffff;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 0.9em;
	}
	#faqInputContainer input[type="submit"]:hover {
	    background-color: #34495e;
	}
	
	/* 상담채팅 입력창 */
	#counselInputContainer p {
	    display: flex;
	    margin: 0 auto;
	}
	#counselInputContainer input[type="text"] {
	    flex-grow: 1;
	    padding: 8px;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	    margin-right: 8px;
	    font-size: 0.9em;
	    width: 250px;
	}
	#counselInputContainer input[type="submit"] {
	    padding: 8px 16px;
	    background-color: #1e88e5;
	    color: #ffffff;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 0.9em;
	}
	#counselInputContainer input[type="submit"]:hover {
	    background-color: #1e73be;
	}

	/* 채팅방 나가기 버튼(세션 만료) */
    .chatOut_container {
        position: absolute;
		top: 11px;
		right: 40px;
    }
    #chatOutBtn {
        width: 33px;
        cursor: pointer;
        opacity: 80%;
    }

	.hidden {
		display: none;
	}

</style>
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
		console.log('role : ', role)
	}

	
	// 페이지가 로드되면 스톰프 연결 시도
	stomp.connect({}, function() {
		// 상담원이 사용자한테 보낸 메시지
		stomp.subscribe('/broker/room/message/' + roomUrl, onReceive)
	})

	// 상담원/사용자 여부에 따라 다른 환경 제공
	if(login && role == 1) {
		roomUrl = clickRoomUrl
		console.log('상담원임')
		console.log('clickRoomUrl : ', clickRoomUrl)
		joinCounselor(clickRoomUrl)		// stomp 연결
	}

	
	/* 상담원 */
	
	// 상담원 채팅방에 입장
	function joinCounselor(clickRoomUrl) {
		stomp.connect({}, function() {
			changeChatMode('counsel')
			console.log("상담원 스톰프 연결 완료")
			connectCounselor(clickRoomUrl) // 상담원이 연결된 방에 입장 시 연결
		})
	}
	// 상담원 입장 시 연결 설정
	function connectCounselor(clickRoomUrl) {
		stomp.subscribe('/broker/room/info/' + clickRoomUrl)
		stomp.subscribe('/broker/room/message/' + clickRoomUrl, onReceive)
		stomp.send('/app/joinCounselor/' + clickRoomUrl, {}, JSON.stringify({}))
	}
	
	// 상대방으로부터 메시지 수신
	async function onReceive(data) {	// data: MESSAGE 객체
		const message = JSON.parse(data.body)	// message: JSON 객체
		console.log(message)
		if(message.messageFilterId == myFilterId) {
			console.log('본인이 보낸 메시지는 필터링: ', message)
			return
		}
		addChatListHandler('other', message.content, Date.now(), true)
		
		const url = cpath + '/chats/counselChat/' + message.room_url
		const opt = {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({
			    sender_id: message.sender_id,
			    content: message.content,
			    chat_time: new Date(message.chat_time).toISOString(),
			    room_url: message.room_url,
			})
		}	
		// 상담원쪽에서 사용자한테 받은 메시지 저장
		if(login && role == 1) {
			await fetch(url, opt)
	    }
	}
	
	
	// 입력창 모드 초기화
	function changeChatMode(mode) {
	    const faqInput = document.getElementById('faqInputContainer');
	    const counselInput = document.getElementById('counselInputContainer');

	    chatMode = mode
	    
        const chat_header = document.querySelector('.chat_header')
	    // faq 모드일 때
	    if(chatMode == 'faq') {
	        faqInput.classList.remove('hidden')
	        counselInput.classList.add('hidden')
	        chat_header.innerText = 'FAQ 자동응답'
	    }
	    // counsel 모드일 때
	    else if(chatMode == 'counsel') {
	        faqInput.classList.add('hidden')
	        counselInput.classList.remove('hidden')
	        chat_header.innerText = '1:1 실시간 상담'
	    }
	}

	
	
	/* 사용자 */

	// 사용자가 1:1 상담요청 클릭
	async function requestCounselChat(event) {
		changeChatMode('counsel')
		
		if(stompConnected) {
			return
		}
		console.log('roomUrl : ', roomUrl)
		const url = cpath + '/chats/counsel/' + roomUrl
		const chatRoom = await fetch(url).then(resp => resp.json())
		
		// STOMP 연결이 준비되면 상담원한테 chatRoom 정보 전송
	    if(chatRoom) {
        	// STOMP 연결 시도		// 상담원이 채팅방에 입장하면, 해당 채팅방정보를 보냄
	        if(stomp.connected) {
	            connecting(chatRoom)	// 스톰프 연결 후 처리
	        } else {
	            stomp.connect({}, function() {
	            	stompConnected = true
	                connecting(chatRoom)
	            })
	        }
	    }
	}
	const requestChat = document.getElementById('requestChatBtn')
	if(requestChat) {
		requestChat.onclick = requestCounselChat
	}
	
	
	// 사용자가 상담요청 보냈을 때 STOMP 연결 후 처리 과정
	function connecting(chatRoom) {
		showNotice('상담원과 연결중입니다.')
		
		// 상담원이 입장했을 때 받을 구독 경로 설정
		stomp.subscribe('/broker/room/notify/' + chatRoom.room_url, onConnect)
		
		// 상담원에게 상담요청 전송할 때 /app/requestCounsel 경로 사용
		stomp.send('/app/updateRoomList/' + chatRoom.room_url, {}, JSON.stringify({
			room_url: chatRoom.room_url,
			memberUserid: chatRoom.memberUserid,
			memberName: chatRoom.memberName,
			created_at: chatRoom.created_at
		}))
	}
	
	// stomp 연결이 완료됐을 때 호출되는 함수 (연결 완료 알림메시지)
	function onConnect(message) {
		const data = message.body
		showNotice(data)
	}
	
	// 알림메시지를 채팅화면에 띄우는 함수
	function showNotice(message) {
	    // .chat_messages 안에 .chatRoomNotice를 추가하거나 업데이트
	    const chat_messages = document.querySelector('.chat_messages')
	    
    	const chatRoomNotice = document.createElement('div')
    	chatRoomNotice.className = 'chatRoomNotice'
        document.querySelector('.chat_messages').appendChild(chatRoomNotice)
	    chatRoomNotice.innerText = message
	}
	
	
	// 채팅내역 없애고 창 닫기 (세션 만료)
	async function faqHistoryRemoveHandler() {
		swal({
			title: '채팅 내역 삭제',
			text: '채팅내역이 삭제됩니다. 계속 진행하시겠습니까?',
			type: 'warning',
			showCancelButton: true,
			confirmButtonText: '예',
 			cancelButtonText: '아니오',
 			closeOnConfirm: false,
 			closeOnCancel: true,
 		}, async function(isConfirm) {
			let result = ''
 			if(isConfirm) {
 				if(chatMode == 'counsel' && login) {	// 상담모드
 					const url = cpath + '/chats/removeCounselHistory/' + roomUrl
 					result = await fetch(url, {method: 'DELETE'})
 					console.log(url, chatMode)
 					console.log('chatMode : ', chatMode)
 				}
 				else {	// FAQ모드
					const url = cpath + '/chats/removeFaqHistory'
					result = await fetch(url, {method: 'POST'})
					console.log(url, chatMode)
 				}
 			}
			if(result && result.ok) {
				window.close()
			}
        })
	}
	const chatOutBtn = document.getElementById('chatOutBtn')
	if(chatOutBtn) {
		chatOutBtn.onclick = faqHistoryRemoveHandler
	}
	
	
	// 채팅방에 채팅 내역 추가
	function addChatListHandler(sender, content, chatTime, isLeft = false) {
	    const chatMessages = document.querySelector('.chat_messages')
	    const chatContentWrapper = document.createElement('div')
	    chatContentWrapper.classList.add('chat_content_wrapper')

	    if(!isLeft) {
	        chatContentWrapper.classList.add('my_message_wrapper')
	    }

	    const chatContent = document.createElement('div')
	    chatContent.classList.add('chat_content', isLeft ? 'other_message' : 'my_message')
	    chatContent.innerText = content

	    const chatTimeSpan = document.createElement('span')
	    chatTimeSpan.classList.add('chat_time')
        chatTimeSpan.innerText = formatChatTime(new Date(chatTime))  // 문자열이면 Date 객체로 변환 후 포맷팅

	    chatContentWrapper.appendChild(chatContent)
	    chatContentWrapper.appendChild(chatTimeSpan)
	    chatMessages.appendChild(chatContentWrapper)
	    
	    chatMessages.scrollTop = chatMessages.scrollHeight
	}
	

	// FAQ 메시지 입력
	async function faqSubmitHandler(event) {
		event.preventDefault()
		
		const faqInput = document.getElementById('faqInput')
		const userMessage = faqInput.value.trim()
		if(!userMessage) return		// 사용자가 입력한 메시지에 유효한 값이 있는지 확인하고 진행
		
		addChatListHandler('user', userMessage, Date.now())
		
		const formData = new FormData(event.target)
	
		const url = cpath + '/chats/faqChat'
		const opt = {
			method: 'POST',
			body: formData
		}
		const result = await fetch(url, opt).then(resp => resp.json())
		console.log(result)
		const autoResponse = result.autoResponse

		const chatTime = result.chat_time
		console.log(chatTime)
		
		addChatListHandler('auto', autoResponse, chatTime, true)
		
		faqInput.value = ''
	}
	const faqForm = document.getElementById('faqInputContainer')
	faqForm.onsubmit = faqSubmitHandler
	
	
	// 1:1 상담채팅 입력
	async function counselSubmitHandler(event) {
	    event.preventDefault();
		
		if(login && role == 1) {
			roomUrl = clickRoomUrl
		}
		const counselInput = document.getElementById('counselInput')
		const userMessage = counselInput.value.trim()
		if(!userMessage) return		// 사용자가 입력한 메시지에 유효한 값이 있는지 확인하고 진행
	    
		addChatListHandler('my', userMessage, Date.now())
		
		const url = cpath + '/chats/counselChat/' + roomUrl
		const opt = {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({
			    sender_id: loginId,
			    content: userMessage,
			    chat_time: new Date().toISOString(),
			    room_url: roomUrl,
			    messageFilterId: myFilterId,
			})
		}
	    // 상담원일 때만 메시지 입력 시 저장
	    if(login && role == 1) {
			await fetch(url, opt)
	    }
		
	    sendMessageToOther(roomUrl, userMessage)

	    counselInput.value = '';
	}
	const counselForm = document.getElementById('counselInputContainer')
	counselForm.onsubmit = counselSubmitHandler
	
	// stomp 구독 경로로 메시지 전송
	function sendMessageToOther(roomUrl, userMessage) {
		console.log('send')
		stomp.send('/app/chat/sendMeassge/' + roomUrl, {}, JSON.stringify({
			sender_id: loginId,
			room_url: roomUrl,
			content: userMessage,
			chat_time: new Date().toISOString(),
			messageFilterId: myFilterId
		}))
	} 
	
	
	// 채팅방에 입장했을 때 세션에 저장된 채팅내역이 있으면 불러오기
	async function loadChatHistoryHandler() {
		let chatHistoryList = ''
		// 1:1 상담내역이 있는지 먼저 확인
		if(login) {
			const url = cpath + '/chats/memberCounselHistory/' + roomUrl
			chatHistoryList = await fetch(url).then(resp => resp.json())
		}
		else {
			const url = cpath + '/chats/guestCounselHistory/' + roomUrl
			chatHistoryList = await fetch(url).then(resp => resp.json())
		}
		if(!chatHistoryList || chatHistoryList.length <= 0) {	// 1:1 상담내역이 없으면
			const url = cpath + '/chats/faqHistory/' + roomUrl
			chatHistoryList = await fetch(url).then(resp => resp.json())
		}
		console.log('chatHistoryList : ', chatHistoryList)
		if(chatHistoryList && chatHistoryList.length > 0) {
			chatHistoryList.forEach(chatHistory => {
				console.log('chatHistory : ', chatHistory)
				if(!chatHistory.autoResponse) {
					if(login && loginId == chatHistory.sender_id) {	// db에 저장된 자기 메시지면 오른쪽
						addChatListHandler('my', chatHistory.content, chatHistory.chat_time)
					}
					else if(login && loginId != chatHistory.sender_id) { // db에 저장된 상대방 메시지면 왼쪽
						addChatListHandler('other', chatHistory.content, chatHistory.chat_time, true)
					}
					else if(!login && !chatHistory.sender_id) {	// 비회원) 상담채팅 세션에 저장된 자기 메시지면 오른쪽
						addChatListHandler('my', chatHistory.content, chatHistory.chat_time)
					}
					else if(!login && chatHistory.sender_id) {	// 비회원) 상담채팅 세션에 저장된 상담원 메시지면 왼쪽
						addChatListHandler('other', chatHistory.content, chatHistory.chat_time, true)
					}
				}
				else {	// FAQ 내역이 있으면
					addChatListHandler('user', chatHistory.content, chatHistory.chat_time)
					addChatListHandler('auto', chatHistory.autoResponse, chatHistory.chat_time, true)
				}
			})
		}
		if(role != 1)
		addChatListHandler('other', '📣 현재 자동응답 모드입니다. 상담원과 실시간 상담을 원하시면 상단의 채팅 아이콘을 눌러주세요.', Date.now(), true)
	}
	window.addEventListener('DOMContentLoaded', loadChatHistoryHandler)
	
	
	
	// 시간을 '2024.11.10. 오후 10:42' 형태로 포맷팅
	function formatChatTime(date) {
	    const hours = date.getHours()
	    const minutes = date.getMinutes()
	    const ampm = hours >= 12 ? '오후' : '오전'  // 오전/오후 구분
	    const formattedHours = hours % 12 || 12  // 12시간제로 변환, 0은 12로 변경
	    const formattedMinutes = minutes < 10 ? '0' + minutes : minutes  // 2자리로 표시
	
	    const day = date.getDate()
	    const month = date.getMonth() + 1  // 월은 0부터 시작하므로 +1
	    const year = date.getFullYear()
	
	    return year + '.' + (month < 10 ? '0' + month : month) + '.' + (day < 10 ? '0' + day : day) + '. ' + ampm + ' ' + formattedHours + ':' + formattedMinutes
	}
	
	
	// 안먹힘
	if(!roomUrl) {
		alert('세션이 만료되어 채팅이 종료됩니다.')
		window.close()
	}

	
</script>




</body>
</html>












