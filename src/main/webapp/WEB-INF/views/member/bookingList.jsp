<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/member/bookingList.css">

<div class="bookingListModal">
   <div class="bookingListContent">
      <div class="topBox">
         <div class="profile-image">
            <div><img class="size" src="${cpath }/fpupload/image/${empty login.storedFileName ? 'default.png' : login.storedFileName }" alt="프로필 이미지"></div>
            <div><h2 class="titleText">병원 예약 현황</h2></div>
         </div>
         <div class="guide">
            <p style="color: gray;">예약된 병원 리스트를 한눈에 관리해 보세요.<br>병원 정보는 리스트에서 병원명을 클릭하여 확인할 수 있습니다.</p>
         </div>
      </div>
      <h3 id="thisIsList">${login.name }님의 예약 정보 리스트</h3>
      <div class="mainTable">
         <table>
            <thead>
               <tr>
                  <th>병원명</th>
                  <th>병원 주소</th>
                  <th>예약 일시 / 예약 날짜</th>
                  <th>예약 상태</th>
               </tr>
            </thead>
            <tbody class="tbody1">
            <c:forEach var="dto" items="${list}">
               <tr class="bodyTr">
                  <td>
                     <div><a href="${cpath }/hospitalInfo/${dto.hospital_id}" style="list-style: none;">${dto.hospital_name}</a></div>
                  </td>
                  <td>
                     <div>${dto.address}</div>
                  </td>
                  <td>
                     <div class="bookingDateTime">
                        <!-- 예약 일시 -->
                        <div class="date">${dto.booked_at}</div>
                        <!-- 예약 날짜 -->
                        <div class="time">${dto.booking_date}</div>
                     </div>
                  </td>
                  <td>
                     <div>${dto.status}</div>
                  </td>
               </tr>
            </c:forEach>
            </tbody>
         </table>
      </div>
      <p><a href="${cpath }/member/info/${login.id}"><button class="gotoBackBtn">뒤로 가기</button></a></p>
   </div>
</div>
<script src="${cpath}/resources/script/member/bookingList.js"></script>
<script>

   // DOM이 준비되면 상태 변환 실행 
   document.addEventListener("DOMContentLoaded", updateBookingStatus)
</script>
</body>
