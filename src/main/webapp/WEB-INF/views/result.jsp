<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%@include file="header.jsp"%>
<link rel="stylesheet" href="${cpath}/resources/css/resultStyle.css">
<div class="input-group">
    <div class="search-buttons">
        <div class="select-wrap">
            <select id="searchTypeSelect">
                <option value="search">증상 검색</option>
            </select>
        </div>
    </div>
    <form id="searchForm" class="search-form" method="post">
        <input type="text" id="searchInput" name="search" placeholder="증상 또는 병명을 입력해주세요" required>
         <button type="submit" class="search">검색</button>
         <img src="${cpath }/resources/image/voice-icon.png" id="soundSearch">
    </form>
</div>
<div id="map"></div>
<%@ include file="footer.jsp" %>
<script>
    // geolib의 getDistance 함수 사용하기
    const { getDistance } = window.geolib; // geolib에서 getDistance 가져오기
    let hospitalImageCache = {};
    let map = '';
</script>
<script src="${cpath}/resources/script/resultFunction.js"></script>
<script>
    const searchTypeSwitch = document.getElementById('searchTypeSwitch');
    const searchForm = document.getElementById('searchForm')
    const searchInput = document.getElementById('searchInput')
    const searchTypeSelect = document.getElementById('searchTypeSelect'); // 셀렉트 요소



    let recognition   //음성인식에 사용
    let isRecognitionActive = false // 음성 인식 상태 플래그
    const soundSearch = document.getElementById('soundSearch')
    // 음성 인식 초기화
    if (window.SpeechRecognition || window.webkitSpeechRecognition) {
        recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)()
        recognition.lang = 'ko-KR' // 한국어로 설정
    }
</script>
<script src="${cpath}/resources/script/searchFunction.js"></script>
<script>
    // 폼 제출 시 searchHandler 실행
    searchForm.addEventListener('submit', searchHandler);
    window.addEventListener('DOMContentLoaded', loadHandler)
</script>


</body>
</html>
