<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="main-content">
    <div class="user-info">
        <h2>반갑습니다! ${login.name }(${login.gender }) 회원님!</h2>

        <div class="profile-image">
            <img class="size" src="${cpath }/fpupload/image/${empty login.storedFileName ? 'default.png' : login.storedFileName }" alt="프로필 이미지">
            <a href="${cpath }/member/imgUpdate/${login.id}" class="upload-icon">
                <img class="uploadicon" src="${cpath }/resources/image/upload_12080306.png" alt="업로드">
            </a>
        </div>
        <div class="user-details">
            <p>[개명 신청시 1:1 챗봇 문의 부탁드립니다.]</p>
            <p>${login.userid }으로 접속 중입니다.</p>
            <p>주소 정보: ${login.location }</p>
        </div>
        <div>
         <details>
            <summary>추가 주소</summary>
            <fieldset>
               <legend>주소 리스트</legend>
               <c:forEach var="dto" items="${list }">
                  <form method="POST" action="${cpath }/member/info/${dto.id}">
                     <p>${dto.memberLocation }|<input type="submit" value="삭제">
                     </p>
                  </form>
               </c:forEach>
            </fieldset>
         </details>
      </div>
    </div>

    <div class="category-buttons">
        <a href="${cpath }/member/bookingList/${login.id}" class="category-button">
            <i class="icon-reservation"></i>
            <span>예약 정보 리스트</span>
        </a>
        <a href="${cpath }/member/locationUpdate/${login.id}" class="category-button">
            <i class="icon-location"></i>
            <span>주소 정보 수정</span>
        </a>
        <a href="${cpath }/member/addLocation/${login.id }" class="category-button">
            <i class="icon-unknown"></i>
            <span>주소 추가 하기</span>
        </a>
        <a href="${cpath }/member/pwUpdate/${login.id}" class="category-button">
            <i class="icon-password"></i>
            <span>패스워드 수정</span>
        </a>
    </div>
</div>

</body>
</html>