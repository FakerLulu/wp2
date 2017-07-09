<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>상세 정보 검색 결과</title>
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=elp9N9m1D5Atbp86IAmD&submodules=geocoder"></script>
<script type="text/javascript"  src="./result.js?ver=5"></script>
    <link  type="text/css" href="./result.css?ver=8" rel="stylesheet">
</head>
<body>

<%
String decodeArea= new String(request.getParameter("name").getBytes("8859_1"), "UTF-8");
decodeArea = decodeArea.replace("<b>", "");
decodeArea = decodeArea.replaceAll("</b>", "");
String decodeAdr= new String(request.getParameter("ad").getBytes("8859_1"), "UTF-8");
//get방식 파라미터의 한글 깨짐때문에 바이트를 읽어 인코딩함.

String clientId = "elp9N9m1D5Atbp86IAmD";//애플리케이션 클라이언트 아이디값";
String clientSecret = "xZ4qGthBZe";//애플리케이션 클라이언트 시크릿값";
StringBuffer res = new StringBuffer();
try {
    String text = URLEncoder.encode(decodeArea, "UTF-8");
    String apiURL = "https://openapi.naver.com/v1/search/encyc?query=" + text; // json 결과
    //String apiURL = "https://openapi.naver.com/v1/search/local.xml?query="+ text; // xml 결과
    URL url = new URL(apiURL);
    HttpURLConnection con = (HttpURLConnection)url.openConnection();
    con.setRequestMethod("GET");
    con.setRequestProperty("X-Naver-Client-Id", clientId);
    con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
    int responseCode = con.getResponseCode();
    BufferedReader br; 
    if(responseCode==200) { // 정상 호출
        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
    } else {  // 에러 발생
        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
    }
    
    String inputLine; 
    
    while ((inputLine = br.readLine()) != null) {
    	res.append(inputLine);
    }
    br.close();
}catch (Exception e) { 
    out.println(e);
}
   
////////////////////////////json파서/////////////////////////////////////
JSONParser jsonParser = new JSONParser();

//JSON데이터를 넣어 JSON Object 로 만들어 준다.
JSONObject jsonObject = (JSONObject) jsonParser.parse(res.toString());

//books의 배열을 추출
JSONArray searchResult = (JSONArray) jsonObject.get("items");

//System.out.println("* BOOKS *");
String rrr = "";
String imgAddr="";
String aaa="";
	for(int i=0; i<searchResult.size(); i++){ 
	
	//System.out.println("="+i+" ===========================================");
	
	//배열 안에 있는것도 JSON형식 이기 때문에 JSON Object 로 추출
		JSONObject searchObject = (JSONObject) searchResult.get(0);
	//JSON name으로 추출
	//사전검색..decodeArea는 검색되는 항목변수. 혹시나 몰라서 타이틀에 검색 항목이 있는 경우만 가져옴
		if(searchObject.get("title").toString().contains(decodeArea)){
				rrr+="<h1>"+searchObject.get("title")+"</h1>";
				
				rrr+=searchObject.get("description")+"<br>";
				imgAddr=searchObject.get("thumbnail").toString();//사진은 img태그에 넣어야 하므로 변수에 저장.
				rrr+="============================================"+"<br>\n";
				rrr+="<button >내용 전체보기</button><br>";
				aaa="\""+searchObject.get("link").toString().substring(0, 7)+"m."+searchObject.get("link").toString().substring(7,searchObject.get("link").toString().length()-1)+"\"";
				//aaa는 iframe에 들어갈  주소.
				break;
		}
	}
	if(rrr.length()==0){ //네이버 백과사전 검색결과가 없는 경우 위키피디아 결과를 보여줄수 있도록 주소 설정.
		rrr = "<h1>"+decodeArea+"</h1>내용을 찾지 못했습니다.<br><button>위키피디아에서 찾기</button>";
		aaa = "\"https://ko.wikipedia.org/wiki/"+decodeArea+"\"";//aaa는 iframe에 들어갈  주소.
	}
%>

<div> 
<button id="findRoad">현재 위치에서 길찾기</button>
	<h1><% //파싱하여 받아온 정보를 이용하여 문화재 이름 삽입	%></h1>
	  <img id="photo" src="<% 
	  if(imgAddr.length()>0){//위에서 저장된 사진 주소가 있으면 그것을 사용. 없으면 충남대 로고 사용
		  out.print(imgAddr);
	  }else{
		  out.print("http://computer.cnu.ac.kr/files/attach/images/15005/dded82bfbb1de1763f4f03aa1604d2ad.png");
	  }
	  //파싱하여 받아온 정보를 이용하여 사진주소 삽입	%>">
	<p id="content"><%=rrr %></p>
	<iframe src=<%out.print(aaa);%>></iframe>
	
</div>
<p id="hiddenp"><%=decodeAdr%><%//주소를 자바스크립트에서 사용하기 위해 display:none;속성의 p태그에 넣어둠. %></p>
</body>
</html>