<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script>
	var clickBtn;
	function callList(){
		$.ajax({
			url: "ajaxList.jsp",
			type: "get",
			success: function(data){
				var json = JSON.parse(data.trim());
				//console.log(json);
				var html = "";
				html += "<table border='1'>";
				html += "<thead>";
				html += "<tr>";
				html += "<th>글번호</th><th>제목</th><th>작성자</th><th> </th>";
				html += "</tr>";
				html += "</thead>";
				html += "<tbody>";
				for(var i=0; i<json.length; i++){
					html += "<tr>";
					html += "<td>"+json[i].bidx+"</td>";
					html += "<td>"+json[i].subject+"</td>";
					html += "<td>"+json[i].writer+"</td>";
					html += "<td><button onclick='modify("+json[i].bidx+",this)'>수정</button>"
							+"<button onclick='deleteFn("+json[i].bidx+",this)'>삭제</button></td>";
					html += "</tr>";
				}
				html += "</tbody>";
				html += "</table>";
				
				$("#list").html(html);
			}
		});
	}
	function modify(bidx,obj){
		clickBtn = obj;
		
		$.ajax({
			url: "ajaxList2.jsp",
			type: "get",
			data: "bidx="+bidx,
			success: function(data){
				var json = JSON.parse(data.trim());
				//console.log(json);
				$("input[name=subject]").val(json[0].subject);
				$("input[name=writer]").val(json[0].writer);
				$("textarea[name=content]").val(json[0].content);
				$("input[name=bidx]").val(json[0].bidx);
			}
		});
	}
	
	function saveFn(){
		//저장버튼 클릭시 ajax를 이용하여 해당 데이터 수정
		var subject = $("input[name=subject]").val();
		var writer = $("input[name=writer]").val();
		var bidx = $("input[name=bidx]").val();
		
		var YN;
		
		if(bidx == ""){
			YN=confirm("등록하시겠습니까?");
			if(YN){
				$.ajax({
					url: "ajaxInsert.jsp",
					type: "post",
					data: $("form").serialize(),
					success: function(data){
						var json = JSON.parse(data.trim());
						$("tbody").eq(0).prepend("<tr><td>"+json[0].bidx+"</td><td>"+json[0].subject+"</td><td>"+json[0].writer+"</td><td><button onclick='modify("+json[0].bidx+",this)'>수정</button><button onclick='deleteFn("+json[0].bidx+",this)'>삭제</button></td></tr>");
						/* var html = "<tr>";
						html += "<td>"+json[0].bidx+"</td>";
						html += "<td>"+json[0].subject+"</td>";
						html += "<td>"+json[0].writer+"</td>";
						html += "<td><button onclick='modify("+json[i].bidx+",this)'>수정</button>"
								+"<button onclick='deleteFn("+json[i].bidx+",this)'>삭제</button></td>"
						html += "</tr>";
						$("tbody").prepend(html); */
					}
				});
			}
		}else{
			YN=confirm("수정하시겠습니까?");
			if(YN){
				$.ajax({
					url: "ajaxSave.jsp",
					type: "post",
					data: $("form").serialize(),      //serialize() = 네임값으로 폼태그안의 양식 다가져옴
					//data: "bidx="+$("input[name=bidx]").val()+"?&subject="+$("input[name=subject]").val()+"?&writer="+$("input[name=writer]").val()+"?&content="+$("textarea[name=content]").val(),
					success: function(data){
						if(data.trim()>0){
							alert("수정완료!");
						}else{
							alert("수정실패!");
						}
						$(clickBtn).parent().prev().text(writer);
						$(clickBtn).parent().prev().prev().text(subject);
						
						//$("form").reset();
						document.frm.reset();
						$("input[name=bidx]").val("");
					}
				});
			}
		}
	}
	
	function deleteFn(bidx,obj){
		$.ajax({
			url: "ajaxDelete.jsp",
			type: "post",
			data: "bidx="+bidx,
			success: function(data){
				if(data.trim()>0){
					$(obj).parent().parent().remove();
				}
			}
		});
	}
	
	function resetFn(){
		document.frm.reset();
		$("input[name=bidx]").val("");
	}
</script>
</head>
<body>
	<button onclick="callList()">목록 출력</button>
	<h2>ajax를 이용한 게시판 구현</h2>
	<div id="list">
	</div>
	<div id="write">
		<form action="" name="frm">
		<input type="hidden" name="bidx" />
			<p>
				<label for="">
					제목 : <input type="text" name="subject" size="50" />
				</label>
			</p>
			<p>
				<label for="">
					작성자 : <input type="text" name="writer" />
				</label>
			</p>
			<p>
				<label for="">
					내용 : <textarea name="content"></textarea>
				</label>
			</p>
			<input type="button" value="저장" onclick="saveFn()" />
			<input type="button" value="초기화" onclick="resetFn()" />
		</form>
	</div>
</body>
</html>