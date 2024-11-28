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
    const url = cpath + '/members/captcha'
    const result = await fetch(url).then(resp => resp.json())

    let tag = '<fieldset><p>'
    // 이미지 경로 설정에서 "${cpath}/upload/captcha/"로 고정된 경로를 사용해야 합니다.
    // 이 경로는 서버가 정적 리소스를 제공하는 경로와 일치해야 합니다.
    // servlet-context.xml <resources> 부분에 경로 추가해야 404오류 안뜸
    tag += '<img src="' + cpath + '/fpupload/captcha/' + result.captchaImage + '" width="300">'
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

    const formData = new FormData(document.getElementById('SjoinFinalForm'))
    formData.append('user', document.querySelector('input[name="captcha"]').value)

    const url = cpath + '/members/captcha'
    const opt = {
        method: 'POST',
        body: formData
    };

    const result = await fetch(url, opt).then(resp => resp.json());

    if(result.result) {
        // 캡차 검증 성공 시, 원래 진행하려던 회원가입 폼을 제출합니다.
        event.target.submit()
        // console.log(result.result)
    }
    else {
        // 캡차 검증 실패 시, 메시지를 출력하고 캡차 이미지를 새로 로드합니다.
        swal('캡차 검증 실패', '입력값을 다시 확인해주세요', 'error')
        loadCaptchaHandler()
    }
}

// 네이버 로그인 누를 시 프로필 불러오는 스크립트 함수
function joinWithNaverHandler() {
    const name = '_blank'
    const options = 'menubar=no, toolbar=no, width=700, height=1000'
    window.open(naverLoginUrl, name, options)
}

// 아이디 중복 확인 스크립트 함수
async function idCheckHandler() {
    const userid = document.querySelector('input[name="userid"]')

    // ID 길이 확인
    if (userid.value.length < 4) {
        swal('ID 길이 부족', '아이디는 최소 4글자 이상이어야 합니다.', 'warning')
        userid.select() // 아이디 입력 필드로 포커스 이동
        return
    }

    // ID 중복 확인
    const url = cpath + '/members/idCheck?userid=' + userid.value
    const result = await fetch(url).then(resp => resp.json())

    swal(result.title, result.content, result.type)

    const userpw = document.querySelector('input[name="userpw"]')
    if (result.success) userpw.focus()
    else                userid.select()
}
