<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
   body{
        background: linear-gradient(to bottom,#2c3e50, #a4a4a4);
        width:100vw;
        height:100vh;
    }
    .Infomodal {
       height: 91%;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .Infocontent {
        width: 600px;
        height: auto;
        padding: 20px;
        background-color: rgba(247, 249, 250, 0.8);
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center;
    } 
    .Infocontent .profile-image .size{
        text-align: center;
        width: 250px;
        height: 250px;
        border-radius: 10px;
    }
    .Infocontent .upload-Btn {
        text-align: center;
    }
    .Infocontent .upload-Btn a{
        background-color: #2c3e50;
        font-size: 17px;
        color: white;
        width: 250px;
        height: 33px;
        margin-bottom: 0;
        padding-top: 0px;
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
        border: 0;
        border-radius: 4px;
        text-decoration: none;  
    }
    .Infocontent .upload-Btn a:hover {
       background-color: #34495e;
    }
    .Infocontent .profile-container {
       display: flex;
       flex-direction: column;
       align-items: center; /* 수평 중앙 정렬 */
       justify-content: center; /* 수직 중앙 정렬 */
       gap: 10px; /* 요소 간 간격 */
   }
   .user-details {
       text-align: left;
       margin: auto;
       margin-bottom: 10px;
       padding: 15px;
       background-color: rgba(0, 0, 0, 0.2); 
       border-radius: 10px;
   }
   .user-details p {
      padding: 0;
      margin: 0;
      margin-top: 5px;
   }
   .category-buttons {
       display: flex; /* Flexbox 활성화 */
       flex-direction: row; /* 가로 정렬 */
       justify-content: space-around; /* 버튼 간 균등 배치 */
       align-items: center; /* 세로 가운데 정렬 */
       gap: 0px; /* 버튼 간 간격 최소화 */
       margin-top: 10px; /* 상단 여백 줄이기 */
   }
   
   .category-button {
       width: 135px;
       height: 90px;
       margin: 0; /* 버튼 외부 간격 제거 */
       padding: 0;
       display: flex; /* 아이콘과 텍스트 정렬 */
       flex-direction: column; /* 세로 정렬 */
       align-items: center; /* 중앙 정렬 */
       justify-content: center; /* 세로 중앙 정렬 */
       text-decoration: none; /* 링크 밑줄 제거 */
       background-color: rgba(247, 249, 250, 0.9); /* 버튼 배경색 */
       color: black; /* 텍스트 색상 */
       font-size: 12px; /* 폰트 크기 줄이기 */
       border-radius: 8px; /* 둥근 모서리 */
       box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 버튼 그림자 */
   }
   
   .category-button:hover {
       background-color: #34495e; /* 호버 배경색 */
   }
   
   .category-button i {
       font-size: 20px; /* 아이콘 크기 줄이기 */
       margin-bottom: 4px; /* 아이콘과 텍스트 간격 최소화 */
   }
   
   .category-button span {
       font-weight: normal; /* 텍스트 강조 줄이기 */
       font-size: 11px; /* 텍스트 크기 줄이기 */
   }
/* imgUpdate style */
   .ImgModal {
      position: fixed;
        top: 136px;
        left: 1100px;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
   }
   .Updateoverlay {
      background-color: rgba(0, 0, 0, 0.8);
      top: 0;
       left: 0;
      width: 100%;
      height: 100%;
      position: fixed;
      z-index: 1;
   }
   .Imgcontent {
        width: 280px;
        height: 430px;
        padding: 20px;
        padding-bottom: 43px;
        background-color: rgba(247, 249, 250, 0.8);
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        text-align: center;
        z-index: 2;
        position: relative;
    }
    .Imgoverlay {
       background-color: rgba(0, 0, 0, 0.3);
       border-radius: 8px;
       height: 447px;
    }
    .topText {
       width: 50px;
       margin: 0px;
       color: black;
       padding-left: 13px;
       padding-top: 5px;
    }
    .text1 {
       width: 333px;
       font-size: 11px;
       color: white;
       padding-bottom: 6px;
    }
    .imgUploadP {
       margin-top: 0px;
    }
    .hidden-file-input {
       display: none;
   }
   .custom-file-label {
      background-color: #2c3e50;
       font-size: 17px;
       color: white;
       width: 200px;
       height: 32px;
       margin-bottom: 0;
       padding-top: 0px;
       display: flex;
       justify-content: center;
       align-items: center;
       text-align: center;
       border: 0;
       border-radius: 4px;
       text-decoration: none;
       margin-left: 40px;
       padding-bottom: 3px;
   }
   .custom-file-label:hover {
       background-color: #34495e;
   }
   #myInfoTitle {
      color: #2c3e50;
      font-size: 25px;
   }
   #myDetail {
   	  font-size: 16px;
   	  font-weight: normal;
   }

