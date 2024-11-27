<%@ page language="java" contentType="text/html; charset=UTF-8" 
   pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/member/reCheckUserid.css">

<div class="reCheckmodal">
<div class="reCheckoverlay"></div>
   <div class="reCheckcontent">
	   <h3 id="reCheckEmailTitle">고객님의 E-mail 주소를 입력하세요.</h3>
	   
	   <form method="POST" id="reCheckForm">
	       <p class="reCheckIdBtn"><input type="email" name="email" placeholder="기억하시는 메일 주소를 입력해주세요" required></p>
	       <p><input type="submit" value="조회"></p>
	   </form>
	   
	   <p><a href="${cpath }/member/resetPassword"><button type="button" class="gotoBackBtn">뒤로가기</button></a></p>
   </div>
</div>

<%@ include file="../footer.jsp" %>

<script>
   document.addEventListener('DOMContentLoaded', function() {
       const form = document.getElementById('reCheckForm')
       form.onsubmit = function(event) {
           event.preventDefault()
           
           const formData = new FormData(form)
           fetch('${cpath}/members/reCheckUserid', {
               method: 'POST',
               body: formData
           })
           .then(response => response.json()) // JSON으로 응답 받기
           .then(data => {
               if (data.status === 'fail') {
                   swal({
                       title: "조회 실패",
                       text: data.message,
                       type: "error",
                       confirmButtonText: "확인"
                   }, function() {
                       location.href = '${cpath}/member/reCheckUserid'
                   })
               } else if (data.status === 'success') {
                   swal({
                       title: "조회 성공",
                       text: data.message,
                       type: "success",
                       confirmButtonText: "로그인 페이지로"
                   }, function() {
                       location.href = '${cpath}/member/login'
                   })
               } else {
                   swal("알림", "예상치 못한 응답을 받았습니다.", "warning");
               }
           })
           .catch(error => {
//                console.error('Error:', error)
               swal("오류", "처리 중 오류가 발생했습니다.", "error")
           })
       }
   })
   
   const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#83888d'
</script>

</body>
</html>