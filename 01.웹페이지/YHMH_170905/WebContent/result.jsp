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
<link href="http://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
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

		%>
		
		var gu = f.selectgu;
		var dong = f.selectdong;	
		 


		
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
	var indexGu = document.form.selectgu.selectedIndex;
	var textDong = document.form.selectdong.options[document.form.selectdong.selectedIndex].text;
	var indexDong = document.form.selectdong.selectedIndex;
	
	if (indexGu==0){
		alert("구를 선택 해주세요");
	} else if (indexDong==0) {
		alert("동을 선택 해주세요");
	} else 
		location.href="./result.jsp?textGu=" + textGu +"&indexGu=" + indexGu+"&textDong=" + textDong+"&indexDong=" + indexDong; 
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


<body onload = "init(this.form)">



 <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top" >
        <a class="navbar-brand" href="main.jsp">YOUR HOME MY HOME</a>
      
        <form name = "form">
      <select align="right" name="selectgu" id="selectgu" onchange="itemChange(this.form)">
          <option disabled selected>구를 선택해주세요</option>
      </select> 
      <select align="right" name="selectdong" id="selectdong" >
            <option disabled selected>동을 선택해주세요</option>
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




<div class="jquery-script-center">
<div class="jquery-script-clear"></div>
</div>
<div class="container" style="margin-top:50px;">


   <%
   
    request.setCharacterEncoding("UTF-8");
    DBCollection collection = db.getCollection("transaction");
 	DBCursor cursor = collection.find();
    %>



<h3><%=textGu%> <%=textDong%> 거래 현황 및 예측가입니다.</h3>
<table id="example" class="table table-striped">
        <thead>
              <tr>
              <th>단지명</th>
              <th>면적</th>
               <th>층</th>
               <th>건축년도</th>
               <th>실거래가(만원)</th>
               <th>예측가(만원)</th>
            </tr>
        </thead>
        
        <tbody>
        
        
        
 	    <%
 	
  while(cursor.hasNext()) {
  BasicDBObject result = (BasicDBObject) cursor.next();
	    if(result.getString("gu").equals(textGu)&&result.getString("dong").equals(textDong)){
	   %>
    <tr>
   		<td><%out.println(result.getString("complex"));%></td>
	    <td><%out.println(result.getString("area"));%></td>
	    <td><%out.println(result.getString("floor"));%></td>
	    <td><%out.println(result.getString("constructed"));%></td>
	    <td><%out.println(result.getString("price"));%></td>
	    <td><%out.println(result.getString("predictedPrice"));%></td>
	</tr>  
	 <% }  
	}
	%> 
        
        
        
        
        </tbody>
    </table>
<script src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
<script src="jquery.simplePagination.js"></script>
<script>
		$(function() {
			$("#example").simplePagination({
				previousButtonClass: "btn btn-danger",
				nextButtonClass: "btn btn-danger"
			});


		});
	</script>
    </div>
    <script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-36251023-1']);
  _gaq.push(['_setDomainName', 'jqueryscript.net']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>


  <h3 style="margin-left:550px;font-size :30px">매매가 추이</h3>         
<div id="chart_div" style="width: 900px; height: 500px; margin-left:180px"></div>

</body>
</html>