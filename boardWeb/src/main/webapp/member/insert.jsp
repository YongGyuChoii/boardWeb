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
		<h2>회원 등록</h2>
		<article>
			<form action="insertOk.jsp" method="post">
				<table border="1" width="100%">
					<tr>
						<th>회원 아이디</th>
						<td><input type="text" name="memberid" /></td>
						<th>회원 비밀번호</th>
						<td><input type="password" name="memberpwd" /></td>
						<th>회원이름</th>
						<td><input type="text" name="membername" /></td>
					</tr>
					<tr>
						<th>주소</th>
						<td><input type="text" name="addr" /></td>
						<th>연락처</th>
						<td colspan="3"><input type="text" name="phone" /></td>
					</tr>
					<tr>
						<th>이메일</th>
						<td colspan="3"><input type="text" name="email" /></td>
						<th>나이</th>
						<td colspan="2"><input type="number" name="age" /></td>
					</tr>
				</table>
				<input type="button" value="취소" onclick="location.href='list.jsp'" />
				<input type="submit" value="등록" />
			</form>
		</article>
	</section>
	<%@ include file = "/footer.jsp" %>
</body>
</html>