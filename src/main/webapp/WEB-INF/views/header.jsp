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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Gugi&family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    <style>
    	body, html {
	        margin: 0;
	        padding: 0;
	        font-family: Arial, sans-serif;
    	}
        /*    챗봇 아이콘 */
        #chat_icon img {
            position: fixed;
            right: 50px;
            bottom: 50px;
        }

        /*   민재 파트 (홈 검색 기능) */


        #mapModal {
            z-index: 4;
            width: 100%;
            height: 100%;
            display: none; /* 기본적으로 숨김 */
            position: fixed;
            top: 0;
            left: 0;
            background-color: rgba(0, 0, 0, 0.7); /* 반투명 검은색 배경 */
        }

        #mapModal.show {
            display: block;
        }

        #mapModal > .content {
            border: 2px solid grey;
            background-color: white;
            position: fixed;
            width: 80%; /* 모달 너비 설정 */
            max-width: 1000px; /* 최대 너비 */
            height: 80%; /* 모달 높이 설정 */
            max-height: 500px; /* 최대 높이 */
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            display: flex; /* 지도와 리스트를 가로로 나란히 배치 */
            flex-direction: row; /* 가로 배치 */
            border-radius: 25px;
            box-shadow: 10px 10px 10px grey;
        }


        #hospitalList {
            list-style-type: none;
            padding:50px 10px;
            overflow-y: auto;
            margin: 0;
            max-height: 100%; /* 리스트가 모달 높이에 맞게 늘어나도록 설정 */
            width: 30%; /* 리스트 영역을 지도 옆에 붙게 설정 */
            background-color: rgba(255, 255, 255, 0.4); /* 투명한 배경 설정 (투명도 높임) */
            opacity: 0.8;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* 그림자 효과 */
            position: relative; /* 부모 요소에 맞춰 위치 */
        }
        #hospitalList::-webkit-scrollbar {
            display: none;
        }
        .hospital-list li {
            margin: 5px 0;
            cursor: pointer;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .hospital-list li:hover {
            background-color: #e9ecef; /* 마우스 오버 시 배경색 변경 */
        }


        #map2 {
            width: 70%; /* 지도 영역 크기 */
            height: 100%;
            position: relative;
        }



        .hospital-list li.selected {
            background-color: #007bff; /* 선택된 항목 배경색 */
            color: white; /* 선택된 항목 글자색 */
            font-weight: bold; /* 선택된 항목 글씨 진하게 */
        }

        
        header{
            width: 100%;
            height: 80px;
            display: flex;
            z-index: 100;
            background-color: rgba(255, 255, 255, 0.2);
   			backdrop-filter: blur(3px);
        }
        .bookingModal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .hidden {
            display: none!important;
        }


        .bookingOverlay {
            position: absolute;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* 반투명한 검은색 배경 */
        }

        .bookingContent {
            position: relative;
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            z-index: 5;
            max-width: 500px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            scrollbar-width: none; /* Firefox */
            -ms-overflow-style: none; /* Internet Explorer 10+ */
        }

        .bookingContent::-webkit-scrollbar {
            display: none; /* WebKit */
        }

        .bookingTitle {
            font-size: 24px;
            color: #2c3e50;
            text-align: center;
            font-weight: 600;
        }

        .bookingDetail {
            margin-bottom: 10px;
        }

        #bookingInsertForm input[type="datetime-local"],
        #bookingUpdateForm input[type="datetime-local"] {
            width: 100%;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            color: #333;
        }

        #bookingInsertForm input[type="submit"],
        #bookingUpdateForm input[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #2c3e50;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        #bookingInsertForm input[type="submit"]:hover,
        #bookingUpdateForm input[type="submit"]:hover {
            background-color: #34495e;
        }

        #closeBookingBtn ,#closeMapModalBtn{
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #ff4d4d;
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

        #closeBookingBtn:hover ,#closeMapModalBtn:hover{
           background-color: #ff3333;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        #closeBookingBtn:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* 애니메이션 효과 */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .bookingContent {
            animation: fadeIn 0.3s ease-out;
        }

        /* 반응형 디자인을 위한 미디어 쿼리 */
        @media (max-width: 600px) {
            .bookingContent {
                padding: 25px;
                width: 95%;
            }

            .bookingTitle {
                font-size: 20px;
            }
        }


        #notificationPaging {
            justify-content: space-between;
            display: flex;
        }

        #notificationCountSpan {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: red;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
        }

        #myFavoritesPaging {
            justify-content: space-between;
            display: flex;
        }
        a {
            color: inherit;
            text-decoration: none;
        }
        /* 최근 본 병원 스타일 */
        #recentHospitalsContainer {
            width: 180px; /* 컨테이너 너비를 조금 더 줄임 */
            position: fixed; /* 화면에 고정 */
            top: 118px; /* 상단에서 80px 떨어지게 위치 */
            right: 20px; /* 화면 오른쪽에 위치 */
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 8px; /* 카드와 동일하게 둥글게 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 5; /* 다른 콘텐츠 위에 표시 */
            max-height: 75vh; /* 화면 높이에 맞게 제한 */
            overflow-y: hidden; /* 스크롤 숨기기 */
            border: 1px solid #e0e0e0; /* 약간의 테두리로 강조 */
        }

        #recentHospitalsContainer h2 {
            font-size: 18px; /* 제목 크기 약간 줄임 */
            font-weight: bold;
            margin-bottom: 10px; /* 여백 줄이기 */
            color: #333;
            text-align: center;
        }

        .recent-hospitals {
            display: flex;
            flex-direction: column; /* 세로로 정렬 */
            gap: 8px; /* 카드 간격을 조금 줄임 */
            max-height: 70vh; /* 내용이 많으면 더 이상 스크롤되지 않게 */
        }

        .hospital-card {
            width: 100%; /* 카드가 컨테이너에 맞게 꽉 차게 */
            background-color: #fff;
            border-radius: 6px; /* 카드 모서리 둥글게 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease-in-out;
            display: flex;
            flex-direction: column;
            margin: 10px 0px;
        }

        .hospital-card:hover {
            transform: scale(1.03); /* 카드 호버시 확대 효과 */
        }

        .recentHospital-image {
            width: 100%;
            height: 100px; /* 이미지 크기를 조금 더 줄임 */
            object-fit: cover; /* 이미지 비율 유지하면서 잘리도록 설정 */
        }

        .recentHospital-info {
            padding: 8px; /* 패딩을 줄여서 내용 영역을 더 좁게 */
            font-size: 13px; /* 폰트 크기 좀 더 줄임 */
        }

        .hospital-name {
            font-size: 14px; /* 병원 이름 폰트 크기 더 줄임 */
            font-weight: bold;
            margin-bottom: 5px;
            color: #007bff;
            white-space: nowrap; /* 텍스트가 한 줄로 나오도록 */
            overflow: hidden;
            text-overflow: ellipsis; /* 긴 이름은 ... 으로 표시 */
        }

        .loginIcon ,.loginIcon2 {
            background-image: url('${cpath}/resources/image/로그인아이콘최종.png');
            position: absolute;
            width: 30px;
            height: 30px;
            top: 30px;
            right: 30px;
            background-size: cover;
            cursor: pointer;
        }
        .notificationIcon {
            background-image: url('${cpath}/resources/image/알림.png');
            position: absolute;
            width: 27px;
            height: 27px;
            top: 33px;
            right: 150px;
            background-size: cover;
        }
        .healthInfoIcon {
        	background-image: url('${cpath}/resources/image/건강정보.png');
            position: absolute;
            width: 30px;
            height: 30px;
            top: 31px;
            right: 90px;
            background-size: cover;
        }
        .myFavoritesIcon{
            background-image: url('${cpath}/resources/image/즐겨찾기.png');
            position: absolute;
            width: 30px;
            height: 30px;
            top: 31px;
            right: 205px;
            background-size: cover;
        }
    </style>

