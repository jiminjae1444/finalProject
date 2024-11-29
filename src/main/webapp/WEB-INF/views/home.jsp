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

<link rel="stylesheet" href="${cpath}/resources/css/home.css">

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





<script src="${cpath}/resources/script/home.js"></script>

<!-- 민재 검색 스크립트 -->
<script>
	const cpath = '${cpath}'
	const loginIcon = document.querySelector('div.loginIcon')
	const login ='${login}'
	const searchTypeSwitch = document.getElementById('searchTypeSwitch')
	const searchForm = document.getElementById('searchForm')
	const searchInput = document.getElementById('searchInput')
	const searchTypeSelect = document.getElementById('searchTypeSelect') // 셀렉트 요소
    let markers = []
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

	// 버튼 클릭 시 음성 검색 사용 여부 확인
	soundSearch.onclick = function () {
		Swal.fire({
			title: '음성 검색',
			text: '음성 검색은 단어만 검색가능합니다 사용하시겠습니까?',
			icon: 'question',
			showCancelButton: true,
			confirmButtonColor: '#9cd2f1',
			cancelButtonColor: '#c1c1c1',
			confirmButtonText: '사용',
			cancelButtonText: '취소'
		}).then((result) => {
			if (result.isConfirmed) {
				// 사용자가 "사용"을 선택한 경우 음성 검색 실행
				startRecognition()
			}
		})
	}

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
		const url = searchTypeSelect.value === 'hospital' ? cpath + '/hospitals/searchs/names' :  cpath + '/hospitals/searchs';
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
				window.location.href = cpath + '/result'
			}
		}
	}
</script>
<script src="${cpath}/resources/script/homeSearch.js"></script>
<script>
    // 사용자 정의 마커 이미지 경로
    const markerImageUrl = '${cpath}/resources/image/3333.png'; // 마커 이미지 경로를 설정하세요
    const markerImageSize = new kakao.maps.Size(30, 30); // 마커 이미지의 크기

	// 사용자 정의 마커 이미지 객체 생성
    const markerImage = new kakao.maps.MarkerImage(markerImageUrl, markerImageSize);

	// 닫기 버튼 클릭 시 모달 닫기
	document.getElementById('closeMapModalBtn').addEventListener('click', function() {
		closeMapModal()
	})
	// 폼 제출 시 searchHandler 실행
	searchForm.addEventListener('submit', searchHandler)
</script>

<script src="${cpath}/resources/script/header/headerFunctionFirst.js"></script>
<%--홈화면--%>
<script>
<!-- 스크롤 효과 스크립트(호준) -->
window.onload = () => {
    const Slider = function(pages, pagination) {
        let slides = [],
            btns = [],
            count = 0,
            current = 0,
            touchstart = 0,
            animation_state = false

        const init = () => {
        slides = pages.children
        count = slides.length
        for(let i = 0; i < count; i++) {
//         	페이지 시작 위치
			if (i === count - 1) {
				slides[i].style.bottom = -(i * 100) + '70%'
			}
			else {
            	slides[i].style.bottom = -(i * 100) + '%'
			}
            
            let btn = document.createElement('li')
            btn.dataset.slide = i
            btn.addEventListener('click', btnClick)
            btns.push(btn)
            pagination.appendChild(btn)
        }
        btns[0].classList.add('active')
        }

        const gotoNum = (index) => {
            if((index != current) && !animation_state) {
                animation_state = true;
                setTimeout(() => animation_state = false, 500)
                btns[current].classList.remove('active')
                current = index
                btns[current].classList.add('active')
                for(let i = 0; i < count; i++) {
                    if (i === count - 1) {
                        slides[i].style.top = (i - current) * 100 + 'vh'
                    } else {
                        slides[i].style.top = (i - current) * 100 + '%'
                    }
                }
            }
        }

        const gotoNext = () => current < count - 1 ? gotoNum(current + 1) : false
        const gotoPrev = () => current > 0 ? gotoNum(current - 1) : false
        const btnClick = (e) => gotoNum(parseInt(e.target.dataset.slide))
        pages.ontouchstart = (e) => touchstart = e.touches[0].screenY
        pages.ontouchend = (e) => touchstart < e.changedTouches[0].screenY ? gotoPrev() : gotoNext()
        pages.onmousewheel = pages.onwheel = (e) => e.deltaY < 0 ? gotoPrev() : gotoNext()

        init()
    }

    let pages = document.querySelector('.pages');
    let pagination = document.querySelector('.pagination');
    let slider = new Slider(pages, pagination)
    }

    // 모든 imgSlide 요소 선택
    const imgSlides = document.querySelectorAll(".imgSlide")

    // 각 imgSlide에 대해 복제 작업 수행
    imgSlides.forEach((imgSlide) => {
        // 복제
        const clone = imgSlide.cloneNode(true)

        // 복제본 추가
        imgSlide.parentElement.appendChild(clone)

        // 원본, 복제본 위치 지정 (offsetWidth를 사용하여 레이아웃을 강제로 업데이트)
        imgSlide.offsetWidth // Trigger reflow

        // 클래스 할당
        imgSlide.classList.add("original")
        clone.classList.add("clone")
    })
</script>
<!-- 응급실 목록 -->
<script>
    window.addEventListener('DOMContentLoaded', emergencyHandler)
</script>

<%--검색어 순위--%>
<script>
	//검색어 순위
	document.addEventListener('DOMContentLoaded', function() {
		tickerAnimation()
		rankingList.addEventListener('mouseover', function() {
			clearTimeout(timer)
			resetOrder() // 순서 초기화
			rankingList.classList.add('expanded')
		})
		rankingList.addEventListener('mouseout', function() {
			rankingList.classList.remove('expanded')
			tickerAnimation()
		})
		document.querySelectorAll('.ranking-item').forEach(item => {
			item.onclick = function() {
				const keyword = item.querySelector('.ranking-text').textContent // 클릭한 아이템의 텍스트 가져오기
				document.getElementById('searchInput').value = keyword // 입력 필드에 키워드 설정
				localStorage.setItem('lastSearch', keyword) // 검색어를 localStorage에 저장
				// FormData 객체 생성
				const formData = new FormData(document.getElementById('searchForm'))
				// FormData에 검색어 추가 (필요한 경우)
				formData.set('search', keyword) // 'search'라는 이름으로 키워드 추가
				// AJAX 요청을 통해 폼 데이터 전송
				searchHandler2(formData)
			}
		})
	})


</script>
<!-- 세번째 페이지 코멘트 스크립트 -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        // 초기 애니메이션 실행
        playAnimation()

        // 텍스트 클릭 시 전체 애니메이션 재실행
        texts.forEach(text => {
            text.addEventListener('click', playAnimation)
        })
    })
</script>

<%--알림--%>
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

</body>
</html>
