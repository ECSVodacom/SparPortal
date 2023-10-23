<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<%
'-----------------------------------------

sub main()
	Dim countinner, countouter, count1, count2, j,k
	
	
	For Each Cookie In Response.Cookies 
		Response.Cookies(Cookie) = "" 
		Response.Cookies(Cookie).Domain = "sparuat.vbecom.co.za"
		Response.Cookies(Cookie).Expires = DateAdd("d",-1,now())
		Response.AddHeader "Set-Cookie", Cookie & "=""; expires=" &  DateAdd("d",-1,now()) & "; domain=sparuat.vbecom.co.za; path=/; HttpOnly"
	Next
	
	
	Response.Cookies("DSLogin") = ""
	Response.Cookies("DSLogin").Expires =  DateAdd("d",-1,now())
	
	Response.Cookies("WebLogon") = ""
	Response.Cookies("WebLogon").Expires =  DateAdd("d",-1,now())
	
	display
	
	
End sub



'-----------------------------------------
sub display()
%>

		<html>
		<head>
		<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
		<title>Progress Bar</title>
		<script language="javascript">
		<!--

		var timerID = null;
		var timerRunning = false;
		var timeValue = 100;  //the time increment in mS
		var count = 0;
		var finish = false;
		//load up the images for the progress bar
		image00 = new Image(); image00.src='image-00.gif';
		image01 = new Image(); image01.src='image-01.gif';
		image02 = new Image(); image02.src='image-02.gif';
		image03 = new Image(); image03.src='image-03.gif';
		image04 = new Image(); image04.src='image-04.gif';
		image05 = new Image(); image05.src='image-05.gif';
		image06 = new Image(); image06.src='image-06.gif';
		image07 = new Image(); image07.src='image-07.gif';
		image08 = new Image(); image08.src='image-08.gif';
		image09 = new Image(); image09.src='image-09.gif';
		image10 = new Image(); image10.src='image-10.gif';


		function increment() {
			count += 1;
			
			//window.alert ('count = ' + count);
			
			if (count == 0) {document.images.bar.src=image00.src;}
			if (count == 1) {document.images.bar.src=image01.src;}
			if (count == 2) {document.images.bar.src=image02.src;}
			if (count == 3) {document.images.bar.src=image03.src;}
			if (count == 4) {document.images.bar.src=image04.src;}
			if (count == 5) {document.images.bar.src=image05.src;}
			if (count == 6) {document.images.bar.src=image06.src;}
			if (count == 7) {document.images.bar.src=image07.src;}
			if (count == 8) {document.images.bar.src=image08.src;}
			if (count == 9) {document.images.bar.src=image09.src;}
			//If you want it to repeat the bar continuously then use this line:
			if (count == 10) {document.images.bar.src=image10.src; count=-1;}
			//If you want it to stop repeating the bar then use this line:
			//if (count == 10) {document.images.bar.src=image10.src; end();}
		}

		function stopclock() {
			if (timerRunning)
				clearInterval(timerID);
			timerRunning = false;	
		}

		function end() {
			if (finish == true) {
				stopclock();
				window.close();
			}
			else {
				finish = true; 
			}
		}

		function startclock() {		
			//stopclock();
			timerID = setInterval("increment()", timeValue);
			
			//window.alert (timerID);
			timerRunning = true;
			document.images.bar.src=image00.src;
		}

		function Send_onclick(frmSubmit) {
			var const_app_ApplicationRoot = 'https://spar.gatewayec.co.za';
			startclock();
			
			for (var i=0;i<=2100000;i++) {
				if (i==2100000) {
					self.parent.location.href=const_app_ApplicationRoot+'/dropship/logout/default.asp';		
				};
			};
		}

		//-->
		</script>		
		
		<head>
		<body onload="return Send_onclick(frmProgressBar)">
		<table border="0" align="center" valign="middle">
			<tr>
				<td class="bheader" align="center">Please wait.</td>
			</tr>
			<tr>
				<td><br><img src="image-00.gif" name="bar" align="middle"></td>
			</tr>
		</table>

		<form name="frmProgressBar" action="<%=const_app_ApplicationRoot%>/finish.asp" method="post">
		</form>		

		</body>
		</html>
<%
	
end sub

'-----------------------------------------
call main


%>

