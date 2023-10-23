<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<%

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

%>

<frameset  rows="117,*" border="0">
	<frame name="frmTop" src="frmtop.asp" scrolling="no" noresize>
	<!--<frameset cols="1000,*" border="1">
		<frameset rows="50,*">
			<frame name="frmtitle" src="frmtitle.asp" scrolling="no" noresize>
			<frame name="toc" src="toc.htm" scrolling="auto" noresize>
		</frameset>
		<frame name="frmMiddle" src="frmmiddle.asp" scrolling="no" noresize>-->
		<frame name="frmcontent" src="frmcontent.asp" scrolling="auto" noresize>
	<!--</frameset>-->
</frameset>
<noframes>
<body>
Please obtain a frames-capable browser.
</body>
</noframes>
</html>

