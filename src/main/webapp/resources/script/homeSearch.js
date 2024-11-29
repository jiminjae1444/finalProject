






function displayHospitalList(hospitals) {
    hospitalList.innerHTML = ''; // 이전 결과 초기화
    hospitals.forEach(hospital => {
        const listItem = document.createElement('li')
        listItem.innerText = hospital.hospital_name + '(' +hospital.address.substring(0,2) + ')' // 병원명 표시

        // 리스트 항목 클릭 시 맵 중심 이동 및 인포윈도우 표시
        listItem.addEventListener('click', () => {
            // 클릭된 리스트 항목에 'selected' 클래스 추가
            const selectedItem = document.querySelector('.hospital-list .selected')
            if (selectedItem) {
                selectedItem.classList.remove('selected')
            }
            listItem.classList.add('selected') // 클릭된 항목에 'selected' 클래스 추가
            const markerPosition = new kakao.maps.LatLng(hospital.lat, hospital.lng)
            map.setCenter(markerPosition) // 맵 중심 이동
            map.setLevel(3) // 줌 레벨을 6으로 설정 (더 크게 보이도록)
            const marker = new kakao.maps.Marker({
                position: markerPosition,
                map: map, // 기존 맵 변수 사용
                image: markerImage
            });
            markers.forEach(m => m.setMap(null)) // 기존 마커 숨기기
            markers = [marker] // 현재 마커로 배열 초기화
            // 인포윈도우 내용 생성
            const infoMapListContent = document.createElement('div');
            infoMapListContent.classList.add('infoMapListContent'); // 클래스 추가

            // 병원 이름을 <a> 태그로 만들기
            const hospitalNameLink = document.createElement('a');
            hospitalNameLink.href = '${cpath}/hospitalInfo/' + hospital.id; // 병원 상세 페이지로 링크
            hospitalNameLink.target = '_blank'; // 새 탭에서 열기
            hospitalNameLink.classList.add('hospitalNameLink'); // 클래스 추가
            hospitalNameLink.innerText = hospital.hospital_name;

            // 주소와 전화번호 정보 추가
            const addressText = document.createElement('div');
            addressText.classList.add('hospitalAddress'); // 클래스 추가
            addressText.innerHTML = '<strong>주소:</strong> ' + hospital.address;

            const telText = document.createElement('div');
            telText.classList.add('hospitalPhone'); // 클래스 추가
            telText.innerHTML = '<strong>전화번호:</strong> ' + hospital.tel;

            // 인포윈도우 내용에 병원 이름, 주소, 전화번호 추가
            infoMapListContent.appendChild(hospitalNameLink);
            infoMapListContent.appendChild(addressText);
            infoMapListContent.appendChild(telText);

            // 인포윈도우 열기
            infowindow.setContent(infoMapListContent);
            infowindow.open(map, marker); // 클릭한 마커 위에 인포윈도우 표시
        });

        hospitalList.appendChild(listItem);
    });
}

// 모달 열기 및 마커 표시
async function openMapModal(hospitals) {
    const modal = document.getElementById('mapModal')
    modal.classList.add('show')

    const mapContainer = document.getElementById('map2') // 맵 컨테이너

    // 카카오 맵 초기화
    map = new kakao.maps.Map(mapContainer, {
        center: new kakao.maps.LatLng(37.5563, 126.9727), // 서울역 좌표
        level: 13  // 줌 레벨 설정
    })

    // 새로운 마커 추가
    markers.forEach(marker => marker.setMap(null)) // 기존 마커 숨기기
    markers = [] // 마커 배열 초기화

    // 새로운 마커 추가
    hospitals.slice(0, 20).forEach(hospital => {
        const markerPosition = new kakao.maps.LatLng(hospital.lat, hospital.lng)
        const marker = new kakao.maps.Marker({
            position: markerPosition,
            image: markerImage
        })

        marker.setMap(map)
        markers.push(marker)
        // 마커 클릭 시 해당 병원의 인포윈도우 띄우기
        kakao.maps.event.addListener(marker, 'click', function() {
            const infoMapContent = document.createElement('div');
            infoMapContent.classList.add('infoMapContent'); // 클래스 추가

            // 병원 이름을 <a> 태그로 만들기
            const hospitalNameLink = document.createElement('a');
            hospitalNameLink.href = '${cpath}/hospitalInfo/' + hospital.id; // 병원 상세 페이지로 링크
            hospitalNameLink.target = '_blank'; // 새 탭에서 열기
            hospitalNameLink.classList.add('hospitalNameLink'); // 클래스 추가
            hospitalNameLink.innerText = hospital.hospital_name;

            // 주소와 전화번호 정보 추가
            const addressText = document.createElement('div');
            addressText.classList.add('hospitalAddress'); // 클래스 추가
            addressText.innerHTML = '<strong>주소:</strong> ' + hospital.address;

            const telText = document.createElement('div');
            telText.classList.add('hospitalPhone'); // 클래스 추가
            telText.innerHTML = '<strong>전화번호:</strong> ' + hospital.tel;

            // 인포윈도우 내용에 병원 이름, 주소, 전화번호 추가
            infoMapContent.appendChild(hospitalNameLink);
            infoMapContent.appendChild(addressText);
            infoMapContent.appendChild(telText);

            // 인포윈도우 열기
            infowindow.setContent(infoMapContent);
            infowindow.open(map, marker); // 클릭한 마커 위에 인포윈도우 표시
        });
    });

    displayHospitalList(hospitals); // 병원 리스트 표시
}

// 모달 닫기
function closeMapModal() {
    const modal = document.getElementById('mapModal')
    modal.classList.remove('show')
    markers.forEach(marker => marker.setMap(null)) // 마커 숨기기
    markers = [] // 마커 배열 초기화
}