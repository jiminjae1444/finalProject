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