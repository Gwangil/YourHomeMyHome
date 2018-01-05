<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script language=JavaScript>
	
	var guselectbox = new Array('강서구','금정구','남구','동래구','북구','부산진구','사상구','사하구','서구','수영구','연제구','중구','해운대구','영도구','기장군');
	var dongselectbox = new Array();
	dongselectbox[0] = new Array('등촌동','화곡동','가양동');
	dongselectbox[1] = new Array('장전동','부곡동','구서동');
	dongselectbox[2] = new Array('대연동','용당동','용호동');

function init(f) {
	var gu = f.selectgu;
	var dong = f.selectdong;
	
	gu.options[0] = new Option("구를 선택하세요","");
	dong.options[1] = new Option("동을 선택하세요","");
	
	for(var i = 0; i < guselectbox.length; i++) {
		gu.options[i+1] = new Option(guselectbox[i], guselectbox[i]);
		}
	}

function itemChange(f) {
	var gu = f.selectgu;
	var dong = f.selectdong;
	
	var sel = gu.selectedIndex;
	for(var i=dong.length; i>=0; i--) {
		dong.options[i] = null;
	}
	
	dong.options[0] = new Option("동을 선택하세요","");
	
	if(sel != 0){
		for(var i=0; i<dongselectbox[sel-1].length; i++) {
			dong.options[i+1] = new Option(dongselectbox[sel-1][i], dongselectbox[sel-1][i]);
		}
	}
}

function goDetail() {
	var textGu = document.form.selectgu.options[document.form.selectgu.selectedIndex].text;
	var textDong = document.form.selectdong.options[document.form.selectdong.selectedIndex].text;
	alert("구 : "+textGu + ",  동 : "+textDong);
	location.href="../YHMH/searchDetail.jsp"
//	location.href="/YHMH/mainController?action=goDetail&gu=" + gu + "&dong=" + dong;
}
</script>
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", {
            packages: ["corechart"]
        });
        google.setOnLoadCallback(drawChart);
 
        function drawChart() {
            var data = google.visualization.arrayToDataTable([
                ['month', '2011', '2012'],
                ['1월',  10,      0],
                ['2월',  30,      0],
                ['3월',  50,      0],
                ['4월',  70,      50],
                ['5월',  90,      100],
                ['6월',  110,     150],
                ['7월',  130,     250],
                ['8월',  150,     500],
                ['9월',  170,     600],
                ['10월',  190,     680],
                ['11월',  210,     750],
                ['12월',  230,     900],
            ]);
            var options = {
   //             title: '2011년 통계'
            };
            var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }
    </script>


<script type="text/javascript" src="https://www.google.com/jsapi"></script>
      <script type="text/javascript">
     google.load('visualization', '1', {packages:['corechart']}); 
     google.setOnLoadCallback(drawChart_cate);
 
     function drawChart_cate() {
      var data_cate = google.visualization.arrayToDataTable([
       ['분류', '입력수'],
       
       ['니네아파트',2],
       
       ['느그아파트',2],
       
       ['내아파트',2],
       
       ['아파또',3],
       
       
      
       
      ]);
 
      var options = {
       pieSliceTextStyle:{fontSize:10},
       chartArea:{width:"85%", height:"85%"},
       pieSliceText : 'label',
       pieSliceTextStyle : {fontSize: 11},
       tooltip : {textStyle: {fontSize: 12}},
       reverseCategories : false,
       sliceVisibilityThreshold : 1/100,
       legend : {position: 'none'}
      };
 
      var Cate_Chart = new google.visualization.PieChart(document.getElementById('visualization_cate'));
 
      function selectHandler() {
       var selectedItem = Cate_Chart.getSelection()[0];
        if (selectedItem) {
         var topping = data_cate.getValue(selectedItem.row, 0);
        }
       }
 
      google.visualization.events.addListener(Cate_Chart, 'select', selectHandler);
 
      Cate_Chart.draw(data_cate, options);
     }
    </script>
    <script src="https://www.google.com/uds/?file=visualization&amp;v=1&amp;packages=corechart" type="text/javascript"></script>
    <link href="https://www.google.com/uds/api/visualization/1.0/ce05bcf99b897caacb56a7105ca4b6ed/ui+ko.css" type="text/css" rel="stylesheet">
    <script src="https://www.google.com/uds/api/visualization/1.0/ce05bcf99b897caacb56a7105ca4b6ed/format+ko,default+ko,ui+ko,corechart+ko.I.js" type="text/javascript">
    </script>


<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>니집내집에 오신걸 환영합니다:)</title>
</head>
<body onload = "init(this.form);">
<h3 style="margin-left:20px;font-size :40px" ><img width="70" height="70" alt="" src="../YHMH/land_logo_small.png">니집내집:)</h3>
<div class="text-center">
	<form style="margin-left:850px;" name = "form">
      <select style="font-size :20px" name="selectgu" id="selectgu" onchange="itemChange(this.form)"></select>
      <select style="font-size :20px" name="selectdong" id="selectdong" ></select>
       <input style="font-size :20px" type="button" value="검색" onclick="goDetail()">
     </form>
</div>
<br>
<h3 style="margin-left:550px;font-size :30px">매매가 추이</h3>         
<div id="chart_div" style="width: 900px; height: 500px; margin-left:180px"></div>
<div id="visualization_cate" style="width: 1000px;  height: 500px;position: relative; margin-left:155px">
   <div dir="ltr" style="position: relative; width: 320px; height: 200px;">
  <div style="position: absolute; left: 0px; top: 0px; width: 100%; height: 100%;">
    <svg width="320" height="200" style="overflow: hidden;">
     <defs id="defs"></defs>
     <rect x="0" y="0" width="320" height="200" stroke="none" stroke-width="0" fill="#ffffff"></rect>
   </svg>
  </div>
  </div>
</div>
</body>
</html>