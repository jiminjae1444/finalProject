function loadViewHandler() {
// 카카오 지도 API Geocoder 인스턴스 생성
    const geocoder = new kakao.maps.services.Geocoder()

// 서버에서 받아온 병원 주소
    const splitAddress = address.split(' ')
    address = splitAddress.slice(0, 4).join(' ')

// 주소를 좌표로 변환
    geocoder.addressSearch(address, function (result, status) {
        if (status === kakao.maps.services.Status.OK) {
            const lat = result[0].y // 위도
            const lng = result[0].x // 경도
            const coords = new kakao.maps.LatLng(lat, lng) // 카카오 지도에 사용할 좌표 객체

// 지도 컨테이너와 기본 옵션 설정
            const mapContainer = document.getElementById('DynamicMap') // 지도 표시할 HTML 요소
            const mapOptions = {
                center: coords, // 지도의 중심 좌표 설정
                level: 2, // 지도 확대/축소 레벨 설정 (1: 가장 축소, 15: 가장 확대)
            }

// 카카오 지도 객체 생성
            const map = new kakao.maps.Map(mapContainer, mapOptions)

// 병원 위치에 마커 생성
            const marker = new kakao.maps.Marker({
                position: coords, // 마커의 위치 설정
            })
            marker.setMap(map) // 지도에 마커 추가

// 병원 이름을 표시할 인포윈도우 생성
            const infowindow = new kakao.maps.InfoWindow({
                content: '<div class="hospital-info-window">' + hospital_name + '</div>',
            })

// 지도 로드 시 바로 인포윈도우 표시
            infowindow.open(map, marker) // 마커 위에 바로 인포윈도우 표시
        } else {
// 주소 검색 실패 시 오류 메시지
            swal({
                title: '오류 발생',
                text: '주소를 찾을 수 없습니다.',
                type: 'error', // 오류에 맞는 아이콘 선택
                button: "확인"
            })
        }
    })
}

function openRouteModal() {
    const modal = document.getElementById("routeModal")
    modal.style.display = "block"  // 모달 표시
    // console.log("모달이 열렸습니다.")
    getUserLocationAndDirections()
}

function closeRouteModal() {
    const modal = document.getElementById('routeModal')
    modal.style.display = 'none'  // 모달 숨기기
    // console.log("모달이 닫혔습니다.")
    document.getElementById('routeInfo').innerHTML = ''
}

async function getUserLocationAndDirections() {
    // 사용자에게 "주소 사용" 또는 "현재 위치 사용"을 물어보는 팝업
    const userChoice = await Swal.fire({
        title: "위치 설정",
        text: "주소를 사용하시겠습니까? 아니면 현재 위치를 사용하시겠습니까?",
        icon: "question",
        showCancelButton: true,
        confirmButtonText: "주소 사용",
        cancelButtonText: "현재 위치 사용",
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#c1c1c1',
    })

    // "주소 사용"을 선택했을 때
    if (userChoice.isConfirmed) {
        useLoginLocation()// 로그인된 주소로 위치 정보 변환 및 경로 찾기
    }
    // "현재 위치 사용"을 선택했을 때
    else {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var userLat = position.coords.latitude
                var userLng = position.coords.longitude


                getDirections(userLat, userLng, hospitalLat, hospitalLng); // 경로 찾기
            }, function(error) {
                Swal.fire({
                    title: "위치 오류",
                    text: "위치 정보를 가져오는데 실패했습니다.",
                    icon: "error",
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: "확인"
                })
            })
        } else {
            Swal.fire({
                title: "오류",
                text: "Geolocation을 지원하지 않는 브라우저입니다.",
                icon: "error",
                confirmButtonColor: '#3085d6',
                confirmButtonText: "확인"
            })
        }
    }
}

