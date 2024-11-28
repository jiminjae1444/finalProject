/**
 * 사용자 위치 정보를 기반으로 지도 및 병원 정보를 초기화하는 함수
 */
async function loadHandler() {
    const lastSearch = localStorage.getItem('lastSearch') // 저장된 검색어 가져오기
    if (lastSearch) {
        searchInput.value = lastSearch // 검색어를 입력 필드에 복원
    }
    // 로그인 사용자 위치 정보가 있는지 확인
    const userLocation = await getUserLocation() // 사용자 정보에서 위치 가져오기
    if (userLocation) {
        // 사용자에게 주소 기반으로 위치를 사용할지 물어봄
        const useStoredLocation = await Swal.fire({
            title: "위치 설정",
            text: "로그인된 사용자 주소를 기반으로 위치를 설정하시겠습니까?",
            icon: "question",
            showCancelButton: true,
            confirmButtonColor: '#9cd2f1',
            cancelButtonColor: '#c1c1c1',
            confirmButtonText: "네",
            cancelButtonText: "아니요"
        })

        if (useStoredLocation.isConfirmed) {
            // 사용자의 주소를 좌표로 변환
            const { lat, lng } = await addressToCoordinates(userLocation)
            sessionStorage.setItem("userLat", lat);
            sessionStorage.setItem("userLng", lng);
            loadMapHandler(lat, lng) // 지도 초기화
            getHospitalListHandler(lat, lng) // 병원 리스트 불러오기
            return
        }
    } else {
        // 사용자 위치 정보가 없는 경우 로그인 여부를 확인
        const goToLogin = await Swal.fire({
            title: "주소 사용시 로그인이 필요",
            text: "로그인을 하시겠습니까?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: '#9cd2f1',
            cancelButtonColor: '#c1c1c1',
            confirmButtonText: "예",
            cancelButtonText: "아니요"
        })

        if (goToLogin.isConfirmed) {
            // 로그인 페이지로 이동
            let currentPageUrl = window.location.href
            window.location.href = cpath + '/member/login?redirectUrl=' + encodeURIComponent(currentPageUrl) // 로그인 페이지의 URL을 여기에 입력
        }
    }

    // 사용자 주소를 사용하지 않거나 사용자 주소가 없는 경우 geolocation 사용 여부 확인
    if (navigator.geolocation) {
        const useGeolocation = await Swal.fire({
            title: "위치 설정",
            text: "사용자의 현재 위치 정보를 사용하시겠습니까?",
            icon: "question",
            showCancelButton: true,
            confirmButtonColor: '#9cd2f1',
            cancelButtonColor: '#c1c1c1',
            confirmButtonText: "네",
            cancelButtonText: "아니요"
        })

        if (useGeolocation.isConfirmed) {
            navigator.geolocation.getCurrentPosition(success, error)  //현재위치의 좌표

        } else {
            Swal.fire({
                title: "기본 위치 사용",
                text: "기본 위치로 설정합니다.",
                icon: "info",
                confirmButtonText: "확인",
                confirmButtonColor: '#9cd2f1'
            })
            loadMapHandler(33.450701, 126.570667) // 기본 위치로 지도 초기화
        }
    } else {
        Swal.fire({
            title: "오류",
            text: "위치 정보를 사용할 수 없습니다. 기본 위치를 사용합니다.",
            icon: "error",
            confirmButtonText: "확인",
            confirmButtonColor: '#9cd2f1'
        })
        loadMapHandler(33.450701, 126.570667) // 기본 위치로 지도 초기화
    }
}

/**
 * 위치 정보 가져오기 성공 시 호출
 */
function success(position) {
    const lat = position.coords.latitude
    const lng = position.coords.longitude
    loadMapHandler(lat, lng) // 지도 초기화
    getHospitalListHandler(lat, lng) // 병원 리스트 불러오기
}

/**
 * 위치 정보 가져오기 실패 시 호출
 */
function error() {
    alert("위치 정보를 가져오는데 실패했습니다.")
    loadMapHandler(33.450701, 126.570667) // 기본 위치로 지도 초기화
}

/**
 * 지도를 초기화하는 함수
 */
