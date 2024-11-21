<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
	table {
		width: 900px;
		border: 2px solid black;
		margin: auto;
		border-collapse: collapse;
	}
	thead {
		background-color: #eee;
	}
	tr {
		border-bottom: 1px solid #eee;
	}
	tbody > tr:hover {
		cursor: pointer;
	}
	th {
		padding: 10px 5px;
	}
	td {
		padding: 10px 5px;
	}
	td:nth-child(1) {
		text-align: center;
	}

</style>

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


<script>
	function trSelectHandler(event) {
		const tr = event.currentTarget
		const id = tr.querySelector('td').innerText
		console.log(id)
		location.href = cpath + '/hospital/' + id
	}

	async function listHandler() {
		const url = cpath + '/hospitals'
		const hospitalList = await fetch(url).then(resp => resp.json())
		console.log(hospitalList)
		
		const tbody = document.querySelector('tbody')
		hospitalList.forEach(hospital => {
			let tag = '<tr>'
			tag += '<td>' + hospital.id + '</td>'
			tag += '<td>' + hospital.hospital_name + '</td>'
			tag += '<td>' + hospital.address + '</td>'
			tag += '</tr>'
			tbody.innerHTML += tag
		})
		tbody.querySelectorAll('tr').forEach(tr => tr.onclick = trSelectHandler)
	}
	window.addEventListener('DOMContentLoaded', listHandler)
</script>

</body>
</html>







