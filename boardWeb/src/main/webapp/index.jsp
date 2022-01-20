<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.vo.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/base.css" />
<script>
	function goMember(){
		var login = '<%=login %>';
		
		if(login == 'null'){
			alert("로그인 후 접근 가능합니다.")
		}else{
			location.href = 'member/list.jsp';
		}
	}
</script>
</head>
<body>
	<%@ include file = "header.jsp" %>
	<section>
		<a href="board/list.jsp">게시판으로 이동</a>
		<a href="javascript:goMember();">회원게시판으로 이동</a>
		<%
			if(login != null){
		%>
			<h2><%=login.getMembername() %>님 로그인을 환영합니다</h2>
		<% 	
			}
		%>
	</section>
	<%@ include file = "footer.jsp" %>
</body>
</html>