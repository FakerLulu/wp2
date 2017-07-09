<%@page import="org.json.simple.parser.ParseException"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

<%
String clientId = "elp9N9m1D5Atbp86IAmD";//애플리케이션 클라이언트 아이디값";
String clientSecret = "xZ4qGthBZe";//애플리케이션 클라이언트 시크릿값";
request.setCharacterEncoding("UTF-8"); //request객체의 값들을 utf-8로 인코딩
String decodeArea = new String(request.getParameter("area").getBytes("8859_1"), "UTF-8");
//get방식이든 뭐든 한글이 깨져서 바이트를 받아 자체적으로 인코딩.

try {//검색 api try문
    String text = URLEncoder.encode(decodeArea+" 문화재", "UTF-8");
    String apiURL = "https://openapi.naver.com/v1/search/local?query=" + text+"&display=100"; // json 결과
    //String apiURL = "https://openapi.naver.com/v1/search/local.xml?query="+ text; // xml 결과
    URL url = new URL(apiURL);
    HttpURLConnection con = (HttpURLConnection)url.openConnection();
    con.setRequestMethod("GET");
    con.setRequestProperty("X-Naver-Client-Id", clientId);
    con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
    int responseCode = con.getResponseCode();//서버측 응답코드를 받는다.
    BufferedReader br; 
    if(responseCode==200) { // 정상 호출시
        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
    } else {  // 에러 발생
        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
    }
    
    String inputLine; //버퍼리더에서 한줄씩 읽는 결과 데이터 임시저장 변수
    StringBuffer res = new StringBuffer();//전체 데이터를 저장할  버퍼
    while ((inputLine = br.readLine()) != null) {
    	res.append(inputLine);
    }
    br.close();//버퍼리더 닫음
    
    text = URLEncoder.encode(decodeArea+" 유적", "UTF-8");
    apiURL = "https://openapi.naver.com/v1/search/local?query=" + text+"&display=100"; // json 결과
    //String apiURL = "https://openapi.naver.com/v1/search/local.xml?query="+ text; // xml 결과
    url = new URL(apiURL);
    HttpURLConnection con2 = (HttpURLConnection)url.openConnection();
    con2.setRequestMethod("GET");
    con2.setRequestProperty("X-Naver-Client-Id", clientId);
    con2.setRequestProperty("X-Naver-Client-Secret", clientSecret);
    responseCode = con2.getResponseCode();
    
    if(responseCode==200) { // 정상 호출, 버퍼리더 닫았으니 새로 설정하여 다시 열어줌
        br = new BufferedReader(new InputStreamReader(con2.getInputStream()));
    } else {  // 에러 발생
        br = new BufferedReader(new InputStreamReader(con2.getErrorStream()));
    }
    StringBuffer res2 = new StringBuffer();
    while ((inputLine = br.readLine()) != null) {
    	res2.append(inputLine);
    }
    br.close();
////////////////////////////json파서/////////////////////////////////////
        JSONParser jsonParser = new JSONParser();
         
        //JSON데이터를 넣어 JSON Object 로 만들어 준다.
        JSONObject jsonObject = (JSONObject) jsonParser.parse(res.toString());//문화재 검색 결과를 이용함
        
        //books의 배열을 추출
        JSONArray searchResult = (JSONArray) jsonObject.get("items");

        //System.out.println("* BOOKS *");
			String rrr = "";
        for(int i=0; i<searchResult.size(); i++){

            //System.out.println("="+i+" ===========================================");
             
            //배열 안에 있는것도 JSON형식 이기 때문에 JSON Object 로 추출
            JSONObject searchObject = (JSONObject) searchResult.get(i);
            //JSON name으로 추출

            //지역이 지도상의 현재 지역과 일치여부
            if(searchObject.get("address").toString().substring(0, decodeArea.length()).equals(decodeArea)){
            	//카테고리가 명소인가
            	if(searchObject.get("category").toString().contains("명소")){
            		if(searchObject.get("roadAddress").toString().length()!=0){//도로명 주소 우선 이용
                    	rrr+="이름: <a href=\"http://localhost:8080/WP00_TP2_201102415/result.jsp?name="+searchObject.get("title")+"&ad="+searchObject.get("roadAddress")+"\" target=\"_blank\">"+searchObject.get("title")+"</a><br>";
            		}else{
                    	rrr+="이름: <a href=\"http://localhost:8080/WP00_TP2_201102415/result.jsp?name="+searchObject.get("title")+"&ad="+searchObject.get("address")+"\" target=\"_blank\">"+searchObject.get("title")+"</a><br>";
            		}
            	rrr+="category: "+searchObject.get("category")+"<br>";
            	rrr+="주소: "+searchObject.get("address")+"<br>"+searchObject.get("roadAddress")+"<br>";
            	rrr+="============================================"+"<br>";
            	}

            }
        }
        jsonObject = (JSONObject) jsonParser.parse(res2.toString());//유적 검색 결과를 이용함.
        searchResult = (JSONArray) jsonObject.get("items");

        //System.out.println("* BOOKS *");
        for(int i=0; i<searchResult.size(); i++){

            //System.out.println("="+i+" ===========================================");
             
            //배열 안에 있는것도 JSON형식 이기 때문에 JSON Object 로 추출
            JSONObject searchObject = (JSONObject) searchResult.get(i);
            //JSON name으로 추출

			//지역이 지도상의 현재 지역과 일치여부
            if(searchObject.get("address").toString().substring(0, decodeArea.length()).equals(decodeArea)){
            	//카테고리가 명소인가
            	if(searchObject.get("category").toString().contains("명소")){
            		if(searchObject.get("roadAddress").toString().length()!=0){//도로명주소 우선 이용
                    	rrr+="이름: <a href=\"http://localhost:8080/WP00_TP2_201102415/result.jsp?name="+searchObject.get("title")+"&ad="+searchObject.get("roadAddress")+"\" target=\"_blank\">"+searchObject.get("title")+"</a><br>";
            		}else{
                    	rrr+="이름: <a href=\"http://localhost:8080/WP00_TP2_201102415/result.jsp?name="+searchObject.get("title")+"&ad="+searchObject.get("address")+"\" target=\"_blank\">"+searchObject.get("title")+"</a><br>";
            		}            	rrr+="category: "+searchObject.get("category")+"<br>";
            	rrr+="주소: "+searchObject.get("address")+"<br>"+searchObject.get("roadAddress")+"<br>";
            	rrr+="============================================"+"<br>";
            	} 

            }
        }
        if(rrr.length()==0)
        	rrr="결과 없음";
        inputLine = rrr;
        response.addHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Headers", "origin, x-requested-with, content-type, accept");
        //위 두줄은 헤더에 크로스 도메인을 허가해주기 위해 넣은 부분
        out.print(inputLine);
} catch (Exception e) { 
    out.println(e);
}
%>



 