// 로그인된 사용자 주소를 사용하는 함수
function useLoginLocation() {
    if (userLocation) {  // 사용자 주소가 있을 때
        var loginAddress = userLocation // 로그인된 사용자 주소
        convertAddressToCoordinates(loginAddress, function(result) {
            if (result) {
                var userLat = result.y
                var userLng = result.x

//                     console.log("사용자 주소 위치:", userLat, userLng); // 주소에서 가져온 사용자 위치
//                     console.log("병원 위치:", hospitalLat, hospitalLng); // 병원 위치 확인

                getDirections(userLat, userLng, hospitalLat, hospitalLng); // 경로 찾기
            } else {
                Swal.fire({
                    title: "오류",
                    text: "주소를 좌표로 변환할 수 없습니다.",
                    icon: "error",
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: "확인"
                })
            }
        })
    } else {
        // 로그인 되어 있지 않은 경우, 로그인 페이지로 이동
        Swal.fire({
            title: "로그인 필요",
            text: "주소를 사용하려면 로그인해야 합니다.",
            icon: "warning",
            confirmButtonColor: '#3085d6',
            confirmButtonText: "로그인",
        }).then((result) => {
            if (result.isConfirmed) {
                const currentPageUrl = window.location.href
                window.location.href = cpath + '/member/login?redirectUrl=' + encodeURIComponent(currentPageUrl) // 로그인 페이지로 리다이렉션
            }
        })
    }
}

// 주소를 좌표로 변환하는 함수
function convertAddressToCoordinates(address, callback) {
    var geocoder = new kakao.maps.services.Geocoder()

    geocoder.addressSearch(address, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            callback(result[0]);
        } else {
            callback(null)
        }
    })
}

async function getDirections(startY, startX, endY, endX) {
    const url = cpath + '/hospitals/routes' // 경로 API 호출 URL
    const requestBody = { startY, startX, endY, endX }

    const options = {
        method: 'POST',
        body: JSON.stringify(requestBody),
        headers: { 'Content-Type': 'application/json' }
    }

    try {
        const result = await fetch(url, options).then(resp=>resp.json())
        const itineraries = result.itineraries
        displayRoute(itineraries)
    } catch (error) {
        await closeRouteModal()
//             console.error("경로 API 호출 중 오류:", error)
        swal({
            title: '오류',
            text: '예기치 못한 오류가 발생했습니다',
            type: 'error',
            confirmButtonColor: '#3085d6',
            button: "확인"
        })
    }
}

