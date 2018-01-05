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
<%
}


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
  </head>
  <body>
   <div id="example" style="width: 550px; height: 350px;"></div>

<div id="wordcloud" style="width: 550px; height: 350px; border: 1px solid #ccc;">
	
	<%
			System.out.println("arr[0]:" + arr[0]);
			System.out.println("arr[1]:" + arr[1]);

			System.out.println("arr2[0]:" + arr2[0]);
			System.out.println("arr2[1]:" + arr2[1]);

		} catch (Exception err) {
			System.out.println(err);
		}
				
	%>
	

</div>

<body>
</html>