<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>���������� ���Ű� ȯ���մϴ�:)</title>
</head>
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
<body onload = "init(this.form);">
<div class="text-center" align="center">
<h3 style="font-size :40px; margin-top:100px;margin-left:37%;margin-right:37%" ><img width="70" height="70" alt="" src="../YHMH/land_logo_small.png">��������:)</h3>
	<form name = "form">
      <select style="font-size :25px" name="selectgu" id="selectgu" onchange="itemChange(this.form)"></select>
      <select style="font-size :25px" name="selectdong" id="selectdong" ></select>
       <input style="font-size :25px" type="button" value="�˻�" onclick="goDetail()">
     </form>
       	
</div>                    
</body>
</html>