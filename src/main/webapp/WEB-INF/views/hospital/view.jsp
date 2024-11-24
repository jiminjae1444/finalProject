<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm" var="now" />

<!-- 예약 정보에 있는 예약 시간을 포맷한다 -->
<fmt:formatDate value="${bookingInfo.booking_date }" pattern="yyyy-MM-dd HH:mm" var="booking_date"/>
<%-- 즐겨찾기 및 예약 스타일--%>

<style>
    body{
        background: linear-gradient(to bottom,#2c3e50, #a4a4a4);
    }
</style>
<style>
    /* favorite-icon 스타일 */
    .favorite-icon {
        display: inline-block;
        width: 50px;
        height: 40px;
        background-size: contain;
        background-repeat: no-repeat;
        margin-left: 8px;
        cursor: pointer;
        margin-bottom: 10px;
        position: absolute;
        top: 40px;
        left: 475px;
    }

    /* time-diff와 booking-btn 스타일 */
    .time-diff {
        margin-top: 15px;
        font-size: 16px;
        color: #d35400;
        padding: 8px 12px;
        background-color: #f9ebea;
        border-radius: 5px;
    }

    #bookingBtn {
        display: flex; /* Flexbox 사용 */
        justify-content: center; /* 수평 중앙 정렬 */
        align-items: center; /* 수직 중앙 정렬 */
        gap: 10px; /* 버튼 간의 간격 */
        margin-top: 10px; /* 상단 여백 */
    }
    /* 예약 취소 및 변경 버튼 스타일 */
    #bookingCancelBtn, #bookingUpdateBtn,#bookingInsertBtn , #paymentBtn ,#cancelPaymentBtn {
        padding: 12px 20px; 
        font-size: 1.1em; 
        font-weight: bold; 
        color: #fff; 
        border: none; 
        border-radius: 5px; 
        cursor: pointer; 
        transition: background-color 0.3s ease, transform 0.2s ease; /* 배경색 변화와 변형 애니메이션 */
    }
    #bookingInsertBtn {
        background-color: #34495e; /* 파란색 배경 */
        width: 100%;
    }
    #bookingInsertBtn:hover {
        background-color: #2c3e50; /* 호버 시 어두운 파란색 */
        transform: translateY(-2px); /* 위로 이동하는 효과 */
    }
    /* 예약 취소 버튼 스타일 */
    #bookingCancelBtn {
        background-color: #e74c3c; /* 빨간색 배경 */
    }

    #bookingCancelBtn:hover {
        background-color: #c0392b; /* 호버 시 어두운 빨간색 */
        transform: translateY(-2px); /* 위로 이동하는 효과 */
    }

    /* 예약 변경 버튼 스타일 */
    #bookingUpdateBtn {
        background-color: #53db34;
    }

    #bookingUpdateBtn:hover {
        background-color: #3ba929;
        transform: translateY(-2px); /* 위로 이동하는 효과 */
    }

    /* 결제하기 버튼 스타일 */
    #paymentBtn {
        background-color: #8e44ad; /* 기본 보라색 배경 */
    }

    #paymentBtn:hover {
        background-color: #704183; /* 호버 시 더 밝은 보라색 */
        transform: translateY(-2px); /* 위로 이동하는 효과 */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    }

    #cancelPaymentBtn{
        background-color: #f358ff; /* 기본 보라색 배경 */
    }

    #cancelPaymentBtn:hover {
        background-color: #d50dc2; /* 호버 시 더 밝은 보라색 */
        transform: translateY(-2px); /* 위로 이동하는 효과 */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    }

    #cancelPaymentBtn{
        transform: translateY(0); /* 클릭 시 원래 위치로 복귀 */
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 클릭 시 더 강한 그림자 */
    }

    #paymentBtn:active {
        transform: translateY(0); /* 클릭 시 원래 위치로 복귀 */
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); /* 클릭 시 더 강한 그림자 */
    }

    /* 모바일 반응형 스타일 */
    @media (max-width: 768px) {
        #bookingCancelBtn, #bookingUpdateBtn , #paymentBtn {
            width: 100%; /* 모바일에서 버튼을 전체 너비로 설정 */
            font-size: 1em; /* 폰트 크기 조정 */
        }
    }
</style>

<%--병원 레이아웃--%>
<style>
    .container {
        display: flex;
        justify-content: space-between;
        align-items: stretch;
        max-width: 1200px; /* 전체 너비 제한 */
        margin: 0 auto; /* 중앙 정렬 */
        padding: 40px;
        font-family: 'Noto Sans KR', Arial, sans-serif;
        gap: 20px; /* 양쪽 열 사이의 간격 */
    }

    .left-column, .right-column {
        flex: 1; /* 양쪽 열의 균등한 너비 */
        padding: 20px;
        background-color: #f7f9fa;
        border-radius: 10px;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        position: relative;
        min-height: 1270px;
    }
    .hospital-info{
        width: 500px;
    }

    .hospital-info h2 {
        font-size: 24px;
        color: #34495e;
        font-weight: bold;
        margin-bottom: 20px;
    }

    .hospital-image{
        height: 300px;
        width: 500px;
    }
    .hospital-image img {
        width: 100%;
        height: 90%;
        object-fit: cover;
        border-radius: 10px;
        margin-bottom: 20px;
        transition: transform 0.3s ease-in-out;
    }

    .hospital-image img:hover {
        transform: scale(1.05); /* 5% 크기 확대 */
    }

    .hospital-details p {
        font-size: 16px;
        color: #2c3e50;
        margin: 15px 0;
    }

    .hospital-details a {
        color: #3498db;
        text-decoration: none;
    }

    .hospital-details a:hover {
        text-decoration: underline;
    }

    .jinryo-description h3, .hospital-time h3 {
        font-size: 20px;
        color: #34495e;
        margin-top: 30px;
        margin-bottom: 10px;
    }

    .tags {
        display: flex;
        flex-wrap: wrap;
        gap: 5px;
    }

    .tag {
        background-color: #e1f5fe;
        color: #0277bd;
        padding: 5px 10px;
        border-radius: 15px;
        font-size: 14px;
    }

    .hospital-time table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }
    .tag:hover {
        background-color: #0073e6;
        color: #fff;
        transform: scale(1.05);
        cursor: pointer;
    }
    .hospital-time th, .hospital-time td {
        padding: 8px 10px;
        font-size: 16px;
        color: #2c3e50;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }

    .find-route {
        display: flex;
        justify-content: center;
        margin-top: 30px;
    }

    .find-route-btn {
        background-color: #2c3e50;
        color: #ffffff;
        padding: 12px 20px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .find-route-btn:hover {
        background-color: #34495e;
        transform: translateY(-2px);
    }
    .hospital-address > h3{
        font-size: 20px;
        color: #34495e;
        margin-bottom: 15px;
    }
    #DynamicMap {
        width: 100%;
        height: 400px;
        border: 1px solid #ddd;
        border-radius: 10px;
        margin-top: 20px;
    }
    .hospital-info-window {
        padding: 10px;
        font-size: 16px;
        text-align: center;
        font-weight: bold;
        color: #3498db;
        background-color: white;
        border-radius: 5px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        width: 200px;
        height: 20px;
        white-space: nowrap; /* 줄 바꿈 없이 한 줄로 표시 */
        overflow: hidden; /* 내용이 넘치면 숨기기 */
        text-overflow: ellipsis; /* 내용이 넘칠 경우 '...' 표시 */
    }

    #routeModal{
        display: none;
    }