</style>
<div class="Infomodal">
<div class="Infooverlay"></div>
    <div class="Infocontent">
    <h2 id="myInfoTitle">회원정보</h2>
        <div class="profile-container">
          <div class="profile-image">
              <img class="size" src="${cpath }/fpupload/image/${empty login.storedFileName ? 'default.png' : login.storedFileName }" alt="프로필 이미지">
          </div>
          <p class="upload-Btn">
              <a title="회원님의 개성을 나타내는 프로필 사진을 업로드 해보세요!" id="openImgUploadModal">IMG UPLOAD</a>
          </p>
      </div>
        <div class="user-details">
            <p style="font-weight: bold;">ID/E-mail   : <span id="myDetail">${login.userid } / ${login.email }</span></p>
            <p style="font-weight: bold;">NAME/GENDER : <span id="myDetail">${login.name }   / ${login.gender }<span></p>
            <p style="font-weight: bold;">Address : <span id="myDetail">${login.location }<span></p>
        </div>
        <div>
            <details>
                <summary>Add Location List</summary>
                <p>현재 위치 정보를 추가하여 List를 만들어,<br>Address정보로 등록하실 수 있습니다.</p>
                <fieldset>
                    <c:forEach var="dto" items="${list}">
                        <form method="POST" action="${cpath}/member/info/${dto.id}"
                            id="deleteForm_${dto.id}">
                            <p>${dto.memberLocation}
                                | <input type="submit" value="삭제">
                            </p>
                        </form>
                    </c:forEach>
                </fieldset>
            </details>
        </div>
    <div class="category-buttons">
        <a href="${cpath }/member/bookingList/${login.id}" class="category-button">
            <img src="${cpath }/resources/image/Reservation.png" style="width: 45px; height: 45px;">
            <span style="font-size: 15px;">예약 정보 리스트</span>
        </a>
        <a href="${cpath }/member/locationUpdate/${login.id}" class="category-button">
            <img src="${cpath }/resources/image/refresh_11316313.png" style="width: 45px; height: 45px;">
            <span style="font-size: 15px;">주소 정보 수정</span>
        </a>
        <a href="${cpath }/member/addLocation/${login.id }" class="category-button">
            <img src="${cpath }/resources/image/map-locator_4904196.png" style="width: 45px; height: 45px;">
            <span style="font-size: 15px;">주소 추가 하기</span>
        </a>
        <a href="${cpath }/member/pwUpdate/${login.id}" class="category-button">
            <img src="${cpath }/resources/image/KakaoTalk_20241119_085732959.png" style="width: 45px; height: 45px;">
            <span style="font-size: 15px;">패스워드 수정</span>
        </a>
    </div>
    <p style="text-align: center;"><a href="${cpath }"><button>뒤로가기</button></a></p>
</div>
</div>

<!-- imgUpdate -->
<div id="ImgUploadModal" class="ImgModal" style="display: none;">
<div class="Updateoverlay"></div>
<div class="Imgcontent">
   <div class="Imgoverlay">
   <h3 class="topText">AMD, IMGupdate</h3>
   <div class="text1">실물이 아니어도 좋습니다!<br>이미지를 변경하여 나의 개성을 표현하세요.</div>
   <div>
      <img src="${cpath }/fpupload/image/${empty login.storedFileName ? 'default.png' : login.storedFileName }" style="width: 200px; height: 190px; border-radius: 10px;">
   </div>
   <form method="POST" action="${cpath}/member/imgUpdate/${login.id}" enctype="multipart/form-data">
      <p class="imgUploadP">
         <input type="file" name="imgUpload" accept="image/*" class="hidden-file-input" id="fileInput" required>
         <label for="fileInput" class="custom-file-label">IMG SEARCH</label>
      </p>
      <p><input type="submit" value="등록하기"></p>
   </form>
   <p class="closeImgUploadModal"><a href="${cpath }/member/info/${login.id}"><button>뒤로가기</button></a></p>
   </div>
   </div>
</div>

<%@ include file="../footer.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 서버에서 전송된 메시지 받기
        const error2 = '${error2}'
        const message3 = '${message3}'
    
        if (error2) {
            swal({
                title: "삭제 실패",
                text: error2,
                type: "error",
                button: "확인"
            })
        }
        if (message3) {
            swal({
                title: "삭제 성공",
                text: message3,
                type: "success",
                button: "확인"
            })
        }
    })
    // imgUpdate 모달 코드
    document.addEventListener('DOMContentLoaded', function() {
       const modal = document.getElementById('ImgUploadModal') // 모달
       const openModalBtn = document.getElementById('openImgUploadModal') // 모달을 여는 버튼
       const closeModalBtn = document.querySelector('.closeImgUploadModal') // 뒤로가기 버튼
   
       // 모달 열기
       openModalBtn.addEventListener('click', function(event) {
           event.preventDefault() // 기본 링크 동작 방지
           modal.style.display = 'block' // 모달 표시
       })
   
       // 모달 닫기 함수
       function closeModal() {
           modal.style.display = 'none' // 모달 숨기기
       }
   
       // 뒤로가기 버튼 클릭 시 모달 닫기
       closeModalBtn.addEventListener('click', function(event) {
           event.preventDefault() // 링크 기본 동작 방지 (페이지 리다이렉션 방지)
           closeModal() // 모달 닫기
       })
   })
   
   // 프로필 업로드 sweetAlert 코드
    document.addEventListener('DOMContentLoaded', function() {
        
        const message = '${message}' 
        const error = '${error}'    

        if (message) {
            swal({
                title: "업로드 성공",
                text: message,
                type: "success",
                button: "확인"
            })
        }

        if (error) {
            swal({
                title: "업로드 실패",
                text: error,
                type: "error",
                button: "확인"
            })
        }
    })
    
    const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#a2a3a3'
</script>

</body>
</html>