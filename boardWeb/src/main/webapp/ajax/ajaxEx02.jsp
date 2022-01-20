<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function callJSON(){
		var request = new XMLHttpRequest();
		
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var jObj = JSON.parse(request.responseText);
					console.log(jObj);
					
					for(var i=0; i<jObj.length; i++){
						var obj = jObj[i];
						
						document.getElementById("result").innerHTML += obj.name + ", "+obj.publisher+", "+obj.author+", "+obj.price+"<br>";
					}
				}
			}
		}
		
		request.open("GET","data/json/data1.json",false);
		request.send();
	}
	
	function callJSON2(){
		var request = new XMLHttpRequest();
		
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var jObj = JSON.parse(request.responseText);
					console.log(jObj);
					
					for(var i=0; i<jObj.length; i++){
						var obj = jObj[i].field3;
							for(var j=0; j<obj.length; j++){
								document.getElementById("result").innerHTML += obj[j].subField1+", "+obj[j].subField2+"<br>";
							}
					}
				}
			}
		}
		
		request.open("GET","data/json/data2.json",false);
		request.send();
	}
	
	function callXML(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var xml = request.responseXML;
					
					var books = xml.getElementsByTagName("book");
					//console.log(books);
					for(var i=0; i<books.length; i++){
						var name = books[i].getElementsByTagName("name")[0].textContent;
						var publisher = books[i].getElementsByTagName("publisher")[0].textContent;
						var author = books[i].getElementsByTagName("author")[0].textContent;
						var price = books[i].getElementsByTagName("price")[0].textContent;
						
						document.getElementById("result").innerHTML += name+", "+publisher+", "+author+", "+price+"<br>";
					}
				}
			}
		}
		request.open("GET","data/xml/data1.xml",false);
		request.send();
	}
	
	function callXML2(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var xml = request.responseXML;
					
					var items = xml.getElementsByTagName("item");
					//console.log(items);
					for(var i=0; i<items.length; i++){
						var subitems = items[i].getElementsByTagName("subItem");
						for(var j=0; j<subitems.length; j++){
							var names = subitems[j].getElementsByTagName("name");
							for(var a=0; a<names.length; a++){
								document.getElementById("result").innerHTML += names[a].textContent+"<br>";
							}
						}
					}
				}
			}
		}
		request.open("GET","data/xml/data2.xml",false);
		request.send();
	}
</script>
</head>
<body>
	<h2>XML,JSON ajax 통신 예제</h2>
	<button onclick="callJSON()">json</button>
	<button onclick="callJSON2()">json2</button>
	<button onclick="callXML()">xml</button>
	<button onclick="callXML2()">xml2</button>
	<div id="result">
	</div>
</body>
</html>