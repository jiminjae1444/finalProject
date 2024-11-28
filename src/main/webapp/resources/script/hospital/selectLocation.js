function loadGuHandler(event) {
    // 모든 sido_name에서 'selected' 클래스 제거
    sido_List.forEach(item => item.classList.remove('selected'));

    // 클릭된 요소에 'selected' 클래스 추가
    event.currentTarget.classList.add('selected');

    const path = window.location.pathname
    const arr = path.split('/')
    const value = event.currentTarget.getAttribute('value')
    location.href = cpath + '/hospital/selectLocation/' + arr[arr.indexOf('selectLocation') + 1] + '/' + value
}

function loadHospitalHandler(event) {
    const path = window.location.pathname
    const arr = path.split('/')
    const jinryo_code = arr[arr.indexOf('selectLocation') + 1]
    const value = event.currentTarget.getAttribute('value')
    location.href = cpath + '/hospital/selectLocation/' + jinryo_code + '/' + arr[arr.indexOf(jinryo_code) + 1] + '/' + value
}