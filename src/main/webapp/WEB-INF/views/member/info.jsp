<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/member/info.css">

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
    <p style="text-align: center;"><a href="${cpath }"><button class="gotoBackBtn" id="gotoBack1">뒤로가기</button></a></p>
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
      <p><input type="submit" value="등록하기" class="imgSubmitBtn"></p>
   </form>
   <p class="closeImgUploadModal"><a href="${cpath }/member/info/${login.id}"><button class="gotoBackBtn">뒤로가기</button></a></p>
   </div>
   </div>
</div>

<%@ include file="../footer.jsp" %>
<script src="${cpath}/resources/script/member/info.js"></script>
<script>
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
   

   
       // 뒤로가기 버튼 클릭 시 모달 닫기
       closeModalBtn.addEventListener('click', function(event) {
           event.preventDefault() // 링크 기본 동작 방지 (페이지 리다이렉션 방지)
           closeInfoModal() // 모달 닫기
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
   footer.style.backgroundColor = '#83888d'
</script>


</body>
</html>