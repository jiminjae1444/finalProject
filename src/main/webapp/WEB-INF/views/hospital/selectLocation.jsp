<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
	body{
        background: linear-gradient(to bottom,#2c3e50, #a4a4a4);
    }
    .title {
        text-align: center;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .title h3 {
        font-size: 28px;
        color: white;
        border-bottom: 2px solid whitesmoke;
        padding-bottom: 10px;
        display: inline-block;
    }
    .location_wrap {
        display: flex;
        justify-content: space-around;
        max-width: 800px;
        margin: 0 auto;
        margin-bottom: 100px;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        padding: 20px;
        height: 60vh;
    }
    #sido, #gu {
        list-style: none;
        padding: 0;
        margin: 0;
        width: 45%;
        display: flex;
        flex-direction: column;
        overflow-y: auto;
        height: 100%;
    }
    #sido::-webkit-scrollbar, #gu::-webkit-scrollbar {
        display: none;
    }
    .sido_name, .gu_name {
        padding: 10px 15px;
        margin-bottom: 10px;
        background-color: #ecf0f1;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.2s ease;
    }
    .sido_name:hover, .gu_name:hover {
        background-color: #2c3e50;
        color: white;
    }
    .selected {
	    background-color: #2c3e50;
	    color: white;
	}
</style>
  
  
<div class="title">
	<h3>지역 선택하기</h3>
</div>

<div class="location_wrap">
	
	<ul id="sido">
		<c:forEach var="sido_List" items="${sido_List }">
			<li class="sido_name" value="${sido_List.sido_code }">
				${sido_List.sido_name }
			</li>
		</c:forEach>
	</ul>
	
	<ul id="gu">
		<c:forEach var="gu_List" items="${gu_List }">
			<li class="gu_name" value="${gu_List.gu_code }">${gu_List.gu_name }</li>
		</c:forEach>
	</ul>
	
</div>
  
<%@ include file="../footer.jsp" %>

<script>
    const sido_List = document.querySelectorAll('.sido_name')
    const gu_List = document.querySelectorAll('.gu_name')
    
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
    
    sido_List.forEach(sido_name => sido_name.onclick = loadGuHandler)
    gu_List.forEach(gu_name => gu_name.onclick = loadHospitalHandler)

    // 페이지 로드 시 현재 선택된 시/도 표시
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const currentSidoCode = currentPath.split('/')[currentPath.split('/').indexOf('selectLocation') + 2];
        
        sido_List.forEach(item => {
            if (item.getAttribute('value') === currentSidoCode) {
                item.classList.add('selected');
            }
        });
    });
</script>

</body>
</html>