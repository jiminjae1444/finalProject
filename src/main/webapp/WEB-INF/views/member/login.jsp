<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
   body{
        background: linear-gradient(to bottom,#2c3e50, #a2a3a3);
        width: 100vw;
        height: 100vh;
    }
    .loginModal {
       position: relative;
       height: 91%;
       display: flex;
       justify-content: center;
       align-items: center;
   }
   .content {
       width: 100%;
       max-width: 400px;
       height: 500px;
       padding: 40px;
       background-color: rgba(247, 249, 250, 0.8);
       border-radius: 8px;
       box-shadow: 0 0 10px rgba(0,0,0,0.1);
       text-align: center;
       /* background-color: rgba(0, 0, 0, 0.5); */
   }   
   .content .amdLoginForm {
       display: flex;
       flex-direction: column;
       align-items: center;
       text-align: center;
   }   
   .content input[type="text"],
   .content input[type="password"],
   .content input[type="submit"] {
       padding: 10px;
       margin: 5px auto;
       border: 1px solid #ddd;
       border-radius: 4px;
   }   
   .content input[type="submit"] {
       background-color: #2c3e50;
       font-size: 17px;
       color: white;
       cursor: pointer;
       width: 183px;
       height: 43px;
       margin-bottom: 0;
       padding-top: 6.5px;
       display: flex;
       justify-content: center;
       align-items: center;
       text-align: center;
       border: 0;
   }   
   .content a {
       color: #333;
       text-decoration: none;
       margin: 5px;
   } 
   .amdOrNaver {
      width: 240px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin: auto;
   }
   .middleLine {
      width: 100px;
      height: 2px;
      background-color: #2c3e50;
   }
   .gotoBackBtn {
	    width: 183px;
	    margin-top: 10px;
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
   #loginTitle {
      color: #2c3e50;
      font-size: 25px;
   }
   
</style>

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
       
       form.onsubmit = function(event) {
           event.preventDefault() // 기본 제출 방지
           
           const formData = new FormData(form)
           
           fetch('${cpath}/member/login', {
               method: 'POST',
               body: formData
           })
           .then(response => response.json())
           .then(data => {
               if (data.status === 'success') {
                   swal({
                       title: "정상 로그인되었습니다",
                       text: "환영합니다!",
                       type: "success",
                       confirmButtonText: "확인"
                   }, function() {
                       location.href = '${cpath}'
                   })
               } else {
                   swal({
                       title: "로그인 실패",
                       text: data.message,
                       type: "error",
                       confirmButtonText: "확인"
                   }, function() {
                       location.href = '${cpath}/member/login'
                   })
               }
           })
           .catch(error => {
               console.error('Error:', error)
               swal("오류", "로그인 처리 중 오류가 발생했습니다.", "error")
           })
       }
   
       // 네이버 로그인 처리
       function loginWithNaverHandler() {
           const url = '${naverLoginURL}'
           const name = '_blank'
           const options = 'menubar=no, toolbar=no, width=700, height=1000'
           const popup = window.open(url, name, options)
   
           // 2초마다 한번씩 팝업이 닫혔는지 확인
           const timer = setInterval(function() {
               console.log(popup.closed)
               if (popup.closed) {
                   afterClosePopup()
                   clearInterval(timer)
               }
           }, 1000)
   
           function afterClosePopup() {
               const json = document.querySelector('input[name="result"]').value
               const result = JSON.parse(json)
               console.log(result)
               if (result.success == false) {
                   swal({
                       title: '연동된 계정이 없습니다',
                       text: '회원가입으로 이동합니다',
                       type: 'info',
                       showCancelButton: true,
                       confirmButtonText: '예',
                       cancelButtonText: '아니오',
                       closeOnConfirm: true,
                       closeOnCancel: true,
                   }, function(isConfirm) {
                       if (isConfirm) {
                           location.href = '${cpath}/member/join'
                       }
                   })
               } else {
                   location.href = '${cpath}'
               }
           }
       }
   
       document.getElementById('loginWithNaver').onclick = loginWithNaverHandler
   })
   
   const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#a2a3a3'
</script>

</body>
</html>