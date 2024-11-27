<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/member/resetPassword.css">
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