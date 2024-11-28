<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm" var="now" />
<!-- 예약 정보에 있는 예약 시간을 포맷한다 -->
<fmt:formatDate value="${bookingInfo.booking_date }" pattern="yyyy-MM-dd HH:mm" var="booking_date"/>
<link rel="stylesheet" href="${cpath}/resources/css/hospital/view.css">

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
<script src="${cpath}/resources/script/hospital/view.js"></script>
<script>
    const closeRouteBtn = document.getElementById('closeRouteBtn');
    const findRouteBtn = document.getElementById('findRouteBtn');
    const userLocation = '${login.location}'
    const hospitalLat = '${hospital.lat}'
    const hospitalLng = '${hospital.lng}'
    var address = '${hospital.address}'
    const hospital_name = '${hospital.hospital_name}'

    findRouteBtn.onclick = openRouteModal
    closeRouteBtn.onclick = closeRouteModal
    window.addEventListener('DOMContentLoaded', loadViewHandler)
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
               IMP.init('imp22288473') // '가맹점 식별코드'는 아임포트에서 발급받은 본인의 식별키를 입력
               const paymentData = {
                   pg: 'html5_inicis.INIpayTest',
                   pay_method: 'card', // 결제 수단
                   merchant_uid: 'merchant_' + new Date().getTime(), // 주문 고유 번호
                   name: '병원 예약 결제', // 결제 상품 이름
                   amount: +'${hospital.medical_expenses}', // 결제 금액 (테스트로 5,000원)
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
            if(login != '' && (await getFavorite(id)) == 1) {
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
            else if(login != '' && await getFavorite(id) != 1) {
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


