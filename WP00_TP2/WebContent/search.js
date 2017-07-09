// 문화재 검색 API를 이용하는 항목을 작성.
// 결과 출력시 jsp 서버로 전송해주는 form태그 html에 작성
var resultScreen;

window.onload=function () {
  var map;//네이버 지도객체
  var latitude, longitude;//위도, 경도
  var bt = document.getElementById("butn");//검색버튼
  var inputtext = document.getElementsByTagName("input");//검색창
  var areabutton = document.getElementById("bt");//지역정보버튼
  var areaclick = false;//지역정보버튼 클릭여부
  var eyeframe = document.getElementById("Frame");//발음봐도 알겠지만 iframe
  resultScreen = document.getElementById("resultScreen");//검색결과항목




  navigator.geolocation.getCurrentPosition (function(pos) {//html5 위치 api.
    latitude=pos.coords.latitude;     // 위도
      longitude=pos.coords.longitude; // 경도
      //위도와 경도를 먼저 얻고 네이버 지도 api를 이용하여 지도 생성. 좌표는 얻은 현재위치를 사용.
      var mapOptions = {

          center: new naver.maps.LatLng(latitude, longitude),
          zoom: 10
      };

      map = new naver.maps.Map('map', mapOptions);//지도 생성
      reverseGeocode(latitude,longitude);//현재 좌표를 이용 주소를 받는 함수.

        var listener = naver.maps.Event.addListener(map, 'dragend', function(e) {//지도 드래그 이벤트 리스너. 네이버 api내에 있는 리스너.
          var marker =  map.getCenter();//중심 위치정보 획득
          //alert(marker);
          reverseGeocode(marker.y, marker.x);//지도 위치가 바뀌었으므로 새 좌표를 넣고 호출함수 호출.
          });
      });


  bt.addEventListener("click",function () {//검색버튼 클릭 이벤트 리스너
    var myaddress;

    myaddress=inputtext[0].value;//검색창에서 값을 가져온다.
    naver.maps.Service.geocode({address: myaddress}, function(status, response) {//geocode모듈을 이용하여 해당 위치의 좌표 검색.
      if (status !== naver.maps.Service.Status.OK) {
          return alert(myaddress + '의 검색 결과가 없거나 기타 네트워크 에러');
      }
      var result = response.result;//받아온 결과를 저장.
      // 검색 결과 갯수: result.total
      // 첫번째 결과 결과 주소: result.items[0].address
      // 첫번째 검색 결과 좌표: result.items[0].point.y, result.items[0].point.x
      var myaddr = new naver.maps.LatLng(result.items[0].point.y, result.items[0].point.x);//네이버 지도 api의 함수를 이용하여 지도 api에 맞는 좌표 데이터로 변환
      //alert(result.items[0].point.x+"    "+result.items[0].point.y);
      map.setCenter(myaddr); // 검색된 좌표로 지도를 이동
      // 마커 표시
      var marker =  map.getCenter();//다시 중심부 위치정보를 획득
      //alert(marker);
      reverseGeocode(marker.y, marker.x);//획득된 정보를 이용하여 주소정보 얻는다.
    });
  });

  inputtext[0].addEventListener("keypress",function (event) {//검색창에서 엔터키 입력했을때 검색 버튼 클릭효과를 줌
    if(event.keyCode===13){
      bt.click();
    }
  });

  areabutton.addEventListener("click",function () {//지역정보 펼치기 접기 버튼 클릭 이벤트 리스너
    if(!areaclick){
      eyeframe.style.display = "block";
      resultScreen.style.display = "none";
      areabutton.innerHTML = "접기";
      areaclick= true;
    }else{
      eyeframe.style.display = "none";
      resultScreen.style.display = "block";
      areabutton.innerHTML = "지역에 대한 정보";
      areaclick= false;
    }
  });



}

function getCultural(area) {//지역 문화재 정보를 얻기위해 search_area.jsp에 요청을 보냄.
          var areacode=0;

          //alert(area);
          var u = "http://localhost:8080/WP00_TP2_201102415/search_cultural.jsp?area="+area;
          //$.support.cors = true;
          $.ajax({  //jsp 접속만 유일하게 jquery를 이용함. jsp 서버에 접속하여 검색이후 완성된 결과물을 받는다.
                type: "get",
                url: u,
                //dataType: "xml",
                //data: sr,
                success: processSuccess,
                error: processError
        });



                    function processSuccess(data, status, req) {
                        if (status == "success")
                            resultScreen.innerHTML="현재 지도 위치 : "+area+"<br>"+req.responseText;//검색 결과창에 내용 갱신

                    }

                    function processError(data, status, req) {
                        alert(req.responseText + " " + status);//실패시 에러메시지
                    }


      }
      function getAreainfo(area) {//지역 정보를 얻기위해 search_cultural.jsp에 요청을 보냄.
        $.ajax({  //jsp 접속만 유일하게 jquery를 이용함. jsp 서버에 접속하여 검색이후 완성된 결과물을 받는다.
              type: "get",
              url: "http://localhost:8080/WP00_TP2_201102415/search_area.jsp?name="+area,
              //dataType: "xml",
              //data: sr,
              success: processSuccess,
              error: processError
      });



                  function processSuccess(data, status, req) {
                      if (status == "success")
                          document.getElementById("Frame").src = data;//받은 데이터로 iframe에서 로딩할 주소를 설정합니다.

                  }

                  function processError(data, status, req) {
                          alert(req.responseText + " " + status);;//실패시 에러메시지
                  }


    }



function reverseGeocode(latitude, longitude){
 naver.maps.Service.reverseGeocode({//geocode모듈의 reverseGeocode. 좌표로 주소얻는 것임.
        location: new naver.maps.LatLng(latitude, longitude),//지도 api의 내장 좌표변환 함수로 좌표를 변환하여 전송
    }, function(status, response) {
        if (status !== naver.maps.Service.Status.OK) {
            return alert('Something wrong!');
        }

        var result = response.result, // 검색 결과의 컨테이너
            items = result.items; // 검색 결과의 배열
          //alert(items["0"].addrdetail.sido+" "+items["0"].addrdetail.sigugun);
          //resultScreen.innerHTML+=items["0"].addrdetail.sido+"<br>";//임시..결과창에 현재 주소 기록
          getCultural(items["0"].addrdetail.sido+" "+items["0"].addrdetail.sigugun);//지역정보 호출함수
          getAreainfo(items["0"].addrdetail.sido+" "+items["0"].addrdetail.sigugun);//문화재정보 호출 함수
    });

}
