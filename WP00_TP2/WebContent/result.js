//필요하다면 필요한 내용을 작성

window.onload=function(){
	var atag = document.getElementsByTagName("button");//빠른길 찾기 버튼
	var frames = document.getElementsByTagName("iframe");//iframe
	var div = document.getElementsByTagName("div");//결과 div
	var p = document.getElementById("hiddenp");//주소 받아서 저장해두는 숨겨진 p태그
	var originButtonValue; // 펼치기, 접기버튼의 원래 값을 저장
	 var latitude,longitude; //위도,경도
	var click = false;//펼치기, 접기 버튼 클릭 여부
	atag[1].addEventListener("click",function(){//펼치기,접기버튼 클릭 이벤트 리스너
		if(!click){
			frames[0].style.display="block";
			originButtonValue = atag[1].innerHTML;
			atag[1].innerHTML="전체내용 접기";
			click = true;
		}else{
			frames[0].style.display="none";
			atag[1].innerHTML=originButtonValue;
			click = false;
		}
	});
	
	navigator.geolocation.getCurrentPosition (function(pos) {//위도 경도 얻기위한 html5 api
	  latitude=pos.coords.latitude;     // 위도
	  longitude=pos.coords.longitude; // 경도
	  geocode(p.innerHTML);//목적지 좌표를 얻기위한 api호출 함수
	      });

	  function geocode(adr){
		  naver.maps.Service.geocode({//네이버 지도 api의 geocode모듈. 주소를 사용하여 위도 경도 좌표를 얻는다
			  address: decodeURI(adr),//주소가 utf-8인코딩이므로 디코드 해줌.
		     }, function(status, response) {//결과 콜백 함수
		         if (status !== naver.maps.Service.Status.OK) {//상태가 안좋은 경우
		             return alert('Something wrong!');
		         }

		         var result = response.result, // 검색 결과의 컨테이너
		             items = result.items; // 검색 결과의 배열
		         
		         atag[0].addEventListener("click",function(){//길찾기 버튼의 클릭 이벤트 리스너. 새창에 빠른길찾기를 띄워준다. 
		        	 window.open("http://m.map.naver.com/route.nhn?menu=route&sname="+encodeURI("현재위치")+"&sx="+encodeURI(longitude)+"&sy="+encodeURI(latitude)+"&ename="+encodeURI(adr)+"&ex="+encodeURI(items["0"].point.x)+"&ey="+encodeURI(items["0"].point.y)+"&pathType=0&showMap=true#","");
		         });
		           
		     });

		 }

	

}
  