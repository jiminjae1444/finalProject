<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
	body{
        background: linear-gradient(to bottom,#2c3e50, #a4a4a4);
    }
    /* 모달(차트) 컨테이너 설정 */
    #chartContainer {
        width: 900px;
        height: 500px;
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background-color: white;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        text-align: center;
        z-index: 3;
    }
    
    /* 오버레이 배경 설정 */
    #chartOverlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.7); /* 어두운 반투명 배경 */
        z-index: 2; /* 모달보다 아래에 위치 */
    }

    /* 로딩 메시지 스타일 */
    #loadingMessage {
        padding: 10px;
        font-size: 30px;
        color: #2c3e50;
        font-weight: bold;
        display: none;
        animation: blink 1.5s ease-in-out infinite; /* 애니메이션 설정 */
    }
    
    /* 깜박임 효과 애니메이션 */
    @keyframes blink {
        0%, 100% { opacity: 0; }
        50% { opacity: 1; }
    }
    
    
	/* 스타일 추가 (호준)*/
	.infoWrap {
		left: 550px;
		top:118px;
		width: 800px;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        padding: 20px;
        position: absolute;
    }

    .hospitals {
        padding: 15px;
        margin-bottom: 15px;
        border-bottom: 1px solid #e0e0e0;
        transition: background-color 0.3s ease;
        display: flex;
    }
    .list-left {
    	flex: 9;
    }
    .list-right {
    	flex: 1;
    	width: 60px;
    	text-align: center;
    	line-height: 60px;
    }

    .hospitals:last-child {
        border-bottom: none;
    }

    .hospitals:hover {
        background-color: #f5f5f5;
    }

    .hospitals p {
        margin: 5px 0;
    }

    .hospitals a {
        color: #3498db;
        text-decoration: none;
        font-weight: bold;
    }

    .hospitals a:hover {
        text-decoration: underline;
    }

    .favorite {
        cursor: pointer;
        color: #e74c3c;
        margin-right: 10px;
    }

    #pagingBtn {
        display: flex;
        justify-content: center;
        list-style-type: none;
        padding: 0;
    }

    #pagingBtn li {
        margin: 0 5px;
    }

    #pagingBtn a {
        display: inline-block;
        padding: 5px 10px;
        text-decoration: none;
        border-radius: 3px;
        transition: background-color 0.3s ease;
    }

    #pagingBtn a:hover {
        background-color: #2c3e50;
    }
	.allWrap {
		width: 100%;
		height: 100vh;
		background-size: cover;
		background-position: center;
	}	
	.favorite-icon {
        display: inline-block;
        width: 50px;
        height: 40px;
        background-size: contain;
        background-repeat: no-repeat;
        margin-left: 8px;
        cursor: pointer;
        margin-top: 15px;
    }
    #pagingBtn a.pageSelected {
	    background-color: #2c3e50;
	    color: white;
	}
</style>


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

    let hospitals = document.querySelectorAll('.hospitals');
    
    // 병원 목록 클릭이벤트
     hospitals.forEach(hospital => {
         hospital.addEventListener('click', function() {
             let num = this.getAttribute('data-id');
//              console.log(num);
             location.href = '${cpath}/hospitalInfo/' + num;
         });
     });
    
    // 현재 페이지 번호 가져오기
    const currentPage = new URLSearchParams(window.location.search).get('pageNo') || '1'

    function pagingHandler(event) {
        event.preventDefault();
        if (event.target.tagName === 'A') {
            const pageNo = event.target.innerText;
            // 모든 버튼에서 pageSelected 클래스 제거
            pagingBtns.forEach(btn => btn.querySelector('a').classList.remove('pageSelected'));
            // 클릭된 버튼에 pageSelected 클래스 추가
            event.target.classList.add('pageSelected');
            // URL에 페이지 번호를 추가하여 리다이렉트
            const newUrl = new URL(url + pageNo, window.location.origin);
            newUrl.searchParams.set('pageNo', pageNo);
            window.location.href = newUrl.toString();
        }
    }

    function nextBtnHandler(event) {
        if (event.target.tagName === 'A') {
            event.preventDefault();
            const value = event.currentTarget.getAttribute('value');
            const newUrl = new URL(url + value, window.location.origin);
            newUrl.searchParams.set('pageNo', value);
            window.location.href = newUrl.toString();
        }
    }

    function prevBtnHandler(event) {
        if (event.target.tagName === 'A') {
            event.preventDefault();
            const value = event.currentTarget.getAttribute('value');
            const newUrl = new URL(url + value, window.location.origin);
            newUrl.searchParams.set('pageNo', value);
            window.location.href = newUrl.toString();
        }
    }

    // 페이지 로드 시 현재 페이지 버튼에 pageSelected 클래스 추가
    function setCurrentPageSelected() {
	    const currentPage = new URLSearchParams(window.location.search).get('pageNo') || '1';
	    pagingBtns.forEach(btn => {
	        const link = btn.querySelector('a');
	        if (link.innerText === currentPage) {
	            link.classList.add('pageSelected');
	        } else {
	            link.classList.remove('pageSelected');
	        }
	    });
	}

    pagingBtns.forEach(btn => {
        btn.addEventListener('click', pagingHandler);
    });

    if (nextBtn) {
        nextBtn.addEventListener('click', nextBtnHandler);
    }
    if (prevBtn) {
        prevBtn.addEventListener('click', prevBtnHandler);
    }

    // 페이지 로드 시 실행
    document.addEventListener('DOMContentLoaded', () => {
        setCurrentPageSelected();

        // 즐겨찾기
        document.querySelectorAll('.favorite').forEach(async (favorite) => {
            const id = favorite.dataset.id;
            favorite.innerText = await getFavorite(id);
            favorite.onclick = (event) => myFavorite(event);
        });
    });
