<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/hospital/hospitalInfo.css">

<div class="allWrap">
		<div class="infoWrap">
			<c:forEach var="hospital_List" items="${hospital_List }">
				<div class="hospitals" data-id="${hospital_List.id}">
				 	<div class="list-left">
						<p><a href="${cpath }/hospitalInfo/${hospital_List.id}" data-id="${hospital_List.id}" class="loadingAtag">${hospital_List.hospital_name }</a></p>
						<p>${hospital_List.address }</p>
						<p>${hospital_List.tel }<p>
					</div>
					<div class="list-right">
				 		<span id="favorite" class="favorite-icon" data-id="${hospital_List.id}"></span>
				 	</div>
				</div>
			</c:forEach>
			
		    <ul id="pagingBtn">
			   	<c:if test="${paging.prev }">
			       	<li class="prevBtn" value="${paging.begin - 1 }"><a href="">[이전]</a></li>
			    </c:if>
			    <c:forEach var="i" begin="${paging.begin }" end="${paging.end }">
			        <li class="pagingBtn"><a href="">${i }</a></li>
			    </c:forEach>
			    <c:if test="${paging.next }">
			    	<li class="nextBtn" value="${paging.begin + paging.pagePerPage}"><a href="">[다음]</a></li>
			    </c:if>
		    </ul>
		</div>
	
	
	<!-- 오버레이 배경 -->
	<div id="chartOverlay"></div>
	<div id="chartContainer">
	    <div id="loadingMessage">잠시만... 기다려주세요...</div>
	    <canvas id="viewCountChart"></canvas>
	</div>
</div>

<%@ include file="../footer.jsp" %>
<script src="${cpath}/resources/script/hospital/hospitalInfo.js"></script>
<script>
    /* 페이징 스크립트 */
    const pagingBtns = document.querySelectorAll('.pagingBtn')
    const nextBtn = document.querySelector('.nextBtn')
    const prevBtn = document.querySelector('.prevBtn')
    const path = window.location.pathname
    const arr = path.split('/')
    const jinryo_code = arr[arr.indexOf('selectLocation') + 1]
    const sido_code = arr[arr.indexOf(jinryo_code) + 1]
    const gu_code = arr[arr.indexOf(sido_code) + 1]
    const url = cpath + '/hospital/selectLocation/' + jinryo_code + '/' + sido_code + '/' + gu_code + '/pageNo='

    let hospitals = document.querySelectorAll('.hospitals')
    
    // 병원 목록 클릭이벤트
     hospitals.forEach(hospital => {
         hospital.addEventListener('click', function() {
             let num = this.getAttribute('data-id')
             console.log(num)
             location.href = cpath + '/hospitalInfo/' + num
         })
     })
    
    // 현재 페이지 번호 가져오기
    const currentPage = new URLSearchParams(window.location.search).get('pageNo') || '1'


    pagingBtns.forEach(btn => {
        btn.addEventListener('click', pagingHandler)
    });

    if (nextBtn) {
        nextBtn.addEventListener('click', nextBtnHandler)
    }
    if (prevBtn) {
        prevBtn.addEventListener('click', prevBtnHandler)
    }

    // 페이지 로드 시 실행
    document.addEventListener('DOMContentLoaded', () => {
        setCurrentPageSelected()

        // 즐겨찾기
        document.querySelectorAll('.favorite').forEach(async (favorite) => {
            const id = favorite.dataset.id
            favorite.innerText = await getFavorite(id)
            favorite.onclick = (event) => myFavorite(event)
        })
    })
</script>

<script>
// 	민재 스크립트


    let myChart = null
    let opacity = 0; // 로딩 메시지의 초기 opacity
    let fadeDirection = 1; // 1: fade in, -1: fade out
    let loadingInterval; // setInterval ID를 저장할 변수




    // 모든 'loadingAtag' 클래스의 링크 요소들을 선택
    const loadingLinks = document.querySelectorAll('.loadingAtag')
    const loadingMessage = document.getElementById('loadingMessage')
    const chartContainer = document.getElementById('chartContainer')
    const chartOverlay = document.getElementById('chartOverlay')



    // 각 링크에 클릭 이벤트 리스너 추가
    loadingLinks.forEach(link => {
        link.addEventListener('click', showChartHandler)
    })



</script>

<script>
	// 호원 스크립트
	<!-- 즐겨찾기 -->
   document.addEventListener('DOMContentLoaded', () => {
      document.querySelectorAll('.favorite-icon').forEach(async (favorite) => {
         const id = favorite.dataset.id
         const isFavorite = await getFavorite(id)
          
         if (isFavorite == 1) {
        	 favorite.style.backgroundImage = 'url(\'' + cpath + '/resources/image/KakaoTalk_20241118_165527259_01.png\')'
         } else {
        	 favorite.style.backgroundImage = 'url(\'' + cpath + '/resources/image/KakaoTalk_20241118_165527259_02.png\')'
         }
         favorite.onclick = async (event) => {
            if(login != '' && (await getFavorite(id)) == 1) {
               Swal.fire({
                    title: '즐겨찾기 삭제',
                    text: '해당 병원을 즐겨찾기 삭제 하시겠습니까?',
                    icon: 'question',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    confirmButtonColor: '#9cd2f1',
                    cancelButtonColor: '#c1c1c1',
                    showCancelButton: true,
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    showCloseButton: false
                }).then((result) => {if(result.isConfirmed) myFavorite(event)})
            }
            else if(login != '' && await getFavorite(id) != 1) {
               Swal.fire({
                    title: '즐겨찾기 추가',
                    text: '해당 병원을 즐겨찾기 추가 하시겠습니까?',
                    icon: 'question',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    confirmButtonColor: '#9cd2f1',
                    cancelButtonColor: '#c1c1c1',
                    showCancelButton: true,
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    showCloseButton: false
                }).then((result) => {if(result.isConfirmed) myFavorite(event)})
            }
            else {
               Swal.fire({
                    title: '',
                    text: '로그인 해주세요.',
                    icon: 'info',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#c1c1c1',
                    showCancelButton: true,
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    showCloseButton: false
                }).then((result) => {
                    if(result.isConfirmed){
                        const currentPageUrl = window.location.href
                        window.location.href = cpath + '/member/login?redirectUrl=' + encodeURIComponent(currentPageUrl) // 로그인 페이지로 리다이렉션
                    }
                })  
            }
         }
      })
   })
	
</script>


</body>
</html>