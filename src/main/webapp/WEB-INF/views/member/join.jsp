<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/member/join.css">

<div id="joinModal" class="joinModal">

   <h3 id="joinTitle">회원가입</h3>

   <form method="POST" id="SjoinFinalForm">
         <div class="joincontent">
         <div class="joinMainline">
            <p>
               <input title="최소 4글자 이상 입력해주세요" type="text" name="userid" id="idCheckText" placeholder="ID" autocomplete="off" min="4" required autofocus>
               <input type="button" id="idCheckBtn" value="ID 중복 확인">
            </p>
         </div>
         
         <p><input type="password" name="userpw" placeholder="Password" required></p>
         <p><input type="text" name="name" placeholder="이름 입력" required></p>
         <p><input title="실제 사용하는 E-mail을 입력하여주세요" type="email" name="email" placeholder="Email"required></p>
         <p><input type="text" name="location" placeholder="주소를 검색하세요" autocomplete="off" required>
         <p><input type="text" name="birth" placeholder="주민번호 앞 6자리를 입력해주세요" required>
         <p>
            <input id="genderM" type="radio" name="gender" value="M" required>
            <label for="genderM" style="color: black;">남성</label>
            <input id="genderF" type="radio" name="gender" value="F" required>
            <label for="genderF" style="color: black;">여성</label>
         </p>
         
         
         
         <p class="naverP"><input id="joinWithNaver" type="image" src="${cpath }/resources/image/naverJoin.png"></p>
      </div>
      
      <div id="captcha" class="captchaline"></div>
      
      <p class="joinfinalBtn">   
         <input type="submit" value="가입신청">
      </p>
      <p>
         <a href="${cpath }/member/login">
            <button type="button" class="gotoBackBtn">뒤로가기</button>
         </a>
      </p>
   </form>
</div>

<%@ include file="../footer.jsp" %>
<script src="${cpath}/resources/script/member/join.js"></script>
<script>
   // 함수 선언 부
   const naverLoginUrl = '${naverLoginURL}'
   window.addEventListener('DOMContentLoaded', loadHandler)
   document.getElementById('SjoinFinalForm').onsubmit = submitHandler
   document.getElementById('idCheckBtn').onclick = idCheckHandler
   document.getElementById('joinWithNaver').onclick = joinWithNaverHandler
   document.querySelector('input[name="location"]').onclick = execDaumPostcode
</script>

</body>
</html>