function displayRoute(itineraries) {
    const routeInfoDiv = document.getElementById('routeInfo')

    if (itineraries && Array.isArray(itineraries)) {
        let routeHtml = '<ul>'

        itineraries.forEach((itinerary, index) => {
            routeHtml += '<li id="routeTitle"><strong>추천 경로' + (index + 1) + '</strong>'

            // 총 소요 시간 및 거리
            routeHtml += '<p class="total-info"><strong>총 소요 시간:</strong> ' + Math.floor(itinerary.totalTime / 60) + '분</p>'
            routeHtml += '<p class="total-info"><strong>총 거리:</strong> ' + (itinerary.totalDistance / 1000).toFixed(2) + 'km</p>'

            // 요금 정보 (존재하는 경우에만)
            if (itinerary.fare && itinerary.fare.regular) {
                routeHtml += '<p class="total-info"><strong>총 요금:</strong> ' + itinerary.fare.regular.currency.symbol + itinerary.fare.regular.totalFare + '원</p>'
            }

            // 각 구간(legs) 정보
            routeHtml += '<ol class="leg-list">'
            itinerary.legs.forEach((leg, legIndex) => {
                routeHtml += '<li class="leg-item ' + leg.mode.toLowerCase() + '"><strong>' + (legIndex + 1) + '번째</strong> '

                // 구간 출발지와 도착지
                if (leg.start && leg.start.name) {
                    routeHtml += '<p class="leg-info"><strong>출발지:</strong> ' + leg.start.name + '</p>'
                }
                if (leg.end && leg.end.name) {
                    routeHtml += '<p class="leg-info"><strong>도착지:</strong> ' + leg.end.name + '</p>'
                }

                // 이동 방법 스타일 적용
                routeHtml += '<p class="leg-mode"><strong>이동 방법:</strong> '
                switch (leg.mode) {
                    case 'WALK':
                        routeHtml += '도보 (' + Math.floor(leg.sectionTime / 60) + '분, ' + leg.distance + 'm)</p>'
                        break
                    case 'BUS':
                        routeHtml += leg.route  + '번 버스 (' + Math.floor(leg.sectionTime / 60) + '분)</p>'
                        break
                    case 'SUBWAY':
                        routeHtml += leg.route + ' 지하철 (' + Math.floor(leg.sectionTime / 60) + '분)</p>'
                        break
                    default:
                        routeHtml += '비행기 외 기타</p>'
                        break
                }

                // 각 구간의 상세 이동 단계 (steps)
                if (leg.steps && leg.steps.length > 0) {
                    routeHtml += '<ul class="step-list">'
                    leg.steps.forEach(step => {
                        routeHtml += '<li><strong>' + (step.streetName || '도로명 없음') + ':</strong> ' + step.description + ' (' + step.distance + 'm)</li>'
                    });
                    routeHtml += '</ul>'
                }

                routeHtml += '</li>'
            })
            routeHtml += '</ol>'
            routeHtml += '</li>'
        })

        routeHtml += '</ul>'
        routeInfoDiv.innerHTML = routeHtml
    } else {
        Swal.fire({
            title: "경로 찾기 실패",
            text: "경로를 찾을 수 없습니다.",
            icon: "error",
            confirmButtonColor: '#3085d6',
            confirmButtonText: "확인"
        })
    }
}


// 예약시간이 30분 남았을때 알림테이블에 넣고 그 알림 메일을 보내는 함수
async function notificationBookingOneDay(){
    const url = cpath + '/notificationBookingOneDay/' + member_id + '/' + hospital_id
    const opt = {
        method : 'GET'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    if(result == 1) sendNotificationMail()
}

// 예약시간까지 남은 시간을 실시간으로 보여주는 함수
function updateBookingTimer(booking_date) {
    let now = new Date().getTime()
    let difference = booking_date - now
    if (difference > 0) {
        let years = Math.floor(difference / (1000 * 60 * 60 * 24 * 365))
        let months = Math.floor((difference % (1000 * 60 * 60 * 24 * 365)) / (1000 * 60 * 60 * 24 * 30))
        let days = Math.floor((difference % (1000 * 60 * 60 * 24 * 30)) / (1000 * 60 * 60 * 24))
        let hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
        let minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60))
        let seconds = Math.floor((difference % (1000 * 60)) / 1000)
        let timerText = "예약시간 " + formatDate(booking_date) + "까지 " + (years == 0 ? '' : years + "년 ") + (months == 0 ? '' : months + "월 ")
            + (days == 0 ? '' : days + "일 ") + (hours == 0 ? '' : hours + "시간 ") + (minutes == 0 ? '' : minutes + "분 ") + (seconds == 0 ? '남음' : seconds + "초 남음");
        document.getElementById("timeDiff").innerHTML = timerText

        // 시간차이가 30분이되면 자동으로 알림을 띄우고 메일을 보냄
        if(difference < 86400500 && difference > 86399500) {
            Swal.fire({
                title: '예약 알림',
                text: '예약이 하루 남았습니다.',
                icon: 'info',
                confirmButtonText: '확인',
                confirmButtonColor: '#9cd2f1',
                allowOutsideClick: false,
                allowEscapeKey: false,
                showCloseButton: false
            }).then((result) => {if(result.isConfirmed) notificationBookingOneDay()})
        }
    }

    // 예약시간에 도달하면 자동으로 알림의 띄우고 메일을 보냄
    else {
        document.getElementById("timeDiff").innerHTML = '예약시간 만료'
        clearInterval(bookingTimerInterval)
        bookingTimeOver()
    }
}

