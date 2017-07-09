<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>문화재 찾기에 오신것을 환영합니다.</title>
    <link rel="stylesheet" href="./search.css">

    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=elp9N9m1D5Atbp86IAmD&submodules=geocoder"></script>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js">    </script>
    <script src="./search.js?ver=1" charset="utf-8"></script>
  </head>
  <body>
<nav>
  <h1>문화재를 찾아서</h1>
</nav>
<section>
  <div class="">
    <input type="text" value="">
    <button type="button" id="butn">검색</button>
  </div>
  <article id="map">
  </article>
</section>
<aside >
  <h3>검색 결과</h3>
  <button id="bt">지역에 대한 정보</button><br>
  <div id="resultScreen">
  </div>
  <iframe id="Frame"></iframe>
</aside>
  </body>

</html>

