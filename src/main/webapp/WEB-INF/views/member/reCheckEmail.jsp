<%@ page language="java" contentType="text/html; charset=UTF-8" 
   pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
   body{
        background: linear-gradient(to bottom,#2c3e50, #a2a3a3);
        width: 100vw;
        height: 100vh;
    }
    .EreCheckmodal {
       width: 100%;
       height: 91%;
       display: flex;
       justify-content: center;
       align-items: center;
   }   
   .EreCheckmodal > .ImgEreCheckoverlay {
       width: 100%;
       height: 100%;
       background-color: rgba(0, 0, 0, 0.8);
       z-index: 1;
   }   
   .EreCheckmodal > .ImgEreCheckcontent {
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
   .EreCheckcontent {
       width: 100%;
       max-width: 400px;
       padding: 20px;
       background-color: rgba(247, 249, 250, 0.8);
       border-radius: 8px;
       box-shadow: 0 0 10px rgba(0,0,0,0.1);
       text-align: center;
       /* background-color: rgba(0, 0, 0, 0.5); */
   }   
   .EreCheckcontent form {
       display: flex;
       flex-direction: column;
       align-items: center;
   }   
   .EreCheckcontent input[type="text"],
   .EreCheckcontent input[type="submit"] {
       width: 100%;
       padding: 10px;
       margin: 5px 0;
       border: 1px solid #ddd;
       border-radius: 4px;
   }   
   .EreCheckcontent input[type="submit"] {
       background-color: #2c3e50;
       font-size: 17px;
       color: white;
       cursor: pointer;
       width: 213px;
       height: 43px;
       margin-bottom: 0;
       padding-top: 6.5px;
       display: flex;
       justify-content: center;
       align-items: center;
       text-align: center;
       border: 0;
   }   
   .EreCheckcontent a {
       color: #333;
       text-decoration: none;
       margin: 5px;
   }
</style>
<div class="EreCheckmodal">
<div class="EreCheckoverlay"></div>
      <div class="EreCheckcontent">
   <h3 style="margin-left: 25px;">고객님의 ID를 입력하세요.</h3>
   <form method="POST" id="EreCheckForm">
       <p><input type="text" name="userid" placeholder="기억하시는 ID를 입력해주세요" required></p>
       <p style="padding-left: 20px;"><input type="submit" value="조회"></p>
   </form>
      <p style="margin-left: 18px;"><a href="${cpath }/member/resetPassword"><button type="button" formnovalidate>뒤로가기</button></a></p>
   </div>
</div>

<%@ include file="../footer.jsp" %>

<script>
   document.addEventListener('DOMContentLoaded', function() {
       const form = document.getElementById('reCheckForm')
       form.onsubmit = function(event) {
           event.preventDefault()
           
           const formData = new FormData(form)
           fetch('${cpath}/member/reCheckEmail', {
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
                       location.href = '${cpath}/member/reCheckEmail'
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
               console.error('Error:', error)
               swal("오류", "처리 중 오류가 발생했습니다.", "error")
           })
       }
   })
   
   const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#a2a3a3'
</script>

</body>
</html>