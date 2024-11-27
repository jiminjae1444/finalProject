
// 밀리초단위의 시간정보를 년월일시분 형태의 문자열로 변환하는 함수
function formatDate(d) {
    const date = new Date(d)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0') // 월은 0부터 시작하므로 +1
    const day = String(date.getDate()).padStart(2, '0')
    const hours = String(date.getHours()).padStart(2, '0')
    const minutes = String(date.getMinutes()).padStart(2, '0')
    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes
}

// 예약 모달 여는 함수
function openBookingModal(bookingTitle, bookingDetail) {
    bookingTitleElement.innerText = bookingTitle
    bookingDetailElement.appendChild(bookingDetail)
    bookingModal.classList.remove('hidden')
}

// 예약 모달 닫는 함수
function closeBookingModal(event){
    bookingModal.classList.add('hidden')
    bookingInsertForm.classList.add('hidden')
    bookingUpdateForm.classList.add('hidden')
    notificationTable.classList.add('hidden')
    myFavoritesTable.classList.add('hidden')
}



// 알림 페이징 최대 페이지 수 가져오는 함수
async function notificationMaxPage(startPage){
    const url = cpath + '/notificationMaxPage'
    const opt = {
        method : 'GET'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    if(result != 0){
        let tag = '<tr id="notificationPaging">'
        tag += '<td>이전</td>'
        for(let i = startPage; i <= Math.min(startPage + 4, result); i++){
            tag += '<td data-page="' + i + '">' + i + '</td>'
        }
        tag += '<td>다음</td></tr>'
        notificationTableBody.innerHTML = tag
    }
    else notificationTableBody.innerText = '알림이 없습니다.'
    return result
}


// 알림 리스트 가져와서 페이지별로 띄우는 함수
async function notificationList(thisPage){
    const url = cpath + '/notificationList/' + thisPage
    const opt = {
        method : 'GET'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    let tag = ''
    tag += '<tr><button id="deleteNotificationAllBtn">일괄 삭제하기</button></tr>'
    result.forEach(e => {
        tag += '<tr>' +
            '<td class="notification-cell" style="background-color: ' + (e.read ? '#ffffff' : 'lightskyblue') + ';">' +
            '<div class="notification-content">' +
            '<span class="notification-date">' + formatDate(e.sent_time) + '</span>  ' +
            '<span class="notification-name">' + e.name + '님의 ' + e.hospital_name + '</span> ' +
            '<span class="notification-date">' + formatDate(e.booking_date) + '</span> ' +
            '<span class="notification-message">' + e.message + '</span>' +
            '</div>' +
            '</td>' +
            '<td>' +
            '<button class="notificationDeleteBtn" data-page="' + thisPage + '" data-id="' + e.id + '">삭제</button>' +
            '</td>' +
            '</tr>'
    })
    notificationTableHead.innerHTML = tag

    // 알림삭제 버튼 기능부여
    document.querySelectorAll('.notificationDeleteBtn').forEach(btn => {
        btn.onclick = (event) => {
            deleteNotification(event)
            readNotification(event)
        }
    })
    document.getElementById('deleteNotificationAllBtn').addEventListener('click', deleteNotificationAll)
    return result  // 결과를 반환합니다.
}

// 알림 지우는 함수
async function deleteNotification(event) {
    event.preventDefault()
    const id = parseInt(event.target.dataset.id)
    const thisPage = parseInt(event.target.dataset.page)
    const url = cpath + '/deleteNotification/' + id
    const opt = {
        method: 'DELETE'
    }
    const result = await fetch(url, opt).then(resp => resp.json());
    if (result == 1) {
        await notificationCount()
        await updateNotificationPage(thisPage)
    }
}

// 알림 페이지 업데이트 함수
function updateNotificationPagination(currentPage, startPage, maxPage) {
    document.querySelectorAll('#notificationPaging td').forEach((td, i, arr) => {
        if(i == 0) {
            td.onclick = () => {
                const prevPage = Math.max(1, currentPage - 1)
                readNotification({ target: { dataset: { page: prevPage } } })
            }
        } else if(i == arr.length - 1) {
            td.onclick = () => {
                const nextPage = Math.min(maxPage, currentPage + 1)
                readNotification({ target: { dataset: { page: nextPage } } })
            }
        } else {
            td.onclick = (e) => readNotification(e)
        }

        if(i + startPage - 1 == currentPage) td.style.fontWeight = 'bold'
    })
}

// 알림 페이지 변경 함수
async function updateNotificationPage(currentPage) {
    const startPage = (Math.floor((currentPage + 4) / 5) - 1) * 5 + 1
    const maxPage = await notificationMaxPage(startPage)

    // 현재 페이지의 알림 목록을 가져옵니다.
    const notifications = await notificationList(currentPage)

    if (notifications.length === 0 && currentPage > 1) {
        // 현재 페이지가 비어있고, 첫 번째 페이지가 아니라면 이전 페이지로 이동
        await readNotification({ target: { dataset: { page: currentPage - 1 } } })
    } else {
        // 페이징 업데이트
        updateNotificationPagination(currentPage, startPage, maxPage)
    }
}


// 알림 읽음 처리하는 함수
async function readNotification(event) {
    const thisPage = parseInt(event.target.dataset.page)
    const startPage = (Math.floor((thisPage + 4) / 5) - 1) * 5 + 1

    // 알림 리스트 불러오기
    await notificationList(thisPage)

    // 알림 읽음 처리
    const url = cpath + '/readNotification/' + thisPage
    const opt = {
        method : 'PATCH'
    }
    await fetch(url, opt)

    // 알림 안읽은 수에서 읽은만큼 빼기
    notificationCount()

    // 알림창 최대 페이지 수
    const maxPage = await notificationMaxPage(startPage)

    // 알림 페이징
    document.querySelectorAll('#notificationPaging td').forEach((td, i, arr) => {

        // 이전
        if(i == 0) {
            td.onclick = (e) => {
                const prevPage = Math.max(1, thisPage - 1)
                readNotification({ target: { dataset: { page: prevPage } } })
            }
        }

        // 다음
        else if(i == arr.length - 1) {
            td.onclick = async (e) => {
                const nextPage = Math.min(maxPage, thisPage + 1)
                readNotification({ target: { dataset: { page: nextPage } } })
            }
        }

        // 페이지
        else td.onclick = (e) => readNotification(e)

        // 현재 페이지 숫자 굵게 표시
        if(i + startPage - 1 == thisPage) td.style.fontWeight = 'bold'
    })
    notificationTable.classList.remove('hidden')
    openBookingModal('알림', notificationTable)
}

async function deleteNotificationAll(event){
    const url = cpath + '/deleteNotificationAll'
    const opt = {
        method : 'DELETE'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    if(result > 0) readNotification({ target: { dataset: { page: 1 } } })

}


closeBookingBtn.addEventListener('click', closeBookingModal)
bookingOverlay.onclick = closeBookingModal
if(login != ''){
    notification.addEventListener('click', readNotification)
}




async function getFavorite(id){
    const url = cpath + '/getFavorite/' + parseInt(id)
    const opt = {
        method : 'GET'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    return result
}

// 즐겨찾기 추가하는 함수
async function myFavorite(event){
    event.preventDefault()
    const url = cpath + '/myFavorite/' + parseInt(event.target.dataset.id)
    const opt = {
        method : 'GET'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    location.reload()
}

// 즐겨찾기 목록 가져오는 함수
async function myFavoritesList(thisPage){
    const url = cpath + '/myFavoritesList/' + thisPage
    const opt = {
        method : 'GET'
    }
    let tag = ''
    tag += '<tr><button id="deleteMyFavoritesAllBtn">일괄 삭제하기</button></tr>'
    const result = await fetch(url, opt).then(resp => resp.json())
//         console.log(result)
    result.forEach(favorite => {
        tag += '<tr>'
        tag += '<th><a href="' + cpath + '/hospitalInfo/' + favorite.hospital_id + '">' + favorite.hospital_name + '</a></th>'
        tag += '<th>' + favorite.address + '</th><th>' + favorite.tel + '</th><th><button class="myFavoritesDeleteBtn" data-page="' + thisPage + '" data-id="' + favorite.hospital_id + '">삭제</button></th>'
        tag += '</tr>'
    })
    myFavoritesTableHead.innerHTML = tag

    // 즐찾삭제 버튼 기능부여
    document.querySelectorAll('.myFavoritesDeleteBtn').forEach(btn => {
        btn.onclick = (event) => {
            Swal.fire({
                title: '즐겨찾기 삭제',
                text: '해당 병원을 즐겨찾기 삭제 하시겠습니까?',
                icon: 'question',  // 'type' 대신 'icon' 사용
                showCancelButton: true,
                confirmButtonText: '확인',
                cancelButtonText: '취소',
                confirmButtonColor: '#9cd2f1',
                cancelButtonColor: '#c1c1c1',
                reverseButtons: true, // 취소 버튼을 왼쪽에 배치하려면 추가
            }).then((result) => {
                if (result.isConfirmed) {
                    deleteMyFavorites(event)
                    openMyFavorites(event)
                }
            })
        }
    })

    document.getElementById('deleteMyFavoritesAllBtn').addEventListener('click', () => {
        if(result != ''){
            Swal.fire({
                title: '즐겨찾기 일괄삭제',
                text: '즐겨찾기 목록을 전부 삭제 하시겠습니까?',
                icon: 'question',
                confirmButtonText: '확인',
                cancelButtonText: '취소',
                confirmButtonColor: '#9cd2f1',
                cancelButtonColor: '#c1c1c1',
                showCancelButton: true,
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false
            }).then((result) => {if(result.isConfirmed) deleteMyFavoritesAll()})}})
    return result
}

// 즐겨찾기 지우는 함수
async function deleteMyFavorites(event) {
    event.preventDefault()
    const id = parseInt(event.target.dataset.id)
    const thisPage = parseInt(event.target.dataset.page)
//         console.log(thisPage)
    const url = cpath + '/deleteMyFavorites/' + id
    const opt = {
        method: 'DELETE'
    }
    const result = await fetch(url, opt).then(resp => resp.json());
    if (result == 1) {
        await updateMyFavoritesPage(thisPage)
    }
}

// 즐겨찾기 페이징 최대 페이지 수 가져오는 함수
async function myFavoritesMaxPage(startPage){
    const url = cpath + '/myFavoritesMaxPage'
    const opt = {
        method : 'GET'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    if(result != 0){
        let tag = '<tr id="myFavoritesPaging">'
        tag += '<td>이전</td>'
        for(let i = startPage; i <= Math.min(startPage + 4, result); i++){
            tag += '<td data-page="' + i + '">' + i + '</td>'
        }
        tag += '<td>다음</td></tr>'
        myFavoritesTableBody.innerHTML = tag
    }
    else myFavoritesTableBody.innerText = '즐겨찾기 한 병원이 없습니다.'
    return result
}

// 즐찾 페이지 업데이트 함수
function updateMyFavoritesPagination(currentPage, startPage, maxPage) {

    document.querySelectorAll('#myFavoritesPaging td').forEach((td, i, arr) => {
        if(i == 0) {
            td.onclick = () => {
                const prevPage = Math.max(1, currentPage - 1)
                openMyFavorites({ target: { dataset: { page: prevPage } } })
            }
        } else if(i == arr.length - 1) {
            td.onclick = () => {
                const nextPage = Math.min(maxPage, currentPage + 1)
                openMyFavorites({ target: { dataset: { page: nextPage } } })
            }
        } else {
            td.onclick = (e) => openMyFavorites(e)
        }

        if(i + startPage - 1 == currentPage) td.style.fontWeight = 'bold'
    })
}

// 즐찾 페이지 변경 함수
async function updateMyFavoritesPage(currentPage) {
    const startPage = (Math.floor((currentPage + 4) / 5) - 1) * 5 + 1
    const maxPage = await myFavoritesMaxPage(startPage)

    // 현재 페이지의 알림 목록을 가져옵니다.
    const myFavoritess = await myFavoritesList(currentPage)

    if (myFavoritess.length === 0 && currentPage > 1) {
        // 현재 페이지가 비어있고, 첫 번째 페이지가 아니라면 이전 페이지로 이동
        await openMyFavorites({ target: { dataset: { page: currentPage - 1 } } })
    } else {
        // 페이징 업데이트
        updateMyFavoritesPagination(currentPage, startPage, maxPage)
    }
}

// 즐겨찾기 목록 여는 함수
async function openMyFavorites(event) {
//         console.log(event.target.dataset.page)
    const thisPage = parseInt(event.target.dataset.page)
    const startPage = (Math.floor((thisPage + 4) / 5) - 1) * 5 + 1

    // 즐겨찾기 리스트 불러오기
    await myFavoritesList(thisPage)

    // 즐겨찾기 최대 페이지 수
    const maxPage = await myFavoritesMaxPage(startPage)


    // 즐겨찾기 페이징
    document.querySelectorAll('#myFavoritesPaging td').forEach((td, i, arr) => {

        // 이전
        if(i == 0) {
            td.onclick = (e) => {
                const prevPage = Math.max(1, thisPage - 1)
                openMyFavorites({ target: { dataset: { page: prevPage } } })
            }
        }

        // 다음
        else if(i == arr.length - 1) {
            td.onclick = async (e) => {
                const nextPage = Math.min(maxPage, thisPage + 1)
                openMyFavorites({ target: { dataset: { page: nextPage } } })
            }
        }

        // 페이지
        else td.onclick = (e) => openMyFavorites(e)

        // 현재 페이지 숫자 굵게 표시
        if(i + startPage - 1 == thisPage) td.style.fontWeight = 'bold'
    })

    myFavoritesTable.classList.remove('hidden')
    openBookingModal('즐겨찾기 목록', myFavoritesTable)
}

async function deleteMyFavoritesAll(event){
    const url = cpath + '/deleteMyfavoritesAll'
    const opt = {
        method : 'DELETE'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    if(result > 0) openMyFavorites({ target: { dataset: { page: 1 } } })
}

if(login != '') {
    myFavorites.addEventListener('click', (event) => openMyFavorites(event))
}