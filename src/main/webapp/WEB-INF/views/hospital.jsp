<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@	include file="header.jsp" %>
<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm" var="now" />

<!-- 예약 정보에 있는 예약 시간을 포맷한다 -->
<fmt:formatDate value="${bookingInfo.booking_date }" pattern="yyyy-MM-dd HH:mm" var="booking_date"/> 

<!-- 예약시간과 현재시간의 차이를 보여주는 요소 -->
<div id="timeDiff"></div> 

<!-- 예약 정보가 없으면 예약하기, 예약정보가 있으면 예약취소 및 변경 버튼을 보여주는 요소 -->
<div id="bookingBtn"></div> 

<!-- 예약 스크립트 -->
<script>
	const timeDiff = document.getElementById('timeDiff')
	const bookingInfo = '${bookingInfo}'
	const hospital_id = '${hospital_id}'	// 병원의 id
	const member_id = '${member_id}'		// 멤버의 id
	const bookingModal = document.getElementById('bookingModal')
	const bookingBtn = document.getElementById('bookingBtn')
	const booking_date = new Date('${booking_date }').getTime()
	let bookingTimerInterval	// 예약시간까지 남은 시간 타이머 설정변수
	
	// 예약시간이 30분 남았을때 알림테이블에 넣고 그 알림 메일을 보내는 함수
	async function notificationBookingOneDay(){	
		const url = '${cpath}/notificationBookingOneDay/' + member_id + '/' + hospital_id
		const opt = {
				method : 'GET'
		}
		const result = await fetch(url, opt).then(resp => resp.json())
		if(result == 1) sendNotificationMail()
	}
	
	// 예약시간까지 남은 시간을 실시간으로 보여주는 함수
	function updateBookingTimer(booking_date) {
	    let now = new Date().getTime()
	    let difference = booking_date - now
	    if (difference > 0) {
	    	let years = Math.floor(difference / (1000 * 60 * 60 * 24 * 365))
	        let months = Math.floor((difference % (1000 * 60 * 60 * 24 * 365)) / (1000 * 60 * 60 * 24 * 30))
	        let days = Math.floor((difference % (1000 * 60 * 60 * 24 * 30)) / (1000 * 60 * 60 * 24))
	        let hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
	        let minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60))
	        let seconds = Math.floor((difference % (1000 * 60)) / 1000)
	        let timerText = "예약시간 " + formatDate(booking_date) + "까지 " + (years == 0 ? '' : years + "년 ") + (months == 0 ? '' : months + "월 ")
	        + (days == 0 ? '' : days + "일 ") + (hours == 0 ? '' : hours + "시간 ") + (minutes == 0 ? '' : minutes + "분 ") + (seconds == 0 ? '남음' : seconds + "초 남음");
			document.getElementById("timeDiff").innerHTML = timerText
	        
	        // 시간차이가 30분이되면 자동으로 알림을 띄우고 메일을 보냄
	        if(difference < 86400500 && difference > 86399500) {
	        	Swal.fire({
					  title: '예약 알림',
					  text: '예약이 하루 남았습니다.',
					  icon: 'info',
					  confirmButtonText: '확인',
					  allowOutsideClick: false,
					  allowEscapeKey: false,
					  showCloseButton: false
					}).then((result) => {if(result.isConfirmed) notificationBookingOneDay()})
	    	}
	    }
	    
	    // 예약시간에 도달하면 자동으로 알림의 띄우고 메일을 보냄
	    else {
	    	document.getElementById("timeDiff").innerHTML = '예약시간 만료'
	        clearInterval(bookingTimerInterval)
	    	bookingTimeOver()
	    }
	}
	
	// 입력폼을 모달에 띄우는 함수
	function readyToBook(event) {
		event.preventDefault()
		bookingInsertForm.classList.remove('bookingHidden')
		openBookingModal('예약하기', bookingInsertForm)
	}
	
	// 변경폼을 모달에 띄우는 함수
	function readyToUpdateBooking(event) {
		event.preventDefault()
		bookingUpdateForm.classList.remove('bookingHidden')
		openBookingModal('예약 변경하기', bookingUpdateForm)
	}
	
	// 알림테이블에 어떤 정보가 추가되면 그 정보를 메일로 보내는 함수
	async function sendNotificationMail(){
		const url = '${cpath}/sendNotificationMail'
		const opt = {
				method : 'POST'
		}
		const result = await fetch(url, opt).then(resp => resp.json())
		location.reload()
	}
	
	// 예약한 정보를 알림테이블에 추가하고 메일로 보내는 함수
	async function notificationBooking(){
		const url = '${cpath}/notificationBooking/' + member_id + '/' + hospital_id
		const opt = {
			method : 'POST'
		}
		const result = await fetch(url, opt).then(resp => resp.json())
		if(result == 1) sendNotificationMail()
		
	}
	
	// 예약 변경한 정보를 알림테이블에 추가하고 메일로 보내는 함수
	async function notificationBookingUpdate(){
		const url = '${cpath}/notificationBookingUpdate/' + member_id + '/' + hospital_id
		const opt = {
			method : 'POST'
		}
		const result = await fetch(url, opt).then(resp => resp.json())
		if(result == 1) sendNotificationMail()
	}
	
	// 예약하는 함수
	async function bookingInsert(){
		const url = '${cpath}/bookingInsert'
		const formData = new FormData(bookingInsertForm)
		const data = {}
		   formData.forEach((value, key) => {
		       data[key] = value
		   })
		const bookingTime = new Date(data.booking_date).getTime()
	    const now = new Date().getTime()
	    const timeDifference = bookingTime - now
	    const thirtyMinutesInMillis = 30 * 60 * 1000 
		
	    // 예약시간이 지금시간보다 이전이면 빠꾸먹임
	    if(timeDifference <= 0){
	    	const confirmResult = await Swal.fire({
				  title: '예약 실패',
				  text: '이미 지난 시간대입니다. 다시 선택해주세요.',
				  icon: 'error',
				  confirmButtonText: '확인',
				  allowOutsideClick: false,
				  allowEscapeKey: false,
				  showCloseButton: false
				})
				if (confirmResult.isConfirmed) {
	            	return 
	        }
    	}
		
		// 예약시간이 지금보다 30분 이내일 경우 추가 확인
	    else if (timeDifference <= thirtyMinutesInMillis) {
	        const confirmResult = await Swal.fire({
	            title: '주의',
	            text: '예약 시간이 30분 이내입니다. 정말로 예약하시겠습니까?',
	            icon: 'warning',
	            showCancelButton: true,
	            confirmButtonColor: '#3085d6',
	            cancelButtonColor: '#d33',
	            confirmButtonText: '예, 예약합니다',
	            cancelButtonText: '아니오'
	        })
	
	        if (!confirmResult.isConfirmed) {
	            return
	        }
    	}
    	
		const opt = {
			method : 'POST', 
			headers: {
	        	'Content-Type': 'application/json', 
	        },
	        	body: JSON.stringify(data),
		}
		const result = await fetch(url, opt).then(resp => resp.json())
		
		// 예약에 성공하면 그 정보를 알림테이블에 추가하고 메일로 보냄
			if(result == 1) {
				Swal.fire({
					  title: '예약 완료',
					  text: '예약이 완료되었습니다.',
					  icon: 'success',
					  confirmButtonText: '확인',
					  allowOutsideClick: false,
					  allowEscapeKey: false,
					  showCloseButton: false
					}).then((result) => {if(result.isConfirmed) 
						notificationBooking()
					})
				
			}
			else if(result == 2) Swal.fire({
				  title: '예약 실패',
				  text: '진료시간이 아닙니다. 다시 선택해주세요.',
				  icon: 'error',
				  confirmButtonText: '확인',
				  allowOutsideClick: false,
				  allowEscapeKey: false,
				  showCloseButton: false
				})
			
			// 예외 상황 대처
			else Swal.fire({
				  title: '예약 실패',
				  text: '알 수 없는 이유로 예약에 실패하였습니다.',
				  icon: 'error',
				  confirmButtonText: '확인',
				  allowOutsideClick: false,
				  allowEscapeKey: false,
				  showCloseButton: false
				})
		}
	
	// 예약 취소하는 함수
	async function bookingCancel(){
			const url = '${cpath}/bookingCancel/' + member_id + '/' + hospital_id
			const opt = {
				method : 'PATCH'
			}
			const result = await fetch(url, opt).then(resp => resp.json())
			
			// 예약 취소에 성공하면 그 내용을 알림테이블에 추가하고 메일로 보냄
			if(result == 1) {
				Swal.fire({
					  title: '예약 취소 완료',
					  text: '예약이 취소되었습니다.',
					  icon: 'success',
					  confirmButtonText: '확인',
					  allowOutsideClick: false,
					  allowEscapeKey: false,
					  showCloseButton: false
					}).then((result) => {if(result.isConfirmed) sendNotificationMail()})
			} 
			
			// 예외 상황 대처
			else Swal.fire({
				  title: '예약 취소 실패',
				  text: '알 수 없는 이유로 예약 취소에 실패하였습니다.',
				  icon: 'error',
				  confirmButtonText: '확인',
				  allowOutsideClick: false,
				  allowEscapeKey: false,
				  showCloseButton: false
				}) 	
	}
	
	// 예약 변경하는 함수
	async function bookingUpdate(){
		const url = '${cpath}/bookingUpdate'
		const formData = new FormData(bookingUpdateForm)
		const data = {}
		   formData.forEach((value, key) => {
		       data[key] = value
		   })
		const bookingTime = new Date(data.booking_date).getTime()
	    const now = new Date().getTime()
	    const timeDifference = bookingTime - now
	    const thirtyMinutesInMillis = 30 * 60 * 1000
		
	    // 예약시간이 지금시간보다 이전이면 빠꾸먹임
	    if(timeDifference <= 0){
	    	const confirmResult = await Swal.fire({
				  title: '예약 변경 실패',
				  text: '이미 지난 시간대입니다. 다시 선택해주세요.',
				  icon: 'error',
				  confirmButtonText: '확인',
				  allowOutsideClick: false,
				  allowEscapeKey: false,
				  showCloseButton: false
				})
				if (confirmResult.isConfirmed) {
	            	return 
				}
    	}
		
		// 예약시간이 지금보다 30분 이내일 경우 추가 확인
	    else if (timeDifference <= thirtyMinutesInMillis) {
	        const confirmResult = await Swal.fire({
	            title: '주의',
	            text: '변경 시 예약시간이 30분 이내입니다. 정말로 예약을 변경하시겠습니까?',
	            icon: 'warning',
	            showCancelButton: true,
	            confirmButtonColor: '#3085d6',
	            cancelButtonColor: '#d33',
	            confirmButtonText: '예, 변경합니다',
	            cancelButtonText: '아니오'
	        })
	        if (!confirmResult.isConfirmed) {
	            return
	        }
    	}
    	
		const opt = {
			method : 'PATCH', 
			headers: {
	        	'Content-Type': 'application/json', 
	        },
	        	body: JSON.stringify(data),
		}
		const result = await fetch(url, opt).then(resp => resp.json())
		
		// 예약 변경에 성공하면 그 내용을 알림테이블에 추가하고 메일로 보냄
		if(result == 1) {
				Swal.fire({
					  title: '예약 변경 완료',
					  text: '예약이 변경되었습니다.',
					  icon: 'success',
					  confirmButtonText: '확인',
					  allowOutsideClick: false,
					  allowEscapeKey: false,
					  showCloseButton: false
					}).then((result) => {if(result.isConfirmed) notificationBookingUpdate()})
				
			}
			else if(result == 2) Swal.fire({
				  title: '예약 변경 실패',
				  text: '진료시간이 아닙니다. 다시 선택해주세요.',
				  icon: 'error',
				  confirmButtonText: '확인',
				  allowOutsideClick: false,
				  allowEscapeKey: false,
				  showCloseButton: false
				})
			
			// 예외 상황 처리
			else Swal.fire({
				  title: '예약 변경 실패',
				  text: '알 수 없는 이유로 예약 변경에 실패하였습니다.',
				  icon: 'error',
				  confirmButtonText: '확인',
				  allowOutsideClick: false,
				  allowEscapeKey: false,
				  showCloseButton: false
				})
		
	}

	// 예약한 시간에 도달하면 기간 만료처리하는 함수
	async function bookingTimeOver(){
		const url = '${cpath}/bookingTimeOver/' + member_id + '/' + hospital_id
		const opt = {
			method : 'PATCH'
		}
		const result = await fetch(url, opt).then(resp => resp.json())
		 
		// 예약시간 만료처리에 성공하면그 내용을 알림테이블에 추가하고 메일로 보냄
		if(result == 1) {
			Swal.fire({
				  title: '예약 시간',
				  text: '예약한 시간이 되었습니다!!',
				  icon: 'info',
				  confirmButtonText: '확인',
				  allowOutsideClick: false,
				  allowEscapeKey: false,
				  showCloseButton: false
				}).then((result) => {if(result.isConfirmed) sendNotificationMail()})
		} 
		
		// 예외 상황 처리
		else alert('시간 처리 안됨') 
	}
	
	document.addEventListener('DOMContentLoaded', () => {
		
		// 예약 후 적용되는 페이지
		if(bookingInfo != "") {
			bookingBtn.innerHTML = '<button id="bookingCancelBtn">예약취소하기</button><button id="bookingUpdateBtn">예약변경하기</button>'
			const bookingCancelBtn = document.getElementById('bookingCancelBtn')
			const bookingUpdateBtn = document.getElementById('bookingUpdateBtn')
			document.querySelector('#bookingUpdateForm #booking_date').value = '${booking_date}'
		
			// 남은 시간 타이머를 1초단위로 카운트다운하도록 설정
			bookingTimerInterval = setInterval(() => updateBookingTimer(booking_date), 1000)
			updateBookingTimer(booking_date)
			
			bookingCancelBtn.onclick = () => {
				Swal.fire({
					  title: '예약 취소',
					  text: '예약을 취소하시겠습니까?',
					  icon: 'question',
					  confirmButtonText: '확인',
					  cancelButtonText: '취소',
					  showCancelButton: true,
					  allowOutsideClick: false,
					  allowEscapeKey: false,
					  showCloseButton: false
					}).then((result) => {if(result.isConfirmed) bookingCancel()})
			}
			bookingUpdateBtn.onclick = readyToUpdateBooking
			bookingUpdateForm.onsubmit = (event) => {
				event.preventDefault()
				Swal.fire({
					  title: '예약 변경',
					  text: '예약을 변경하시겠습니까?',
					  icon: 'question',
					  confirmButtonText: '확인',
					  cancelButtonText: '취소',
					  showCancelButton: true,
					  allowOutsideClick: false,
					  allowEscapeKey: false,
					  showCloseButton: false
					}).then((result) => {if(result.isConfirmed) bookingUpdate()})
			}
		}
		
		// 예약 전 적용되는 페이지
		else {	
			bookingBtn.innerHTML = '<button id="bookingInsertBtn">예약하기</button>'
			const bookingInsertBtn = document.getElementById('bookingInsertBtn')
			document.querySelector('#bookingInsertForm #booking_date').value = '${now}'			
			bookingInsertBtn.onclick = readyToBook
			bookingInsertForm.onsubmit = async (event) => {
				 	event.preventDefault()
					await Swal.fire({
			        title: '예약',
			        text: '예약하시겠습니까?',
			        icon: 'question',
			        confirmButtonText: '확인',
			        cancelButtonText: '취소',
			        showCancelButton: true,
			        allowOutsideClick: false,
			        allowEscapeKey: false,
			        showCloseButton: false
			    }).then((result) => {if(result.isConfirmed) bookingInsert()})
			}
		}
	})
	
</script>
</body>
</html>