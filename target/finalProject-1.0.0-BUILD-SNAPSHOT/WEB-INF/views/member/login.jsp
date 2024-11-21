<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div id="loginModal" class="modal">
<div class="overlay"></div>
   <div class="content">
	<h3>finalProject</h3>
      <form method="POST">
         <p><input type="text" name="userid" placeholder="ID" autocomplete="off" required autofocus></p>
         <p><input type="password" name="userpw" placeholder="Password" required ></p>
         <p><input type="submit" value="로그인"></p>
      </form>
      
      <p><input id="loginWithNaver" type="image" src="${cpath }/resources/naver/btnG_완성형.png" width="183" height="45"></p>
      <p>
         <a href="${cpath }/member/join">회원가입하기</a>
         <a href="${cpath }/member/resetPassword">비밀번호 재발급</a>
      </p>
      
      <input type="hidden" name="result">
      <p><a href="${cpath }"><button>뒤로가기</button></a></p>
   </div>
</div>
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
       const urlParams = new URLSearchParams(window.location.search) // URL 쿼리 매개변수 읽기
       const redirectUrl = urlParams.get('redirectUrl') || '${cpath}'
        
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
                   window.location.href = redirectUrl;
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
</script>

</body>
</html>