</style>


<%--리뷰 스타일--%>
<style>
    .review-section {
        margin-top: 30px;
        padding: 20px;
    }
    .no-reviews {
        text-align: center;
        font-size: 16px;
        color: #666;
        padding: 30px;
        background-color: #f9f9f9;
        border-radius: 10px;
        border: 1px solid #ddd;
    }
    .review-section h3 {
        font-size: 20px;
        color: #34495e;
        margin-bottom: 15px;
    }
    .review-section img {
    	width: 40px;
    	align-items: center;
    	vertical-align: middle;
    	margin-bottom: 3px;
    	margin-left: 8px;
    	margin-right: 10px;
    }

    .review-card {
        display: flex;
        flex-direction: column;
        background-color: #ffffff;
        padding: 15px;
        margin-bottom: 15px;
        border-radius: 10px;
        box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
    }

    .review-header {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
    }

    .profile-img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        margin-right: 10px;
    }

    .user-info {
        display: flex;
        flex-direction: column;
    }

    .user-id {
        font-size: 14px;
        font-weight: bold;
        color: #34495e;
    }

    .created-at {
        font-size: 12px;
        color: #7f8c8d;
    }

    .review-body {
        margin-top: 10px;
    }

    .rating {
        font-size: 16px;
        font-weight: bold;
        color: #f39c12;
    }

    .comments {
        font-size: 14px;
        color: #2c3e50;
        margin-top: 5px;
    }

    .review-footer {
        display: flex;
        justify-content: center;
        margin-top: 20px;
    }

    .view-all-reviews-btn {
        background-color: #2c3e50;
        color: #ffffff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .view-all-reviews-btn:hover {
        background-color: #34495e;
        transform: translateY(-2px);
    }

</style>

<%--찾아오는 길 스타일--%>
<style>
    .route-legend {
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid #ddd;
    }

    .route-legend h4 {
        font-size: 18px;
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }

    .route-legend ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .route-legend li {
        display: flex;
        align-items: center;
        margin-bottom: 8px;
        font-size: 14px;
        color: #444;
    }

    .route-legend .legend-item {
        width: 20px;
        height: 20px;
        margin-right: 10px;
        border-radius: 50%;
    }

    .route-legend .walk {
        background-color: #e6e6e6; /* 도보 색상 */
    }

    .route-legend .bus {
        background-color: #ffe6e6; /* 버스 색상 */
    }

    .route-legend .subway {
        background-color: #e6ffe6; /* 지하철 색상 */
    }

    .route-legend .default {
        background-color: #fff9e6; /* 기타 색상 */
    }
    /* 공통 스타일 */
    #routeInfo {
        font-family: Arial, sans-serif;
        line-height: 1.6;
    }

    #routeTitle{
        font-size: 20px;
        font-weight: bold;
    }
    /* 모달 배경 스타일 */
    .routeModal {
        display: none; /* 초기 상태 숨김 */
        position: fixed; /* 화면 고정 */
        z-index: 1000; /* 최상위 표시 */
        left: 0;
        top: 0;
        width: 100vw;
        height: 100vh;
        background-color: rgba(0, 0, 0, 0.5); /* 반투명 검정 배경 */
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden; /* 모달 외부 스크롤 방지 */
    }

    /* 모달 콘텐츠 */
    .modal-content {
        position: relative;
        width: 80%; /* 모달 가로 크기 */
        max-width: 600px; /* 최대 가로 크기 */
        height: 70%; /* 모달 세로 크기 */
        background-color: white;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.25);
        display: flex;
        flex-direction: column; /* 콘텐츠 상하 정렬 */
        overflow: hidden; /* 내부 콘텐츠 스크롤 */
        left: 50%;
        top: 50%;
        transform: translate(-50%,-50%);
    }

    /* 모달 제목 */
    .modal-content h4 {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 15px;
        color: #333;
    }

    /* 스크롤 가능한 영역 */
    #routeInfo {
        flex: 1; /* 남은 공간 채우기 */
        overflow-y: auto; /* 세로 스크롤 활성화 */
        font-family: Arial, sans-serif;
        line-height: 1.6;
        font-size: 14px;
        color: #444;
        padding-right: 10px; /* 스크롤바와 텍스트 간 여백 */
        margin-bottom: 15px; /* 버튼과 간격 */
    }

    /* 스크롤바 숨김 (크롬, 엣지) */
    #routeInfo::-webkit-scrollbar {
        width: 0; /* 스크롤바 너비 제거 */
    }


    #routeInfo > ul, ol {
        list-style-type: none;
        padding: 0;
        margin: 0;
    }

    #routeInfo > ul li {
        margin-bottom: 15px;
    }

    .total-info {
        font-size: 16px;
        margin: 5px 0;
    }

    .leg-list {
        border-left: 3px solid #ddd;
        padding-left: 15px;
        margin-top: 10px;
    }

    .leg-item {
        margin-bottom: 20px;
        padding: 10px;
        border-radius: 8px;
        background-color: #f9f9f9;
        transition: transform 0.3s ease;
    }

    .leg-item:hover {
        transform: translateX(10px);
        background-color: #f5f5f5;
    }

    /* 스타일별 이동 방법 */
    .leg-item.walk {
        border-left-color: black;
        background-color: #e6e6e6;
        color: black;
    }

    .leg-item.bus {
        border-left-color: red;
        background-color: #ffe6e6;
        color: red;
    }

    .leg-item.subway {
        border-left-color: green;
        background-color: #e6ffe6;
        color: green;
    }

    .leg-item.default {
        border-left-color: yellow;
        background-color: #fff9e6;
        color: #b58900;
    }

    /* 세부 단계 (steps) */
    .step-list {
        padding-left: 20px;
        margin-top: 10px;
    }

    .step-list li {
        margin-bottom: 8px;
        font-size: 14px;
        color: #555;
    }

    .step-list li strong {
        color: #333;
    }

    .modal-content h4 {
        margin-top: 0;
        font-size: 20px;
        color: #333;
    }
    #closeRouteBtn {
        position: absolute;
        top: 10px;
        right: 10px;
        background-color: #e74c3c;
        color: white;
        border: none;
        border-radius: 5px;
        padding: 5px 10px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.2s ease;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    #closeRouteBtn:hover {
        background-color: #c0392b;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }
