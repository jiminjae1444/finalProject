//다음 주소 찾기 함수
function onComplete(data) {
    document.querySelector('input[name="memberLocation"]').value = data.address
}

function execDaumPostcode() {
    const postCode = new daum.Postcode({
        oncomplete: onComplete
    })
    postCode.open()
}