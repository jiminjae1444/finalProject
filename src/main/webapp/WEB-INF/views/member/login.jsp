<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<link rel="stylesheet" href="${cpath}/resources/css/member/login.css">

<div id="loginModal" class="loginModal">   
    <div class="content">
      <h2 id="loginTitle">AMD 로그인</h2>
<!--        <p style="color: gray;">로그인하여<br> -->
<!--                  최적의 응급 정보를 보다 효율적으로 관리해보세요.</p> -->
       <form method="POST" id="amdLoginForm">
           <p><input type="text" name="userid" placeholder="ID" autocomplete="off" required autofocus></p>
           <p><input type="password" name="userpw" placeholder="Password" required ></p>
           <p><input type="submit" value="AMD 로그인" ></p>
       </form>
         
       <div class="amdOrNaver">
          <div class="middleLine"></div>
          <span>or</span>
          <div class="middleLine"></div>
       </div>
         
       <p><input id="loginWithNaver" type="image" src="${cpath }/resources/naver/btnG_완성형.png" width="183" height="45" ></p>
       <p>
          <a href="${cpath }/member/join" style="color: gray;">회원가입하기</a>|<a href="${cpath }/member/resetPassword" style="color: gray;">비밀번호 재발급</a>
       </p>
         
       <input type="hidden" name="result">
       <p><a href="${cpath }"><button class="gotoBackBtn">뒤로가기</button></a></p>
   </div>
</div>

<%@ include file="../footer.jsp" %>

<script>
   document.addEventListener('DOMContentLoaded', function() {
       const message = '${message}'
       
       if (message != '') {
           swal('회원 가입 결과', message, 'success')
       }
   
       // 일반 로그인 처리
       const form = document.querySelector('#loginModal form')

       form.onsubmit = loginHandler
       document.getElementById('loginWithNaver').onclick = loginWithNaverHandler
   })
   
   const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#a2a3a3'
</script>

<script src="${cpath}/resources/script/member/login.js"></script>

</body>
</html>