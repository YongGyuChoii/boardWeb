<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");
	request.setCharacterEncoding("UTF-8");

	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");
	
	String bidx = request.getParameter("bidx");

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	PreparedStatement psmtReply = null;
	ResultSet rsReply = null;
	
	String subject_ = "";
	String writer_ = "";
	String content_ = "";
	int bidx_ = 0;
	int midx_ = 0;
	
	ArrayList<Reply> rList = new ArrayList<>();
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		String sql = "select * from board where bidx="+bidx;
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		if(rs.next()){
			subject_ = rs.getString("subject");
			writer_ = rs.getString("writer");
			content_ = rs.getString("content");
			bidx_ = rs.getInt("bidx");
			midx_ = rs.getInt("midx");
		}
		
		sql = "select * from reply r, member m where r.midx=m.midx and bidx="+bidx;
		
		psmtReply = conn.prepareStatement(sql);
		
		rsReply = psmtReply.executeQuery();
		
		while(rsReply.next()){
			Reply reply = new Reply();
			reply.setBidx(rsReply.getInt("bidx"));
			reply.setMidx(rsReply.getInt("midx"));
			reply.setRidx(rsReply.getInt("ridx"));
			reply.setRcontent(rsReply.getString("rcontent"));
			reply.setRdate(rsReply.getString("rdate"));
			reply.setMemberName(rsReply.getString("memberName"));
			
			rList.add(reply);
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null){conn.close();}
		if(psmt != null){psmt.close();}
		if(rs != null){rs.close();}
		if(psmtReply != null){psmtReply.close();}
		if(rsReply != null){rsReply.close();}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/base.css" />
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script> 
	function replySave(){
		$.ajax({
			url: "replySave.jsp",
			type: "post",
			data: $("form[name=reply]").serialize(),
			success: function(data){
				alert("등록 완료!!");
				var json = JSON.parse(data.trim());
				var html = "<tr>";
				html += "<td>"+json[0].memberName+"<input type='hidden' name='ridx' value='"+json[0].ridx+"'></td>";
				html += "<td>"+json[0].rcontent+"</td>";
				html += "<td><input type='button' value='수정' onclick='modify(this)'>";
				html +=	"<input type='button' value='삭제' onclick='deleteReply(this)' /></td>";
				html += "</tr>";
				
				$("#replyTable>tbody").append(html);
				
				document.reply.reset();
			}
		});
	}
	
	function modify(obj){
		var rcontent = $(obj).parent().prev().text();
		var html = "<input type='text' name='rcontent' value='"+rcontent+"'><input type='hidden' name='origin' value='"+rcontent+"'>";
		$(obj).parent().prev().html(html);
		
		html = "<input type='button' value='저장' onclick='updateReply(this)'><input type='button' value='취소' onclick='cancleReply(this)'>";
		$(obj).parent().html(html);
	}
	
	function cancleReply(obj){
		var originContent = $(obj).parent().prev().find("input[name=origin]").val();
		$(obj).parent().prev().html(originContent);
		
		var html = "";
		html += "<input type='button' value='수정' onclick='modify(this)'>";
		html += "<input type='button' value='삭제' onclick='deleteReply(this)'>";
		
		$(obj).parent().html(html);
	}
	
	function updateReply(obj){
		var ridx = $(obj).parent().prev().prev().find("input:hidden").val();
		var rcontent = $(obj).parent().prev().find("input:text").val();
		
		$.ajax({
			url: "replyupdate.jsp",
			type: "post",
			data: "ridx="+ridx+"&rcontent="+rcontent,
			success: function(data){
				$(obj).parent().prev().html(rcontent);
				var html = "<input type='button' value='수정' onclick='modify(this)'>";
				html += "<input type='button' value='삭제' onclick='deleteReply(this)'>";
				$(obj).parent().html(html);
			}
		});
	}
	
	function deleteReply(obj){
		var YN = confirm("정말 삭제하시겠습니까?");
		if(YN){
			var ridx = $(obj).parent().prev().prev().find("input:hidden").val();
			
			$.ajax({
				url: "replyDelete.jsp",
				type: "post",
				data: "ridx="+ridx,
				success: function(){
					$(obj).parent().parent().remove();
				}
			});
		}
	}
</script>
</head>
<body>
	<%@ include file="/header.jsp" %>
	<section>
		<h2>게시글 상세조회</h2>
		<article>
			<table border="1" width="70%">
				<tr>
					<th>글제목</th>
					<td colspan="3"><%= subject_ %></td>
				</tr>
				<tr>
					<th>글번호</th>
					<td><%= bidx_ %></td>
					<th>작성자</th>
					<td><%= writer_ %></td>
				</tr>
				<tr height="300">
					<th>내용</th>
					<td colspan="3"><%= content_ %></td>
				</tr>
			</table>
			
			<button onclick="location.href='list.jsp?searchType=<%=searchType%>&searchValue=<%=searchValue%>';">목록</button>
			<%
				if(login != null && login.getMidx() == midx_){
			%>
				<button onclick="location.href='modify.jsp?bidx=<%=bidx_%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">수정</button>
				<button onclick="deleteFn()">삭제</button>
			<% 		
				}
			%>
			
			<form name="frm" action="delete.jsp" method="post">
				<input type="hidden" name="bidx" value="<%=bidx_ %>" />
			</form>
			
			<div class="replyArea">
				<div class="replyList">
					<table border="1" id="replyTable">
						<tbody>
						<%for(Reply r : rList){ %>
							<tr>
								<td><%=r.getMemberName() %><input type="hidden" name="ridx" value="<%=r.getRidx()%>"></td>
								<td><%=r.getRcontent() %></td>
								<%if(login != null && login.getMidx() == r.getMidx()){ %>
								<td>
								<input type="button" value="수정" onclick="modify(this)" />
								<input type="button" value="삭제" onclick="deleteReply(this)" />
								</td>
								<%} %>
							</tr>	
						<%} %>
						</tbody>
					</table>
				</div>
				<%
				if(login != null){
				%>
				<div class="replyInput">
					<form name="reply">
						<input type="hidden" name="bidx" value="<%=bidx_ %>" />
						<input type="hidden" name="midx" value="<%=login.getMidx() %>" />
						<input type="hidden" name="memberName" value="<%=login.getMembername() %>" />
						<p>
							<label for="">
								내용 : <input type="text" size="50" name="rcontent" />
							</label>
						</p>
						<p>
							<input type="button" value="저장" onclick="replySave()"/>
						</p>
					</form>
				</div>
				<%} %>
			</div>
		</article>
	</section>
	<%@ include file="/footer.jsp" %>
	<script>
		function deleteFn(){
			document.frm.submit();
		}
	</script>
</body>
</html>