<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="cpath" value="${pageContext.request.contextPath }" />

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

<style>
   body, html {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
    }

    /*  ============ 첫번째 페이지 ============ */
    .first {        
        width: 100%;
        height: 1190px;
        justify-content: center;
        align-items: center;
        overflow: hidden;
        display: flex;
    }
    @keyframes moveBackground {     /* 배경화면 이동효과 */
        from {
            background-position: -100 0;
        }
        to {
            background-position: 0 0;
        }
    }
    .main_right {
        width: 50%;
        height: 100%;
        z-index: 1;
		position: relative;
    }
    .main_left {
        width: 50%;
        height: 100%;
        z-index: 1;
    }
    .main_left > p,
    .main_right > p  {
        text-align: center;
        color: white;
        font-weight: bold;
    }
     .main_left > p:first-child {
         font-size: 60px;
         margin: 0;
         margin-top: 350px;
     }
     .main_left > p:nth-child(2) {
         font-size: 20px;
         margin: 0;
         font-weight: bold;
     }
     .main_left > p:nth-child(3) {
         font-size: 20px;
         margin: 0;
         margin-top: 50px;
         font-weight: bold;
     }
     .overlay {
         position: absolute;
         background-color: black;
         opacity: 0.5;
         top: 0;
         left: 0;
         width: 100%;
         height: 100vh;
     }

     .pages {
         height: 100vh;
         width: 100%;
         position: absolute;
         overflow: hidden;
     }
     .page {
         height: 100%;
         width: 100%;
         position: absolute;
         top: 100%;
         transition: top .7s;
     
         background-attachment: fixed;
         background-position: center;
         background-repeat: no-repeat;
         background-size: cover;
     }
     .first {
         top: 0;
         background-image: url('${cpath}/resources/image/배경최종.jpg');
         animation: moveBackground 5s linear forwards;
     }
     .fourth {
     	width: 100%;
     	height: 100vh;
     	background-color: #edf7fa;
     }
     .pagination {
         position: absolute;
         display: flex;
         left: 50%;
         top: 0%;
         transform: translateX(-50%);
         z-index: 100;
     }
     .pagination>li {
     	 margin: 5px;
         list-style: none;
         height: 10px;
         width: 10px;
         background: #999999;
         border-radius: 50%;
         margin-top: 10px;
         transition: background .7s;
     }
     .pagination>li.active {
         background: #ffffff;
     }

	/*  2번째 페이지  */
	 .second {
         background-color: white;
     }
     .categoryComment {
         margin-left: 50px;
         font-size: 100px;
         font-weight: bold;
         color: black;
     }
     .categoryComment p {
         margin: 0;
         margin-top: 45px;
     }
     .slideWrap {
         display: flex;
         position: relative;
         height: 300px;
         overflow: hidden;
     }
     .slideWrap:nth-child(2) {
         margin-top: 70px;
     }
     .slideWrap .imgSlide {
         display: flex;
         align-items: center;
         justify-content: space-between;
         padding-left: 0;
     }
     .slideWrap .imgSlide.original {
         animation: 50s linear 0s infinite normal forwards running slide01;
     }
     .slideWrap .imgSlide.clone {
         animation: 50s linear 0s infinite normal none running slide02;
     }
     .slideWrap .imgSlide li {
         position: relative;
         width: 250px;
         height: 250px;
         line-height: 200px;
         margin-right: 20px;
         background-color: #ccc;
         text-align: center;
         list-style: none;
         border-radius: 30px;
         cursor: pointer;
     }
     .imgSlide img {
         width: 250px;
         height: 250px;
         border-radius: 25px;
     }
     .categoryOverlay {
         position: absolute; /* 절대 위치 설정 */
         top: 0; 
         left: 0;
         width: 100%;
         height: 100%;
         background-color: rgba(0, 0, 0, 0.4);
         border-radius: 25px;
     }
     .imgSlide h4 {
         position: absolute;
         bottom: 10px;
         left: 20px;
         font-size: 25px;
         color: white;
         line-height: normal;
         font-weight: bold;
     }

     @keyframes slide01 {
         0% { transform: translateX(0);}
         50% { transform: translateX(-100%);}
         50.01% { transform: translateX(100%);}
         100% { transform: translateX(0);}
     }
     @keyframes slide02 {
         0% {transform: translateX(0);}
         100% {transform: translateX(-200%);}
     }
     
	/* 3번째 페이지 */
	.third {
     	 background-color: #f1f1f1;
     	 width: 100%;
     	 height: 100%;
         color: white;
     }
     .thirdPageComment {
     	padding-left: 100px;
     }
     .thirdPageComment > p {
     	font-size: 80px;
     	font-weight: bold;
     	margin: 10px auto;
     }
     .thirdPageComment > p:first-child {
     	margin-top: 180px;
     }
    .rollerWrap {
		position: absolute;
		bottom: 0px;
        border: 1px solid;
        display: flex;
        overflow: hidden;
    }
     .rollerWrap a{
     	color : blue;
     }
    .rolling-list ul {
        padding: 0;
        display: flex;
        margin: 0;
    }
    .rolling-list ul li {
        box-sizing: border-box;
        display: flex;
        align-items: center;
        flex-shrink: 0;
        padding: 10px;
        border-right: 1px solid #ddd;
        min-width: 200px;
    }
    .rolling-list.original {
        animation: rollingleft1 1500s linear infinite;
    }
    .rolling-list.clone {
        animation: rollingleft2 1500s linear infinite;
    }
    @keyframes rollingleft1 {
        0% { transform: translateX(0); }
        50% { transform: translateX(-100%); }
        50.01% { transform: translateX(100%); }
        100% { transform: translateX(0); }
    }
    @keyframes rollingleft2 {
        0% { transform: translateX(0); }
        100% { transform: translateX(-200%); }
    }

    .region-seoul { background-color: #ffebee; color: #c62828; }
    .region-gyeonggi { background-color: #e3f2fd; color: #1565c0; }
    .region-incheon { background-color: #f1f8e9; color: #2e7d32; }
    .region-busan { background-color: #e0f7fa; color: #006064; }
    .region-daegu { background-color: #fbe9e7; color: #bf360c; }
    .region-daejeon { background-color: #e8eaf6; color: #303f9f; }
    .region-gwangju { background-color: #f3e5f5; color: #6a1b9a; }
    .region-ulsan { background-color: #e0f2f1; color: #004d40; }
    .region-sejong { background-color: #ffecb3; color: #ff6f00; }
    .region-gangwon { background-color: #fff3e0; color: #e65100; }
    .region-chungbuk { background-color: #f0f4c3; color: #827717; }
    .region-chungnam { background-color: #f9fbe7; color: #33691e; }
    .region-jeonbuk { background-color: #ffe0b2; color: #e64a19; }
    .region-jeonnam { background-color: #d7ccc8; color: #5e403a; }
    .region-gyeongbuk { background-color: #c8e6c9; color: #2e7d32; }
    .region-gyeongnam { background-color: #ffccbc; color: #d84315; }
    .region-jeju { background-color: #dcedc8; color: #558b2f; }
    .region-etc { background-color: #e0e0e0; color: #616161; }

</style>

<!-- 세번째 페이지 코멘트 스타일 -->
<style>
	:root {
	     --font-ns: 'CustomFont', sans-serif;
	 }
	 .reveal-text {
	     font-size: 70px;
	     font-size: clamp(62px, 5.1042vw, 36px);
	     font-weight: 800;
	     letter-spacing: -0.045em;
	     font-family: var(--font-ns);
	     line-height: 1.3;
	     background-image: linear-gradient(90deg, #070707 0%, #070707 100%);
	     background-size: 0% 100%;
	     background-repeat: no-repeat;
	     -webkit-background-clip: text;
	     background-clip: text;
	     -webkit-text-fill-color: transparent;
	     color: #1A1A1A; /* 폴백 색상 */
	     transition: background-size 15s ease;
	     cursor: pointer;
	     margin: 10px 0;
	 }
	 
	 .reveal-text:first-child {
	 	margin-top: 260px;
	 	font-size: 70px;
	 }
	 .reveal-text:nth-child(2) {
	 	font-size: 70px;
	 }
	 .reveal-text:nth-child(3) {
	 	font-size: 70px;
	 }
	 .reveal-text.reset {
	     transition: none;
	 }
</style>

<%--검색어 순위 스타일--%>
<style>
	.ranking-list {
		position:absolute;
		top: 53%;
		left: 11%;
		list-style: none;
		padding: 0;
		margin: 0;
		height: 30px;
		overflow: hidden;
	}

	.ranking-item {
		width: 300px;
		padding: 5px 0;
		font-size: 18px;
		color: white;
		cursor: pointer;
		display: flex;
		align-items: center;
	}


	.ranking-index {
		font-weight: bold;
		color: white;
		margin-right: 60px;
		width: 20px;
	}

	.ranking-text {
		flex-grow: 1;
	}

	.ranking-count {
		color: red;
		font-weight: bold;
		font-size: 12px;
	}

	.ranking-list.expanded {
		height: auto;
	}
</style>

<%--검색창 스타일--%>
<style>
	.input-group {
		background-color: white; /* 배경색 */
		display: flex; /* 플렉스 박스 사용 */
		align-items: center; /* 수직 중앙 정렬 */
		padding: 10px; /* 패딩 */
		border: 2px solid #ddd; /* 테두리 색상 */
		border-radius: 40px; /* 둥근 모서리 */
		margin-top: 430px; /* 상단 여백 */
		margin-left: 60px;
		position: absolute;
		width: 70%;
	}

	.search-buttons {
		margin-right: 10px; /* 버튼과 입력 필드 간의 간격 */
	}

	.search-form {
		display: flex; /* 플렉스 박스 사용 */
		align-items: center; /* 수직 중앙 정렬 */
		flex-grow: 1; /* 남은 공간 차지 */
		margin: 0;
	}
	
	.search-form #soundSearch {
		width: 40px;
	}

	#searchInput {
		flex-grow: 1; /* 입력 필드가 가능한 공간을 모두 차지하도록 설정 */
		padding: 10px; /* 패딩 */
		border: 1px solid #ddd; /* 테두리 색상 */
		border-radius: 20px; /* 둥근 모서리 */
	}
	.select-wrap {
		width: 120px; /* 셀렉트 박스의 너비 설정 */
		height: 40px; /* 셀렉트 박스의 높이 설정 */
		border: 1px solid #ccc; /* 테두리 색상 */
		border-radius: 40px 40px 40px 40px;
		background: url('${cpath}/resources/image/try-me.gif') no-repeat 97% 50% / 25px auto; /* 화살표 이미지 지정 */
	}
	

	/* select 스타일 */
	#searchTypeSelect {
		width: 100%; /* 전체 너비 사용 */
		height: 100%; /* 전체 높이 사용 */
		padding: 0 28px 0 10px; /* 패딩 설정 (오른쪽, 왼쪽) */
		font-size: 15px; /* 폰트 크기 설정 */
		border: 0; /* 기본 스타일 제거 */

		-webkit-appearance: none; /* Chrome에서 기본 화살표 제거 */
		-moz-appearance: none; /* Firefox에서 기본 화살표 제거 */
		appearance: none; /* 모든 브라우저에서 기본 화살표 제거 */

		box-sizing: border-box; /* 셀렉트 박스의 크기 방식 지정 */
		background: transparent; /* 배경색 투명 처리 */
	}

	select::-ms-expand {
		display: none; /* IE10,11에서 기본 화살표 숨기기 */
	}

	button.search {
		padding: 10px 15px;
		border: none;
		border-radius: 20px;
		background-color: #2c3e50;
		color: white;
		cursor: pointer;
		margin: 5px;
	}
</style>

<%--지도모달 마커 스타일--%>
<style>
	.infoMapListContent , .infoMapContent{
		padding: 10px;
		font-family: Arial, sans-serif;
		font-size: 14px;
		max-width: 300px; /* 인포윈도우 크기 제한 */
		word-wrap: break-word; /* 텍스트가 길어질 경우 줄바꿈 */
	}

	/* 병원 이름 링크 스타일 */
	.hospitalNameLink {
		font-weight: bold;
		font-size: 16px;
		color: #0077cc;
		text-decoration: none; /* 링크 밑줄 제거 */
	}

	.hospitalNameLink:hover {
		text-decoration: underline; /* 링크에 마우스를 올리면 밑줄 표시 */
	}

	/* 주소 스타일 */
	.hospitalAddress {
		margin-top: 8px;
		font-size: 14px;
		color: #333;
	}

	/* 전화번호 스타일 */
	.hospitalPhone {
		margin-top: 5px;
		font-size: 14px;
		color: #333;
	}
	/* 닫기 버튼 스타일 */
	.close-btn {
		position: absolute;
		top: 10px;
		right: 10px;
		background-color: #f44336; /* 빨간색 */
		color: white;
		border: none;
		padding: 10px 15px;
		font-size: 16px;
		cursor: pointer;
		border-radius: 5px;
		transition: background-color 0.3s;
	}

	/* 닫기 버튼에 마우스 오버 시 색상 변경 */
	.close-btn:hover {
		background-color: #e53935;
	}

</style>

<!-- 헤더 스타일 -->
<style>
		/* 	챗봇 아이콘 */
	#chat_icon img {
		position: fixed;
		right: 40px;
		bottom: 40px;
		z-index: 1000;
		cursor: pointer;
	}
	/* 	(상담사) 채팅방 목록 아이콘 */
	#list_icon img {
		position: fixed;
		right: 40px;
		bottom: 100px;
		z-index: 1000;
		cursor: pointer;
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

        #closeBookingBtn:hover ,#closeMapModalBtn:hover{
            background-color: #c0392b;
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
            top: 130px; /* 상단에서 80px 떨어지게 위치 */
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

        .header-right {
			justify-content: flex-end;
			display: flex;
			margin: 5px;
			align-items: center;
		}
        .loginIcon {
            background-image: url('${cpath}/resources/image/로그인아이콘최종.png');
            width: 30px;
            height: 30px;
            background-size: cover;
            cursor: pointer;
            margin-right: 25px;
        }
        #gotoInfo {
        	color: white;
        	width: 30px;
            height: 30px;
            cursor: pointer;
            margin: 10px;
        }
        .notificationIcon {
            background-image: url('${cpath}/resources/image/알림.png');
            width: 27px;
            height: 27px;
            background-size: cover;
            margin-right: 25px;
            cursor: pointer;
        }
        .healthInfoIcon {
        	background-image: url('${cpath}/resources/image/건강정보.png');
            width: 30px;
            height: 30px;
            background-size: cover;
            margin-right: 25px;
        }
        .myFavoritesIcon{
            background-image: url('${cpath}/resources/image/즐겨찾기.png');
            width: 30px;
            height: 30px;
            background-size: cover;
            margin-right: 25px;
            cursor: pointer;
        }
        #logoutBtn {
        	width: 100px;
		    padding: 8px;
		    background: none;
		    border: 1px solid white;
		    border-radius: 4px; /* 둥글기 축소 */
		    color: white;
		    cursor: pointer;
		    transition: background 0.3s ease, color 0.3s ease;
		    font-size: 0.9rem; /* 텍스트 크기 축소 */
		    margin-right: 10px;
        }
        #logoutBtn:hover {
        	background: #364657;
        	border: 1px solid #364657;
       		color: white;
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
<!--     footer 스타일 -->
    <style>
		#footer {
		    position: absolute;
		    bottom: 0;
		    width: 100%;
		    height: 250px;
		    background-color: #8a8e92;
		    padding: 20px;
		    color: white;
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
		    padding-left: 380px;
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
		header{
			position: absolute;
			top: 0;
			left: 0;
            width: 100%;
            height: 80px;
            display: flex;
            justify-content: space-between;
            z-index: 100;
            background-color: rgba(255, 255, 255, 0.2);
   			backdrop-filter: blur(3px);
        }
        .fourth > p {
        	font-size: 40px;
        	color: #18114e;
        	margin: 0;
        	margin-top: 80px;
        	font-weight: bold;
        	padding-left: 50px;
        }
        .reviewCard {
        	width: 300px;
        	height: 300px;
        	text-align: center;
        	background-color: white;
        	box-shadow: 0px 10px 25px 0px rgba(24, 17, 78, 0.08);
        	border-radius: 20px;
        	margin: auto;
        	cursor: pointer;
        }
        .reviewContainer {
        	margin-top: 74px;
        	align-items: center;
        	display: flex;
        }
        .reviewCard_hospitalName {
        	font-size: 16px;
	        font-weight: bold;
	        color: #34495e;
        }
        .reviewCard_userid {
        	font-size: 14px;
	        color: #7f8c8d;
        }
        .reviewCard_comments {
        	font-size: 16px;
        }
        .reviewCard span {
        	font-size: 16px;
	        font-weight: bold;
	        color: #f39c12;
        }
    </style>
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
<!-- 즐겨찾기 테이블 -->
<table id="myFavoritesTable" class="hidden">
    <thead></thead>
    <tbody></tbody>
</table>

<div class="pages">
   <div class="first page">
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
      <div class="overlay"></div>
      
      <div class="main_left">
          <p>AMD, 세상의 모든 응급 검색</p>
          <p>All Emergency Searches in the World</p>
          <p>최신 IP정보를 수집하여<br>
                  최적의 응급 정보와 전문 상담 서비스를 제공합니다.</p>
      </div>
      
	  <div class="main_right">
		   <div class="input-group">
            <div class="search-buttons">
               <div class="select-wrap">
                  <select id="searchTypeSelect">
                     <option value="search">증상 검색</option>
                     <option value="hospital">병원명 검색</option>
                  </select>
               </div>
            </div>
            <form id="searchForm" class="search-form" method="post">
               <input type="text" id="searchInput" name="search" placeholder="증상 또는 병명을 입력해주세요" required>
               <button type="submit" class="search">검색</button>
               <img src="${cpath }/resources/image/voice-icon.png" id="soundSearch">
            </form>
         </div>
		
		<p>
		<div class="ranking-container">
			<ul id="rankingList" class="ranking-list">
			<c:forEach var="keyword" items="${rankings}" varStatus="status">
				<li class="ranking-item">
					<span class="ranking-index">${status.index + 1}</span>
					<span class="ranking-text">${keyword.keyword}</span>
					<span class="ranking-count">${keyword.total_count}</span>
				</li>
			</c:forEach>
			</ul>
		</div>
		</p>

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

		</div>	<!-- main_right 종료 -->
	</div>	<!-- 첫번째 페이지 종료 -->
   
    <div class="second page">
        <div class="categoryComment">
            <p>CATEGORY</p>
        </div>
       	<div class="slideWrap">
		    <ul class="imgSlide">
		        <li>
		            <a href="${cpath}/hospital/selectLocation/23">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/가정의학과.avif" alt="가정의학과">
		                <h4>가정의학과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/8">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/성형외과.jpg" alt="성형외과">
		                <h4>성형외과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/14">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/피부과.avif" alt="피부과">
		                <h4>피부과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/80">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/한의원.avif" alt="한의원">
		                <h4>한의원</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/15">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/비뇨기과.avif" alt="비뇨기과">
		                <h4>비뇨기과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/10">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/산부인과.jpg" alt="산부인과">
		                <h4>산부인과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/1">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/내과.avif" alt="내과">
		                <h4>내과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/3">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/정신과.jpg" alt="정신건강의학과">
		                <h4>정신건강의학과</h4>
		            </a>
		        </li>
		    </ul>
		</div>		<!-- 첫번째 줄 리스트 종료 -->

		<div class="slideWrap">
		    <ul class="imgSlide">
		        <li>
		            <a href="${cpath}/hospital/selectLocation/49">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/치과.avif" alt="치과">
		                <h4>치과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/12">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/안과.avif" alt="안과">
		                <h4>안과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/13">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/이비인후과.jpg" alt="이비인후과">
		                <h4>이비인후과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/5">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/정형외과.jpg" alt="정형외과">
		                <h4>정형외과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/21">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/재활의학과.jpg" alt="재활의학과">
		                <h4>재활의학과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/6">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/신경외과.jpg" alt="신경외과">
		                <h4>신경외과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/9">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/마취통증의학과.avif" alt="마취통증의학과">
		                <h4>마취통증의학과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/4">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/외과.avif" alt="외과">
		                <h4>외과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/2">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/신경과.jpg" alt="신경과">
		                <h4>신경과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/16">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/영상의학과.jpg" alt="영상의학과">
		                <h4>영상의학과</h4>
		            </a>
		        </li>
		        <li>
		            <a href="${cpath}/hospital/selectLocation/11">
		                <div class="categoryOverlay"></div>
		                <img src="${cpath}/resources/category/소아과.jpg" alt="소아과">
		                <h4>소아과</h4>
		            </a>
		        </li>
		    </ul>
		</div>	<!-- 2번째줄 리스트 종료 -->
       
   </div> 	<!-- 2번째 페이지 종료 -->

	<div class="third page">
		<div class="thirdPageComment">
			<h1 class="reveal-text">당신의 건강 파트너, 병원 검색의 시작.</h1>
			<p class="reveal-text">빠르고 간편하게, 필요한 정보를 한눈에.</p>
			<p class="reveal-text">편리하게, 믿을 수 있는 병원을 찾아보세요.</p>
		</div>
		<div class="rollerWrap">
			<div class="rolling-list" id="roller1">
				<ul id="emergencyList"></ul>
			</div>
		</div>
    
	</div>	<!-- 3번째 페이지 종료 -->
	
	<div class="fourth page">
		<p>실제 후기를 확인해보세요</p>
		<div class="reviewContainer">
			<c:forEach var="dto" items="${homeReview }">
				<div class="reviewCard">
					<p class="reviewCard_hospitalName"><a href="${cpath }/hospitalInfo/${dto.hospital_id}">${dto.hospital_name }</a>
					<p class="reviewCard_userid">${dto.userid }</p>
					<p class="reviewCard_comments">${dto.comments }</p>
				<c:forEach var="i" begin="1" end="${dto.rating }">
				    <span>★</span>
				</c:forEach>	
				</div>
			</c:forEach>
		</div>
	
		<footer id="footer">
			<p>
			   사업자: 민재컴퍼니 | 대표자: 지민재<br>
			    사업자등록번호: 000-00-000000<br>
			    통신판매업신고번호 : 제2024-부산해운대-00001호<br>
			   주소 : 부산 해운대구 센텀2로 25<br>
			   개인정보관리자 : 이호준<br>
			   문의번화번호 : 000-0000-0000
			</p>
			<div class="footerRight">
			   <div class="icons">
			      <a class="icon_youtube"></a>
			      <a class="icon_instagram"></a>
			      <a class="icon_facebook"></a>
			   </div>
			   <p>
			      Copyright©ApuziMapsidak Inc. All rights reserved.<br>
			      개인정보 처리 방침 | 사이트 이용약관 | 이메일무단수집거부
			   </p>
			</div>
		</footer>
	</div>
</div>


<ul class="pagination">
</ul>

<div class="backImage">
</div>
   
<div id="mapModal">
    <div class="content">
        <div id="map2"></div>
		<ul id="hospitalList" class="hospital-list"></ul>
		<div id="closeMapModalBtn">닫기</div>
	</div>
</div>



<!-- 새창에서 챗봇 페이지로 이동 -->
<script>
	async function openChatRoom() {
		const url = cpath + '/chats/room'
		const roomUrl = await fetch(url).then(resp => resp.text())
// 		console.log('roomUrl 받아온 후: ', roomUrl)
		
		if(roomUrl) {
			window.open(cpath + '/chat/room/' + roomUrl, '_blank', 'width=600, height=1080')
		}
		else {
			alert('챗봇으로 연결할 수 없습니다')
		}
	}
</script>
<!-- 민재 검색 스크립트 -->
<script>
    let markers = []
    const searchTypeSwitch = document.getElementById('searchTypeSwitch');
    const searchForm = document.getElementById('searchForm')
    const searchInput = document.getElementById('searchInput')
	const searchTypeSelect = document.getElementById('searchTypeSelect'); // 셀렉트 요소
    const hospitalList = document.getElementById('hospitalList')
    const mapModal = document.getElementById('mapModal')
    let map; // 맵 변수 선언
    const infowindow = new kakao.maps.InfoWindow({ zIndex: 1 }) // 인포윈도우 생성
    
    let recognition   //음성인식에 사용
    let isRecognitionActive = false // 음성 인식 상태 플래그
    const soundSearch = document.getElementById('soundSearch')
    // 음성 인식 초기화
    if (window.SpeechRecognition || window.webkitSpeechRecognition) {
       recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)()
       recognition.lang = 'ko-KR' // 한국어로 설정
    }

    // 음성 인식 시작 이벤트
    recognition.onstart = function () {
       isRecognitionActive = true // 음성 인식이 시작되었음을 표시
       Swal.fire({
          title: '알림',
          text: '음성 인식이 시작되었습니다.',
          icon: 'success',
          confirmButtonColor:'#9cd2f1',
          confirmButtonText: '확인'
       })
    }

    // 음성 인식 종료 이벤트
    recognition.onend = function () {
       isRecognitionActive = false // 음성 인식이 종료되었음을 표시
       Swal.fire({
          title: '알림',
          text: '음성 인식이 종료되었습니다.',
          confirmButtonColor:'#9cd2f1',
          icon: 'info',
          confirmButtonText: '확인'
       })
    }

    // 음성 인식 시작 함수
    function startRecognition() {
       if (!isRecognitionActive) { // 음성 인식이 실행 중이 아닐 때만 시작
          recognition.start()
       } else {
          Swal.fire({
             title: '알림',
             text: '음성 인식이 이미 실행 중입니다.',
             confirmButtonColor:'#9cd2f1',
             icon: 'info',
             confirmButtonText: '확인'
          })
       }
    }
    // 음성 인식 결과 처리
    recognition.onresult = function (event) {
		let speechToText = event.results[0][0].transcript
		// 마침표 제거 및 텍스트 트리밍
		speechToText = speechToText.trim().replace('.', '')
		// 단어를 공백 기준으로 분리하고 컴마로 연결
		const formattedText = speechToText.split(' ').join(' , ')
       searchInput.value = formattedText // 텍스트 입력 필드에 반영
//        console.log('음성 검색 결과: ', speechToText)
    }

    soundSearch.onclick = startRecognition

    // 초기 플레이스 홀더 설정
    searchInput.placeholder = '증상 또는 병명을 입력해주세요'  // 기본값

    // 스위치 상태에 따라 플레이스 홀더 및 name 속성 변경
    searchTypeSelect.addEventListener('change', function() {
       if (this.value === 'hospital') {
          // 병원명 검색 선택 시
          searchInput.placeholder = '병원명을 입력해주세요'
          searchInput.name = 'hospital'  // 병원명 검색
       } else {
          // 증상 검색 선택 시
          searchInput.placeholder = '증상 또는 병명을 입력해주세요'
          searchInput.name = 'search'  // 증상 검색
       }
    })

    // 검색 핸들러
    async function searchHandler(event) {
       event.preventDefault();
       const formData = new FormData(event.target);
		const query = searchInput.value // 입력된 검색어를 저장
		localStorage.setItem('lastSearch', query) // 검색어를 localStorage에 저장
       const url = searchTypeSelect.value === 'hospital' ? '${cpath}/hospitals/searchs/names' : '${cpath}/hospitals/searchs';
       const opt = {
          method: 'POST',
          body: formData
       }
       const result = await fetch(url, opt).then(response => response.json());
//        console.log(result);

       if (result.noSearch) {
          swal({
             title: '알림',
             text: '검색결과가 없습니다. 검색어를 조건에 맞게 검색하세요',
             type: 'info',
             button: '확인'
          })
       } else {
          if (searchTypeSelect.value === 'hospital') {
             // 병원명 검색인 경우 모달 열기
             openMapModal(result.hospitals)
          } else {
             // 다른 페이지로 이동 (증상 검색의 경우)
             window.location.href = '${cpath}/result'
          }
       }
    }

    // 폼 제출 시 searchHandler 실행
    searchForm.addEventListener('submit', searchHandler);

    function displayHospitalList(hospitals) {
        hospitalList.innerHTML = ''; // 이전 결과 초기화
        hospitals.forEach(hospital => {
            const listItem = document.createElement('li')
            listItem.innerText = hospital.hospital_name + '(' +hospital.address.substring(0,2) + ')' // 병원명 표시

            // 리스트 항목 클릭 시 맵 중심 이동 및 인포윈도우 표시
            listItem.addEventListener('click', () => {
                // 클릭된 리스트 항목에 'selected' 클래스 추가
                const selectedItem = document.querySelector('.hospital-list .selected')
                if (selectedItem) {
                    selectedItem.classList.remove('selected')
                }
                listItem.classList.add('selected') // 클릭된 항목에 'selected' 클래스 추가
                const markerPosition = new kakao.maps.LatLng(hospital.lat, hospital.lng)
                map.setCenter(markerPosition) // 맵 중심 이동
                map.setLevel(3) // 줌 레벨을 6으로 설정 (더 크게 보이도록)
                const marker = new kakao.maps.Marker({
                    position: markerPosition,
                    map: map, // 기존 맵 변수 사용
                    image: markerImage
                });
                markers.forEach(m => m.setMap(null)) // 기존 마커 숨기기
                markers = [marker] // 현재 마커로 배열 초기화
				// 인포윈도우 내용 생성
				const infoMapListContent = document.createElement('div');
				infoMapListContent.classList.add('infoMapListContent'); // 클래스 추가

				// 병원 이름을 <a> 태그로 만들기
				const hospitalNameLink = document.createElement('a');
				hospitalNameLink.href = '${cpath}/hospitalInfo/' + hospital.id; // 병원 상세 페이지로 링크
				hospitalNameLink.target = '_blank'; // 새 탭에서 열기
				hospitalNameLink.classList.add('hospitalNameLink'); // 클래스 추가
				hospitalNameLink.innerText = hospital.hospital_name;

				// 주소와 전화번호 정보 추가
				const addressText = document.createElement('div');
				addressText.classList.add('hospitalAddress'); // 클래스 추가
				addressText.innerHTML = '<strong>주소:</strong> ' + hospital.address;

				const telText = document.createElement('div');
				telText.classList.add('hospitalPhone'); // 클래스 추가
				telText.innerHTML = '<strong>전화번호:</strong> ' + hospital.tel;

				// 인포윈도우 내용에 병원 이름, 주소, 전화번호 추가
				infoMapListContent.appendChild(hospitalNameLink);
				infoMapListContent.appendChild(addressText);
				infoMapListContent.appendChild(telText);

				// 인포윈도우 열기
				infowindow.setContent(infoMapListContent);
				infowindow.open(map, marker); // 클릭한 마커 위에 인포윈도우 표시
			});

            hospitalList.appendChild(listItem);
        });
    }

    // 사용자 정의 마커 이미지 경로
    const markerImageUrl = '${cpath}/resources/image/3333.png'; // 마커 이미지 경로를 설정하세요
    const markerImageSize = new kakao.maps.Size(30, 30); // 마커 이미지의 크기

    // 사용자 정의 마커 이미지 객체 생성
    const markerImage = new kakao.maps.MarkerImage(markerImageUrl, markerImageSize);

    // 모달 열기 및 마커 표시
    async function openMapModal(hospitals) {
        const modal = document.getElementById('mapModal')
        modal.classList.add('show')

        const mapContainer = document.getElementById('map2') // 맵 컨테이너

        // 카카오 맵 초기화
        map = new kakao.maps.Map(mapContainer, {
            center: new kakao.maps.LatLng(37.5563, 126.9727), // 서울역 좌표
            level: 13  // 줌 레벨 설정
        })

        // 새로운 마커 추가
        markers.forEach(marker => marker.setMap(null)) // 기존 마커 숨기기
        markers = [] // 마커 배열 초기화

        // 새로운 마커 추가
        hospitals.slice(0, 20).forEach(hospital => {
            const markerPosition = new kakao.maps.LatLng(hospital.lat, hospital.lng)
            const marker = new kakao.maps.Marker({
                position: markerPosition,
                image: markerImage
            })

            marker.setMap(map)
            markers.push(marker)
            // 마커 클릭 시 해당 병원의 인포윈도우 띄우기
            kakao.maps.event.addListener(marker, 'click', function() {
				const infoMapContent = document.createElement('div');
				infoMapContent.classList.add('infoMapContent'); // 클래스 추가

				// 병원 이름을 <a> 태그로 만들기
				const hospitalNameLink = document.createElement('a');
				hospitalNameLink.href = '${cpath}/hospitalInfo/' + hospital.id; // 병원 상세 페이지로 링크
				hospitalNameLink.target = '_blank'; // 새 탭에서 열기
				hospitalNameLink.classList.add('hospitalNameLink'); // 클래스 추가
				hospitalNameLink.innerText = hospital.hospital_name;

				// 주소와 전화번호 정보 추가
				const addressText = document.createElement('div');
				addressText.classList.add('hospitalAddress'); // 클래스 추가
				addressText.innerHTML = '<strong>주소:</strong> ' + hospital.address;

				const telText = document.createElement('div');
				telText.classList.add('hospitalPhone'); // 클래스 추가
				telText.innerHTML = '<strong>전화번호:</strong> ' + hospital.tel;

				// 인포윈도우 내용에 병원 이름, 주소, 전화번호 추가
				infoMapContent.appendChild(hospitalNameLink);
				infoMapContent.appendChild(addressText);
				infoMapContent.appendChild(telText);

				// 인포윈도우 열기
				infowindow.setContent(infoMapContent);
				infowindow.open(map, marker); // 클릭한 마커 위에 인포윈도우 표시
			});
        });

        displayHospitalList(hospitals); // 병원 리스트 표시
    }

    // 모달 닫기
    function closeMapModal() {
        const modal = document.getElementById('mapModal')
        modal.classList.remove('show')
        markers.forEach(marker => marker.setMap(null)) // 마커 숨기기
        markers = [] // 마커 배열 초기화
    }

	// 닫기 버튼 클릭 시 모달 닫기
	document.getElementById('closeMapModalBtn').addEventListener('click', function() {
		closeMapModal();
	})
</script>

<script>
<!-- 스크롤 효과 스크립트(호준) -->
window.onload = () => {
    const Slider = function(pages, pagination) {
        let slides = [],
            btns = [],
            count = 0,
            current = 0,
            touchstart = 0,
            animation_state = false;

        const init = () => {
        slides = pages.children;
        count = slides.length;
        for(let i = 0; i < count; i++) {
//         	페이지 시작 위치
			if (i === count - 1) {
				slides[i].style.bottom = -(i * 100) + '70%';
			}
			else {
            	slides[i].style.bottom = -(i * 100) + '%';
			}
            
            let btn = document.createElement('li');
            btn.dataset.slide = i;
            btn.addEventListener('click', btnClick)
            btns.push(btn);
            pagination.appendChild(btn);
        }
        btns[0].classList.add('active');
        }

        const gotoNum = (index) => {
            if((index != current) && !animation_state) {
                animation_state = true;
                setTimeout(() => animation_state = false, 500);
                btns[current].classList.remove('active');
                current = index;
                btns[current].classList.add('active');
                for(let i = 0; i < count; i++) {
                    if (i === count - 1) {
                        slides[i].style.top = (i - current) * 100 + 'vh';
                    } else {
                        slides[i].style.top = (i - current) * 100 + '%';
                    }
                }
            }
        }

        const gotoNext = () => current < count - 1 ? gotoNum(current + 1) : false;
        const gotoPrev = () => current > 0 ? gotoNum(current - 1) : false;
        const btnClick = (e) => gotoNum(parseInt(e.target.dataset.slide));
        pages.ontouchstart = (e) => touchstart = e.touches[0].screenY;
        pages.ontouchend = (e) => touchstart < e.changedTouches[0].screenY ? gotoPrev() : gotoNext();
        pages.onmousewheel = pages.onwheel = (e) => e.deltaY < 0 ? gotoPrev() : gotoNext();

        init();
    }

    let pages = document.querySelector('.pages');
    let pagination = document.querySelector('.pagination');
    let slider = new Slider(pages, pagination)
    }

    // 모든 imgSlide 요소 선택
    const imgSlides = document.querySelectorAll(".imgSlide");

    // 각 imgSlide에 대해 복제 작업 수행
    imgSlides.forEach((imgSlide) => {
        // 복제
        const clone = imgSlide.cloneNode(true);

        // 복제본 추가
        imgSlide.parentElement.appendChild(clone);

        // 원본, 복제본 위치 지정 (offsetWidth를 사용하여 레이아웃을 강제로 업데이트)
        imgSlide.offsetWidth; // Trigger reflow

        // 클래스 할당
        imgSlide.classList.add("original");
        clone.classList.add("clone");
    });
</script>



<!-- 응급실 목록 -->
<script>
    async function emergencyHandler() {
        const url = '${cpath}/hospitals/emergency'
        const result = await fetch(url).then(response => response.json())
        const emergency = result.emergency

        const emergencyList = document.getElementById('emergencyList')

        emergency.forEach(function(x) {
            const listItem = document.createElement('li')
            const areaCode = x.dutyTel3.slice(0, 3)
            let region
            let regionClass

            switch (areaCode) {
                case '02': region = '서울'; regionClass = 'region-seoul'; break
                case '031': region = '경기'; regionClass = 'region-gyeonggi'; break
                case '032': region = '인천'; regionClass = 'region-incheon'; break
                case '051': region = '부산'; regionClass = 'region-busan'; break
                case '053': region = '대구'; regionClass = 'region-daegu'; break
                case '042': region = '대전'; regionClass = 'region-daejeon'; break
                case '062': region = '광주'; regionClass = 'region-gwangju'; break
                case '052': region = '울산'; regionClass = 'region-ulsan'; break
                case '044': region = '세종'; regionClass = 'region-sejong'; break
                case '033': region = '강원'; regionClass = 'region-gangwon'; break
                case '043': region = '충북'; regionClass = 'region-chungbuk'; break
                case '041': region = '충남'; regionClass = 'region-chungnam'; break
                case '063': region = '전북'; regionClass = 'region-jeonbuk'; break
                case '061': region = '전남'; regionClass = 'region-jeonnam'; break
                case '054': region = '경북'; regionClass = 'region-gyeongbuk'; break
                case '055': region = '경남'; regionClass = 'region-gyeongnam'; break
                case '064': region = '제주'; regionClass = 'region-jeju'; break
                default: region = '기타'; regionClass = 'region-etc'; break
            }

            listItem.innerHTML =
                '<div>' +
                '<strong>' + x.dutyName + ' (' + region + ')</strong><br>' +
                '<a href="tel:' + x.dutyTel3 + '">전화: ' + x.dutyTel3 + '</a><br>' +
                '입원실: ' + x.hvgc + '<br>' +
                '응급실: ' + x.hvec +
                '</div>'

            listItem.classList.add(regionClass)
            emergencyList.appendChild(listItem)
        })

        const roller = document.getElementById('roller1')
        const clone = roller.cloneNode(true)
        clone.id = 'roller2'
        document.querySelector('.rollerWrap').appendChild(clone)

        document.querySelector('#roller1').style.left = '0px'
        document.querySelector('#roller2').style.left = roller.offsetWidth + 'px'

        roller.classList.add('original')
        clone.classList.add('clone')
    }

    window.addEventListener('DOMContentLoaded', emergencyHandler)
</script>

<%--검색어 순위--%>
<script>
	//검색어 순위
	document.addEventListener('DOMContentLoaded', function() {
		const rankingList = document.getElementById('rankingList');
		const originalOrder = Array.from(rankingList.children);
		let timer;

		// Animate the rankings to scroll one by one
		function tickerAnimation() {
			timer = setTimeout(function() {
				const firstLi = rankingList.querySelector('li:first-child');
				firstLi.style.marginTop = '-30px';
				firstLi.style.transition = 'margin-top 400ms';

				setTimeout(() => {
					rankingList.appendChild(firstLi);
					firstLi.style.marginTop = '';
					firstLi.style.transition = '';
					tickerAnimation();
				}, 400);
			}, 2000);
		}

		function resetOrder() {
			// 리스트를 초기 순서로 재정렬
			originalOrder.forEach(item => rankingList.appendChild(item));
		}

		tickerAnimation();

		rankingList.addEventListener('mouseover', function() {
			clearTimeout(timer);
			resetOrder(); // 순서 초기화
			rankingList.classList.add('expanded');
		});

		rankingList.addEventListener('mouseout', function() {
			rankingList.classList.remove('expanded');
			tickerAnimation();
		});


		document.querySelectorAll('.ranking-item').forEach(item => {
			item.onclick = function() {
				const keyword = item.querySelector('.ranking-text').textContent // 클릭한 아이템의 텍스트 가져오기
				document.getElementById('searchInput').value = keyword // 입력 필드에 키워드 설정

				// FormData 객체 생성
				const formData = new FormData(document.getElementById('searchForm'))

				// FormData에 검색어 추가 (필요한 경우)
				formData.set('search', keyword) // 'search'라는 이름으로 키워드 추가

				// AJAX 요청을 통해 폼 데이터 전송
				searchHandler2(formData)
			}
		})
	})

	// 검색 핸들러
	async function searchHandler2(data) {
		const url = searchTypeSelect.value === 'hospital' ? '${cpath}/hospitals/searchs/names' : '${cpath}/hospitals/searchs';
		const opt = {
			method: 'POST',
			body: data
		};
		const result = await fetch(url, opt).then(response => response.json());
// 		console.log(result);

		if (result.noSearch) {
			swal({
				title: '알림',
				text: '검색결과가 없습니다. 검색어를 조건에 맞게 검색하세요',
				type: 'info',
				button: '확인'
			});
		} else {
			if (searchTypeSelect.value === 'hospital') {
				// 병원명 검색인 경우 모달 열기
				openMapModal(result.hospitals);
			} else {
				// 다른 페이지로 이동 (증상 검색의 경우)
				window.location.href = '${cpath}/result';
			}
		}
	}
</script>

<%--로그인--%>
<script>
    const cpath = '${cpath}'
    const loginIcon = document.querySelector('div.loginIcon')
    const gotoInfo = document.getElementById('div.gotoInfo')
    if (loginIcon) {
        loginIcon.addEventListener('click', function() {
            location.href = cpath + '/member/login'
        })
    }
    if (gotoInfo) {
        gotoInfo.addEventListener('click', function() {
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
        if (result > 0 && '${login}' != '') {
            notificationCountSpan.classList.remove('hidden')
            if (result >= 10 ) {
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

<!-- 세번째 페이지 코멘트 스크립트 -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const texts = document.querySelectorAll('.reveal-text'); // 모든 .reveal-text 요소 선택

        function playAnimation() {
            texts.forEach((element, index) => {
                // 애니메이션 리셋
                element.classList.add('reset');
                element.style.backgroundSize = '0% 100%';

                // 강제로 리플로우 발생
                void element.offsetWidth;

                // 리셋 클래스 제거 및 애니메이션 시작
                element.classList.remove('reset');
                setTimeout(() => {
                    element.style.backgroundSize = '100% 100%';
                }, index * 500); // 순차적으로 애니메이션 적용
            });
        }

        // 초기 애니메이션 실행
        playAnimation();

        // 텍스트 클릭 시 전체 애니메이션 재실행
        texts.forEach(text => {
            text.addEventListener('click', playAnimation);
        });
    });
</script>

</body>
</html>