<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>

/* 기본 설정 */
body {
    background: linear-gradient(to bottom, #2c3e50, #a4a4a4);
    font-family: 'Arial', sans-serif;
    width: 100vw;
    box-sizing: border-box;
}

/* 회원가입 모달 */
.joinModal {
    width: 332px;
    margin: auto;
    margin-top: 50px;
    background-color: rgba(247, 249, 250, 0.8);
    border-radius: 12px; /* 둥글기 조정 */
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    z-index: 100;
    padding: 40px;
}

   /* 제목 */
   #joinTitle {
       color: #2c3e50;
       text-align: center;
       margin: 0 0 15px;
       font-size: 25px; /* 텍스트 크기 조정 */
   }

/* 설명 텍스트 */
   .joinMainline p {
       margin: 0 0 10px;
       color: gray;
       line-height: 1.4;
       text-align: center;
       font-size: 0.9rem; /* 글씨 크기 축소 */
   }

   /* 입력 필드 */
   #idCheckText {
      width: 50%;
      border: 1px solid #d7dadd;
   }
   #idCheckBtn {
      width: 40%;
      height: 34px;
      margin-top: 8px;
      background-color: #2c3e50;
      border: 1px solid #2c3e50;
      border-radius: 5px;
      font-weight: bold;
      cursor: pointer;
      color: white;
   }
   .joincontent > p {
      text-align: center;
   }
   input[type='text'],
   input[type='password'],
   input[type='email'] {
       width: 90%;
       padding: 8px; /* 입력 필드 여백 축소 */
       margin-top: 8px; /* 간격 축소 */
       border: 1px solid #d7dadd;
       border-radius: 4px; /* 둥글기 축소 */
       box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
       font-size: 0.9rem; /* 텍스트 크기 축소 */
   }

input:focus {
    border-color: #2c3e50;
    box-shadow: inset 0 1px 5px rgba(44, 62, 80, 0.2);
}

/* 라디오 버튼 */
input[type='radio'] {
    margin-right: 5px;
}

label {
    color: #2c3e50;
    margin-right: 10px; /* 간격 축소 */
    font-size: 0.9rem; /* 텍스트 크기 조정 */
}


/* 제출 버튼 */
.joinfinalBtn input[type='submit'] {
    width: 330px;
    padding: 8px; /* 여백 축소 */
    border: none;
    border-radius: 5px;
    background: #2c3e50;
    color: white;
    font-weight: bold;
    cursor: pointer;
    transition: background 0.3s ease;
    font-size: 0.9rem; /* 텍스트 크기 축소 */
}

.joinfinalBtn input[type='submit']:hover {
    background: #34495e;
}

