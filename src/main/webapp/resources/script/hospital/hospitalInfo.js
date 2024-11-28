
function pagingHandler(event) {
    event.preventDefault()
    if (event.target.tagName === 'A') {
        const pageNo = event.target.innerText
        // 모든 버튼에서 pageSelected 클래스 제거
        pagingBtns.forEach(btn => btn.querySelector('a').classList.remove('pageSelected'))
        // 클릭된 버튼에 pageSelected 클래스 추가
        event.target.classList.add('pageSelected')
        // URL에 페이지 번호를 추가하여 리다이렉트
        const newUrl = new URL(url + pageNo, window.location.origin)
        newUrl.searchParams.set('pageNo', pageNo)
        window.location.href = newUrl.toString()
    }
}

function nextBtnHandler(event) {
    if (event.target.tagName === 'A') {
        event.preventDefault()
        const value = event.currentTarget.getAttribute('value')
        const newUrl = new URL(url + value, window.location.origin)
        newUrl.searchParams.set('pageNo', value)
        window.location.href = newUrl.toString()
    }
}

function prevBtnHandler(event) {
    if (event.target.tagName === 'A') {
        event.preventDefault()
        const value = event.currentTarget.getAttribute('value')
        const newUrl = new URL(url + value, window.location.origin)
        newUrl.searchParams.set('pageNo', value)
        window.location.href = newUrl.toString()
    }
}

// 페이지 로드 시 현재 페이지 버튼에 pageSelected 클래스 추가
function setCurrentPageSelected() {
    const currentPage = new URLSearchParams(window.location.search).get('pageNo') || '1'
    pagingBtns.forEach(btn => {
        const link = btn.querySelector('a')
        if (link.innerText === currentPage) {
            link.classList.add('pageSelected')
        } else {
            link.classList.remove('pageSelected')
        }
    })
}



//차트 애니메이션
function startLoadingAnimation() {
    loadingMessage.style.display = 'block'
    loadingInterval = setInterval(() => {
        opacity += 0.05 * fadeDirection // 0.05씩 opacity 변화
        if (opacity >= 1 || opacity <= 0) fadeDirection *= -1  // 방향 전환
        loadingMessage.style.opacity = opacity
    }, 50) // 50ms마다 opacity 업데이트
}

function stopLoadingAnimation() {
    clearInterval(loadingInterval) // 애니메이션 중지
    loadingMessage.style.opacity = 0 // 초기화
}

function dateChange(date){
    const date1 = new Date(date)
    const year = date1.getFullYear()
    const month = date1.getMonth() + 1
    const day = date1.getDate()
    const formattedMonth = month < 10 ? '0' + month : month
    const formattedDay = day < 10 ? '0' + day : day

    // yyyy-mm-dd 형식으로 반환
    const formattedDate = year + '-' + formattedMonth + '-' + formattedDay

    return formattedDate
}


async function showChartHandler(event) {
    event.preventDefault()
    const hId = event.target.getAttribute('data-id')
//         const hId = event.target.dataset.id

    const url = cpath + '/hospitals/viewCount/' + hId

    // loadingMessage.style.display = 'none'
    stopLoadingAnimation()
    chartContainer.style.display = 'none'
    chartOverlay.style.display = 'none'

    const result = await fetch(url).then(resp => resp.json())
    // console.log(result.viewCount)
    //차트 띄우기
    showChart(result.viewCount)
    // 로딩 메시지 숨기기
    // loadingMessage.style.display = 'block'
    startLoadingAnimation()
    chartContainer.style.display = 'block'
    chartOverlay.style.display = 'block'

    setTimeout(() => {
        window.location.href = cpath + '/hospitalInfo/' + hId
    },2000)
}

function showChart(data) {
    const labels = []
    const viewCount = []
    const today = new Date()

    // 일주일간의 날짜 배열 생성
    for (let i = 6; i >= 0; i--) {
        const date = new Date(today)
        date.setDate(today.getDate() - i)
        labels.push(dateChange(date))
    }

    // 조회수를 날짜별로 매핑
    const viewData = {}
    data.forEach(item => {
        const date = dateChange(item.view_date)
        viewData[date] = item.view_count
    })

    // labels의 날짜를 기준으로 조회수 가져오고, 없으면 0으로 추가
    labels.forEach(date => {
        if (viewData[date] !== undefined) {
            viewCount.push(viewData[date]) // 조회수 있는 날짜는 추가
        } else {
            viewCount.push(0) // 조회수 없는 날짜는 0으로 추가
        }
    })

    // 기존 차트가 있을 경우 destroy
    if (myChart) {
        myChart.destroy()
    }

    const context = document.getElementById('viewCountChart')
    const chartData ={
        labels : labels,
        datasets:[{
            label:'조회수',
            data: viewCount,
            borderColor: 'rgba(75, 192, 192, 1)',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            fill: true,
            tension: 0.1
        }]
    }
    const config = {
        type: 'line', // 'line' 차트로 설정
        data: chartData,
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) { return Number.isInteger(value) ? value : '' } // 정수만 표시
                    }
                }
            },
            plugins: {
                legend: {
                    position: 'top',
                },
                title: {
                    display: true,
                    text: '일주일 간 병원 조회수'
                }
            }
        }
    }
    myChart = new Chart(context, config)
}