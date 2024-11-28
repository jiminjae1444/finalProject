// 음성 인식 시작 이벤트
recognition.onstart = function () {
    isRecognitionActive = true // 음성 인식이 시작되었음을 표시
    Swal.fire({
        title: '알림',
        text: '음성 인식이 시작되었습니다.',
        icon: 'success',
        confirmButtonColor:'#9cd2f1',
        confirmButtonText: '확인'
    })
}

// 음성 인식 종료 이벤트
recognition.onend = function () {
    isRecognitionActive = false // 음성 인식이 종료되었음을 표시
    Swal.fire({
        title: '알림',
        text: '음성 인식이 종료되었습니다.',
        confirmButtonColor:'#9cd2f1',
        icon: 'info',
        confirmButtonText: '확인'
    })
}

// 음성 인식 시작 함수
function startRecognition() {
    if (!isRecognitionActive) { // 음성 인식이 실행 중이 아닐 때만 시작
        recognition.start()
    } else {
        Swal.fire({
            title: '알림',
            text: '음성 인식이 이미 실행 중입니다.',
            confirmButtonColor:'#9cd2f1',
            icon: 'info',
            confirmButtonText: '확인'
        })
    }
}
// 음성 인식 결과 처리
recognition.onresult = function (event) {
    let speechToText = event.results[0][0].transcript
    // 마침표 제거 및 텍스트 트리밍
    speechToText = speechToText.trim().replace('.', '')
    // 단어를 공백 기준으로 분리하고 컴마로 연결
    const formattedText = speechToText.split(' ').join(', ')
    searchInput.value = formattedText // 텍스트 입력 필드에 반영
}


// 버튼 클릭 시 음성 검색 사용 여부 확인
soundSearch.onclick = function () {
    Swal.fire({
        title: '음성 검색',
        text: '음성 검색은 단어만 검색가능합니다 사용하시겠습니까?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#9cd2f1',
        cancelButtonColor: '#c1c1c1',
        confirmButtonText: '사용',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            // 사용자가 "사용"을 선택한 경우 음성 검색 실행
            startRecognition()
        }
    })
}

// 초기 플레이스 홀더 설정
searchInput.placeholder = '증상 또는 병명을 입력해주세요'  // 기본값

// 스위치 상태에 따라 플레이스 홀더 및 name 속성 변경
searchTypeSelect.addEventListener('change', function() {
    if (this.value !== 'hospital') {
        // 증상 검색 선택 시
        searchInput.placeholder = '증상 또는 병명을 입력해주세요'
        searchInput.name = 'search'  // 증상 검색
    }
})


// 검색 핸들러
async function searchHandler(event) {
    event.preventDefault()
    const formData = new FormData(event.target)
    const query = searchInput.value // 입력된 검색어를 저장
    localStorage.setItem('lastSearch', query) // 검색어를 localStorage에 저장
    const url = searchTypeSelect.value === 'hospital' ? cpath + '/hospitals/searchs/names' :  cpath + '/hospitals/searchs';
    const opt = {
        method: 'POST',
        body: formData
    }
    const result = await fetch(url, opt).then(response => response.json());

    if (result.noSearch) {
        swal({
            title: '알림',
            text: '검색결과가 없습니다. 검색어를 조건에 맞게 검색하세요',
            type: 'info',
            button: '확인'
        })
    } else {
        if (searchTypeSelect.value === 'hospital') {
            // 병원명 검색인 경우 모달 열기
            openMapModal(result.hospitals)
        } else {
            // 다른 페이지로 이동 (증상 검색의 경우)
            window.location.reload()
        }
    }
}