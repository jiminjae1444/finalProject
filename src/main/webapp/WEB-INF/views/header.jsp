<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="cpath" value="${pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>finalProject</title>
	<link rel="stylesheet" href="${cpath}/resources/css/header.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Gugi&family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
	
    <%--    chart    --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
    <!--  sweetalert2 -->
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <%-- sweetalert --%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"
            integrity="sha512-7VTiy9AhpazBeKQAlhaLRUk+kAMAb8oczljuyJHPsVPWox/QIXDFOnT9DUk1UC8EbnHKRdQowT7sOBe7LAjajQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css"
          integrity="sha512-gOQQLjHRpD3/SEOtalVq50iDn4opLVup2TF8c4QPI3/NmUPNZOk2FG0ihi8oCU/qYEsw4P6nuEZT2lAG0UNYaw=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>

    <%-- 카카오맵 API --%>
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f714ffceece9359c7acaeb2b338b1ae7&libraries=services,clusterer,drawing"></script>

    <%-- 좌표계산을 쉽게 할 수 있음 --%>
    <script src="https://cdn.jsdelivr.net/npm/geolib@3.3.4/lib/index.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css"/>

    <!-- 다음 주소 API -->
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%--아임포트 API--%>
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <!-- jQuery 로드 -->
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<%--    포트원 결제--%>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>

</head>
<body>
<!-- 즐겨찾기 테이블 -->
<table id="myFavoritesTable" class="hidden">
    <thead></thead>
    <tbody></tbody>
</table>

<!-- 챗봇 아이콘 -->
<div id="chat_icon">
	<a onclick="openChatRoom(); return false;">
		<img src="${cpath }/resources/image/chat-icon.png" width="50">
	</a>
</div>

<!-- (상담사한테만 뜸) 채팅방 목록 아이콘 -->
<c:if test="${not empty login && login.role == 1 }">
	<div id="list_icon">
		<a href="${cpath }/chat/rooms">
			<img src="${cpath }/resources/image/list-icon.png" width="50">
		</a>
	</div>
</c:if>


<header>
	<!-- 로고 -->
	<div class="logo">
		<a href="${cpath }"><img src="${cpath }/resources/image/로고.png"></a>
	</div>
	
	<!-- 헤더 오른쪽 메뉴 모음 -->
	<div class="header-right">
	  
	  	<c:if test="${not empty login }">
			<!-- 즐겨찾기 아이콘 -->
			<div class="myFavoritesIcon" id="myFavorites" data-page="1"></div>
			      
			<!-- 알림 아이콘 -->
			<div class="notificationIcon" id="notification" data-page="1"><span id="notificationCountSpan" class="hidden"></span></div>
		</c:if>
		      
		<!-- 건강정보 아이콘 -->
		<a href="${cpath }/healthInfo/healthInfo">
			<div class="healthInfoIcon"></div>
		</a>
		
		<!-- 로그인 아이콘, 로그인했을 시 정보띄우기 -->
		<c:if test="${empty login }">
			<div class="loginIcon"></div>
		</c:if>
		<c:if test="${not empty login }">
			<div class="loginInfoArea">
				<span id="gotoInfo">
					<a href="${cpath}/member/info/${login.id}">${login.name } 님</a>
				</span>
				<a href="${cpath }/member/logout"><button id="logoutBtn">로그아웃</button></a>
			</div>
		</c:if>
	</div>
</header>

<!--예약 모달 -->
<div id="bookingModal" class="bookingModal hidden" >
    <div class="bookingOverlay"></div>
    <div class="bookingContent">
        <h3 class="bookingTitle"></h3>
        <div class="bookingDetail"></div>
        <button id="closeBookingBtn">닫기</button>
    </div>
</div>

<%-- 최근 본 병원 목록 표시 (로그인 후) --%>
<c:if test="${not empty recentHospitals}">
<div id="recentHospitalsContainer">
    <h2>최근 본 병원</h2>
    <div class="recent-hospitals">
        <c:forEach var="hospital" items="${recentHospitals}">
            <a href="${cpath}/hospitalInfo/${hospital.id}">
                <div class="hospital-card">
                    <img src="${hospital.imageUrl}" class="recentHospital-image"/>
                    <div class="recentHospital-info">
                        <h3 class="hospital-name">${hospital.hospital_name}</h3>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>