<%--    알림 메시지 스타일--%>
        <style>
            /* 알림 테이블 스타일 */
            #notificationTable {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            #notificationTable th, #notificationTable td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #e0e0e0;
            }

            #notificationTable th {
                background-color: #f8f8f8;
                font-weight: bold;
                color: #333;
            }

            /* 읽지 않은 알림 스타일 */
            #notificationTable th[style*="background-color: lightskyblue"] {
                background-color: #e3f2fd;
                font-weight: bold;
            }

            /* 알림 삭제 버튼 스타일 */
            .notificationDeleteBtn {
                padding: 6px 12px;
                background-color: #ff4d4d;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .notificationDeleteBtn:hover  {
                background-color: #ff3333; /* 삭제 버튼의 호버 효과는 유지 */
            }

            /* 페이징 스타일 */
            #notificationPaging {
                display: flex;
                justify-content: space-around;
                margin-top: 20px;
                margin-bottom: 20px;
            }

            #notificationPaging td {
                padding: 8px 12px;
                margin: 0 5px;
                cursor: pointer;
                border: 1px solid #ddd;
                border-radius: 4px;
            }

            /* 현재 페이지 강조 스타일 */
            #notificationPaging td[style*="font-weight: bold"] {
                background-color: #007bff; /* 강조 색상 */
                color: white; /* 강조 색상에서의 글자 색상 */
            }

            /* '이전'과 '다음' 버튼 스타일 */
            #notificationPaging td:first-child,
            #notificationPaging td:last-child {
                background-color: #f8f9fa; /* 기본 배경색 */
                font-weight: bold; /* 두꺼운 폰트 */
            }

            /* 알림 없음 메시지 스타일 */
            #notificationTableBody:empty::before {
                content: '알림이 없습니다.';
                display: block;
                text-align: center;
                padding: 20px;
                color: #666; /* 회색 글자 색상 */
                font-style: italic; /* 이탤릭체 */
            }

            /* 알림 셀 스타일 */
            .notification-cell {
                padding: 15px; /* 패딩 */
                border-bottom: 1px solid #ddd; /* 하단 테두리 */
            }

            /* 알림 내용 스타일 */
            .notification-content {
                display: flex; /* 플렉스 박스 사용 */
                flex-direction: column; /* 세로 방향 정렬 */
            }

            /* 날짜 및 이름 강조 스타일 */
            .notification-date {
                font-size: 0.9em; /* 폰트 크기 조정 */
                color: #666; /* 회색 글자 색상 */
            }

            .notification-name {
                font-weight: bold; /* 두꺼운 폰트 */
                color: #333; /* 어두운 글자 색상 */
            }

            /* 메시지 스타일 */
            .notification-message {
                font-size: 1em; /* 기본 폰트 크기 */
                color: #444; /* 어두운 회색 글자 색상 */
            }

            /* '일괄 삭제하기' 버튼 스타일 */
            #deleteNotificationAllBtn {
                margin: 10px 10px;
                padding: 10px 20px;
                font-size: 14px;
                font-weight: bold;
                background-color: #ff4d4d;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            /* '일괄 삭제하기' 버튼 호버 및 클릭 효과 */
            #deleteNotificationAllBtn:hover {
                background-color: #ff3333; /* 호버 시 배경색 */
            }
    </style>

