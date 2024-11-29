// 응급실 항목
async function emergencyHandler() {
    const url = cpath + '/hospitals/emergency'
    const result = await fetch(url).then(response => response.json())
    const emergency = result.emergency

    const emergencyList = document.getElementById('emergencyList')

    emergency.forEach(function(x) {
        const listItem = document.createElement('li')
        const areaCode = x.dutyTel3.slice(0, 3)
        let region
        let regionClass

        switch (areaCode) {
            case '02': region = '서울'; regionClass = 'region-seoul'; break
            case '031': region = '경기'; regionClass = 'region-gyeonggi'; break
            case '032': region = '인천'; regionClass = 'region-incheon'; break
            case '051': region = '부산'; regionClass = 'region-busan'; break
            case '053': region = '대구'; regionClass = 'region-daegu'; break
            case '042': region = '대전'; regionClass = 'region-daejeon'; break
            case '062': region = '광주'; regionClass = 'region-gwangju'; break
            case '052': region = '울산'; regionClass = 'region-ulsan'; break
            case '044': region = '세종'; regionClass = 'region-sejong'; break
            case '033': region = '강원'; regionClass = 'region-gangwon'; break
            case '043': region = '충북'; regionClass = 'region-chungbuk'; break
            case '041': region = '충남'; regionClass = 'region-chungnam'; break
            case '063': region = '전북'; regionClass = 'region-jeonbuk'; break
            case '061': region = '전남'; regionClass = 'region-jeonnam'; break
            case '054': region = '경북'; regionClass = 'region-gyeongbuk'; break
            case '055': region = '경남'; regionClass = 'region-gyeongnam'; break
            case '064': region = '제주'; regionClass = 'region-jeju'; break
            default: region = '기타'; regionClass = 'region-etc'; break
        }

        listItem.innerHTML =
            '<div>' +
            '<strong>' + x.dutyName + ' (' + region + ')</strong><br>' +
            '<a href="tel:' + x.dutyTel3 + '">전화: ' + x.dutyTel3 + '</a><br>' +
            '입원실: ' + x.hvgc + '<br>' +
            '응급실: ' + x.hvec +
            '</div>'

        listItem.classList.add(regionClass)
        emergencyList.appendChild(listItem)
    })

    const roller = document.getElementById('roller1')
    const clone = roller.cloneNode(true)
    clone.id = 'roller2'
    document.querySelector('.rollerWrap').appendChild(clone)

    document.querySelector('#roller1').style.left = '0px'
    document.querySelector('#roller2').style.left = roller.offsetWidth + 'px'

    roller.classList.add('original')
    clone.classList.add('clone')
}

//애니메이션
const rankingList = document.getElementById('rankingList')
const originalOrder = Array.from(rankingList.children)
let timer


function tickerAnimation() {
    timer = setTimeout(function() {
        const firstLi = rankingList.querySelector('li:first-child');
        firstLi.style.marginTop = '-30px';
        firstLi.style.transition = 'margin-top 400ms';

        setTimeout(() => {
            rankingList.appendChild(firstLi);
            firstLi.style.marginTop = '';
            firstLi.style.transition = '';
            tickerAnimation();
        }, 400);
    }, 2000);
}

function resetOrder() {
    // 리스트를 초기 순서로 재정렬
    originalOrder.forEach(item => rankingList.appendChild(item));
}


// 검색 핸들러
async function searchHandler2(data) {
    const url = searchTypeSelect.value === 'hospital' ? cpath + '/hospitals/searchs/names' : cpath + '/hospitals/searchs';
    const opt = {
        method: 'POST',
        body: data
    };
    const result = await fetch(url, opt).then(response => response.json());
// 		console.log(result);

    if (result.noSearch) {
        swal({
            title: '알림',
            text: '검색결과가 없습니다. 검색어를 조건에 맞게 검색하세요',
            type: 'info',
            button: '확인'
        });
    } else {
        if (searchTypeSelect.value === 'hospital') {
            // 병원명 검색인 경우 모달 열기
            openMapModal(result.hospitals);
        } else {
            // 다른 페이지로 이동 (증상 검색의 경우)
            window.location.href = cpath + '/result';
        }
    }
}

const texts = document.querySelectorAll('.reveal-text') // 모든 .reveal-text 요소 선택
function playAnimation() {
    texts.forEach((element, index) => {
        // 애니메이션 리셋
        element.classList.add('reset')
        element.style.backgroundSize = '0% 100%'

        // 강제로 리플로우 발생
        void element.offsetWidth

        // 리셋 클래스 제거 및 애니메이션 시작
        element.classList.remove('reset')
        setTimeout(() => {
            element.style.backgroundSize = '100% 100%'
        }, index * 500) // 순차적으로 애니메이션 적용
    })
}