<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"></script>
<link rel="stylesheet" href="${cpath}/resources/css/chat/rooms.css">

<div id="chatRoom_Container">
	<div id="chatRoomList_frame">
		<table id="chatRoomList">
			<thead>
				<tr>
					<th><div class="thNotify"></div></th>
					<th>NAME</th>
					<th>ID</th>
					<th>TIME</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
</div>


<script>
	let roomUrl = '${roomUrl}'
// 	console.log('roomUrl : ', roomUrl)
	const role = '${login.role}'
// 	console.log('role : ', role)
	
	const counselor = '상담원'
	const tbody = document.querySelector('#chatRoomList tbody')
	
	// 채팅방목록 갱신 웹소켓
	const listSockJS = new SockJS(cpath + '/chatRoomListReload')
	const listStomp = Stomp.over(listSockJS)

	// 1:1 상담 웹소켓
	const chatSockJS = new SockJS(cpath + '/counselChatConnection')
	const chatStomp = Stomp.over(chatSockJS)
	
	

	window.addEventListener('DOMContentLoaded', loadChatRoomListHandler)
	
	
	// 채팅방목록 실시간 갱신 연결 (rooms에 접근한 상담원만 /broker/roomList/ 구독 )
	// 새로 상담 요청이 들어오면 기존 채팅방은 알림만 갱신하고, 새로운 채팅방은 목록에 추가
	listStomp.connect({}, function() {
		listStomp.subscribe('/broker/roomList/', function(message) {
// 			console.log('listStomp.subscribe : ', message)
			const chatRoom = JSON.parse(message.body)
			roomUrl = chatRoom.room_url
			const trs = document.querySelectorAll('.chatRoom') // 모든 채팅방의 tr 선택
			let isRoomExist = false
			
			// 기존 각 채팅방 확인
			for(let tr of trs) {
				const trRoomUrl = tr.dataset.roomurl
				if(trRoomUrl == roomUrl) {
					isRoomExist = true
					break	// 일치하는 채팅방 찾으면 반복문 종료
				}
			}
			if(isRoomExist) {
				updateNotify(roomUrl)	// 기존 방은 알림 갱신
			}
			else {
				addNewChatRoom(chatRoom)	// 새로운 방은 채팅방목록에 추가
			}
		})
	})
</script>
<script src="${cpath}/resources/script/chat/rooms.js"></script>
</body>
</html>