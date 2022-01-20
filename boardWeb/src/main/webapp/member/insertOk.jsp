<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("UTF-8");

	String memberid = request.getParameter("memberid");
	String memberpwd = request.getParameter("memberpwd");
	String membername = request.getParameter("membername");
	String addr = request.getParameter("addr");
	String phone = request.getParameter("phone");
	String email = request.getParameter("email");
	String age = request.getParameter("age");
	int age2 = Integer.parseInt(age);
	
	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "insert into member(midx,memberid,memberpwd,membername,addr,phone,email,age) values(midx_seq.nextval,?,?,?,?,?,?,?)";
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,memberid);
		psmt.setString(2,memberpwd);
		psmt.setString(3,membername);
		psmt.setString(4,addr);
		psmt.setString(5,phone);
		psmt.setString(6,email);
		psmt.setInt(7,age2);
		
		int result = psmt.executeUpdate();
		
		response.sendRedirect("list.jsp");
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null){conn.close();}
		if(psmt != null){psmt.close();}
	}
%>