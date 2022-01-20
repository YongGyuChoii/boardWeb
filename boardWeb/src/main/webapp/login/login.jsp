<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/base.css" />
</head>
<body>
	<%@ include file = "/header.jsp" %>
	<section>
		<form action="loginOk.jsp" method="post">
			<p id="id">
				<label for="">
					아이디 :
					<input type="text" name="memberid" />
				</label>
			</p>
			<p>
				<label for="">
					비밀번호 :
					<input type="password" name="memberpwd" />
				</label>
			</p>
			<input type="submit" value="로그인" />
		</form>
	</section>
	<%@ include file = "/footer.jsp" %>
</body>
</html>