function loadMapHandler(lat, lng) {
    const mapContainer = document.getElementById('map')
    const mapOption = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 4
    }
    map = new kakao.maps.Map(mapContainer, mapOption)
}

/**
 * 병원 리스트를 필터링하여 거리 기준으로 반환하는 함수
 */
function calculateDistance(hospitalList, lat, lng) {
    const currentLocation = { latitude: lat, longitude: lng } // 현재 위치

    const hospitalDistance = hospitalList
        .map(hospital => {
            if (hospital.lat == null || hospital.lng == null) return null // 유효하지 않은 병원 제외

            const hospitalLocation = { latitude: hospital.lat, longitude: hospital.lng }
            const distance = getDistance(currentLocation, hospitalLocation) // 거리 계산 (미터)
            return { ...hospital, distance: distance / 1000 } // km로 변환
        })
        .filter(Boolean)
        .filter(hospital => hospital.distance <= 20) // 20km 이하의 병원만
        .sort((a, b) => a.distance - b.distance) // 거리 순 정렬(다른 필드를 이용해서 기준을 바꿀수 있음)

    return hospitalDistance.slice(0, Math.min(hospitalDistance.length, 30)) // 최대 30개
}

/**
 * 사용자 위치 정보를 가져오는 함수 (로그인 정보 기반)
 */
async function getUserLocation() {
    return userLocation || null
}

/**
 * 주소를 좌표로 변환하는 함수
 */
async function addressToCoordinates(address) {
    return new Promise((resolve, reject) => {
        const geocoder = new kakao.maps.services.Geocoder()
        geocoder.addressSearch(address, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const lat = parseFloat(result[0].y)
                const lng = parseFloat(result[0].x)
                resolve({ lat, lng })
            } else {
                reject(new Error('주소를 좌표로 변환하는데 실패했습니다.'))
            }
        })
    })
}

async function getHospitalListHandler(lat,lng){
    const url = cpath + '/hospitals/hospitalLists'
    const response = await fetch(url)
    if (response.ok){
        const hospitalList = await response.json() // JSON 파싱
        // console.log(hospitalList) // 리스트 출력
        const nearHospitals = calculateDistance(hospitalList,lat,lng)
        // console.log(nearHospitals) //14개

        // 마커 추가
        addCurrentLocationMarker(lat, lng) // 현재 위치 마커 추가
        addHospitalMarkers(nearHospitals) // 병원 마커 추가
    } else {
//             console.error('데이터를 가져오는 데 실패했습니다.')
    }
}
// 현재 위치 마커 추가
function addCurrentLocationMarker(lat, lng) {
    const currentPosition = new kakao.maps.LatLng(lat, lng)
    const marker = addMarker(map, currentPosition, 'red') // 빨간색 마커 추가

    const infoWindowContentSelf = document.createElement('div')
    infoWindowContentSelf.className = 'infoWindowContentSelf'
    infoWindowContentSelf.innerHTML = '현재 나의 위치'
    const overlay = new kakao.maps.InfoWindow({
        content: infoWindowContentSelf,
        removable: true
    });

    // 마커 클릭 이벤트
    kakao.maps.event.addListener(marker, 'click', function() {
        overlay.setPosition(currentPosition)
        overlay.setMap(map)
    });
}