</style>

<div class="container">
    <div class="content-wrapper">
        <div class="left-column">
            <div class="hospital-info">
                <h2>${hospital.hospital_name}</h2>
                <span id="myFavoriteHospital" class="favorite-icon" data-id="${hospital.id}"></span>
                <div class="hospital-image">
                    <img id="hospitalImage" src="${hospital.imageUrl}" alt="${hospital.hospital_name}">
                </div>
                <div class="hospital-details">
                    <p><strong>주소:</strong> ${hospital.address}</p>
                    <p><strong>전화번호:</strong> ${hospital.tel}</p>
                    <p><strong>홈페이지:</strong> <a href="${hospital.homepage}" target="_blank">${hospital.homepage}</a></p>
                    <p><strong>의사 수:</strong> ${hospital.doctors}명</p>
                    <p><strong>기본진료비:</strong> ${hospital.medical_expenses}원</p>
                </div>
                <div class="jinryo-description">
                    <h3>진료과</h3>
                    <div class="tags">
                        <c:forEach var="jinryo" items="${jinryoNames}">
                            <span class="tag">${jinryo}</span>
                        </c:forEach>
                    </div>
                </div>
                <div class="hospital-time">
                    <h3>운영 시간</h3>
                    <table>
                        <thead>
                        <tr>
                            <th>요일</th>
                            <th>운영 시간</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>월요일</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty hospitalTime.mon_start && not empty hospitalTime.mon_end}">
                                        ${hospitalTime.mon_start.substring(0, 2)}:${hospitalTime.mon_start.substring(2, 4)} - ${hospitalTime.mon_end.substring(0, 2)}:${hospitalTime.mon_end.substring(2, 4)}
                                    </c:when>
                                    <c:otherwise>
                                        9:00 - 18:00
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>화요일</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty hospitalTime.tue_start && not empty hospitalTime.tue_end}">
                                        ${hospitalTime.tue_start.substring(0, 2)}:${hospitalTime.tue_start.substring(2, 4)} - ${hospitalTime.tue_end.substring(0, 2)}:${hospitalTime.tue_end.substring(2, 4)}
                                    </c:when>
                                    <c:otherwise>
                                        9:00 - 18:00
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>수요일</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty hospitalTime.wed_start && not empty hospitalTime.wed_end}">
                                        ${hospitalTime.wed_start.substring(0, 2)}:${hospitalTime.wed_start.substring(2, 4)} - ${hospitalTime.wed_end.substring(0, 2)}:${hospitalTime.wed_end.substring(2, 4)}
                                    </c:when>
                                    <c:otherwise>
                                        9:00 - 18:00
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>목요일</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty hospitalTime.thu_start && not empty hospitalTime.thu_end}">
                                        ${hospitalTime.thu_start.substring(0, 2)}:${hospitalTime.thu_start.substring(2, 4)} - ${hospitalTime.thu_end.substring(0, 2)}:${hospitalTime.thu_end.substring(2, 4)}
                                    </c:when>
                                    <c:otherwise>
                                        9:00 - 18:00
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>금요일</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty hospitalTime.fri_start && not empty hospitalTime.fri_end}">
                                        ${hospitalTime.fri_start.substring(0, 2)}:${hospitalTime.fri_start.substring(2, 4)} - ${hospitalTime.fri_end.substring(0, 2)}:${hospitalTime.fri_end.substring(2, 4)}
                                    </c:when>
                                    <c:otherwise>
                                        9:00 - 18:00
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>토요일</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty hospitalTime.sat_start && not empty hospitalTime.sat_end}">
                                        ${hospitalTime.sat_start.substring(0, 2)}:${hospitalTime.sat_start.substring(2, 4)} - ${hospitalTime.sat_end.substring(0, 2)}:${hospitalTime.sat_end.substring(2, 4)}
                                    </c:when>
                                    <c:otherwise>
                                        9:00 - 13:00
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td>일요일</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty hospitalTime.sun_start && not empty hospitalTime.sun_end}">
                                        ${hospitalTime.sun_start.substring(0, 2)}:${hospitalTime.sun_start.substring(2, 4)} - ${hospitalTime.sun_end.substring(0, 2)}:${hospitalTime.sun_end.substring(2, 4)}
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div id="timeDiff" class="time-diff hidden"></div>
                <div id="payment" class="payment"></div>
                <div id="bookingBtn"></div>
            </div>
        </div>
    </div>
        <div class="right-column">
            <div class="hospital-address">
                <h3>위치</h3>
                <div id="DynamicMap"></div>
                <div class="find-route">
                    <button class="find-route-btn" id="findRouteBtn">찾아오는 길</button>
                </div>
            </div>
            <div class="review-section">
                <h3>리뷰 (${reviewCount }) <img src="${cpath}/resources/image/star-icon.png">${reviewAvg }</h3>
                <div id="reviewListSome">
                    <c:if test="${empty reviewList}">
                        <div class="no-reviews">
                            <p>아직 리뷰가 없습니다. 첫 번째 리뷰를 작성해 주세요!</p>
                        </div>
                    </c:if>
                    <c:forEach var="review" items="${reviewList}">
                        <div class="review-card">
                            <div class="review-header">
                                <img class="profile-img" src="${cpath }/fpupload/image/${empty review.PROFILE_IMG ? 'default.png' : review.PROFILE_IMG}">
                                <div class="user-info">
                                    <div class="user-id">${review.USERID}</div>
                                    <div class="created-at">${review.CREATED_AT}</div>
                                </div>
                            </div>
                            <div class="review-body">
                                <div class="rating">
                                    <c:forEach var="i" begin="1" end="${review.RATING}">
                                        ★
                                    </c:forEach>
                                    <c:forEach var="i" begin="${review.RATING + 1}" end="5">
                                        ☆
                                    </c:forEach>
                                </div>
                                <p class="comments">${review.COMMENTS}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="review-footer">
                    <a href="${cpath}/review/${id}/view">
                        <button class="view-all-reviews-btn">리뷰 전체보기</button>
                    </a>
                </div>
            </div>
        </div>
    </div>

   </div>


<div id="routeModal" class="routeModal">
    <div class="modal-content">
        <div class="route-legend">
            <h4>이동 방법별 색상 범례</h4>
            <ul>
                <li><span class="legend-item walk"></span> 도보</li>
                <li><span class="legend-item bus"></span> 버스</li>
                <li><span class="legend-item subway"></span> 지하철</li>
                <li><span class="legend-item default"></span> 기타</li>
            </ul>
        </div>
        <h4>경로 정보</h4>
        <div id="routeInfo"></div> <!-- 경로 정보가 들어갈 부분 -->
        <button id="closeRouteBtn">닫기</button>
    </div>
</div>


