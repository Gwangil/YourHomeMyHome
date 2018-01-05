<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>니집내집에 오신걸 환영합니다:)</title>
</head>
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
<body onload = "init(this.form);">
<div class="text-center" align="center">
<h3 style="font-size :40px; margin-top:100px;margin-left:37%;margin-right:37%" ><img width="70" height="70" alt="" src="../YHMH/land_logo_small.png">니집내집:)</h3>
	<form name = "form">
      <select style="font-size :25px" name="selectgu" id="selectgu" onchange="itemChange(this.form)"></select>
      <select style="font-size :25px" name="selectdong" id="selectdong" ></select>
       <input style="font-size :25px" type="button" value="검색" onclick="goDetail()">
     </form>
       	
</div>                    
</body>
</html>