async function getHospitalImageAndDetails(id, infoWindowContent, position) {
    if (hospitalImageCache[id]) {
//             console.log("이미 이미지 요청이 완료된 병원입니다.")
        return  // 이미지가 이미 요청되었으면 아무 작업도 하지 않고 종료
    }

    // 병원 이미지 요청 상태를 true로 설정 (요청 중)
    hospitalImageCache[id] = true
    // infoWindowContent에 이미지가 이미 존재하는지 확인

    const loadingImage = document.createElement('img')
    loadingImage.src = cpath + '/resources/image/point.gif' // 로딩 이미지 경로
    loadingImage.alt = '로딩 중...'
    loadingImage.style.position = 'absolute'  // 절대 위치
    loadingImage.style.top = '50%'           // 세로 중앙
    loadingImage.style.left = '50%'          // 가로 중앙
    loadingImage.style.transform = 'translate(-50%, -50%)' // 가운데 정렬
    loadingImage.style.width = '100%'         // 인포윈도우 크기에 맞게 확장
    loadingImage.style.height = '100%'        // 인포윈도우 크기에 맞게 확장
    infoWindowContent.appendChild(loadingImage)  // 인포윈도우에 로딩 이미지 추가

    const url = cpath + '/hospitals/getHospitalImage'
    const opt = {
        method: 'POST',
        body: JSON.stringify({id: id}),
        headers: {
            'Content-Type': 'application/json'
        }
    }
    const result = await fetch(url, opt).then(resp => resp.json())
    // console.log(result)
    // 기본 이미지 URL
    const defaultImageUrl = cpath + '/resources/image/default_hospital.png'

    // 이미지 URL이 비어 있으면 기본 이미지 사용
    const imageUrl = result.imageUrl ? result.imageUrl : defaultImageUrl
    if (imageUrl) {
        loadingImage.remove()
        const imgElement = document.createElement('img')
        imgElement.src = imageUrl
        imgElement.alt = '병원 이미지'
        infoWindowContent.insertBefore(imgElement, infoWindowContent.firstChild)  // 이미지 추가
    }
}

// 병원 마커 추가
function addHospitalMarkers(hospitals) {
    const placeList = document.getElementById('placeList')
    hospitals.forEach(hospital => {
        const position = new kakao.maps.LatLng(hospital.lat, hospital.lng)
        const marker = addMarker(map, position, 'blue') // 파란색 마커 추가

        // 오버레이 내용 생성
        const infoWindowContent = document.createElement('div')
        infoWindowContent.className ='infoWindowCard'

        // 병원 이름을 링크로 만들기
        const hospitalNameLink = document.createElement('a')
        hospitalNameLink.href = cpath + '/hospitalInfo/' + hospital.id
        hospitalNameLink.innerText = hospital.hospital_name // 병원 이름 설정

        // 링크 클릭 시 새 페이지 열기
        hospitalNameLink.addEventListener('click', function(event) {
            event.preventDefault() // 기본 링크 동작 방지 (필요시)
            window.location.href = hospitalNameLink.href // 페이지 이동
        });

        // 거리와 전화번호 추가
        const distanceText = document.createElement('div')
        distanceText.innerText = '거리: ' + (hospital.distance).toFixed(2) * 1000 + 'm'  //m로 할지 km할지ㅋ
        distanceText.classList.add('infoDistance')
        const telText = document.createElement('div')
        telText.innerText = 'TEL: ' + hospital.tel
        telText.classList.add('infoTel')
        const homepageText = document.createElement('a')
        // 홈페이지가 존재하는 경우에만 href를 설정
        if (hospital.homepage) {
            homepageText.href = hospital.homepage
            homepageText.innerText = '홈페이지: ' + hospital.homepage
        } else {
            homepageText.innerText = '홈페이지: 없음'
        }
        homepageText.classList.add('infoHomepage')
        // 병원 클릭 시 서버에서 이미지 및 정보를 받아오기
        kakao.maps.event.addListener(marker, 'click', function() {
            getHospitalImageAndDetails(hospital.id, infoWindowContent, position)
        })

        // InfoWindow에 내용 추가
        infoWindowContent.appendChild(hospitalNameLink)
        infoWindowContent.appendChild(distanceText)
        infoWindowContent.appendChild(telText)
        infoWindowContent.appendChild(homepageText)

        const overlay = new kakao.maps.InfoWindow({
            content: infoWindowContent,
            removable: true
        })

        // 마커 클릭 시 오버레이 표시
        kakao.maps.event.addListener(marker, 'click', function() {
            overlay.setPosition(position)
            overlay.setMap(map)
        })
    })
}

// 지도의 마커를 설정하는 함수
function addMarker(map, position, color) {
    const markerImageSrc = color === 'red' ? cpath + '/resources/image/MarkerMee.png' : cpath + '/resources/image/3333.png' // 마커 이미지 경로 설정
    const markerImage = new kakao.maps.MarkerImage(markerImageSrc, new kakao.maps.Size(30, 30)) // 마커 크기 설정
    const marker = new kakao.maps.Marker({
        position: position,
        image: markerImage
    })
    marker.setMap(map)
    return marker // 마커 객체를 반환
}

