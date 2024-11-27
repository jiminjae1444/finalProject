// 네이버 로그인 처리
function loginWithNaverHandler() {
    const url = '${naverLoginURL}'
    const name = '_blank'
    const options = 'menubar=no, toolbar=no, width=700, height=1000'
    const popup = window.open(url, name, options)

    // 2초마다 한번씩 팝업이 닫혔는지 확인
    const timer = setInterval(function() {
//                console.log(popup.closed)
        if (popup.closed) {
            afterClosePopup()
            clearInterval(timer)
        }
    }, 1000)

    function afterClosePopup() {
        const json = document.querySelector('input[name="result"]').value
        const result = JSON.parse(json)
//                console.log(result)
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
                    location.href = cpath + '/member/join'
                }
            })
        } else {
            location.href = cpath
        }
    }
}

 function loginHandler(event) {
    event.preventDefault() // 기본 제출 방지

    const formData = new FormData(event.target)

    fetch(cpath + '/members/login', {
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
                    const redirectUrl = new URL(window.location.href).searchParams.get('redirectUrl') || cpath
                    console.log('Redirect URL:', redirectUrl);  // 확인용 콘솔 출력
                    location.href = redirectUrl
                })
            } else {
                swal({
                    title: "로그인 실패",
                    text: data.message,
                    type: "error",
                    confirmButtonText: "확인"
                }, function() {
                    location.href = cpath + '/member/login'
                })
            }
        })
        .catch(error => {
//                console.error('Error:', error)
            swal("오류", "로그인 처리 중 오류가 발생했습니다.", "error")
        })
}
