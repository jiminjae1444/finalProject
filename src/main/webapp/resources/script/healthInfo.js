async function fetchBlogResults(search, number) {
    const NaverSearchUrl = cpath + '/naverBlogSearch/' + search + '/' + parseInt(number)
    const opt = {
        method: 'GET',
    }
    const response = await fetch(NaverSearchUrl, opt)
    const data = await response.json()

    const totalCount = data.total // Access total count
    const items = data.items // Access items

    results.innerHTML = '<p>총 ' + totalCount + '건 중 ' + items.length + '건 출력</p>'

    items.forEach((item) => {
        const itemElement = document.createElement('div') // div 요소 생성
        const tag =
            '<h3 class="result-title">' + item.title + '</h3>' +
            '<p class="result-description">' + item.description + '</p>' +
            '<hr>'
        itemElement.innerHTML = '<a href="' + item.link + '" target="_blank">' + tag + '</a>'
        results.appendChild(itemElement) // results에 추가
    })

    results.innerHTML +=
        '<button id="moreBlog" class="load-more-btn" data-id="' +
        search +
        '" data-number="' +
        parseInt(items.length) +
        '">더보기</button>'
}