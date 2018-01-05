<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.mongodb.*"
	import="com.mongodb.BasicDBObject" import="com.mongodb.DB"
	import="com.mongodb.DBCollection" import="com.mongodb.DBCursor"
	import="com.mongodb.MongoClient" import="com.mongodb.MongoException"
	import="java.net.UnknownHostException" import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport"
   content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="">

<title>YHMH</title>

<!-- Bootstrap core CSS -->
<link href="./vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom fonts for this template -->
<link href="./vendor/font-awesome/css/font-awesome.min.css"
   rel="stylesheet" type="text/css">
<link
   href='https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800'
   rel='stylesheet' type='text/css'>
<link
   href='https://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic'
   rel='stylesheet' type='text/css'>

<!-- Plugin CSS -->
<link href="./vendor/magnific-popup/magnific-popup.css" rel="stylesheet">

<!-- Custom styles for this template -->
<link href="./css/creative.min.css" rel="stylesheet">

<!-- wordcloud -->
<link rel="stylesheet" type="text/css" href="./jqcloud.css" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
<script type="text/javascript" src="./jqcloud-1.0.4.js"></script>



</head>
<script language=JavaScript>
   
   var guselectbox = new Array('강서구','금정구','기장군','남구','동구','동래구','부산진구','북구','사상구','사하구','   서구','수영구','연제구','영도구','   중구','해운대구');
   var dongselectbox = new Array();
   dongselectbox[0] = new Array('명지동','신호동','지사동');      //강서구
   dongselectbox[1] = new Array('구서동','금사동','남산동','   부곡동','서동','장전동','청룡동','   회동동');      //금정구
   dongselectbox[2] = new Array('기장읍교리','기장읍대라리','   기장읍동부리','   기장읍서부리','   기장읍청강리','   일광면삼성리','   일광면이천리','   정관읍달산리','   정관읍모전리','   정관읍용수리','   기장읍내리','정관읍매학리',
         '정관읍방곡리','기장읍대변리','철마면고촌리','   장안읍명례리','   장안읍좌천리');      //기장군
   dongselectbox[3] = new Array('감만동','대연동','문현동','   용당동','용호동','우암동');      //남구
   dongselectbox[4] = new Array('범일동','수정동','좌천동','초량동');      //동구
   dongselectbox[5] = new Array('낙민동','명륜동','명장동','복천동','사직동','수안동','안락동','온천동','칠산동');      //동래구
   dongselectbox[6] = new Array('가야동','개금동','당감동','범천동','부암동','부전동','양정동','연지동','전포동','초읍동','범전동');      //부산진구
   dongselectbox[7] = new Array('구포동','금곡동','덕천동','   만덕동','화명동');      //북구
   dongselectbox[8] = new Array('괘법동','덕포동','모라동','삼락동','엄궁동','주례동','학장동','감전동');      //사상구
   dongselectbox[9] = new Array('감천동','괴정동','구평동','   다대동','당리동','신평동','장림동','하단동');      //사하구
   dongselectbox[10] = new Array('남부민동','   동대신동','부민동','서대신동','암남동','토성동','아미동','충무동','부용동','초장동');      //서구
   dongselectbox[11] = new Array('광안동','남천동','망미동','민락동','수영동');      //수영구
   dongselectbox[12] = new Array('거제동','연산동');      //연제구
   dongselectbox[13] = new Array('동삼동','봉래동','신선동','영선동','청학동','남항동','대평동','대교동');      //영도구
   dongselectbox[14] = new Array('동광동','보수동','부평동','신창동','영주동','대청동','대창동','중앙동');      //중구
   dongselectbox[15] = new Array('반송동','반여동','송정동','우동','재송동','좌동','중동');      //해운대구



function init(f) {
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
   
   dong.options[0] = new Option("동을 선택 해주세요","");
   
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
//   location.href="/YHMH/mainController?action=goDetail&gu=" + gu + "&dong=" + dong;
}

</script>

