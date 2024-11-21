<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"></script>

<style>
	/* 알림을 표시할 스타일 */
	.statusNotify {
	    width: 10px;            /* 크기 설정 */
	    height: 10px;           /* 크기 설정 */
	    border-radius: 50%;     /* 동그라미 모양 */
	    background-color: red;  /* 빨간색 */
	    display: inline-block;  /* 인라인 블록 요소로 표시 */
	    margin-left: 5px;       /* 약간의 여백 */
	}
</style>


<h3>채팅방 목록</h3>

<table id="chatRoomList">
	<thead>
		<tr>
			<th>요청상태</th>
			<th>채팅방 URL</th>
			<th>고객님 이름</th>
			<th>고객님 ID</th>
			<th>채팅방 생성일</th>
		</tr>
	</thead>
	<tbody></tbody>
</table>


<script>
	let roomUrl = '${roomUrl}'
	console.log('roomUrl : ', roomUrl)
	const counselor = '상담원'
	const tbody = document.querySelector('#chatRoomList tbody')
	
	// 채팅방목록 갱신 웹소켓
	const listSockJS = new SockJS(cpath + '/chatRoomListReload')
	const listStomp = Stomp.over(listSockJS)

	// 1:1 상담 웹소켓
	const chatSockJS = new SockJS(cpath + '/counselChatConnection')
	const chatStomp = Stomp.over(chatSockJS)
	
	
	// 페이지가 로드되면 전체 채팅방목록 불러오기
	async function loadChatRoomListHandler() {
		const url = cpath + '/chats/roomList'	// ajax로 채팅방목록 호출
		const chatRoomList = await fetch(url).then(resp => resp.json())
		tbody.innerHTML = ''
		
		chatRoomList.forEach(chatRoom => {
			let tag = '<tr class="chatRoom" data-roomUrl="' + chatRoom.room_url + '">'
			tag += '<td class="requestStatus"></td>'
			tag += '<td class="roomUrl">' + chatRoom.room_url + '</td>'
			tag += '<td>' + chatRoom.memberName + '</td>'
			tag += '<td>' + chatRoom.memberUserid + '</td>'
			tag += '<td>' + formatChatTime(new Date(chatRoom.created_at)) + '</td>'
			tag += '</tr>'
			tbody.insertAdjacentHTML('beforeend', tag)
		})
		// tr에 클릭이벤트 추가
		const trs = document.querySelectorAll('.chatRoom')
		trs.forEach(tr => {
			tr.addEventListener('click', function() {
				const clickRoomUrl = this.getAttribute('data-roomUrl')
				enterChatRoom(clickRoomUrl)
			})
		})
	}
	window.addEventListener('DOMContentLoaded', loadChatRoomListHandler)
	
	
	// 채팅방목록 실시간 갱신 연결 (rooms에 접근한 상담원만 /broker/roomList/ 구독 )
	// 새로 상담 요청이 들어오면 기존 채팅방은 알림만 갱신하고, 새로운 채팅방은 목록에 추가
	listStomp.connect({}, function() {
		listStomp.subscribe('/broker/roomList/', function(message) {
			console.log('listStomp.subscribe : ', message)
			const chatRoom = JSON.parse(message.body)
			roomUrl = chatRoom.room_url
			const trs = document.querySelectorAll('.chatRoom') // 모든 채팅방의 tr 선택
			let isRoomExist = false
			
			// 기존 각 채팅방 확인
			for(let tr of trs) {
				const roomUrlTd = tr.querySelector('.roomUrl')
				if(roomUrlTd && roomUrlTd.innerText == roomUrl) {
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
	
	// 새로운 채팅방 추가 함수
	function addNewChatRoom(chatRoom) {
		let tag = '<tr class="chatRoom" data-roomUrl="' + chatRoom.room_url + '">'
		tag += '<td class="requestStatus"></td>'
		tag += '<td class="roomUrl">' + chatRoom.room_url + '</td>'
		tag += '<td>' + chatRoom.memberName + '</td>'
		tag += '<td>' + chatRoom.memberUserid + '</td>'
		tag += '<td>' + formatChatTime(new Date(chatRoom.created_at)) + '</td>'
		tbody.insertAdjacentHTML('afterbegin', tag)
		
		// 새로운 상담요청 알림 표시
		const tr = tbody.querySelector('.chatRoom')
		const statusTd = tr.querySelector('.requestStatus')
		if(statusTd) {
			const statusNotify = document.createElement('span')
			statusNotify.classList.add('statusNotify')
			statusTd.appendChild(statusNotify)
		}
		tr.addEventListener('click', function() {
			const clickRoomUrl = this.getAttribute('data-roomUrl')
			enterChatRoom(clickRoomUrl)	// 상담원 입장 시 연결
		})
		
	}
	
	// 새창으로 채팅방 열기
	function enterChatRoom(clickRoomUrl) {
// 		const url = cpath + '/chats/room/isRead/' + clickRoomUrl
// 		fetch(url)
	    window.open(cpath + '/chat/counselRoom/' + clickRoomUrl, '_blank', 'width=600, height=1080');
// 	    window.open(cpath + '/chat/counselRoom/' + clickRoomUrl, '_blank', 'width=600, height=1080,noopener,noreferrer');
	}
	
	
	// 상담요청을 받으면 채팅방목록에서 해당 채팅방에 알림 표시
	function updateNotify(roomUrl) {
// 		const data = JSON.parse(message.body)
// 		roomUrl = data.roomUrl
// 		const time = data.time
// 		console.log('새로운 상담 요청 : ', roomUrl, time)
		
		// 채팅방 목록 중 상담요청을 걸어온 채팅방에 알림 표시
		const trs = tbody.querySelectorAll('.chatRoom')
		
		for(let tr of trs) {
			const td = tr.querySelector('.roomUrl')
			if(td && td.innerText === roomUrl) {
				// 이미 알림 표시가 있는지 확인
				let existingNotify = tr.querySelector('.statusNotify');
				if(!existingNotify) {
					// 알림표시 span태그 추가
					const statusNotify = document.createElement('span')
					statusNotify.classList.add('statusNotify')
					
					// span 알림표시를 td 안에 추가
					const requestStatusTd = tr.querySelector('.requestStatus')
		            if(requestStatusTd) {
		            	requestStatusTd.appendChild(statusNotify);  // 알림을 추가
		            }
				}
				break
			}
		}
	}

	
	// 시간을 '2024.11.10. 오후 10:42' 형태로 포맷팅
	function formatChatTime(date) {
	    const hours = date.getHours();
	    const minutes = date.getMinutes();
	    const ampm = hours >= 12 ? '오후' : '오전';  // 오전/오후 구분
	    const formattedHours = hours % 12 || 12;  // 12시간제로 변환, 0은 12로 변경
	    const formattedMinutes = minutes < 10 ? '0' + minutes : minutes;  // 2자리로 표시
	
	    const day = date.getDate();
	    const month = date.getMonth() + 1;  // 월은 0부터 시작하므로 +1
	    const year = date.getFullYear();
	
	    return year + '.' + (month < 10 ? '0' + month : month) + '.' + (day < 10 ? '0' + day : day) + '. ' + ampm + ' ' + formattedHours + ':' + formattedMinutes;
	}
	
</script>


</body>
</html>