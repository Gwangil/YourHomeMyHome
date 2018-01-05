<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="com.mongodb.*"
    import="com.mongodb.BasicDBObject"
    import="com.mongodb.DB"
    import="com.mongodb.DBCollection"
    import="com.mongodb.DBCursor"
    import="com.mongodb.MongoClient"
    import="com.mongodb.MongoException"
     import="java.net.UnknownHostException"
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="./css/vendor/bootstrap/css/bootstrap-grid.css">
<link type="text/css" rel="stylesheet" href="./vendor/bootstrap/css/bootstrap-reboot.css">
<link type="text/css" rel="stylesheet" href="./vendor/bootstrap/css/bootstrap.css">
<link type="text/css" rel="stylesheet" href="./bootstrap-3.3.2/css/styles.css">
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css">
		<link rel="stylesheet" href="css/datatables/datatables.css">

<title >니집내집에 오신걸 환영합니다:)</title>

</head>
<script language=JavaScript>
	
	
	var guselectbox = new Array('강서구','금정구','기장군','남구','동구','동래구','부산진구','북구','사상구','사하구','	서구','수영구','연제구','영도구','	중구','해운대구');
	var dongselectbox = new Array();
	dongselectbox[0] = new Array('명지동','신호동','지사동');		//강서구
	dongselectbox[1] = new Array('구서동','금사동','남산동','	부곡동','서동','장전동','청룡동','	회동동');		//금정구
	dongselectbox[2] = new Array('기장읍교리','기장읍대라리','	기장읍동부리','	기장읍서부리','	기장읍청강리','	일광면삼성리','	일광면이천리','	정관읍달산리','	정관읍모전리','	정관읍용수리','	기장읍내리','정관읍매학리',
			'정관읍방곡리','기장읍대변리','철마면고촌리','	장안읍명례리','	장안읍좌천리');		//기장군
	dongselectbox[3] = new Array('감만동','대연동','문현동','	용당동','용호동','우암동');		//남구
	dongselectbox[4] = new Array('범일동','수정동','좌천동','초량동');		//동구
	dongselectbox[5] = new Array('낙민동','명륜동','명장동','복천동','사직동','수안동','안락동','온천동','칠산동');		//동래구
	dongselectbox[6] = new Array('가야동','개금동','당감동','범천동','부암동','부전동','양정동','연지동','전포동','초읍동','범전동');		//부산진구
	dongselectbox[7] = new Array('구포동','금곡동','덕천동','	만덕동','화명동');		//북구
	dongselectbox[8] = new Array('괘법동','덕포동','모라동','삼락동','엄궁동','주례동','학장동','감전동');		//사상구
	dongselectbox[9] = new Array('감천동','괴정동','구평동','	다대동','당리동','신평동','장림동','하단동');		//사하구
	dongselectbox[10] = new Array('남부민동','	동대신동','부민동','서대신동','암남동','토성동','아미동','충무동','부용동','초장동');		//서구
	dongselectbox[11] = new Array('광안동','남천동','망미동','민락동','수영동');		//수영구
	dongselectbox[12] = new Array('거제동','연산동');		//연제구
	dongselectbox[13] = new Array('동삼동','봉래동','신선동','영선동','청학동','남항동','대평동','대교동');		//영도구
	dongselectbox[14] = new Array('동광동','보수동','부평동','신창동','영주동','대청동','대창동','중앙동');		//중구
	dongselectbox[15] = new Array('반송동','반여동','송정동','우동','재송동','좌동','중동');		//해운대구


	function init(f) {

	<%String textGu = request.getParameter("textGu");
	String textDong = request.getParameter("textDong");
	String indexGu = request.getParameter("indexGu");
	String indexDong = request.getParameter("indexDong");

	
	Mongo mongo = new Mongo("52.78.114.111",27017);

	DB db = mongo.getDB("newDB");

	System.out.println(indexGu);
	System.out.println(indexDong);	%>
	
	var gu = f.selectgu;
	var dong = f.selectdong;	
	
	
	 gu.options[0] = new Option(<%=textDong%>,"");
	 dong.options[0] = new Option(<%=textDong%>,""); 
	
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
    location.href="./searchDetail.jsp?textGu=" + textGu +"&textDong=" + textDong; 
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


<body onload = "init(this.form)">


    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" >
        <a class="navbar-brand" href="#">YOUR HOME MY HOME</a>
      
        <form name = "form">
      <select align="right" name="selectgu" id="selectgu" onchange="itemChange(this.form)">
 </select> 
      <select align="right" name="selectdong" id="selectdong" >
      
    </select>
      
      </select>
       <input align="right" type="button" value="검색" onclick="goDetail()">
     </form>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
        </div>
    </nav>

    <!-- Header - set the background image for the header in the line below -->
    <header class="py-5 bg-image-full" style="background-image: url('https://unsplash.it/1900/1080?image=1076');">
        <img class="img-fluid d-block mx-auto" src="http://placehold.it/200x200&text=YHMH" alt="">
    </header>


    <!-- Content section -->
    <section class="py-5">
    <h3>테이브으으으으으을</h3>
    
   <%
   request.setCharacterEncoding("UTF-8");
   DBCollection collection = db.getCollection("mean_gu");
	DBCursor cursor = collection.find();
   %>
   <table border="1">
   <tr>
   <th>번호</th>
   <th>디비넣어주십시오</th>
   </tr>
    <%
   while(cursor.hasNext()) {
	    BasicDBObject result = (BasicDBObject) cursor.next();
	//    System.out.println(result.getString("name"));
	    if(result.getString("gu").equals(textGu)){
	    %>
   <tr>
   		<td><%out.println(result.getString("gu"));%></td>
	    <td><%out.println(result.getString("price"));%></td>
	</tr>
	<%} //else System.out.println("안된다는");
	}
	%>
   </table> 
   
    <% out.println(textGu); %>
    
    
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
    </section>

    <!-- Image Section - set the background image for the header in the line below -->
    <section class="py-5 bg-image-full" style="background-image: url('https://unsplash.it/1900/1080?image=1081');">
        <!-- Put anything you want here! There is just a spacer below for demo purposes! -->
        <div style="height: 200px;"></div>
    </section>

    <!-- Content section -->
    <section class="py-5">
       
    </section>

    <!-- Footer -->
    <footer class="py-5 bg-inverse">
        <div class="container">
            <p class="m-0 text-center text-white">Copyright &copy; Your Website 2017</p>
        </div>
        <!-- /.container -->
    </footer>

    <!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/popper/popper.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.min.js"></script>



</body>


</html>