<%
		String[] arr = null;
		String[] arr2 = null;
		try {

			Mongo mongo = new Mongo("52.78.114.111", 27017);
			DB db = mongo.getDB("newDB");
			request.setCharacterEncoding("UTF-8");
			DBCollection collection2 = db.getCollection("wordcloud");
			DBObject doc = new BasicDBObject();
			BasicDBObject query = new BasicDBObject();
			//query.put("dong", textDong);
			//System.out.println("query:" + query);
			//System.out.println("gu:" + query.getString("gu"));
			//System.out.println("dong:" + query.getString("dong"));

			ArrayList<String> array = new ArrayList<String>();
			ArrayList<String> array2 = new ArrayList<String>();

			DBCursor cursor = collection2.find();
			while (cursor.hasNext()) {
				BasicDBObject dbObject = (BasicDBObject) cursor.next();
				//System.out.println("gu:" + dbObject.getString("gu"));
				array.add(dbObject.getString("rev"));
				array2.add(dbObject.getString("Freq"));

			}
			System.out.println(array);
			System.out.println(array2);

			arr = new String[array.size()];
			arr = array.toArray(arr);

			arr2 = new String[array2.size()];
			arr2 = array2.toArray(arr2);
%>

<script language="JavaScript">  

var rev = new Array();
var freq = new Array();
<%  
for (int i=0; i < arr.length; i++) {  
%>  
	rev[<%= i %>] = "<%=arr[i] %>"
<%
}

for (int i=0; i < arr2.length; i++) {  
%>  
	freq[<%= i %>] = "<%=arr2[i] %>"
<%}
%>
</script>

<script type="text/javascript">
	var word_array = [
		{text: rev[0], weight: freq[0]},
        {text: rev[1], weight: freq[1]},
        {text: rev[2], weight: freq[2]},
        {text: rev[3], weight: freq[3]},
        {text: rev[4], weight: freq[4]},
        {text: rev[5], weight: freq[5]},
        {text: rev[6], weight: freq[6]},
        {text: rev[7], weight: freq[7]},
        {text: rev[8], weight: freq[8]},
        {text: rev[9], weight: freq[9]},
        {text: rev[10], weight: freq[10]},
        {text: rev[11], weight: freq[11]},
        {text: rev[12], weight: freq[12]},
        {text: rev[13], weight: freq[13]},
        {text: rev[14], weight: freq[14]},
        {text: rev[15], weight: freq[15]},
        {text: rev[16], weight: freq[16]},
        {text: rev[17], weight: freq[17]},
        {text: rev[18], weight: freq[18]},
        {text: rev[19], weight: freq[19]},
        {text: rev[20], weight: freq[20]},
        {text: rev[21], weight: freq[21]},
        {text: rev[22], weight: freq[22]},
        {text: rev[23], weight: freq[23]},
        {text: rev[24], weight: freq[24]},
        {text: rev[25], weight: freq[25]},
        {text: rev[26], weight: freq[26]},
        {text: rev[27], weight: freq[27]},
        {text: rev[28], weight: freq[28]},
        {text: rev[29], weight: freq[29]},
        {text: rev[30], weight: freq[30]},
        {text: rev[31], weight: freq[31]},
        {text: rev[32], weight: freq[32]},
        {text: rev[33], weight: freq[33]},
        {text: rev[34], weight: freq[34]},
        {text: rev[35], weight: freq[35]},
        {text: rev[36], weight: freq[36]},
        {text: rev[37], weight: freq[37]},
        {text: rev[38], weight: freq[38]},
        {text: rev[39], weight: freq[39]},
        {text: rev[40], weight: freq[40]},
        {text: rev[41], weight: freq[41]},
        {text: rev[42], weight: freq[42]},
        {text: rev[43], weight: freq[43]},
        {text: rev[44], weight: freq[44]},
        {text: rev[45], weight: freq[45]},
        {text: rev[46], weight: freq[46]},
        {text: rev[47], weight: freq[47]},
        {text: rev[48], weight: freq[48]},
        {text: rev[49], weight: freq[49]}   
        
        
      ];

      $(function() {
        $("#example").jQCloud(word_array);
      });
    </script>
    
<body onload="init(this.form);">
<body id="page-top">

   <header class="masthead">
   <div class="header-content">
      <div class="header-content-inner">
         <h1 id="homeHeading">Your Home My Home</h1>
         <hr>
         <a class="btn btn-primary btn-xl" href="#services">Find Out More</a>
      </div>
   </div>
   </header>

  <!--  <section class="bg-primary" id="about">
   <hr><hr><hr><hr><hr><hr><hr>
   <div class="container">
      <div class="row">
         <div class="col-lg-8 mx-auto text-center">
            <h2 class="section-heading text-white">Busan Real Estate Analysis</h2>
            <p class="section-heading text-white">부산광역시 부동산 시세 예측</p>
            <hr class="light">
            <a class="btn btn-default btn-xl sr-button" href="#services">Get
               Started!</a>
         </div>
      </div>
   </div>
   <hr><hr><hr><hr><hr><hr><hr><hr><hr><hr>
   </section> -->

<!-- Navigation -->
  <!--  <nav class="navbar navbar-expand-lg navbar-light fixed-top"
      id="mainNav"> <a class="navbar-brand" href="#page-top">YHMH</a>
   <button class="navbar-toggler navbar-toggler-right" type="button"
      data-toggle="collapse" data-target="#navbarResponsive"
      aria-controls="navbarResponsive" aria-expanded="false"
      aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
   </button>
   <div class="collapse navbar-collapse" id="navbarResponsive">
      <ul class="navbar-nav ml-auto">
         <li class="nav-item"><a class="nav-link" href="#about">About</a>
         </li>
         <li class="nav-item"><a class="nav-link" href="#services">Services</a>
         </li>

         <li class="nav-item"><a class="nav-link" href="#contact">Contact</a>
         </li>
      </ul>
   </div>
   </nav> -->







<style>
body{
background-color : #FAFAFA
}
</style>


<style type="text/css">


.extable {
margin:auto;
top:0px;
bottom:0px;
 padding: 0;
page-break-after: always;
page-break-inside: avoid;
width: 7in;

}
/* th,td{
border: 1px solid #036;

} */

/* ############################################### service header ####################################################*/
.service_header {
	width: 100%;
	height: 80px;
	z-index: 10000;
	transition:background 0.3s ease-in 0s;
	top: 0;
	background-color: #F05F40;
}

.service_header .wrap_inner {
display:flex;
align-items:center;
	
}
.service_header .wrap_inner.inner_author, .service_header .wrap_inner.inner_request {
	margin: 30px 30px 0;
	text-align: center;
}

.service_header.beyond_content .wrap_inner {
	margin: 20px 30px 0;
}

.service_header.beyond_content {
	position: fixed;
	background: rgba(255, 255, 255, 0.95);
	border-bottom: 1px solid #ddd;
	height: 60px;
}

</style>



<header id="dkHead">
			<div class="service_header">
		<div class="wrap_inner">
		<a style="color : white; font-size:30px; margin-left:10px; margin-top:20px;">YOURHOMEMYHOME</a>
</div>
</div>
</header>

   <section id="services">
<table class=extable>
<tr>
<td rowspan=2>
<SPAN style="FONT-SIZE: 15pt; font-weight: bold; "> <FONT face=돋움>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
최근 부동산 뉴스 키워드<br><br>
</FONT></SPAN>
<div id="example" style="width: 450px; height: 350px; "></div>
</td>
<td><SPAN style="FONT-SIZE: 13pt; "> <FONT face=돋움>
알고 싶은 집을 찾아보세요!<br>
</FONT></SPAN>
<SPAN style="FONT-SIZE: 15pt; font-weight: bold"> <FONT face=돋움>
부산시 동별 아파트 매매가 검색 >
</FONT></SPAN>
</td>
<td>
<br>
<form name="form">
               <select align="right" name="selectgu" id="selectgu" onchange="itemChange(this.form)">
                      <option disabled selected>구를 선택해주세요</option>
                 </select> 
                  <select align="right" name="selectdong" id="selectdong" >
                     <option disabled selected>동을 선택해주세요</option>
                  </select> <input align="right"
                  type="button" value="검색" onclick="goDetail()">
            </form>
</td>
</tr>
<tr>
<td colspan=2>

<iframe align="middle" width="700" height="404" src="pusan2016.html" frameborder="1"></iframe>
<SPAN  style="FONT-SIZE: 9pt; font-weight: bold; float:right;"> <FONT face=돋움>
출처  : 국토교통부 실거래가 공개시스템
</FONT></SPAN>
</td>
</tr>
</table>
   </section>
	<%
			System.out.println("arr[0]:" + arr[0]);
			System.out.println("arr[1]:" + arr[1]);

			System.out.println("arr2[0]:" + arr2[0]);
			System.out.println("arr2[1]:" + arr2[1]);

		} catch (Exception err) {
			System.out.println(err);
		}
				
	%>

   <!-- <section id="contact">
   <div class="container">
      <div class="row">
         <div class="col-lg-8 mx-auto text-center">
            <h2 class="section-heading">빅데이터 청년인재 양성교육</h2>
            <hr class="primary">
         </div>
      </div>
      <div class="row">
         <div class="col-lg-4 ml-auto text-center">
            <i class="fa fa-phone fa-3x sr-contact"></i>
            <p>010-0000-0000</p>
         </div>
         <div class="col-lg-4 mr-auto text-center">
            <i class="fa fa-envelope-o fa-3x sr-contact"></i>
            <p>
               <a href="mailto:your-email@your-domain.com">feedback@naver.com</a>
            </p>
         </div>
      </div>
   </div>
   </section> -->

  
   <!-- Plugin JavaScript -->
   <script src="vendor/jquery-easing/jquery.easing.min.js"></script>
   <script src="vendor/scrollreveal/scrollreveal.min.js"></script>
   <script src="vendor/magnific-popup/jquery.magnific-popup.min.js"></script>

   <!-- Custom scripts for this template -->
   <script src="js/creative.min.js"></script>

</body>
</html>