<%--    즐겨찾기 스타일--%>
    <style>
        #myFavoritesTable {
            width: 500px;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);

        }

        #myFavoritesTable th, #myFavoritesTable td {
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
        }
        #myFavoritesTable th {
            background-color: #f8f8f8;
            font-weight: bold;
            color: #333;
            padding: 20px 0px;
        }
        /* 즐겨찾기 목록의 링크 스타일 */
        #myFavoritesTable a {
            color: #007bff; /* 링크 색상 */
            text-decoration: none; /* 밑줄 제거 */
        }
        #myFavoritesTable th:nth-child(2){
            width: 18%;
            font-size: 14px;
        }
        #myFavoritesTable a:hover {
            text-decoration: underline; /* 호버 시 밑줄 추가 */
        }
        /* 페이징 스타일 */
        #myFavoritesPaging {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        #myFavoritesPaging td {
            padding: 8px 10px; /* 패딩 조정 (위아래 8px, 좌우 10px) */
            margin: 0 5px; /* 좌우 여백 */
            cursor: pointer; /* 커서 모양 변경 */
            border: 1px solid #ddd; /* 테두리 색상 */
            border-radius: 4px; /* 둥근 모서리 */
            min-width: 40px; /* 최소 너비 설정 */
            text-align: center; /* 텍스트 중앙 정렬 */
        }

        /* 현재 페이지 강조 스타일 */
        #myFavoritesPaging td[style*="font-weight: bold"] {
            background-color: #007bff; /* 강조 색상 */
            color: white; /* 강조 색상에서의 글자 색상 */
        }

        /* '이전'과 '다음' 버튼 스타일 */
        #myFavoritesPaging td:first-child,
        #myFavoritesPaging td:last-child {
            background-color: #f8f9fa; /* 기본 배경색 */
            font-weight: bold; /* 두꺼운 폰트 */
        }
        /* 알림 없음 메시지 스타일 */
        #myFavoritesTableBody:empty::before {
            content: '즐겨찾기 한 병원이 없습니다.';
            display: block;
            text-align: center;
            padding: 20px;
            color: #666; /* 회색 글자 색상 */
            font-style: italic; /* 이탤릭체 */
        }

        /* 삭제 버튼 스타일 */
        .myFavoritesDeleteBtn {
            padding: 6px 12px;
            background-color: #ff4d4d; /* 삭제 버튼 배경색 */
            color: white; /* 버튼 텍스트 색상 */
            border: none; /* 테두리 제거 */
            border-radius: 4px; /* 버튼 모서리 둥글게 */
            cursor: pointer; /* 클릭 가능 커서 */
            transition: background-color 0.3s ease, transform 0.2s ease; /* 효과 */
        }

        .myFavoritesDeleteBtn:hover {
            background-color: #ff3333; /* 호버 시 배경색 */
        }

        .myFavoritesDeleteBtn:active {
            transform: scale(0.95); /* 클릭 시 버튼 크기 감소 */
        }

        /* '일괄 삭제하기' 버튼 스타일 */
        #deleteMyFavoritesAllBtn {
            margin: 10px 10px;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: bold;
            background-color: #ff4d4d;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        #deleteMyFavoritesAllBtn:hover {
            background-color: #ff3333;
        }

        #deleteMyFavoritesAllBtn:active {
            transform: scale(0.95);
        }
    </style>
    
    <style>
    	/* footer */
		#footer {
		    position: relative;
		    width: 100%;
		    background-color: #8a8e92;
		    padding: 20px;
		    color: white;
		    z-index: 2;
		    display: flex;
		}
		footer p {
		    color: white;
		    font-weight: 400;
		    align-items: center;
		    line-height: 30px;
		    font-size: 20px;
		    font-family: "Do Hyeon", sans-serif;
		}
		footer p:first-child {
		    padding-left: 500px;
		}
		.footerRight {
		    margin-left: 90px;
		}
		.icons {
		    display: flex;
		    margin: 20px;
		    margin-left: 0;
		    align-items: center;
		}
		.icons a {
		    background-size: cover;
		    background-repeat: no-repeat;
		    background-position: center;
		    margin: 0 8px;
		}
		.icon_youtube {
			width: 50px;
			height: 45px;
		    background-image: url('${cpath}/resources/image/icon_youtube.png');
		}
		.icon_instagram {
			width: 43px;
		    height: 43px;
		    background-image: url('${cpath}/resources/image/icon_instagram.png');
		}
		.icon_facebook {
			width: 45px;
		    height: 45px;
		    background-image: url('${cpath}/resources/image/icon_facebook.png');
		}
		.logo img {
			width: 146px;
			height: 145px;
			margin-top: -32px;
			margin-left: -33px;
		}

    </style>
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
    <a href="${cpath }/chat/room" onclick="window.open(this.href, '_blank', 'width=600, height=1080'); return false;">
        <img src="${cpath }/resources/image/chat-icon.png" width="50">
    </a>
