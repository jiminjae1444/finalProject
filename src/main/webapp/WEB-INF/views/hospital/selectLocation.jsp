<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<link rel="stylesheet" href="${cpath}/resources/css/hospital/selectLocation.css">

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
<script src="${cpath}/resources/script/hospital/selectLocation.js"></script>
<script>
    const sido_List = document.querySelectorAll('.sido_name')
    const gu_List = document.querySelectorAll('.gu_name')
    
    sido_List.forEach(sido_name => sido_name.onclick = loadGuHandler)
    gu_List.forEach(gu_name => gu_name.onclick = loadHospitalHandler)

    // 페이지 로드 시 현재 선택된 시/도 표시
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname
        const currentSidoCode = currentPath.split('/')[currentPath.split('/').indexOf('selectLocation') + 2]
        
        sido_List.forEach(item => {
            if (item.getAttribute('value') === currentSidoCode) {
                item.classList.add('selected')
            }
        })
    })
</script>


</body>
</html>