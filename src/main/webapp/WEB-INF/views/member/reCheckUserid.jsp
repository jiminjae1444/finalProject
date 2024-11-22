<%@ page language="java" contentType="text/html; charset=UTF-8" 
   pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
    body{
        background: linear-gradient(to bottom,#2c3e50, #a2a3a3);
        width: 100vw;
        height: 100vh;
    }
    .reCheckmodal {
       width: 100%;
       height: 91%;
       display: flex;
       justify-content: center;
       align-items: center;
   }   
   .reCheckmodal > .ImgreCheckoverlay {
       width: 100%;
       height: 100%;
       position: fixed;
       top: 0;
       left: 0;
       background-color: rgba(0, 0, 0, 0.8);
       z-index: 1;
   }   
   .reCheckmodal > .ImgreCheckcontent {
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
   .reCheckcontent {
       padding: 30px;
       background-color: rgba(247, 249, 250, 0.8);
       border-radius: 8px;
       box-shadow: 0 0 10px rgba(0,0,0,0.1);
       text-align: center;
   }   
   .reCheckcontent #reCheckForm {
       display: flex;
       flex-direction: column;
       align-items: center;
   }   
   .reCheckcontent input[type="email"],
   .reCheckcontent input[type="submit"] {
       width: 250px;
       padding: 10px;
       margin: auto;
       border: 1px solid #ddd;
       border-radius: 4px;
   }   
   .reCheckcontent input[type="submit"] {
       background-color: #2c3e50;
       font-size: 17px;
       color: white;
       cursor: pointer;
       width: 270px;
       height: 43px;
       margin-bottom: 0;
       padding-top: 6.5px;
       display: flex;
       justify-content: center;
       align-items: center;
       text-align: center;
       border: 0;
   }   
   .reCheckcontent a {
       color: #333;
       text-decoration: none;
       margin: 5px;
   }
   #reCheckEmailTitle {
      color: #2c3e50;
      font-size: 25px;
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
</style>

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
               console.error('Error:', error)
               swal("오류", "처리 중 오류가 발생했습니다.", "error")
           })
       }
   })
   
   const footer = document.getElementById('footer')
   footer.style.backgroundColor = '#83888d'
</script>

</body>
</html>