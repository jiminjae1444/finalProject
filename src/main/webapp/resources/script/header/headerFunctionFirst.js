//새창에서 챗봇 페이지로 이동
async function openChatRoom() {
    const url = cpath + '/chats/room'
    const roomUrl = await fetch(url).then(resp => resp.text())
// 		console.log('roomUrl 받아온 후: ', roomUrl)

    if(roomUrl) {
        window.open(cpath + '/chat/room/' + roomUrl, '_blank', 'width=600, height=900')
    }
    else {
        alert('챗봇으로 연결할 수 없습니다')
    }
}


// 로그인 이동
if (loginIcon) {
    const loginIcon = document.querySelector('div.loginIcon')
    loginIcon.addEventListener('click', function() {
        location.href = cpath + '/member/login'
    })
}
const gotoInfo = document.getElementById('div.gotoInfo')
if (gotoInfo) {
    gotoInfo.addEventListener('click', function() {
        location.href =  cpath + '/member/info/${login.id}'
    })
}

// 아직 안읽은 알림 갯수 가져와서 띄우는 함수

async function notificationCount(){
    const url = cpath + '/notificationCount'
    const opt = {
        method : 'GET'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    if (result > 0 && login != '') {
        notificationCountSpan.classList.remove('hidden')
        if (result >= 10) {
            notificationCountSpan.innerText = '9+' // 10 이상은 '9+'로 표시
        } else {
            notificationCountSpan.innerText = result // 10 미만은 해당 숫자 표시
        }
        return result
    } else {
        if(login  != ''){

            notificationCountSpan.innerText = '' // 0 이하일 경우 비움
            notificationCountSpan.classList.add('hidden')
        }
        return ''
    }
}
