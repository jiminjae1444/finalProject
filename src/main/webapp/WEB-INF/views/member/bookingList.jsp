<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
body {
    background: linear-gradient(to bottom, #2c3e50, #a4a4a4);
    width: 100vw;
    height: 100vh;
    margin: 0;
    padding: 0;
    font-family: Arial, sans-serif;
}

.bookingListModal {
    height: 91%;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.bookingListContent {
    width: 80%;
    max-width: 1000px;
    background-color: rgba(247, 249, 250, 0.9);
    border-radius: 8px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    padding: 30px;
    overflow-y: auto;
}

.topBox {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 20px;
}

.profile-image {
    text-align: center;
    margin-bottom: 15px;
}

.profile-image .size {
    width: 150px;
    height: 150px;
    border-radius: 10px;
    object-fit: cover;
    border: 3px solid #34495e;
}

.titleText {
    font-size: 24px;
    font-weight: bold;
    color: #34495e;
    margin-top: 10px;
}

.guide {
    text-align: center;
    font-size: 16px;
    color: gray;
    margin-top: 5px;
}

#thisIsList {
    text-align: center;
    font-size: 20px;
    font-weight: bold;
    color: #2c3e50;
    margin-bottom: 20px;
}

.mainTable {
    width: 100%;
    margin-top: 20px;
}

table {
    width: 100%;
    border-collapse: collapse;
    background-color: #fff;
}

table th, table td {
    padding: 10px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

table th {
    background-color: #34495e;
    color: white;
    font-weight: bold;
}

table td {
    font-size: 16px;
}

table a {
    color: #2c3e50;
    text-decoration: none;
}

table a:hover {
    text-decoration: underline;
}

bodyTr:hover {
    background-color: #f4f4f4;
}


.gotoBackBtn {
    background-color: #2c3e50;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    transition: background-color 0.3s ease;
}

.gotoBackBtn:hover {
    background-color: #34495e;
}

</style>
<h3>${list.size()}</h3>
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
                         <div>${dto.booked_at}/${dto.booking_date}</div>
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

<script>
   //예약 상태 숫자를 문자열로 변환하는 함수
   function getStatusText(status) {
       switch (status) {
           case 1:
               return "예약 완료"
           case 0:
               return "예약 취소"
           case -1:
               return "완료된 예약"
           default:
               return "알 수 없음"
       }
   }
   
   // 예약 상태를 변환하고 색상 변경하는 함수
   function updateBookingStatus() {
       // 모든 테이블 행을 가져오기
       const rows = document.querySelectorAll("tbody tr")
       rows.forEach(row => {
           // 현재 행에서 상태 열(td)의 내용을 가져오기
           const statusCell = row.querySelector("td:last-child")
           const statusValue = parseInt(statusCell.textContent.trim(), 10) // 숫자로 변환
           const statusText = getStatusText(statusValue) // 변환된 문자열
   
           // 상태 텍스트 업데이트
           statusCell.textContent = statusText
   
           // 색상 변경 로직
           if (statusValue === 1) {
               // 예약 완료 상태: rgba(0, 0, 0, 0.3)
               row.style.backgroundColor = '#ffffff'
           } else if (statusValue === 0) {
               // 예약 취소 상태: 빨간색
               row.style.backgroundColor = '#ffebee'
           } else if (statusValue === -1) {
               // 완료된 예약 상태: 녹색
               row.style.backgroundColor = '#d5f7d5'
           } else {
               // 기본 색상: 흰색 (알 수 없는 상태)
               row.style.backgroundColor = '#fff3e0'
           }
      })
   }    
   // DOM이 준비되면 상태 변환 실행 
   document.addEventListener("DOMContentLoaded", updateBookingStatus)
</script>
</body>