<%@ include file="../footer.jsp" %>



<!-- 민재 스크립트 -->

<script>
    const closeRouteBtn = document.getElementById('closeRouteBtn');
    const findRouteBtn = document.getElementById('findRouteBtn');
    function loadHandler() {
// 카카오 지도 API Geocoder 인스턴스 생성
        const geocoder = new kakao.maps.services.Geocoder();

// 서버에서 받아온 병원 주소
        var address = '${hospital.address}'; // JSP에서 병원 주소로 대체됩니다
        const splitAddress = address.split(' ');
         address = splitAddress.slice(0, 4).join(' ');

// 주소를 좌표로 변환
        geocoder.addressSearch(address, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const lat = result[0].y // 위도
                const lng = result[0].x // 경도
                const coords = new kakao.maps.LatLng(lat, lng) // 카카오 지도에 사용할 좌표 객체

// 지도 컨테이너와 기본 옵션 설정
                const mapContainer = document.getElementById('DynamicMap') // 지도 표시할 HTML 요소
                const mapOptions = {
                    center: coords, // 지도의 중심 좌표 설정
                    level: 2, // 지도 확대/축소 레벨 설정 (1: 가장 축소, 15: 가장 확대)
                }

// 카카오 지도 객체 생성
                const map = new kakao.maps.Map(mapContainer, mapOptions)

// 병원 위치에 마커 생성
                const marker = new kakao.maps.Marker({
                    position: coords, // 마커의 위치 설정
                });
                marker.setMap(map) // 지도에 마커 추가

// 병원 이름을 표시할 인포윈도우 생성
                const infowindow = new kakao.maps.InfoWindow({
                    content: `<div class="hospital-info-window">${hospital.hospital_name}</div>`,
                })

// 지도 로드 시 바로 인포윈도우 표시
                infowindow.open(map, marker) // 마커 위에 바로 인포윈도우 표시
            } else {
// 주소 검색 실패 시 오류 메시지
                swal({
                    title: '오류 발생',
                    text: '주소를 찾을 수 없습니다.',
                    type: 'error', // 오류에 맞는 아이콘 선택
                    button: "확인"
                });
            }
        })
    }

    function openRouteModal() {
        const modal = document.getElementById("routeModal")
        modal.style.display = "block"  // 모달 표시
        // console.log("모달이 열렸습니다.")
        getUserLocationAndDirections()
    }

    function closeRouteModal() {
        const modal = document.getElementById('routeModal')
        modal.style.display = 'none'  // 모달 숨기기
        // console.log("모달이 닫혔습니다.")
        document.getElementById('routeInfo').innerHTML = '';
    }

    async function getUserLocationAndDirections() {
        // 사용자에게 "주소 사용" 또는 "현재 위치 사용"을 물어보는 팝업
        const userChoice = await Swal.fire({
            title: "위치 설정",
            text: "주소를 사용하시겠습니까? 아니면 현재 위치를 사용하시겠습니까?",
            icon: "question",
            showCancelButton: true,
            confirmButtonText: "주소 사용",
            cancelButtonText: "현재 위치 사용",
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#c1c1c1',
        });

        // "주소 사용"을 선택했을 때
        if (userChoice.isConfirmed) {
            useLoginLocation(); // 로그인된 주소로 위치 정보 변환 및 경로 찾기
        }
        // "현재 위치 사용"을 선택했을 때
        else {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var userLat = position.coords.latitude;
                    var userLng = position.coords.longitude;
                    var hospitalLat = ${hospital.lat}; // 서버에서 전달받은 병원 위도
                    var hospitalLng = ${hospital.lng}; // 서버에서 전달받은 병원 경도

                    getDirections(userLat, userLng, hospitalLat, hospitalLng); // 경로 찾기
                }, function(error) {
                    Swal.fire({
                        title: "위치 오류",
                        text: "위치 정보를 가져오는데 실패했습니다.",
                        icon: "error",
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: "확인"
                    });
                });
            } else {
                Swal.fire({
                    title: "오류",
                    text: "Geolocation을 지원하지 않는 브라우저입니다.",
                    icon: "error",
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: "확인"
                });
            }
        }
    }

    // 로그인된 사용자 주소를 사용하는 함수
    function useLoginLocation() {
        if (${not empty login.location}) {  // 사용자 주소가 있을 때
            var loginAddress = "${login.location}";  // 로그인된 사용자 주소
            convertAddressToCoordinates(loginAddress, function(result) {
                if (result) {
                    var userLat = result.y;
                    var userLng = result.x;
                    var hospitalLat = ${hospital.lat}; // 서버에서 전달받은 병원 위도
                    var hospitalLng = ${hospital.lng}; // 서버에서 전달받은 병원 경도

//                     console.log("사용자 주소 위치:", userLat, userLng); // 주소에서 가져온 사용자 위치
//                     console.log("병원 위치:", hospitalLat, hospitalLng); // 병원 위치 확인

                    getDirections(userLat, userLng, hospitalLat, hospitalLng); // 경로 찾기
                } else {
                    Swal.fire({
                        title: "오류",
                        text: "주소를 좌표로 변환할 수 없습니다.",
                        icon: "error",
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: "확인"
                    });
                }
            });
        } else {
            // 로그인 되어 있지 않은 경우, 로그인 페이지로 이동
            Swal.fire({
                title: "로그인 필요",
                text: "주소를 사용하려면 로그인해야 합니다.",
                icon: "warning",
                confirmButtonColor: '#3085d6',
                confirmButtonText: "로그인",
            }).then((result) => {
                if (result.isConfirmed) {
                    const currentPageUrl = window.location.href
                    window.location.href = cpath + '/member/login?redirectUrl=' + encodeURIComponent(currentPageUrl) // 로그인 페이지로 리다이렉션
                }
            });
        }
    }

    // 주소를 좌표로 변환하는 함수
    function convertAddressToCoordinates(address, callback) {
        var geocoder = new kakao.maps.services.Geocoder();

        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                callback(result[0]);
            } else {
                callback(null);
            }
        });
    }

    async function getDirections(startY, startX, endY, endX) {
        const url = '${cpath}/hospitals/routes' // 경로 API 호출 URL
        const requestBody = { startY, startX, endY, endX }

        const options = {
            method: 'POST',
            body: JSON.stringify(requestBody),
            headers: { 'Content-Type': 'application/json' }
        }

        try {
            const result = await fetch(url, options).then(resp=>resp.json())
            const itineraries = result.itineraries
            displayRoute(itineraries)
        } catch (error) {
            await closeRouteModal()
//             console.error("경로 API 호출 중 오류:", error)
            swal({
                title: '오류',
                text: '예기치 못한 오류가 발생했습니다',
                type: 'error',
                confirmButtonColor: '#3085d6',
                button: "확인"
            })
        }
    }

    function displayRoute(itineraries) {
        const routeInfoDiv = document.getElementById('routeInfo')

        if (itineraries && Array.isArray(itineraries)) {
            let routeHtml = '<ul>'

            itineraries.forEach((itinerary, index) => {
                routeHtml += '<li id="routeTitle"><strong>추천 경로' + (index + 1) + '</strong>'

                // 총 소요 시간 및 거리
                routeHtml += '<p class="total-info"><strong>총 소요 시간:</strong> ' + Math.floor(itinerary.totalTime / 60) + '분</p>'
                routeHtml += '<p class="total-info"><strong>총 거리:</strong> ' + (itinerary.totalDistance / 1000).toFixed(2) + 'km</p>'

                // 요금 정보 (존재하는 경우에만)
                if (itinerary.fare && itinerary.fare.regular) {
                    routeHtml += '<p class="total-info"><strong>총 요금:</strong> ' + itinerary.fare.regular.currency.symbol + itinerary.fare.regular.totalFare + '원</p>'
                }

                // 각 구간(legs) 정보
                routeHtml += '<ol class="leg-list">'
                itinerary.legs.forEach((leg, legIndex) => {
                    routeHtml += '<li class="leg-item ' + leg.mode.toLowerCase() + '"><strong>' + (legIndex + 1) + '번째</strong> '

                    // 구간 출발지와 도착지
                    if (leg.start && leg.start.name) {
                        routeHtml += '<p class="leg-info"><strong>출발지:</strong> ' + leg.start.name + '</p>'
                    }
                    if (leg.end && leg.end.name) {
                        routeHtml += '<p class="leg-info"><strong>도착지:</strong> ' + leg.end.name + '</p>'
                    }

                    // 이동 방법 스타일 적용
                    routeHtml += '<p class="leg-mode"><strong>이동 방법:</strong> '
                    switch (leg.mode) {
                        case 'WALK':
                            routeHtml += '도보 (' + Math.floor(leg.sectionTime / 60) + '분, ' + leg.distance + 'm)</p>'
                            break
                        case 'BUS':
                            routeHtml += leg.route  + '번 버스 (' + Math.floor(leg.sectionTime / 60) + '분)</p>'
                            break
                        case 'SUBWAY':
                            routeHtml += leg.route + ' 지하철 (' + Math.floor(leg.sectionTime / 60) + '분)</p>'
                            break
                        default:
                            routeHtml += '비행기 외 기타</p>'
                            break
                    }

                    // 각 구간의 상세 이동 단계 (steps)
                    if (leg.steps && leg.steps.length > 0) {
                        routeHtml += '<ul class="step-list">'
                        leg.steps.forEach(step => {
                            routeHtml += '<li><strong>' + (step.streetName || '도로명 없음') + ':</strong> ' + step.description + ' (' + step.distance + 'm)</li>'
                        });
                        routeHtml += '</ul>'
                    }

                    routeHtml += '</li>'
                })
                routeHtml += '</ol>'
                routeHtml += '</li>'
            })

            routeHtml += '</ul>'
            routeInfoDiv.innerHTML = routeHtml
        } else {
            Swal.fire({
                title: "경로 찾기 실패",
                text: "경로를 찾을 수 없습니다.",
                icon: "error",
                confirmButtonColor: '#3085d6',
                confirmButtonText: "확인"
            });
        }
    }
    findRouteBtn.onclick = openRouteModal
    closeRouteBtn.onclick = closeRouteModal
    window.addEventListener('DOMContentLoaded', loadHandler)
