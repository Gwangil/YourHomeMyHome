<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.mongodb.*"
	import="com.mongodb.BasicDBObject" import="com.mongodb.DB"
	import="com.mongodb.DBCollection" import="com.mongodb.DBCursor"
	import="com.mongodb.MongoClient" import="com.mongodb.MongoException"
	import="java.net.UnknownHostException" import="java.util.ArrayList"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="./jqcloud.css" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
<script type="text/javascript" src="./jqcloud-1.0.4.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
<script src="./jquery.awesomeCloud-0.2.js"></script>
<style type="text/css">
.wordcloud {
border: 1px solid #036;
height: 7in;
margin: 0.5in auto;
padding: 0;
page-break-after: always;
page-break-inside: avoid;
width: 7in;
}
</style>

</head>
<body>

<title>워드클라우드</title>

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
			
		} catch (Exception err) {
			System.out.println(err);
		}
				
	%>


<div id="wordcloud1" class="wordcloud">
	<span data-weight=<%=arr2[0]%>><%=arr[0]%></span>
	<span data-weight=<%=arr2[1]%>><%=arr[1]%></span>
	<span data-weight=<%=arr2[2]%>><%=arr[2]%></span>
	<span data-weight=<%=arr2[3]%>><%=arr[3]%></span>
	<span data-weight=<%=arr2[4]%>><%=arr[4]%></span>
	<span data-weight=<%=arr2[5]%>><%=arr[5]%></span>
	<span data-weight=<%=arr2[6]%>><%=arr[6]%></span>
	<span data-weight=<%=arr2[7]%>><%=arr[7]%></span>
	<span data-weight=<%=arr2[8]%>><%=arr[8]%></span>
	<span data-weight=<%=arr2[9]%>><%=arr[9]%></span>
	<span data-weight=<%=arr2[10]%>><%=arr[10]%></span>
	<span data-weight=<%=arr2[11]%>><%=arr[11]%></span>
	<span data-weight=<%=arr2[12]%>><%=arr[12]%></span>
	<span data-weight=<%=arr2[13]%>><%=arr[13]%></span>
	<span data-weight=<%=arr2[14]%>><%=arr[14]%></span>
	<span data-weight=<%=arr2[15]%>><%=arr[15]%></span>
	<span data-weight=<%=arr2[16]%>><%=arr[16]%></span>
	<span data-weight=<%=arr2[17]%>><%=arr[17]%></span>
	<span data-weight=<%=arr2[18]%>><%=arr[18]%></span>
	<span data-weight=<%=arr2[19]%>><%=arr[19]%></span>
	<span data-weight=<%=arr2[20]%>><%=arr[20]%></span>
	<span data-weight=<%=arr2[21]%>><%=arr[21]%></span>
	<span data-weight=<%=arr2[22]%>><%=arr[22]%></span>
	<span data-weight=<%=arr2[23]%>><%=arr[23]%></span>
	<span data-weight=<%=arr2[24]%>><%=arr[24]%></span>
	<span data-weight=<%=arr2[25]%>><%=arr[25]%></span>
	<span data-weight=<%=arr2[26]%>><%=arr[26]%></span>
	<span data-weight=<%=arr2[27]%>><%=arr[27]%></span>
	<span data-weight=<%=arr2[28]%>><%=arr[28]%></span>
	<span data-weight=<%=arr2[29]%>><%=arr[29]%></span>
	<span data-weight=<%=arr2[30]%>><%=arr[30]%></span>
	<span data-weight=<%=arr2[31]%>><%=arr[31]%></span>
	<span data-weight=<%=arr2[32]%>><%=arr[32]%></span>
	<span data-weight=<%=arr2[33]%>><%=arr[33]%></span>
	<span data-weight=<%=arr2[34]%>><%=arr[34]%></span>
	<span data-weight=<%=arr2[35]%>><%=arr[35]%></span>
	<span data-weight=<%=arr2[36]%>><%=arr[36]%></span>
	<span data-weight=<%=arr2[37]%>><%=arr[37]%></span>
	<span data-weight=<%=arr2[38]%>><%=arr[38]%></span>
	<span data-weight=<%=arr2[39]%>><%=arr[39]%></span>
	<span data-weight=<%=arr2[40]%>><%=arr[40]%></span>
	<span data-weight=<%=arr2[41]%>><%=arr[41]%></span>
	<span data-weight=<%=arr2[42]%>><%=arr[42]%></span>
	<span data-weight=<%=arr2[43]%>><%=arr[43]%></span>
	<span data-weight=<%=arr2[44]%>><%=arr[44]%></span>
	<span data-weight=<%=arr2[45]%>><%=arr[45]%></span>
	<span data-weight=<%=arr2[46]%>><%=arr[46]%></span>
	<span data-weight=<%=arr2[47]%>><%=arr[47]%></span>
	<span data-weight=<%=arr2[48]%>><%=arr[48]%></span>
	<span data-weight=<%=arr2[49]%>><%=arr[49]%></span>
	
	
</div>

<script>
			$(document).ready(function(){
				$("#wordcloud1").awesomeCloud({
					"size" : {
						"grid" : 16,
						"normalize" : false
					},
					"options" : {
						"color" : "random-dark",
						"rotationRatio" : 0.4,
						"printMultiplier" : 3,
						
					},
					"font" : "'Times New Roman', Times, serif",
					"shape" : "square"
				});
			
			});
		</script> 
<!--[if lt IE 7 ]>
		<script src="//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.3/CFInstall.min.js"></script>
		<script>window.attachEvent('onload',function(){CFInstall.check({mode:'overlay'})})</script>
		<![endif]-->
        
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




<body>
</html>