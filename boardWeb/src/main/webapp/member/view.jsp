<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");

	String midx = request.getParameter("midx");
	
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	String memberid = "";
	String memberpwd = "";
	String membername = "";
	String addr = "";
	String phone = "";
	String email = "";
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		String sql = "select * from member where midx="+midx;
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		if(rs.next()){
			memberid = rs.getString("memberid");
			memberpwd = rs.getString("memberpwd");
			membername = rs.getString("membername");
			addr = rs.getString("addr");
			phone = rs.getString("phone");
			email = rs.getString("email");
		}
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null){conn.close();}
		if(psmt != null){psmt.close();}
		if(rs != null){rs.close();}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/base.css" />
</head>
<body>
	<%@ include file="/header.jsp" %>
	<section>
		<h2>회원 상세조회</h2>
		<article>
			<table border="1" width="70%">
				<tr>
					<th>회원 아이디</th>
					<td><%= memberid %></td>
					<th>회원 비밀번호</th>
					<td><%= memberpwd %></td>
					<th>회원이름</th>
					<td><%= membername %></td>
				</tr>
				<tr>
					<th>주소</th>
					<td><%= addr %></td>
					<th>연락처</th>
					<td colspan="3"><%= phone %></td>
				</tr>
				<tr>
					<th>이메일</th>
					<td colspan="5"><%= email %></td>
				</tr>
			</table>
			
			<button onclick="location.href='list.jsp?searchType=<%=searchType%>&searchValue=<%=searchValue%>';">목록</button>
			<button onclick="location.href='modify.jsp?midx=<%=midx%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">수정</button>
			<button onclick="deleteFn()">삭제</button>
			<form action="delete.jsp" name="frm" method="post">
				<input type="hidden" name="midx" value="<%=midx %>" />
			</form>
		</article>
	</section>
	<%@ include file="/footer.jsp" %>
	<script>
		function deleteFn(){
			//document.frm.action = "delete.jsp";
			document.frm.submit();
		}
	</script>
</body>
</html>