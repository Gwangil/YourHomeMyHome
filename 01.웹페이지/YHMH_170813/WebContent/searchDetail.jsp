<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script language=JavaScript>
	
	var guselectbox = new Array('������','������','����','������','�ϱ�','�λ�����','���','���ϱ�','����','������','������','�߱�','�ؿ�뱸','������','���屺');
	var dongselectbox = new Array();
	dongselectbox[0] = new Array('���̵�','ȭ�','���絿');
	dongselectbox[1] = new Array('������','�ΰ','������');
	dongselectbox[2] = new Array('�뿬��','��絿','��ȣ��');

function init(f) {
	var gu = f.selectgu;
	var dong = f.selectdong;
	
	gu.options[0] = new Option("���� �����ϼ���","");
	dong.options[1] = new Option("���� �����ϼ���","");
	
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
	
	dong.options[0] = new Option("���� �����ϼ���","");
	
	if(sel != 0){
		for(var i=0; i<dongselectbox[sel-1].length; i++) {
			dong.options[i+1] = new Option(dongselectbox[sel-1][i], dongselectbox[sel-1][i]);
		}
	}
}

function goDetail() {
	var textGu = document.form.selectgu.options[document.form.selectgu.selectedIndex].text;
	var textDong = document.form.selectdong.options[document.form.selectdong.selectedIndex].text;
	alert("�� : "+textGu + ",  �� : "+textDong);
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
                ['1��',  10,      0],
                ['2��',  30,      0],
                ['3��',  50,      0],
                ['4��',  70,      50],
                ['5��',  90,      100],
                ['6��',  110,     150],
                ['7��',  130,     250],
                ['8��',  150,     500],
                ['9��',  170,     600],
                ['10��',  190,     680],
                ['11��',  210,     750],
                ['12��',  230,     900],
            ]);
            var options = {
   //             title: '2011�� ���'
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
       ['�з�', '�Է¼�'],
       
       ['�ϳ׾���Ʈ',2],
       
       ['���׾���Ʈ',2],
       
       ['������Ʈ',2],
       
       ['���Ķ�',3],
       
       
      
       
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
<title>���������� ���Ű� ȯ���մϴ�:)</title>
</head>
<body onload = "init(this.form);">
<h3 style="margin-left:20px;font-size :40px" ><img width="70" height="70" alt="" src="../YHMH/land_logo_small.png">��������:)</h3>
<div class="text-center">
	<form style="margin-left:850px;" name = "form">
      <select style="font-size :20px" name="selectgu" id="selectgu" onchange="itemChange(this.form)"></select>
      <select style="font-size :20px" name="selectdong" id="selectdong" ></select>
       <input style="font-size :20px" type="button" value="�˻�" onclick="goDetail()">
     </form>
</div>
<br>
<h3 style="margin-left:550px;font-size :30px">�ŸŰ� ����</h3>         
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