//예약 상태 숫자를 문자열로 변환하는 함수
function getStatusText(status) {
    switch (status) {
        case 1:
            return "예약 완료"
        case 0:
            return "예약 취소"
        case -1:
            return "완료된 예약"
        default:
            return "알 수 없음"
    }
}

// 예약 상태를 변환하고 색상 변경하는 함수
function updateBookingStatus() {
    // 모든 테이블 행을 가져오기
    const rows = document.querySelectorAll("tbody tr")
    rows.forEach(row => {
        // 현재 행에서 상태 열(td)의 내용을 가져오기
        const statusCell = row.querySelector("td:last-child")
        const statusValue = parseInt(statusCell.textContent.trim(), 10) // 숫자로 변환
        const statusText = getStatusText(statusValue) // 변환된 문자열

        // 상태 텍스트 업데이트
        statusCell.textContent = statusText

        // 색상 변경 로직
        if (statusValue === 1) {
            // 예약 완료 상태: rgba(0, 0, 0, 0.3)
            row.style.backgroundColor = '#ffffff'
        } else if (statusValue === 0) {
            // 예약 취소 상태: 빨간색
            row.style.backgroundColor = '#ffebee'
        } else if (statusValue === -1) {
            // 완료된 예약 상태: 녹색
            row.style.backgroundColor = '#d5f7d5'
        } else {
            // 기본 색상: 흰색 (알 수 없는 상태)
            row.style.backgroundColor = '#fff3e0'
        }
    })
}