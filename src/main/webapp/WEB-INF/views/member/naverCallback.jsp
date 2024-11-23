<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script>
	const arr = opener.location.href.split('/')
	const menu = arr[arr.length - 1]
	
	const userProfile = '${userProfile}'
	switch(menu) {
	case 'login':
		const naver_id = JSON.parse(userProfile).response.id
		const formData = new FormData()
		formData.append('naver_id', naver_id)
		const url = '${cpath}/members/naverLogin'
		const opt = {
			method: 'POST',
			body: formData
		}
		fetch(url, opt)
			.then(resp => resp.json())
			.then(json => {
// 				console.log(json)
				const str = JSON.stringify(json)
				opener.document.querySelector('input[name="result"]').value = str
				window.close()	// fetch가 끝나면 마지막에 창을 닫는다(비동기 함수를 사용시는 await로 작업하는게 좋다)
			})
		break
		
	case 'join':
		if(userProfile != '') {
			const ob = JSON.parse(userProfile)
			opener.document.querySelector('input[name="name"]').value = ob.response.name
			opener.document.querySelector('input[name="email"]').value = ob.response.email
			opener.document.querySelector('input[name="gender"][value="' + ob.response.gender + '"]').checked = 'checked'
			opener.document.querySelector('input[name="userid"]').value = ob.response.email.split('@')[0]
			opener.document.querySelector('input[name="birth"]').value = ob.response.birthyear.substring(2) + ob.response.birthday.replace('-', '')
			
			const naver_id = document.createElement('input')
			naver_id.name = 'naver_id'
			naver_id.type = 'hidden'
			naver_id.value = ob.response.id
			opener.document.forms[0].appendChild(naver_id)
		}
		window.close()
		break
	}
//	window.close() 		// fetch를 호출하자말자 결과 여부 상관없이 window를 close한다
</script>

</body>
</html>