/* 뒤로가기 버튼 */
.gotoBackBtn {
    width: 330px;
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
.captchaReloadBtn {
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
</style>

<div id="joinModal" class="joinModal">

   <h3 id="joinTitle">회원가입</h3>

   <form method="POST">
         <div class="joincontent">
         <div class="joinMainline">
            <p>
               <input type="text" name="userid" id="idCheckText" placeholder="ID" autocomplete="off" required autofocus>
               <input type="button" id="idCheckBtn" value="ID 중복 확인">
            </p>
         </div>
         
         <p><input type="password" name="userpw" placeholder="Password" required></p>
         <p><input type="text" name="name" placeholder="이름 입력" required></p>
         <p><input title="실제 사용하는 E-mail을 입력하여주세요" type="email" name="email" placeholder="Email"required></p>
         <p><input type="text" name="location" placeholder="주소를 검색하세요" autocomplete="off" required>
         <p><input type="text" name="birth" placeholder="주민번호 앞 6자리를 입력해주세요" required>
         <p>
            <input id="gender" type="radio" name="gender" value="M" required>
            <label for="genderM" style="color: black;">남성</label>
            <input id="gender" type="radio" name="gender" value="F" required>
            <label for="genderF" style="color: black;">여성</label>
         </p>
         
         
         
         <p class="naverP"><input id="joinWithNaver" type="image" src="${cpath }/resources/naver/btnG_완성형.png" width="177" height="38"></p>
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
<script>
   // 다음 주소 찾기 함수 
   function onComplete(data) {
      document.querySelector('input[name="location"]').value = data.address
   }
   
   function execDaumPostcode() {
      const postCode = new daum.Postcode({
           oncomplete: onComplete
       })
       postCode.open()
   }
   
   // 캡차 이미지를 로드하는 함수
   async function loadCaptchaHandler() {
       // AJAX 요청을 통해 서버에서 캡차 데이터를 가져옵니다.
       const url = '${cpath}/members/captcha'
       const result = await fetch(url).then(resp => resp.json())
       
       let tag = '<fieldset><p>'       
       // 이미지 경로 설정에서 "${cpath}/upload/captcha/"로 고정된 경로를 사용해야 합니다.
       // 이 경로는 서버가 정적 리소스를 제공하는 경로와 일치해야 합니다.
       // servlet-context.xml <resources> 부분에 경로 추가해야 404오류 안뜸
       tag += '<img src="${cpath}/fpupload/captcha/' + result.captchaImage + '" width="300">'
       tag += '<input type="text" name="captcha" placeholder="그림에 나타난 글자를 입력하세요" required>'
       tag += '<input type="button" name="reload" class="captchaReloadBtn" value="새로고침">'
       tag += '</p>'
       tag += '</fieldset>'

       // 생성한 HTML을 "captcha" 요소에 삽입합니다.
       document.getElementById('captcha').innerHTML = tag

       // 새로고침 버튼을 클릭하면 캡차 이미지를 다시 로드하도록 설정합니다.
       document.querySelector('input[name="reload"]').onclick = loadCaptchaHandler
   }

   // 페이지가 로드되면 첫 캡차 이미지를 불러오도록 설정
   async function loadHandler() {
       await loadCaptchaHandler()
   }

   // 폼을 제출할 때 캡차 인증을 확인하는 함수
   async function submitHandler(event) {
       // 기본 제출 이벤트를 방지하고 AJAX 요청을 준비합니다.
       event.preventDefault();
       
       const formData = new FormData(document.forms[0])
       formData.append('user', document.querySelector('input[name="captcha"]').value)
       
       const url = '${cpath}/members/captcha'
       const opt = {
           method: 'POST',
           body: formData
       };
       
       const result = await fetch(url, opt).then(resp => resp.json());
       
       if(result.result) {  
           // 캡차 검증 성공 시, 원래 진행하려던 회원가입 폼을 제출합니다.
//            event.target.submit()
         console.log(result.result)
       }
       else {  
           // 캡차 검증 실패 시, 메시지를 출력하고 캡차 이미지를 새로 로드합니다.
           swal('캡차 검증 실패', '입력값을 다시 확인해주세요', 'error')
           loadCaptchaHandler()
       }
   }
   
   // 네이버 로그인 누를 시 프로필 불러오는 스크립트 함수
   function joinWithNaverHandler() {
      const url = '${naverLoginURL}'
      const name = '_blank'
      const options = 'menubar=no, toolbar=no, width=700, height=1000'
      window.open(url, name, options)
   }
   
   // 아이디 중복 확인 스크립트 함수
   async function idCheckBtnHandler() {
      const userid = document.querySelector('input[name="userid"]')
      if(userid.value == '') {
         return
      }
      const url = '${cpath}/members/idCheck?userid=' + userid.value
      const result = await fetch(url).then(resp => resp.json())
      
      swal(result.title, result.content, result.type)
      
      const userpw = document.querySelector('input[name="userpw"]')
      if(result.success) userpw.focus()   // 패스워드를 입력할 수 있도록 커서를 옮겨준다
      else            userid.select()   // 아이디를 다시 입력하도록 커서를 옮기면서 입력
      
   }
   
   // 함수 선언 부
   window.addEventListener('DOMContentLoaded', loadHandler)
   document.forms[0].onsubmit = submitHandler
   document.getElementById('idCheckBtn').onclick = idCheckBtnHandler
   document.getElementById('joinWithNaver').onclick = joinWithNaverHandler
   document.querySelector('input[name="location"]').onclick = execDaumPostcode
</script>

</body>
</html>