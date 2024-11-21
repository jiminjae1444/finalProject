<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@	include file="../header.jsp" %>

<style>
	body{
        background: linear-gradient(to bottom,#2c3e50, #a4a4a4);
    }
	/* 컨테이너 스타일 */
	.search-container {
		display: flex;
		gap: 20px;
		margin: 20px;
	}

	/* 카테고리 섹션 스타일 */
	.category-section {
		flex: 1;
		background-color: #f8f9fa;
		padding: 15px;
		border-radius: 10px;
		box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		height: 80vh;
		overflow-y: auto;
	}

	.category-list {
		display: flex;
		flex-direction: column;
		gap: 10px;
	}

	.category-list .item {
		display: flex;
		align-items: center;
		gap: 10px;
		padding: 10px;
		border: 1px solid #ddd;
		border-radius: 8px;
		cursor: pointer;
		transition: background-color 0.3s ease;
	}

	.category-list .item:hover {
		background-color: #e9ecef;
	}

	.category-list .item img {
		width: 40px;
		height: 40px;
		object-fit: contain;
	}

	.category-list .item h4 {
		margin: 0;
		font-size: 1.2rem;
		color: #34495e;
	}

	/* 결과 섹션 스타일 */
	.results-section {
		flex: 2;
		background-color: #ffffff;
		padding: 20px;
		border-radius: 10px;
		box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		height: 80vh;
		overflow-y: auto;
	}

	.results-section h3 {
		margin-bottom: 20px;
		font-size: 1.5rem;
		color: #34495e;
	}

	#results p {
		font-size: 1rem;
		color: #555;
	}

	.result-title {
		font-size: 1.2rem;
		color: #007bff;
		margin: 0;
	}

	.result-description {
		font-size: 0.9rem;
		color: #6c757d;
	}

	.load-more-btn {
		display: block;
		margin: 20px auto;
		padding: 10px 20px;
		font-size: 1rem;
		color: #fff;
		background-color: #34495e;
		border: none;
		border-radius: 5px;
		cursor: pointer;
		transition: background-color 0.3s ease;
	}

	.load-more-btn:hover {
		background-color: #23313f;
	}
		.category-section::-webkit-scrollbar,
		.results-section::-webkit-scrollbar {
			display: none; /* 스크롤바 숨기기 */
	}
	.category-list .item.selected {
    background-color: #2c3e50;
    color: white;
	}

	.category-list .item.selected h4 {
	    color: white;
	}

</style>
<div class="search-container">
	<!-- 카테고리 영역 -->
	<div class="category-section">
		<h3>카테고리</h3>
		<div class="category-list">
			<div class="item" data-id="${login.location.substring(0, 6) } 내과">
				<img src="${cpath }/resources/healthCategory/내과.png">
				<h4>내과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 신경과">
				<img src="${cpath }/resources/healthCategory/신경과.png">
				<h4>신경과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 정신건강의학과">
				<img src="${cpath }/resources/healthCategory/정신건강의학과.png">
				<h4>정신건강의학과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 외과">
				<img src="${cpath }/resources/healthCategory/외과.png">
				<h4>외과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 정형외과">
				<img src="${cpath }/resources/healthCategory/정형외과.png">
				<h4>정형외과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 신경외과">
				<img src="${cpath }/resources/healthCategory/신경외과.png">
				<h4>신경외과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 성형외과">
				<img src="${cpath }/resources/healthCategory/성형외과.png">
				<h4>성형외과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 마취통증의학과">
				<img src="${cpath }/resources/healthCategory/마취통증의학과.png">
				<h4>마취통증의학과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 산부인과">
				<img src="${cpath }/resources/healthCategory/산부인과.png">
				<h4>산부인과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 소아청소년과">
				<img src="${cpath }/resources/healthCategory/소아청소년과.png">
				<h4>소아청소년과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 안과">
				<img src="${cpath }/resources/healthCategory/안과.png">
				<h4>안과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 이비인후과">
				<img src="${cpath }/resources/healthCategory/이비인후과.png">
				<h4>이비인후과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6)} 피부과">
				<img src="${cpath }/resources/healthCategory/피부과.png">
				<h4>피부과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 비뇨기과">
				<img src="${cpath }/resources/healthCategory/비뇨기과.png">
				<h4>비뇨기과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 치과">
				<img src="${cpath }/resources/healthCategory/치과.png">
				<h4>치과</h4>
			</div>
			<div class="item" data-id="${login.location.substring(0, 6) } 한의원">
				<img src="${cpath }/resources/healthCategory/한의원.png">
				<h4>한의원</h4>
			</div>
		</div>
	</div>

	<!-- 검색 결과 영역 -->
	<div class="results-section">
		<h3>검색 결과</h3>
		<div id="results">
			<p>카테고리를 선택하면 결과가 표시됩니다.</p>
		</div>
	</div>
</div>

<%@ include file="../footer.jsp" %>

<script>
    const results = document.getElementById('results')
    const categoryItems = document.querySelectorAll('.category-list .item')

    async function fetchBlogResults(search, number) {
   		const url = '${cpath}/naverBlogSearch/' + search + '/' + parseInt(number)
   		const opt = {
   			method: 'GET',
   		}
   		const response = await fetch(url, opt)
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

    categoryItems.forEach((item) => {
        item.onclick = (event) => {
            // 모든 카테고리에서 'selected' 클래스 제거
            categoryItems.forEach(i => i.classList.remove('selected'));
            
            // 클릭된 카테고리에 'selected' 클래스 추가
            event.currentTarget.classList.add('selected');
            
            const search = event.currentTarget.dataset.id
            fetchBlogResults(search, 10)
        }
    })

    results.addEventListener('click', (event) => {
        if (event.target.id === 'moreBlog') {
            const search = event.target.dataset.id
            const number = parseInt(event.target.dataset.number) + 10
            fetchBlogResults(search, number)
        }
    })
</script>
</body>
</html>