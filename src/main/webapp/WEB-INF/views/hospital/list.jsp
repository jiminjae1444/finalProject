<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<link rel="stylesheet" href="${cpath}/resources/css/hospital/list.css">

<h3>목록</h3>

<table>
	<thead>
		<tr>
			<th>번호</th>
			<th>병원이름</th>
			<th>병원주소</th>
		</tr>
	</thead>
	<tbody></tbody>
</table>
<script src="${cpath}/resources/script/hospital/list.js"></script>
<script>
	window.addEventListener('DOMContentLoaded', listHandler)
</script>

</body>
</html>