</div>


<header>
	<div class="logo">
		<a href="${cpath }"><img src="${cpath }/resources/image/로고.png"></a>
	</div>
    <a href="${cpath }/healthInfo/healthInfo">
		<div class="healthInfoIcon"></div>
	</a>
    <div class="-container">
        <c:if test="${empty login }">
        <div class="loginIcon"></div>
	    </c:if>
    </div>

    <c:set var="default" value="${cpath }/resources/image/default.png" />
    <c:if test="${not empty login }">
        <div class="header-right">
            <div class="loginIcon2"></div>
            <div class="notificationIcon" id="notification" data-page="1"><span id="notificationCountSpan" class="hidden"></span></div>
            <div class="myFavoritesIcon" id="myFavorites" data-page="1"></div>
            <span>${login.name }</span>
            <a href="${cpath }/member/logout"><button>로그아웃</button></a>

        </div>
    </c:if>
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
    console.log(loginIcon)
    const loginIcon2 = document.querySelector('div.loginIcon2')
    if (loginIcon) {
        loginIcon.addEventListener('click', function() {
            location.href = cpath + '/member/login'
        })
    }

    if (loginIcon2) {
        loginIcon2.addEventListener('click', function() {
            location.href =  '${cpath}/member/info/${login.id}'
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
        const url = '${cpath}/notificationCount'
        const opt = {
            method : 'GET'
        }
        const result = await fetch(url, opt).then(resp => resp.json())
        if (result > 0) {
            notificationCountSpan.classList.remove('hidden')
            if (result >= 10) {
                notificationCountSpan.innerText = '9+' // 10 이상은 '9+'로 표시
            } else {
                notificationCountSpan.innerText = result // 10 미만은 해당 숫자 표시
            }
            return result
        } else {
            notificationCountSpan.innerText = '' // 0 이하일 경우 비움
            notificationCountSpan.classList.add('hidden')
            return ''
        }
    }

    // 알림 페이징 최대 페이지 수 가져오는 함수
    async function notificationMaxPage(startPage){
        const url = '${cpath}/notificationMaxPage'
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
        const url = '${cpath}/notificationList/' + thisPage
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
        const url = '${cpath}/deleteNotification/' + id
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
        const url = '${cpath}/readNotification/' + thisPage
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
        const url = '${cpath}/deleteNotificationAll'
        const opt = {
            method : 'DELETE'
        }
        const result = await fetch(url, opt).then(resp => resp.json())
        if(result > 0) readNotification({ target: { dataset: { page: 1 } } })


    }


    closeBookingBtn.addEventListener('click', closeBookingModal)
    bookingOverlay.onclick = closeBookingModal
    notification.addEventListener('click', readNotification)
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
        console.log(result)
        result.forEach(favorite => {
            tag += '<tr>'
            tag += '<th><a href="${cpath }/hospitalInfo/' + favorite.hospital_id + '">' + favorite.hospital_name + '</a></th>'
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
                    confirmButtonColor: '#3085d6',
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
                    confirmButtonColor: '#3085d6',
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
        console.log(thisPage)
        const url = '${cpath}/deleteMyFavorites/' + id
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
        console.log(event.target.dataset.page)
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


    myFavorites.addEventListener('click', (event) => {
        if('${login}' != '') openMyFavorites(event)
        else {
            Swal.fire({
                title: '',
                text: '로그인 해주세요.',
                icon: 'info',
                confirmButtonText: '확인',
                cancelButtonText: '취소',
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                showCancelButton: true,
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false
            }).then((result) => {if(result.isConfirmed) location.href = '${cpath}/member/login'})
        }
    })
</script>