</script>

<!--  호원 스크립트 -->
<script>
    const payment = document.getElementById('payment')
   const timeDiff = document.getElementById('timeDiff')
   const bookingInfo = '${bookingInfo}'
   const hospital_id = '${hospital.id}'   // 병원의 고유id
   const member_id = '${login.id}'      // 멤버의 id
   const bookingModal = document.getElementById('bookingModal')
   const bookingBtn = document.getElementById('bookingBtn')
   const booking_date = new Date('${booking_date }').getTime()
   let bookingTimerInterval   // 예약시간까지 남은 시간 타이머 설정변수
   
   // 예약시간이 30분 남았을때 알림테이블에 넣고 그 알림 메일을 보내는 함수
   async function notificationBookingOneDay(){   
      const url = '${cpath}/notificationBookingOneDay/' + member_id + '/' + hospital_id
      const opt = {
            method : 'GET'
      }
      const result = await fetch(url, opt).then(resp => resp.json())
      if(result == 1) sendNotificationMail()
   }
   
   // 예약시간까지 남은 시간을 실시간으로 보여주는 함수
   function updateBookingTimer(booking_date) {
       let now = new Date().getTime()
       let difference = booking_date - now
       if (difference > 0) {
          let years = Math.floor(difference / (1000 * 60 * 60 * 24 * 365))
           let months = Math.floor((difference % (1000 * 60 * 60 * 24 * 365)) / (1000 * 60 * 60 * 24 * 30))
           let days = Math.floor((difference % (1000 * 60 * 60 * 24 * 30)) / (1000 * 60 * 60 * 24))
           let hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
           let minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60))
           let seconds = Math.floor((difference % (1000 * 60)) / 1000)
           let timerText = "예약시간 " + formatDate(booking_date) + "까지 " + (years == 0 ? '' : years + "년 ") + (months == 0 ? '' : months + "월 ")
           + (days == 0 ? '' : days + "일 ") + (hours == 0 ? '' : hours + "시간 ") + (minutes == 0 ? '' : minutes + "분 ") + (seconds == 0 ? '남음' : seconds + "초 남음");
         document.getElementById("timeDiff").innerHTML = timerText
           
           // 시간차이가 30분이되면 자동으로 알림을 띄우고 메일을 보냄
           if(difference < 86400500 && difference > 86399500) {
              Swal.fire({
                 title: '예약 알림',
                 text: '예약이 하루 남았습니다.',
                 icon: 'info',
                 confirmButtonText: '확인',
                    confirmButtonColor: '#9cd2f1',
                    allowOutsideClick: false,
                 allowEscapeKey: false,
                 showCloseButton: false
               }).then((result) => {if(result.isConfirmed) notificationBookingOneDay()})
          }
       }
       
       // 예약시간에 도달하면 자동으로 알림의 띄우고 메일을 보냄
       else {
          document.getElementById("timeDiff").innerHTML = '예약시간 만료'
           clearInterval(bookingTimerInterval)
          bookingTimeOver()
       }
   }
   
   // 입력폼을 모달에 띄우는 함수
   function readyToBook(event) {
      event.preventDefault()
      bookingInsertForm.classList.remove('hidden')
      openBookingModal('예약하기', bookingInsertForm)
   }
   
   // 변경폼을 모달에 띄우는 함수
   function readyToUpdateBooking(event) {
      event.preventDefault()
      bookingUpdateForm.classList.remove('hidden')
      openBookingModal('예약 변경하기', bookingUpdateForm)
   }
   
   // 알림테이블에 어떤 정보가 추가되면 그 정보를 메일로 보내는 함수
   async function sendNotificationMail(){
      const url = '${cpath}/sendNotificationMail'
      const opt = {
            method : 'POST'
      }
      const result = await fetch(url, opt).then(resp => resp.json())
      location.reload()
   }
   
   // 예약한 정보를 알림테이블에 추가하고 메일로 보내는 함수
   async function notificationBooking(){
      const url = '${cpath}/notificationBooking/' + member_id + '/' + hospital_id
      const opt = {
         method : 'POST'
      }
      const result = await fetch(url, opt).then(resp => resp.json())
      if(result == 1) sendNotificationMail()
      
   }
   
   // 예약 변경한 정보를 알림테이블에 추가하고 메일로 보내는 함수
   async function notificationBookingUpdate(){
      const url = '${cpath}/notificationBookingUpdate/' + member_id + '/' + hospital_id
      const opt = {
         method : 'POST'
      }
      const result = await fetch(url, opt).then(resp => resp.json())
      if(result == 1) sendNotificationMail()
   }

    async function bookingInsert() {
        const isLoggedIn = '${login}'
        if (!isLoggedIn) {
            const confirmResult = await Swal.fire({
                title: '로그인 필요',
                text: '예약을 진행하시려면 로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#9cd2f1',
                cancelButtonColor: '#c1c1c1',
                confirmButtonText: '예, 로그인하러 가기',
                cancelButtonText: '아니오'
            })

            if (confirmResult.isConfirmed) {
                // 로그인 페이지로 리디렉션
                const currentPageUrl = window.location.href
                window.location.href = cpath + '/member/login?redirectUrl=' + encodeURIComponent(currentPageUrl) // 로그인 페이지로 리다이렉션
            }
            return
        }

        const url = '${cpath}/bookingInsert'
        const formData = new FormData(bookingInsertForm)
        const data = {}
        formData.forEach((value, key) => {
            data[key] = value;
        })

        const bookingTime = new Date(data.booking_date).getTime()
        const now = new Date().getTime()
        const timeDifference = bookingTime - now
        const thirtyMinutesInMillis = 30 * 60 * 1000

        // 예약시간이 지금시간보다  30분 전이면 빠꾸먹임
        if (timeDifference <= 0) {
            const confirmResult = await Swal.fire({
                title: '예약 실패',
                text: '이미 지난 시간대입니다. 다시 선택해주세요.',
                icon: 'error',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1' // 확인 버튼 색상
            })
            if (confirmResult.isConfirmed) {
                return
            }
        }

        // 예약시간이 지금보다 30분 이내일 경우 추가 확인
        else if (timeDifference <= thirtyMinutesInMillis) {
            const confirmResult = await Swal.fire({
                title: '주의',
                text: '예약 시간이 30분 이내입니다. 정말로 예약하시겠습니까?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#9cd2f1',
                cancelButtonColor: '#c1c1c1',
                confirmButtonText: '예, 예약합니다',
                cancelButtonText: '아니오'
            })

            if (!confirmResult.isConfirmed) {
                return
            }
        }

        const opt = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        }
        const result = await fetch(url, opt).then(resp => resp.json())

        // 예약에 성공하면 그 정보를 알림테이블에 추가하고 메일로 보냄
        if (result == 1) {
            Swal.fire({
                title: '예약 완료',
                text: '예약이 완료되었습니다.',
                icon: 'success',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            }).then((result) => {
                if (result.isConfirmed) {
                    notificationBooking();
                }
            })
        } else if (result == 2) {
            Swal.fire({
                title: '예약 실패',
                text: '진료시간이 아닙니다. 다시 선택해주세요.',
                icon: 'error',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            })
        } else if (result == 3) {
            Swal.fire({
                title: '예약 불가',
                text: '해당 병원은 예약 불가능합니다.',
                icon: 'info',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            })
        } else {
            Swal.fire({
                title: '예약 실패',
                text: '알 수 없는 이유로 예약에 실패하였습니다.',
                icon: 'error',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            })
        }
    }

   // 예약 취소하는 함수
   async function bookingCancel(){
         const url = '${cpath}/bookingCancel/' + member_id + '/' + hospital_id
         const opt = {
            method : 'PATCH'
         }
         const result = await fetch(url, opt).then(resp => resp.json())
         
         // 예약 취소에 성공하면 그 내용을 알림테이블에 추가하고 메일로 보냄
         if(result == 1) {
            Swal.fire({
                 title: '예약 취소 완료',
                 text: '예약이 취소되었습니다.',
                 icon: 'success',
                 confirmButtonText: '확인',
                 allowOutsideClick: false,
                 allowEscapeKey: false,
                 showCloseButton: false,
                    confirmButtonColor: '#9cd2f1'
               }).then((result) => {if(result.isConfirmed) sendNotificationMail()})
         } 
         
         // 예외 상황 대처
         else Swal.fire({
              title: '예약 취소 실패',
              text: '알 수 없는 이유로 예약 취소에 실패하였습니다.',
              icon: 'error',
              confirmButtonText: '확인',
              allowOutsideClick: false,
              allowEscapeKey: false,
              showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            })    
   }
   
   // 예약 변경하는 함수
    async function bookingUpdate(){
        const url = '${cpath}/bookingUpdate'
        const formData = new FormData(bookingUpdateForm)

        const bookingDate1 = formData.get('booking_date')
        const bookingDate2 = '${booking_date}'
        const date1 = new Date(bookingDate1)
        const date2 = new Date(bookingDate2.replace(' ', 'T'))
        const oldTimeDifference = parseInt(Math.abs(date1 - date2))
//         console.log(Math.abs(oldTimeDifference))
        const data = {}
        formData.forEach((value, key) => {
            data[key] = value
        })
        const bookingTime = new Date(data.booking_date).getTime()
        const now = new Date().getTime()
        const timeDifference = bookingTime - now
        const thirtyMinutesInMillis = 30 * 60 * 1000

        // 예약시간이 지금시간보다 이전이면 빠꾸먹임
        if(timeDifference <= 0){
            const confirmResult = await Swal.fire({
                title: '예약 변경 실패',
                text: '이미 지난 시간대입니다. 다시 선택해주세요.',
                icon: 'error',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            })
            if (confirmResult.isConfirmed) {
                return
            }
        }

        // 예약시간이 지금보다 30분 이내일 경우 추가 확인
        else if (timeDifference <= thirtyMinutesInMillis) {
            const confirmResult = await Swal.fire({
                title: '주의',
                text: '변경 시 예약시간이 30분 이내입니다. 정말로 예약을 변경하시겠습니까?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#9cd2f1',
                cancelButtonColor: '#c1c1c1',
                confirmButtonText: '예, 변경합니다',
                cancelButtonText: '아니오'
            })
            if (!confirmResult.isConfirmed) {
                return
            }
        }
        // 예약시간이 변경 전 예약시간에서 1시간 이상 차이 안나면 빠꾸
        else if (oldTimeDifference < 60 * 60 * 1000) {
            const confirmResult = await Swal.fire({
                title: '예약 변경 실패',
                text: '예약시간이 변경 전 예약시간과 1시간 이상 차이나야 합니다.',
                icon: 'error',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            })
            if (confirmResult.isConfirmed) {
                return
            }
        }
        const opt = {
            method : 'PATCH',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        }
        const result = await fetch(url, opt).then(resp => resp.json())

        // 예약 변경에 성공하면 그 내용을 알림테이블에 추가하고 메일로 보냄
        if(result == 1) {
            Swal.fire({
                title: '예약 변경 완료',
                text: '예약이 변경되었습니다.',
                icon: 'success',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            }).then((result) => {if(result.isConfirmed) notificationBookingUpdate()})

        }
        else if(result == 2) Swal.fire({
            title: '예약 변경 실패',
            text: '진료시간이 아닙니다. 다시 선택해주세요.',
            icon: 'error',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        })

        // 예외 상황 처리
        else Swal.fire({
                title: '예약 변경 실패',
                text: '알 수 없는 이유로 예약 변경에 실패하였습니다.',
                icon: 'error',
                confirmButtonText: '확인',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            })

    }
   // 예약한 시간에 도달하면 기간 만료처리하는 함수
   async function bookingTimeOver(){
      const url = '${cpath}/bookingTimeOver/' + member_id + '/' + hospital_id
      const opt = {
         method : 'PATCH'
      }
      const result = await fetch(url, opt).then(resp => resp.json())
       
      // 예약시간 만료처리에 성공하면그 내용을 알림테이블에 추가하고 메일로 보냄
      if(result == 1) {
         Swal.fire({
              title: '예약 시간',
              text: '예약한 시간이 되었습니다!!',
              icon: 'info',
              confirmButtonText: '확인',
              allowOutsideClick: false,
              allowEscapeKey: false,
              showCloseButton: false,
                confirmButtonColor: '#9cd2f1'
            }).then((result) => {if(result.isConfirmed) sendNotificationMail()})
      } 
      
      // 예외 상황 처리
      else alert('시간 처리 안됨') 
   }
   
   document.addEventListener('DOMContentLoaded', () => {

       const paymentStatus = sessionStorage.getItem('paymentStatus')
//        console.log(paymentStatus)



       // 예약 후 적용되는 페이지
       if (bookingInfo != "") {
           bookingBtn.innerHTML = '<button id="bookingCancelBtn">예약취소하기</button><button id="bookingUpdateBtn">예약변경하기</button><button id="paymentBtn">결제하기</button><button id="cancelPaymentBtn">결제 취소</button>'
           const bookingCancelBtn = document.getElementById('bookingCancelBtn')
           const bookingUpdateBtn = document.getElementById('bookingUpdateBtn')
           const paymentBtn = document.getElementById('paymentBtn')
           const payment = document.getElementById('payment') // payment 요소 확인
           const cancelPaymentBtn = document.getElementById('cancelPaymentBtn')

           timeDiff.classList.remove('hidden')
           document.querySelector('#bookingUpdateForm #booking_date').value = '${booking_date}'

           // 남은 시간 타이머를 1초단위로 카운트다운하도록 설정
           bookingTimerInterval = setInterval(() => updateBookingTimer(booking_date), 1000)
           updateBookingTimer(booking_date)

           bookingCancelBtn.onclick = () => {
               Swal.fire({
                   title: '예약 취소',
                   text: '예약을 취소하시겠습니까?',
                   icon: 'question',
                   confirmButtonText: '확인',
                   cancelButtonText: '취소',
                   confirmButtonColor: '#9cd2f1',
                   cancelButtonColor: '#c1c1c1',
                   showCancelButton: true,
                   allowOutsideClick: false,
                   allowEscapeKey: false,
                   showCloseButton: false
               }).then((result) => { if (result.isConfirmed) bookingCancel() })
           }
           bookingUpdateBtn.onclick = readyToUpdateBooking
           bookingUpdateForm.onsubmit = (event) => {
               event.preventDefault()
               Swal.fire({
                   title: '예약 변경',
                   text: '예약을 변경하시겠습니까?',
                   icon: 'question',
                   confirmButtonText: '확인',
                   cancelButtonText: '취소',
                   confirmButtonColor: '#9cd2f1',
                   cancelButtonColor: '#c1c1c1',
                   showCancelButton: true,
                   allowOutsideClick: false,
                   allowEscapeKey: false,
                   showCloseButton: false
               }).then((result) => { if (result.isConfirmed) bookingUpdate() })
           }

           // 결제 버튼 클릭 이벤트
           paymentBtn.onclick = async () => {
               var IMP = window.IMP
               const paymentData = {
                   pg: 'html5_inicis.INIpayTest',
                   pay_method: 'card', // 결제 수단
                   merchant_uid: 'merchant_' + new Date().getTime(), // 주문 고유 번호
                   name: '병원 예약 결제', // 결제 상품 이름
                   amount: +'${hospital.medical_expenses}', // 결제 금액 (테스트로 10,000원)
                   buyer_email: '${login.email}', // 구매자 이메일
                   buyer_name: '${login.name}', // 구매자 이름
                   buyer_addr: '${login.location}', // 구매자 주소
                   m_redirect_url: '${cpath}/hospitalInfo/' + hospital_id // 결제 완료 후 리디렉션될 페이지
               }

               IMP.request_pay(paymentData, function (rsp) {
//                    console.log(rsp);
                   if (rsp.success) {
                       Swal.fire({
                           title: '결제 성공',
                           text: '결제가 성공적으로 완료되었습니다.',
                           icon: 'success',
                           confirmButtonText: '확인',
                           confirmButtonColor: '#9cd2f1'
                       }).then(() => {
                           // 결제 상태를 sessionStorage에 저장
                           sessionStorage.setItem('paymentStatus', 'success')
                           sessionStorage.setItem('paymentData', JSON.stringify(paymentData)) // paymentData 세션에 저장

                           // 결제 취소 버튼 클릭 이벤트 추가
                           addCancelPaymentListener(paymentData); // 결제 취소 이벤트 리스너를 추가
                           location.reload()
                       })
                   } else {
                       Swal.fire({
                           title: '결제 실패',
                           text: '결제가 실패하였습니다. 사유: ' + rsp.error_msg,
                           icon: 'error',
                           confirmButtonText: '확인',
                           confirmButtonColor: '#9cd2f1'
                       })
                   }
               })
           }
       }
           // 예약 전 적용되는 페이지
      else {
            timeDiff.classList.add('hidden')
         bookingBtn.innerHTML = '<button id="bookingInsertBtn">예약하기</button>'
         const bookingInsertBtn = document.getElementById('bookingInsertBtn')
         document.querySelector('#bookingInsertForm #booking_date').value = '${now}'         
         bookingInsertBtn.onclick = readyToBook
         bookingInsertForm.onsubmit = async (event) => {
                event.preventDefault()
               await Swal.fire({
                 title: '예약',
                 text: '예약하시겠습니까?',
                 icon: 'question',
                 confirmButtonText: '확인',
                 cancelButtonText: '취소',
                   confirmButtonColor: '#9cd2f1',
                   cancelButtonColor: '#c1c1c1',
                 showCancelButton: true,
                 allowOutsideClick: false,
                 allowEscapeKey: false,
                 showCloseButton: false
             }).then((result) => {if(result.isConfirmed) bookingInsert()})
         }
      }
       // 결제 상태에 따른 버튼 표시 여부 처리
       if (paymentStatus === 'cancelled') {
           // 결제 취소 후 결제하기 버튼 보이기, 결제 취소 버튼 숨기기
           if (paymentBtn) paymentBtn.style.display = 'inline-block'
           if (cancelPaymentBtn) cancelPaymentBtn.style.display = 'none'
       } else if (paymentStatus === 'success') {
           // 결제 성공 후 결제하기 버튼 숨기기, 결제 취소 버튼 보이기
           if (paymentBtn) paymentBtn.style.display = 'none'
           if (cancelPaymentBtn) cancelPaymentBtn.style.display = 'inline-block'
           // 결제 취소 이벤트 리스너 추가
           addCancelPaymentListener()
       } else {
           if(bookingInfo != ""){
           if (paymentBtn) paymentBtn.style.display = 'inline-block'
           if (cancelPaymentBtn) cancelPaymentBtn.style.display = 'none'
            }
       }

       function addCancelPaymentListener(paymentData = null) {
           cancelPaymentBtn.onclick = async () => {
               const confirmCancel = await Swal.fire({
                   title: '결제 취소',
                   text: '결제를 취소하시겠습니까?',
                   icon: 'warning',
                   showCancelButton: true,
                   confirmButtonText: '네',
                   cancelButtonText: '아니오',
                   confirmButtonColor: '#c1c1c1',
                   cancelButtonColor: '#9cd2f1'
               })
               if (confirmCancel.isConfirmed) {
                   // paymentData가 null이면 sessionStorage에서 가져옴
                   const storedPaymentData = paymentData || JSON.parse(sessionStorage.getItem('paymentData'));
                   if (storedPaymentData) {
//                        console.log('결제 취소:', storedPaymentData.merchant_uid)
                       // 서버에 취소 요청 보내기
                       const cancelUrl = cpath + '/cancelPayment'
                       const response = await fetch(cancelUrl, {
                           method: 'POST',
                           headers: {
                               'Content-Type': 'application/json'
                           },
                           body: JSON.stringify({
                               merchant_uid: storedPaymentData.merchant_uid // 결제 데이터에 있는 고유 주문 번호 전달
                           })
                       })

                       const result = await response.json()

                       if (result.success) {
                           await Swal.fire({
                               title: '결제 취소 성공',
                               text: '결제가 성공적으로 취소되었습니다.',
                               icon: 'success',
                               confirmButtonText: '확인',
                               confirmButtonColor: '#9cd2f1'
                           })
                           // 결제 취소 상태를 로컬 저장소에 기록
                           sessionStorage.setItem('paymentStatus', 'cancelled')

                           // 결제 취소 후 버튼 상태 변경
                           cancelPaymentBtn.style.display = 'none'// 결제 취소 버튼 숨기기
                           paymentBtn.style.display = 'inline-block' // 결제 버튼 다시 보이기
                       } else {
                           Swal.fire({
                               title: '결제 취소 실패',
                               text: '결제 취소가 실패하였습니다. 사유: ' + result.message,
                               icon: 'error',
                               confirmButtonText: '확인',
                               confirmButtonColor: '#9cd2f1'
                           })
                       }
                   } else {
                       Swal.fire({
                           title: '결제 데이터 없음',
                           text: '결제 데이터가 존재하지 않습니다.',
                           icon: 'warning',
                           confirmButtonText: '확인',
                           confirmButtonColor: '#9cd2f1'
                       })
                   }
               }
           }
       }
   })
   
   const myFavoriteHospital = document.getElementById('myFavoriteHospital')
   document.addEventListener('DOMContentLoaded', async () => {
         const id = '${hospital.id}'
        const isFavorite = await getFavorite(id)
        // 병원이 즐겨찾기일 경우, 즐겨찾기 아이콘을 배경으로 설정
        if (isFavorite == 1) {
            myFavoriteHospital.style.backgroundImage = 'url(\'' + cpath + '/resources/image/KakaoTalk_20241118_165527259_01.png\')'
        } else {
            myFavoriteHospital.style.backgroundImage = 'url(\'' + cpath + '/resources/image/KakaoTalk_20241118_165527259_02.png\')'
        }
        myFavoriteHospital.onclick = async (event) => {
            if('${login}' != '' && (await getFavorite(id)) == 1) {
                Swal.fire({
                    title: '즐겨찾기 삭제',
                    text: '해당 병원을 즐겨찾기 삭제 하시겠습니까?',
                    icon: 'question',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    showCancelButton: true,
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    showCloseButton: false,
                    confirmButtonColor: '#9cd2f1', // 확인 버튼 색상
                    cancelButtonColor: '#c1c1c1'
                }).then((result) => {if(result.isConfirmed) myFavorite(event)})
            }
            else if('${login}' != '' && await getFavorite(id) != 1) {
                Swal.fire({
                    title: '즐겨찾기 추가',
                    text: '해당 병원을 즐겨찾기 추가 하시겠습니까?',
                    icon: 'question',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    showCancelButton: true,
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    showCloseButton: false,
                    confirmButtonColor: '#9cd2f1', // 확인 버튼 색상
                    cancelButtonColor: '#c1c1c1'
                }).then((result) => {if(result.isConfirmed) myFavorite(event)})
            }
            else {
                Swal.fire({
                    title: '',
                    text: '로그인 해주세요.',
                    icon: 'info',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    showCancelButton: true,
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    showCloseButton: false,
                    confirmButtonColor: '#9cd2f1', // 확인 버튼 색상
                    cancelButtonColor: '#c1c1c1'
                }).then((result) => {
                    if(result.isConfirmed){
                        const currentPageUrl = window.location.href
                        window.location.href = cpath + '/member/login?redirectUrl=' + encodeURIComponent(currentPageUrl) // 로그인 페이지로 리다이렉션
                    }
                })
            }
        }
    })

    const footer = document.getElementById('footer')
    footer.style.backgroundColor = '#929497'
</script>




</body>
</html>


