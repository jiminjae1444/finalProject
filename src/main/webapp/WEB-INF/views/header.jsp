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
    const login = '${login}'
    const loginIcon = document.querySelector('div.loginIcon')
</script>
<script src="${cpath}/resources/script/header/headerFunctionFirst.js"></script>

<script>

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

    document.addEventListener('DOMContentLoaded', notificationCount)
</script>
<script src="${cpath}/resources/script/header/headerFunctuion.js"></script>


<!-- 즐겨찾기 -->
<script>
    const myFavorites = document.getElementById('myFavorites')
    const myFavoritesTable = document.getElementById('myFavoritesTable')
    const myFavoritesTableHead = document.querySelector('#myFavoritesTable thead')
    const myFavoritesTableBody = document.querySelector('#myFavoritesTable tbody')
</script>

