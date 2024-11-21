<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
	body{
        background: linear-gradient(to bottom,#2c3e50, #a2a3a3);
        width: 100vw;
        height: 100vh;
    }
    .bookingListModal {
        width: 98%;
        height: 91%;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-right: 10px;
    }
    .bookingListContent {
    	width: 800px;
    	height: auto;
    	background-color: rgba(247, 249, 250, 0.8);
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center; 
    }
    .topBox {
	    display: flex; /* 두 개의 div를 나란히 배치 */
	    justify-content: space-between; /* 두 div 사이에 공간을 균등하게 배치 */
	    align-items: center; /* 세로 중앙 정렬 */
	    margin-bottom: 20px; /* 상자 아래에 간격을 추가 */
	}
	.topBox .guide {
		width: 485px;
	}
    .profile-image {
	    width: 340px;
	    padding: 5px;
	    border: 1px solid #2c3e50; 
	    border-radius: 10px;
	    margin-top: 17px;
	    margin-left: 20px;
	    display: flex;
	    align-items: center;
	}
    .profile-image .size {
    	padding-top: 5px;
	    padding-left: 7px;
	    width: 100px;
	    height: 100px;
	    border-radius: 10px;
    }
    .profile-image p {
    	width: 115px;
    	margin-top: 0px;
    	margin-bottom: 0px;
    }
	.titleText, #thisIsList {
      	color: #2c3e50;
      	font-size: 25px;
    }
	.mainTable {
		text-align: center;
		padding-left: 20px;
    	padding-right: 20px;
	}
    table {
        width: 100%;
        border-collapse: separate; /* 셀 간격을 유지하기 위해 separate 설정 */
        border-spacing: 0; /* 셀 간격 초기화 */
    }
    th {
        text-align: center;
        font-size: 17px;
        padding: 8px;
    }   
    tbody.tbody1 tr:first-child td:first-child {
	    border-top-left-radius: 8px;
	}
	tbody.tbody1 tr:first-child td:last-child {
	    border-top-right-radius: 8px;
	}
	tbody.tbody1 tr:last-child td:first-child {
	    border-bottom-left-radius: 8px;
	}
	tbody.tbody1 tr:last-child td:last-child {
	    border-bottom-right-radius: 8px;
	}
    .bodyTr {
	    height: 30px; 
	    padding: 1px 0; 
	    font-size: 15px; 
	    line-height: 1.2; 
	    overflow: hidden; 
    }
    td {    	
        padding: 10px 5px;
        border-bottom: 1px solid black; 
    }
    td > div {
    	margin-bottom: 0;
    	margin-top: 5px;
    	margin-left: 5px;
    	margin-right: 5px;
    }
    a {
        text-decoration: none;  /* 밑줄 제거 */
        transition: color 0.3s ease, background-color 0.3s ease;  /* 호버 시 색상과 배경 색상 변경 효과 */
    }
    a:hover {
        color: rgba(44, 62, 80, 0.9);
    }
    .gotoBackBtn {
	    width: 183px;
	    padding: 8px; /* 여백 축소 */
	    background: none;
	    border: 1px solid #2c3e50;
	    border-radius: 4px; /* 둥글기 축소 */
	    color: #2c3e50;
	    cursor: pointer;
	    transition: background 0.3s ease, color 0.3s ease;
	    font-size: 0.9rem; /* 텍스트 크기 축소 */
   }
   .gotoBackBtn:hover {
       background: #2c3e50;
       color: white;
   }
</style>
<div class="bookingListModal">
	<div class="bookingListContent">
		<div class="topBox">
			<div class="profile-image">
				<div><img class="size" src="${cpath }/fpupload/image/${empty login.storedFileName ? 'default.png' : login.storedFileName }" alt="프로필 이미지"></div>
				<div><h2 class="titleText">병원 예약현황</h2></div>
			</div>
			<div class="guide">
				<p style="color: gray;">예약된 병원 리스트를 한눈에 관리해 보세요.<br>병원 정보는 리스트 병원명 클릭을 통하여 확인 가능합니다.</p>
			</div>
		</div>
		<h3 id="thisIsList">${login.name }님의 예약 정보 리스트입니다</h3>
	<div class="mainTable">
	<table>
		<thead>
			<tr >	
				<th>ID</th><!-- userid -->
				<th>병원명</th>
				<th>병원 주소</th>
				<th>예약일 / 예약 날짜</th>
				<th>예약 상태</th>
			</tr>
		</thead>
			<tbody class="tbody1">
				<c:forEach var="dto" items="${list }">
				<tr class="bodyTr">
					<td>
					    <div>[${dto.userid}]</div> <!-- 각 셀의 내용을 div로 감싸서 출력 -->
					</td>
					<td>
					    <div><a href="#" style="list-style: none;">${dto.hospital_name}</a></div> <!-- 병원명 -->
					</td>
					<td>
					    <div>${dto.address}</div> <!-- 주소 -->
					</td>
					<td>
					    <div>${dto.booked_at}/${dto.booking_date}</div> <!-- 예약일 -->
					</td>
					<td>
					    <div>${dto.status}</div> <!-- 예약 상태 -->
					</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<p><a href="${cpath }/member/info/${login.id}"><button class="gotoBackBtn">뒤로가기</button></a></p>
	</div>
</div>

<%@ include file="../footer.jsp" %>

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
	            row.style.backgroundColor = 'rgba(0, 0, 0, 0.3)'
	        } else if (statusValue === 0) {
	            // 예약 취소 상태: 빨간색
	            row.style.backgroundColor = 'rgba(148, 34, 34, 0.8)'
	        } else if (statusValue === -1) {
	            // 완료된 예약 상태: 녹색
	            row.style.backgroundColor = 'rgba(3, 199, 90, 0.6)'
	        } else {
	            // 기본 색상: 흰색 (알 수 없는 상태)
	            row.style.backgroundColor = 'rgba(247, 249, 250, 0.8)'
	        }
	    })
	}	
	// DOM이 준비되면 상태 변환 실행
	document.addEventListener("DOMContentLoaded", updateBookingStatus)
	
	const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#a2a3a3'
</script>
</body>
</html>