</div>
</c:if>

<!-- 새창에서 챗봇 페이지로 이동 -->
<script>
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
</script>

<!-- 예약하기 입력 폼 -->
<form id="bookingInsertForm" class="hidden">
    <p><input type="hidden" name="member_id" value="${login.id }"></p>
    <p><input id="hospital_id" type="hidden" name="hospital_id" value="${hospital.id }"></p>
    <p><input type="hidden" name="status" value=1></p>
    <p><input id="booking_date" type="datetime-local" name="booking_date"  value="${now }" required></p>
    <p><input type="submit" value="예약하기"></p>
</form>

<!-- 예약 변경 입력 폼 -->
<form id="bookingUpdateForm" class="hidden">
    <p><input type="hidden" name="member_id" value="${login.id }"></p>
    <p><input id="hospital_id" type="hidden" name="hospital_id" value="${hospital.id }"></p>
    <p><input id="booking_date" type="datetime-local" name="booking_date" required><p>
    <p><input type="submit" value="예약변경"></p>
</form>

<!-- 알림 정보 테이블 -->
<table id="notificationTable" class="hidden">
    <thead></thead>
    <tbody></tbody>
</table>

<%--로그인--%>
<script>
    const cpath = '${cpath}'
    const loginIcon = document.querySelector('div.loginIcon')

    
    if (loginIcon) {
        loginIcon.addEventListener('click', function() {
            location.href = cpath + '/member/login'
        })
    }
</script>

<!-- 호원 스크립트 -->
<script>
    <!-- 알림 스크립트 -->
    const notification = document.getElementById('notification')
    const notificationTable = document.getElementById('notificationTable')
    const notificationTableHead = document.querySelector('#notificationTable thead')
    const notificationTableBody = document.querySelector('#notificationTable tbody')
    const bookingTitleElement = document.querySelector('.bookingTitle')
    const bookingDetailElement = document.querySelector('.bookingDetail')
    const bookingOverlay = document.querySelector('.bookingOverlay')
    const notificationCountSpan = document.getElementById('notificationCountSpan')
    const closeBookingBtn = document.getElementById('closeBookingBtn')
    const bookingInsertForm = document.getElementById('bookingInsertForm')
    const bookingUpdateForm = document.getElementById('bookingUpdateForm')

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



 	// 아직 안읽은 알림 갯수 가져와서 띄우는 함수

    async function notificationCount(){
        const url = cpath + '/notificationCount'
        const opt = {
            method : 'GET'
        }
        const result = await fetch(url, opt).then(resp => resp.json())
        if (result > 0 && '${login}' != '') {
            notificationCountSpan.classList.remove('hidden')
            if (result >= 10) {
                notificationCountSpan.innerText = '9+' // 10 이상은 '9+'로 표시
            } else {
                notificationCountSpan.innerText = result // 10 미만은 해당 숫자 표시
            }
            return result
        } else {
			if('${login}' != ''){
              
               notificationCountSpan.innerText = '' // 0 이하일 경우 비움
               notificationCountSpan.classList.add('hidden')
           }
            return ''
        }
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
    if('${login}' != ''){
	    notification.addEventListener('click', readNotification)	
    }
    document.addEventListener('DOMContentLoaded', notificationCount)
</script>



<!-- 즐겨찾기 -->
<script>
    const myFavorites = document.getElementById('myFavorites')
    const myFavoritesTable = document.getElementById('myFavoritesTable')
    const myFavoritesTableHead = document.querySelector('#myFavoritesTable thead')
    const myFavoritesTableBody = document.querySelector('#myFavoritesTable tbody')


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
                    cancelButtonColor: '#d33',
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
                    cancelButtonColor: '#d33',
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
        const url = '${cpath}/myFavoritesMaxPage'
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
        const url = '${cpath}/deleteMyfavoritesAll'
        const opt = {
            method : 'DELETE'
        }
        const result = await fetch(url, opt).then(resp => resp.json())
        if(result > 0) openMyFavorites({ target: { dataset: { page: 1 } } })
    }

    if('${login}' != '') {
    	myFavorites.addEventListener('click', (event) => openMyFavorites(event))
    }
</script>

