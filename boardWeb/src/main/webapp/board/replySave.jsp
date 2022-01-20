<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.simple.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	String rcontent = request.getParameter("rcontent");
	String midx2 = request.getParameter("midx");
	String bidx2 = request.getParameter("bidx");
	int midx = Integer.parseInt(midx2);
	int bidx = Integer.parseInt(bidx2);
	String memberName = request.getParameter("memberName");

	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "insert into reply(ridx,rcontent,bidx,midx,rdate) values(ridx_seq.nextval,?,?,?,sysdate)";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, rcontent);
		psmt.setInt(2, bidx);
		psmt.setInt(3, midx);
		
		int result = psmt.executeUpdate();
		
		sql = "select * from reply where ridx = (select max(ridx) from reply)";
		
		psmt = null;
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		JSONArray list = new JSONArray();
		
		if(rs.next()){
			JSONObject obj = new JSONObject();
			obj.put("ridx", rs.getInt("ridx"));
			obj.put("midx", rs.getInt("midx"));
			obj.put("rcontent", rs.getString("rcontent"));
			obj.put("bidx", rs.getInt("bidx"));
			obj.put("memberName", memberName);
			
			list.add(obj);
		}
		
		out.print(list.toJSONString());
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}
%>