<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
    body{
        background: linear-gradient(to bottom,#2c3e50, #a2a3a3);
        width: 100vw;
        height: 100vh;
    }
    .resetmodal {
       width: 100%;
       height: 91%;
       display: flex;
       justify-content: center;
       align-items: center;
   }   
   .resetmodal > .Imgresetoverlay {
       width: 100%;
       height: 100%;
       position: fixed;
       top: 0;
       left: 0;
       background-color: rgba(0, 0, 0, 0.8);
       z-index: 1;
   }   
   .resetmodal > .Imgresetcontent {
       width: 300px;
       height: 400px;
       display: flex;
       flex-direction: column;
       justify-content: center;
       align-items: center;
       z-index: 2;
       position: fixed;
       top: 50%;
       left: 50%;
       transform: translate(-50%, -50%);
       border-radius: 25px;
       box-shadow: 0 0 20px rgba(0, 0, 0, 0.2);
   }
   .resetcontent {
       width: 100%;
       max-width: 400px;
       padding: 20px;
       background-color: rgba(247, 249, 250, 0.8);
       border-radius: 8px;
       box-shadow: 0 0 10px rgba(0,0,0,0.1);
       text-align: center;
       /* background-color: rgba(0, 0, 0, 0.5); */
   }   
   .resetcontent form {
       display: flex;
       flex-direction: column;
       align-items: center;
       padding: 0;
   }   
   .resetcontent input[type="text"],
   .resetcontent input[type="email"],
   .resetcontent input[type="submit"] {
       width: 190px;
       padding: 10px;
       border: 1px solid #ddd;
       border-radius: 4px;
   }   
   .resetcontent input[type="submit"] {
       background-color: #2c3e50;
       font-size: 17px;
       color: white;
       cursor: pointer;
       width: 210px;
       height: 37px;
       margin-bottom: 0;
       padding-top: 6.5px;
       display: flex;
       justify-content: center;
       align-items: center;
       text-align: center;
       border: 0;
   }   
   .resetcontent a {
       color: #333;
       text-decoration: none;
       margin: 5px;
   }
   .rpcaptchaline {
        margin-top: 10px;
    }    
    .rpcaptchaline fieldset {
        border: none;
        padding: 0;
    }   
    .resetcontent .rpcaptchaline input[type="text"] {
       text-align: center;
       padding-left: 0px;
       padding-right: 0px;
       width: 291px;
     } 
    .rpcaptchaline {
       border: 1px solid white;
       padding: 10px;
       margin-top: 10px;
       margin-bottom: 10px;
       border-radius: 10px;
   } 
   #resetPwTitle {
      color: #2c3e50;
      font-size: 25px;
   }
   .captchaReloadBtn {
   width: 289px;
   padding: 8px; /* 여백 축소 */
   background: none;
   border: 1px solid #2c3e50;
   border-radius: 4px; /* 둥글기 축소 */
   color: #2c3e50;
   cursor: pointer;
   transition: background 0.3s ease, color 0.3s ease;
   font-size: 0.9rem; /* 텍스트 크기 축소 */
   margin-top: 20px;
	}
	.gotoBackBtn {
	    width: 200px;
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
<div class="resetmodal">
<div class="resetoverlay"></div>
      <div class="resetcontent">
   <h2 id="resetPwTitle">비밀번호 재발급</h2>
   <form id ="resetForm">
      <p><input type="text" name="userid" placeholder="ID" autocomplete="off" required autofocus></p>
      <p><input type="email" name="email" placeholder="Email" autocomplete="off" required></p>
      <div id="captcha" class="rpcaptchaline"></div>
      <p><input type="submit" value="재발급"></p>   
   </form>
      <p><a href="${cpath }/member/reCheckUserid">ID 재확인</a> | <a href="${cpath }/member/reCheckEmail">Email 재확인</a></p>
      <p><a href="${cpath }/member/login"><button type="button" class="gotoBackBtn">뒤로가기</button></a></p>
   </div>
</div>

<%@ include file="../footer.jsp" %>

<script>
	const resetForm = document.getElementById('resetForm');
   async function loadCaptchaHandler() {
      const url = '${cpath}/members/captcha'
      const result = await fetch(url).then(resp => resp.json())
      let tag = '<fieldset><p>'
      tag += '<img src="${cpath}/fpupload/captcha/' + result.captchaImage + '" width="300">'
      tag += '<input type="button" name="reload" class="captchaReloadBtn" value="새로고침">'
      tag += '</p>'
      tag += '<input type="text" name="user" placeholder="그림에 나타난 글자를 입력하세요" required>'
      tag += '</fieldset>'
      document.getElementById('captcha').innerHTML = tag
      document.querySelector('input[name="reload"]').onclick = loadCaptchaHandler
   }
   async function checkCaptcha() {
      const url = '${cpath}/members/captcha'
      const opt = {
            method: 'POST',
            body: new FormData(resetForm)
      }
      const result = await fetch(url, opt).then(resp => resp.json())
      if(result.result == false) {
         swal('캡차 검증 실패', '입력값을 다시 확인해주세요', 'error')
         loadCaptchaHandler()
      }
      return result.result
   }
   
   async function resetPasswordHandler(event) {
      event.preventDefault()
      const captchaResult = await checkCaptcha()
      if(captchaResult == false) {
         return
      }      
      
      const url = '${cpath}/members/resetPassword'
//       console.log(url)
      const opt = {
            method: 'POST',
            body: new FormData(event.target)
      }
      const result = await fetch(url, opt).then(resp => resp.json())
//       console.log(result)
      if(result.success) {
         swal({
            title: '비밀번호 재설정',
            text: '이메일로 변경된 비밀번호를 전송했습니다',
            type: 'success',
            confirmButtonText: '확인',
            closeOnConfirm: true,
         }, function(isConfirm) {
            if(isConfirm) {
               location.href = '${cpath}/member/login'
            }
         })
      }
      else {
         swal('정보 재확인', '일치하는 계정 혹은 이메일을 찾을 수 없습니다', 'error')
      }
   }
   resetForm.onsubmit = resetPasswordHandler
   window.addEventListener('DOMContentLoaded', loadCaptchaHandler)
   
   const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#83888d'
</script>

</body>
</html>