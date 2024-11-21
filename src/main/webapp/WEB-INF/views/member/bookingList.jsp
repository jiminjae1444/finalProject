<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<h3>${login.name }님의 예약 정보 리스트입니다</h3>
<table>
	<thead>
		<tr>	
			<th>ID</th><!-- userid -->
			<th>병원명</th>
			<th>병원 주소</th>
			<th>예약일/ 예약 날짜</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="dto" items="${list }">
		<tr>
			<td>${dto.userid }</td>
			<td><a href="#">${dto.hospital_name }</a></td>
			<td>${dto.address }</td>
			<td>${dto.booked_at }/ ${dto.booking_date }</td>
		</tr>
		</c:forEach>
	</tbody>
</table>

<script>
	
</script>
</body>
</html>