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
<script src="${cpath}/resources/script/member/resetPassword.js"></script>
<script>
	const resetForm = document.getElementById('resetForm');

   resetForm.onsubmit = resetPasswordHandler
   window.addEventListener('DOMContentLoaded', loadCaptchaHandler)
   
   const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#83888d'
</script>

</body>
</html>