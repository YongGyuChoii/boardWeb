<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql. *" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	String searchValue = request.getParameter("searchValue");
	String searchType = request.getParameter("searchType");

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		String sql = "select * from member";
		
		if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")){
			if(searchType.equals("membername")){
				sql += " where membername like '%"+searchValue+"%'";
			}else if(searchType.equals("addr")){
				sql += " where addr = '"+searchValue+"'";
			}
		}
		
		sql += " order by midx desc";
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		

%>
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
		<h2>회원 목록</h2>
		<article>
			<div class="searchArea">
				<form action="list.jsp">
					<select name="searchType">
						<option value="membername" <% if(searchType != null && searchType.equals("membername")){out.print("selected");} %>>회원이름</option>
						<option value="addr" <% if(searchType != null && searchType.equals("addr")){out.print("selected");} %>>회원주소</option>
					</select>
					
					<input type="text" name="searchValue" <% if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")){out.print("value='"+searchValue+"'");} %> />
					<input type="submit" value="검색" />
				</form>
			</div>
		
			<table border="1" width="70%">
				<thead>
					<tr>
						<th>회원번호</th>
						<th>회원이름</th>
						<th>회원나이</th>
						<th>회원주소</th>
					</tr>
				</thead>
				
				<tbody>
					<%
						while(rs.next()){
					%>
						<tr>
							<td><%= rs.getInt("midx") %></td>
							<td><a href="view.jsp?midx=<%= rs.getInt("midx") %>&searchType=<%=searchType %>&searchValue=<%= searchValue %>"><%= rs.getString("membername") %></a></td>
							<td><%= rs.getInt("age") %></td>
							<td><%= rs.getString("addr") %></td>
						</tr>
					<%		
						}
					%>
				</tbody>
			</table>
			
			<button onclick="location.href='insert.jsp'">등록</button>
		</article>
	</section>
	<%@ include file = "/footer.jsp" %>
</body>
</html>
<% 
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null){
			conn.close();
		}
		if(psmt != null){
			psmt.close();
		}
		if(rs != null){
			rs.close();
		}
	}
%>