<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"></script>

<style>
	/* 페이지 전체 배경 스타일 */
	body {
	    background: linear-gradient(to bottom, #2c3e50, #a4a4a4);
	    height: 100vh;
	    margin: 0;
	}
	
	#chatRoom_Container {
	    background-color: #f7f9fa;
	    width: 550px;
	    height: 600px;
	    margin: 60px auto;
	    padding: 20px;
	    border-radius: 10px;
	    align-items: center;
	}
	
	/* 채팅방 목록 전체 프레임 */
	#chatRoomList_frame {
	    width: 95%;
	    height: 95%; /* 고정 높이 설정 */
	    margin: 20px auto;
	    overflow-y: auto; /* 테이블 본문 스크롤 활성화 */
	}
	
	/* 채팅방 목록 테이블 */
	#chatRoomList {
	    width: 100%;
	    margin: 0;
	    margin-bottom: 50px;
	    border-collapse: collapse;
	    background-color: white;
	    border-radius: 10px;
	    overflow: hidden;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	}
	
	/* 테이블 헤더 스타일 */
	#chatRoomList thead {
	    background-color: #1e88e5;
	    color: white;
	    text-align: left;
	}
	
	/* 테이블 헤더 고정 */
	#chatRoomList thead th {
	    position: sticky; /* 스크롤 시 고정 */
	    top: 0; /* 상단 고정 위치 */
	    z-index: 10; /* 다른 요소 위에 표시 */
	    color: white; /* 텍스트 색상 */
	    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* 헤더 하단 그림자 */
	    padding: 15px;
	    font-size: 16px;
	}
	
	
	/* 테이블 본문 스타일 */
	#chatRoomList tbody tr {
	    border-bottom: 1px solid #ddd;
	    cursor: pointer;
	}
	
	#chatRoomList tbody tr:hover {
	    background-color: #f1f1f1;  /* 마우스 오버시 배경색 변경 */
	}
	
	/* 테이블 본문 셀 스타일 */
	#chatRoomList td {
	    padding: 15px;
	    font-size: 14px;
	}
	
	#chatRoomList td:nth-child(1) {
	    width: 10%;
	}
	#chatRoomList td:nth-child(2) {
	    width: 27%;
	    font-weight: bold;
	    color: #34495e;
	}
	#chatRoomList td:nth-child(3) {
	    width: 30%;
	    color: #34495e;
	}
	#chatRoomList td:nth-child(4) {
	    width: 33%;
	    color: #888;
	}
	
	/* 요청 상태 알림 스타일 (동그라미) */
	.thNotify {
	    width: 12px;
	    height: 12px;
	    border-radius: 50%;
	    background-color: yellow;
	    display: inline-block;
	    margin-left: 10px;
	}
	.statusNotify {
	    width: 12px;
	    height: 12px;
	    border-radius: 50%;
	    background-color: red;
	    display: inline-block;
	    margin-left: 10px;
	}
	
	
	/* 트리거된 알림 상태 스타일 */
	#chatRoomList td .requestStatus {
	    text-align: center;
	    padding: 5px;
	}
	
	/* 스타일을 클릭했을 때 활성화된 트리 스타일 */
	#chatRoomList .chatRoom {
	    transition: background-color 0.3s ease;  /* 부드러운 배경색 전환 효과 */
	}
	
	/* 스크롤바 전체 영역 */
	#chatRoomList_frame::-webkit-scrollbar {
	    width: 8px; /* 세로 스크롤 너비 */
	    height: 8px; /* 가로 스크롤 높이 */
	}
	
	/* 스크롤바 트랙 (스크롤바 배경) */
	#chatRoomList_frame::-webkit-scrollbar-track {
	    background: #eaf5fa; /* 트랙 색상 */
	    border-radius: 10px; /* 둥근 모서리 */
	}
	
	/* 스크롤바 슬라이더 (스크롤바 핸들) */
	#chatRoomList_frame::-webkit-scrollbar-thumb {
	    background: #cbe8f5; /* 슬라이더 색상 */
	    border-radius: 10px; /* 둥근 모서리 */
	}
	
	/* 슬라이더에 마우스 오버 시 색상 변경 */
	#chatRoomList_frame::-webkit-scrollbar-thumb:hover {
	    background: #9fd8f3; /* 오버 시 색상 */
	}


</style>


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
	console.log('roomUrl : ', roomUrl)
	const role = '${login.role}'
	console.log('role : ', role)
	
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
		if(role && role == 1) {
			const url = cpath + '/chats/roomList'	// ajax로 채팅방목록 호출
			const chatRoomList = await fetch(url).then(resp => resp.json())
			tbody.innerHTML = ''
			
			chatRoomList.forEach(chatRoom => {
				let tag = '<tr class="chatRoom" data-roomUrl="' + chatRoom.room_url + '">'
				tag += '<td class="requestStatus"></td>'
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
	
	
	// 새로운 채팅방 추가 함수
	function addNewChatRoom(chatRoom) {
		let tag = '<tr class="chatRoom" data-roomUrl="' + chatRoom.room_url + '">'
		tag += '<td class="requestStatus"></td>'
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
	    window.open(cpath + '/chat/counselRoom/' + clickRoomUrl, '_blank', 'width=600, height=1080');
	}
	
	
	// 상담요청을 받으면 채팅방목록에서 해당 채팅방에 알림 표시
	function updateNotify(roomUrl) {
		// 채팅방 목록 중 상담요청을 걸어온 채팅방에 알림 표시
		const trs = tbody.querySelectorAll('.chatRoom')
		
		for(let tr of trs) {
			const trRoomUrl = tr.dataset.roomurl
			if(trRoomUrl && trRoomUrl === roomUrl) {
				// 이미 알림 표시가 있는지 확인
				let existingNotify = tr.querySelector('.statusNotify')
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

	
	// 시간을 '2024.11.10. 17:42' 형태로 포맷팅
	function formatChatTime(date) {
	    const hours = date.getHours();
	    const minutes = date.getMinutes();
	    const formattedHours = hours < 10 ? '0' + hours : hours;  // 2자리로 표시
	    const formattedMinutes = minutes < 10 ? '0' + minutes : minutes;  // 2자리로 표시

	    const day = date.getDate();
	    const month = date.getMonth() + 1;  // 월은 0부터 시작하므로 +1
	    const year = date.getFullYear();

	    return year + '.' + (month < 10 ? '0' + month : month) + '.' + (day < 10 ? '0' + day : day) + '. ' + formattedHours + ':' + formattedMinutes;
	}
	
</script>


</body>
</html>