// 입력폼을 모달에 띄우는 함수
function readyToBook(event) {
    event.preventDefault()
    bookingInsertForm.classList.remove('hidden')
    openBookingModal('예약하기', bookingInsertForm)
}

// 변경폼을 모달에 띄우는 함수
function readyToUpdateBooking(event) {
    event.preventDefault()
    bookingUpdateForm.classList.remove('hidden')
    openBookingModal('예약 변경하기', bookingUpdateForm)
}

// 알림테이블에 어떤 정보가 추가되면 그 정보를 메일로 보내는 함수
async function sendNotificationMail(){
    const url = cpath + '/sendNotificationMail'
    const opt = {
        method : 'POST'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    location.reload()
}

// 예약한 정보를 알림테이블에 추가하고 메일로 보내는 함수
async function notificationBooking(){
    const url = cpath + '/notificationBooking/' + member_id + '/' + hospital_id
    const opt = {
        method : 'POST'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    if(result == 1) sendNotificationMail()

}

// 예약 변경한 정보를 알림테이블에 추가하고 메일로 보내는 함수
async function notificationBookingUpdate(){
    const url = cpath + '/notificationBookingUpdate/' + member_id + '/' + hospital_id
    const opt = {
        method : 'POST'
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    if(result == 1) sendNotificationMail()
}

async function bookingInsert() {
    if (!login) {
        const confirmResult = await Swal.fire({
            title: '로그인 필요',
            text: '예약을 진행하시려면 로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#9cd2f1',
            cancelButtonColor: '#c1c1c1',
            confirmButtonText: '예, 로그인하러 가기',
            cancelButtonText: '아니오'
        })

        if (confirmResult.isConfirmed) {
            // 로그인 페이지로 리디렉션
            const currentPageUrl = window.location.href
            window.location.href = cpath + '/member/login?redirectUrl=' + encodeURIComponent(currentPageUrl) // 로그인 페이지로 리다이렉션
        }
        return
    }

    const url = cpath + '/bookingInsert'
    const formData = new FormData(bookingInsertForm)
    const data = {}
    formData.forEach((value, key) => {
        data[key] = value
    })

    const bookingTime = new Date(data.booking_date).getTime()
    const now = new Date().getTime()
    const timeDifference = bookingTime - now
    const thirtyMinutesInMillis = 30 * 60 * 1000

    // 예약시간이 지금시간보다  30분 전이면 빠꾸먹임
    if (timeDifference <= 0) {
        const confirmResult = await Swal.fire({
            title: '예약 실패',
            text: '이미 지난 시간대입니다. 다시 선택해주세요.',
            icon: 'error',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1' // 확인 버튼 색상
        })
        if (confirmResult.isConfirmed) {
            return
        }
    }

    // 예약시간이 지금보다 30분 이내일 경우 추가 확인
    else if (timeDifference <= thirtyMinutesInMillis) {
        const confirmResult = await Swal.fire({
            title: '주의',
            text: '예약 시간이 30분 이내입니다. 정말로 예약하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#9cd2f1',
            cancelButtonColor: '#c1c1c1',
            confirmButtonText: '예, 예약합니다',
            cancelButtonText: '아니오'
        })

        if (!confirmResult.isConfirmed) {
            return
        }
    }

    const opt = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    }
    const result = await fetch(url, opt).then(resp => resp.json())

    // 예약에 성공하면 그 정보를 알림테이블에 추가하고 메일로 보냄
    if (result == 1) {
        Swal.fire({
            title: '예약 완료',
            text: '예약이 완료되었습니다.',
            icon: 'success',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        }).then((result) => {
            if (result.isConfirmed) {
                notificationBooking()
            }
        })
    } else if (result == 2) {
        Swal.fire({
            title: '예약 실패',
            text: '진료시간이 아닙니다. 다시 선택해주세요.',
            icon: 'error',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        })
    } else if (result == 3) {
        Swal.fire({
            title: '예약 불가',
            text: '해당 병원은 예약 불가능합니다.',
            icon: 'info',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        })
    } else {
        Swal.fire({
            title: '예약 실패',
            text: '알 수 없는 이유로 예약에 실패하였습니다.',
            icon: 'error',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        })
    }
}

// 예약 취소하는 함수
async function bookingCancel(){
    const url = cpath + '/bookingCancel/' + member_id + '/' + hospital_id
    const opt = {
        method : 'PATCH'
    }
    const result = await fetch(url, opt).then(resp => resp.json())

    // 예약 취소에 성공하면 그 내용을 알림테이블에 추가하고 메일로 보냄
    if(result == 1) {
        Swal.fire({
            title: '예약 취소 완료',
            text: '예약이 취소되었습니다.',
            icon: 'success',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        }).then((result) => {if(result.isConfirmed) sendNotificationMail()})
    }

    // 예외 상황 대처
    else Swal.fire({
        title: '예약 취소 실패',
        text: '알 수 없는 이유로 예약 취소에 실패하였습니다.',
        icon: 'error',
        confirmButtonText: '확인',
        allowOutsideClick: false,
        allowEscapeKey: false,
        showCloseButton: false,
        confirmButtonColor: '#9cd2f1'
    })
}

// 예약 변경하는 함수
async function bookingUpdate(){
    const url = cpath + '/bookingUpdate'
    const formData = new FormData(bookingUpdateForm)

    const bookingDate1 = formData.get('booking_date')
    const bookingDate2 = '${booking_date}'
    const date1 = new Date(bookingDate1)
    const date2 = new Date(bookingDate2.replace(' ', 'T'))
    const oldTimeDifference = parseInt(Math.abs(date1 - date2))
//         console.log(Math.abs(oldTimeDifference))
    const data = {}
    formData.forEach((value, key) => {
        data[key] = value
    })
    const bookingTime = new Date(data.booking_date).getTime()
    const now = new Date().getTime()
    const timeDifference = bookingTime - now
    const thirtyMinutesInMillis = 30 * 60 * 1000

    // 예약시간이 지금시간보다 이전이면 빠꾸먹임
    if(timeDifference <= 0){
        const confirmResult = await Swal.fire({
            title: '예약 변경 실패',
            text: '이미 지난 시간대입니다. 다시 선택해주세요.',
            icon: 'error',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        })
        if (confirmResult.isConfirmed) {
            return
        }
    }

    // 예약시간이 지금보다 30분 이내일 경우 추가 확인
    else if (timeDifference <= thirtyMinutesInMillis) {
        const confirmResult = await Swal.fire({
            title: '주의',
            text: '변경 시 예약시간이 30분 이내입니다. 정말로 예약을 변경하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#9cd2f1',
            cancelButtonColor: '#c1c1c1',
            confirmButtonText: '예, 변경합니다',
            cancelButtonText: '아니오'
        })
        if (!confirmResult.isConfirmed) {
            return
        }
    }
    // 예약시간이 변경 전 예약시간에서 1시간 이상 차이 안나면 빠꾸
    else if (oldTimeDifference < 60 * 60 * 1000) {
        const confirmResult = await Swal.fire({
            title: '예약 변경 실패',
            text: '예약시간이 변경 전 예약시간과 1시간 이상 차이나야 합니다.',
            icon: 'error',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        })
        if (confirmResult.isConfirmed) {
            return
        }
    }
    const opt = {
        method : 'PATCH',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    }
    const result = await fetch(url, opt).then(resp => resp.json())

    // 예약 변경에 성공하면 그 내용을 알림테이블에 추가하고 메일로 보냄
    if(result == 1) {
        Swal.fire({
            title: '예약 변경 완료',
            text: '예약이 변경되었습니다.',
            icon: 'success',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        }).then((result) => {if(result.isConfirmed) notificationBookingUpdate()})

    }
    else if(result == 2) Swal.fire({
        title: '예약 변경 실패',
        text: '진료시간이 아닙니다. 다시 선택해주세요.',
        icon: 'error',
        confirmButtonText: '확인',
        allowOutsideClick: false,
        allowEscapeKey: false,
        showCloseButton: false,
        confirmButtonColor: '#9cd2f1'
    })

    // 예외 상황 처리
    else Swal.fire({
            title: '예약 변경 실패',
            text: '알 수 없는 이유로 예약 변경에 실패하였습니다.',
            icon: 'error',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        })

}
// 예약한 시간에 도달하면 기간 만료처리하는 함수
async function bookingTimeOver(){
    const url = cpath + '/bookingTimeOver/' + member_id + '/' + hospital_id
    const opt = {
        method : 'PATCH'
    }
    const result = await fetch(url, opt).then(resp => resp.json())

    // 예약시간 만료처리에 성공하면그 내용을 알림테이블에 추가하고 메일로 보냄
    if(result == 1) {
        Swal.fire({
            title: '예약 시간',
            text: '예약한 시간이 되었습니다!!',
            icon: 'info',
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showCloseButton: false,
            confirmButtonColor: '#9cd2f1'
        }).then((result) => {if(result.isConfirmed) sendNotificationMail()})
    }

    // 예외 상황 처리
    else alert('시간 처리 안됨')
}

//결제 취소
function addCancelPaymentListener(paymentData = null) {
    cancelPaymentBtn.onclick = async () => {
        const confirmCancel = await Swal.fire({
            title: '결제 취소',
            text: '결제를 취소하시겠습니까?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: '네',
            cancelButtonText: '아니오',
            confirmButtonColor: '#9cd2f1',
            cancelButtonColor: '#c1c1c1'
        })
        if (confirmCancel.isConfirmed) {
            // paymentData가 null이면 sessionStorage에서 가져옴
            const storedPaymentData = paymentData || JSON.parse(sessionStorage.getItem('paymentData'));
            if (storedPaymentData) {
//                        console.log('결제 취소:', storedPaymentData.merchant_uid)
                // 서버에 취소 요청 보내기
                const cancelUrl = cpath + '/cancelPayment'
                const response = await fetch(cancelUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        merchant_uid: storedPaymentData.merchant_uid // 결제 데이터에 있는 고유 주문 번호 전달
                    })
                })

                const result = await response.json()

                if (result.success) {
                    await Swal.fire({
                        title: '결제 취소 성공',
                        text: '결제가 성공적으로 취소되었습니다.',
                        icon: 'success',
                        confirmButtonText: '확인',
                        confirmButtonColor: '#9cd2f1'
                    })
                    // 결제 취소 상태를 로컬 저장소에 기록
                    sessionStorage.setItem('paymentStatus', 'cancelled')

                    // 결제 취소 후 버튼 상태 변경
                    cancelPaymentBtn.style.display = 'none'// 결제 취소 버튼 숨기기
                    paymentBtn.style.display = 'inline-block' // 결제 버튼 다시 보이기
                } else {
                    Swal.fire({
                        title: '결제 취소 실패',
                        text: '결제 취소가 실패하였습니다. 사유: ' + result.message,
                        icon: 'error',
                        confirmButtonText: '확인',
                        confirmButtonColor: '#9cd2f1'
                    })
                }
            } else {
                Swal.fire({
                    title: '결제 데이터 없음',
                    text: '결제 데이터가 존재하지 않습니다.',
                    icon: 'warning',
                    confirmButtonText: '확인',
                    confirmButtonColor: '#9cd2f1'
                })
            }
        }
    }
}