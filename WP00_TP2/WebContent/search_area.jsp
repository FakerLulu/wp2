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


<%
String decodeArea= new String(request.getParameter("name").getBytes("8859_1"), "UTF-8");
//바이트로 파라미터를 받아 직접 인코딩
decodeArea = decodeArea.replace("<b>", "");
decodeArea = decodeArea.replaceAll("</b>", "");
String[] splited = decodeArea.split(" ");//주소를 시도 와 시군구로 나눈다
String sido = splited[0];//시도
String sigungu= splited[1];//시군구
String clientId = "elp9N9m1D5Atbp86IAmD";//애플리케이션 클라이언트 아이디값";
String clientSecret = "xZ4qGthBZe";//애플리케이션 클라이언트 시크릿값";
StringBuffer res = new StringBuffer();
try {
    String text = URLEncoder.encode(sigungu, "UTF-8");
    String apiURL = "https://openapi.naver.com/v1/search/encyc?query=" + text; // json 결과. 시군구로 검색.
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

String aaa="";
	 for(int i=0; i<searchResult.size(); i++){ 
	
	//System.out.println("="+i+" ===========================================");
	
	//배열 안에 있는것도 JSON형식 이기 때문에 JSON Object 로 추출
		JSONObject searchObject = (JSONObject) searchResult.get(i);
	//JSON name으로 추출
		if(searchObject.get("description").toString().contains(sido)){//중복되는 시군구 이름중 원하는 지역을 찾기 위해 요약정보에 시도가 존재할때만 선택
				aaa="\""+searchObject.get("link").toString().substring(0, 7)+"m."+searchObject.get("link").toString().substring(7,searchObject.get("link").toString().length()-1)+"\"";
				//주소만 획득. 어차피 api 결과는 요약본만 제공. 사전이 어떤 사전인지에 따라 html구조가 달라 html파싱도 어렵다.
				break;
		}
	} 
	if(aaa.length()==0){ //네이버 백과사전 검색결과가 없는 경우 위키피디아 결과를 보여줄수 있도록 주소 설정. 
		aaa = "\"https://ko.wikipedia.org/wiki/"+decodeArea+"\"";
	}
	response.addHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
    //크로스 도메안 허용. 아래의 출력 주석도 여기에 넣는다. 최종 출력은 "이 없도록하여 출력한다.
%>
<%=aaa.replaceAll("\"","")%>


