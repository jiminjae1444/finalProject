<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>


<div id="ImgUploadModal" class="modal">
<div class="Imgoverlay"></div>
	<div class="Imgcontent">
	<h3>프로필 이미지 변경</h3>
	<div>${login.name }님의 현재 이미지</div>
	<div>
		<img src="${cpath }/fpupload/image/${empty login.storedFileName ? 'default.png' : login.storedFileName }" style="width: 100px; height: 100px; border-radius: 10px;">
	</div>
	<div>변경할 이미지 첨부</div>
	<form method="POST" enctype="multipart/form-data">
		<p><input type="file" name="imgUpload" accept="image/*" required></p>
		<p><input type="submit" value="등록하기"></p>
	</form>
	<p><a href="${cpath }/member/info"><button>뒤로가기</button></a></p>
	</div>
</div>

</body>
</html>