</script>

<script>
// 	민재 스크립트


    let myChart = null
    let opacity = 0; // 로딩 메시지의 초기 opacity
    let fadeDirection = 1; // 1: fade in, -1: fade out
    let loadingInterval; // setInterval ID를 저장할 변수

    function startLoadingAnimation() {
        loadingMessage.style.display = 'block'
        loadingInterval = setInterval(() => {
            opacity += 0.05 * fadeDirection // 0.05씩 opacity 변화
            if (opacity >= 1 || opacity <= 0) fadeDirection *= -1  // 방향 전환
            loadingMessage.style.opacity = opacity
        }, 50) // 50ms마다 opacity 업데이트
    }

    function stopLoadingAnimation() {
        clearInterval(loadingInterval) // 애니메이션 중지
        loadingMessage.style.opacity = 0 // 초기화
    }
    // 모든 'loadingAtag' 클래스의 링크 요소들을 선택
    const loadingLinks = document.querySelectorAll('.loadingAtag')
    const loadingMessage = document.getElementById('loadingMessage')
    const chartContainer = document.getElementById('chartContainer')
    const chartOverlay = document.getElementById('chartOverlay')
    function dateChange(date){
        const date1 = new Date(date)
        const year = date1.getFullYear()
        const month = date1.getMonth() + 1
        const day = date1.getDate()
        const formattedMonth = month < 10 ? '0' + month : month
        const formattedDay = day < 10 ? '0' + day : day

        // yyyy-mm-dd 형식으로 반환
        const formattedDate = year + '-' + formattedMonth + '-' + formattedDay

        return formattedDate
    }


    async function showChartHandler(event) {
        event.preventDefault()
        const hId = event.target.getAttribute('data-id')
//         const hId = event.target.dataset.id
        
        const url = '${cpath}/hospitals/viewCount/' + hId
		
        // loadingMessage.style.display = 'none'
        stopLoadingAnimation();
        chartContainer.style.display = 'none'
        chartOverlay.style.display = 'none'

        const result = await fetch(url).then(resp => resp.json())
        // console.log(result.viewCount)
        //차트 띄우기
        showChart(result.viewCount)
        // 로딩 메시지 숨기기
        // loadingMessage.style.display = 'block'
        startLoadingAnimation();
        chartContainer.style.display = 'block'
        chartOverlay.style.display = 'block'

        setTimeout(() => {
            window.location.href = '${cpath}/hospitalInfo/' + hId
        },2000)
    }

    function showChart(data) {
            const labels = []
            const viewCount = []
            const today = new Date()

            // 일주일간의 날짜 배열 생성
            for (let i = 6; i >= 0; i--) {
                const date = new Date(today)
                date.setDate(today.getDate() - i)
                labels.push(dateChange(date))
            }

            // 조회수를 날짜별로 매핑
            const viewData = {}
            data.forEach(item => {
                const date = dateChange(item.view_date)
                viewData[date] = item.view_count
            })

            // labels의 날짜를 기준으로 조회수 가져오고, 없으면 0으로 추가
            labels.forEach(date => {
                if (viewData[date] !== undefined) {
                    viewCount.push(viewData[date]) // 조회수 있는 날짜는 추가
                } else {
                    viewCount.push(0) // 조회수 없는 날짜는 0으로 추가
                }
            })

            // 기존 차트가 있을 경우 destroy
            if (myChart) {
                myChart.destroy()
            }

        const context = document.getElementById('viewCountChart')
        const chartData ={
            labels : labels,
            datasets:[{
                label:'조회수',
                data: viewCount,
                borderColor: 'rgba(75, 192, 192, 1)',
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                fill: true,
                tension: 0.1
            }]
        }
        const config = {
            type: 'line', // 'line' 차트로 설정
            data: chartData,
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) { return Number.isInteger(value) ? value : '' } // 정수만 표시
                        }
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: '일주일 간 병원 조회수'
                    }
                }
            }
        }
        myChart = new Chart(context, config)
    }


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
            if('${login}' != '' && (await getFavorite(id)) == 1) {
               Swal.fire({
                    title: '즐겨찾기 삭제',
                    text: '해당 병원을 즐겨찾기 삭제 하시겠습니까?',
                    icon: 'question',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    confirmButtonColor: '#9cd2f1',
                    cancelButtonColor: '#d33',
                    showCancelButton: true,
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    showCloseButton: false
                }).then((result) => {if(result.isConfirmed) myFavorite(event)})
            }
            else if('${login}' != '' && await getFavorite(id) != 1) {
               Swal.fire({
                    title: '즐겨찾기 추가',
                    text: '해당 병원을 즐겨찾기 추가 하시겠습니까?',
                    icon: 'question',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소',
                    confirmButtonColor: '#9cd2f1',
                    cancelButtonColor: '#d33',
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
                    cancelButtonColor: '#d33',
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