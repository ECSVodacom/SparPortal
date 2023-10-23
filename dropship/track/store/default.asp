<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/setuserdetails.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>

<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
//-->
</script>
<%
										dim Folder
										dim StrText
										dim NewCount
										dim Counter
										dim StrCount
										dim StrDisplay
										dim oFile
										dim File
										dim DayCount
										dim NoDisplay
										dim NewDate
										
										PageTitle = "Drop Shipment: Track and Trace"

										Select Case Session("UserType")
										Case 1
											' This is a Supplier
											Folder = "supplier"
										Case 2
											' This is a DC
											Folder = "dc"
										Case 3
											' This is a Store
											Folder = "store"
										End Select
										
										NewDate = Year(Now) & "/" & Month(Now) & "/" & Day(Now)
										
										'StrText = "<pre>"
										StrText = StrText & "<!--" & VbCrLf
										StrText = StrText & "var tocTab = new Array();var ir=0;" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('0', 'Date Menu', '');" & VbCrLf
										'StrText = StrText & "tocTab[ir++] = new Array ('0', '', '');" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('1', '" & FormatDate(CDate(NewDate),false) & "', '" & const_app_ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?id=" & FormatDate(CDate(NewDate),false) & "');" & VbCrLf

										NewCount = 0
										DayCount = 0

										For Counter = 2 to 30
											DayCount = DayCount + 1
											StrCount = Counter
											StrDisplay = FormatDate(CDate(NewDate) - DayCount,false)
												
											if Counter >= 9 Then
												if Counter = 9 Then
													StrCount = 9 
												else
													NewCount = NewCount + 1
													StrCount = 9 & "." & NewCount
												end if
													
												if NewCount = 0 Then
													StrDisplay = "Before " & FormatDate(CDate(NewDate) - DayCount,false)
												else
													StrDisplay = FormatDate(CDate(NewDate) - DayCount,false)
												end if
											end if
												
											StrText = StrText & "tocTab[ir++] = new Array ('" & StrCount & "', '" & StrDisplay & "', '" & const_app_ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?id=" & FormatDate(CDate(NewDate) - DayCount,false) & "');" & VbCrLf
										Next
										
										StrText = StrText & "var nCols = 4;" & VbCrLf
										StrText = StrText & "//-->" & VbCrLf
										'StrText = StrText & "</pre>"

										' Create the file system object
										Set oFile = Server.CreateObject("Scripting.FileSystemObject")

										' Open the text file
										'Response.Write "C:\Inetpub\wwwroot\spar\dropship\includes\" & Folder & "datemenu.js"
										'Response.End
										'Set File = oFile.OpenTextFile ("C:\Inetpub\wwwroot\spar\dropship\includes\" & Folder & "datemenu.js",2,True)
										'On Error Resume Next
										'Response.Write const_app_IncludePath & Folder & "datemenu.js"
										'Response.End
										Set File = oFile.OpenTextFile (const_app_IncludePath & Folder & "datemenu.js",2,True)		
										'Response.Write Err.Description			
									
										' write the string to the text file
										File.Write StrText
																						
										' Close the file system object
										Set File = Nothing
										Set oFile = Nothing
%>
<script language="JavaScript" src="../../includes/<%=Folder%>datemenu.js"></script>
<script language="JavaScript" src="../../includes/tocParas.js"></script>
<script language="JavaScript" src="../../includes/displayToc.js"></script>
<!--#include file="../../layout/headclose.asp"-->
<%
										if NoDisplay Then
%>
<body>
<p><img src="<%=const_app_ApplicationRoot%>/images/logos/trackhead.gif" border="0"></p>
<p class="errortext">You are not allowed to access this application.</p>
<p class="pcontent">Please <a href="javascript:history.back(1);">return</a> to the previous page.</p>
</body>
<%
										else
%>
<!--<frameset  rows="105,*" border="0">
	<frame name="frmTop" src="frmtop.asp" scrolling="no" noresize>
	<frameset cols="200,10,*" border="1">
		<frameset rows="50,*" onload="reDisplay('0',true)">
			<frame name="frmtitle" src="frmtitle.asp" scrolling="no" noresize>
			<frame name="toc" src="toc.htm" scrolling="auto" noresize>
		</frameset>
		<frame name="frmMiddle" src="frmmiddle.asp" scrolling="no" noresize>-->
<frameset  rows="117,*" border="0">
	<frame name="frmTop" src="frmtop.asp" scrolling="no" noresize>
	<frameset cols="150,10,*" border="1" onload="reDisplay('0',true)">
		<!--<frameset rows="40 ,*" onload="reDisplay('0',true)">
			<frame name="frmtitle" src="frmtitle.asp" scrolling="no" noresize>-->
			<frame name="toc" src="toc.htm" scrolling="auto" noresize>
		<!--</frameset>-->
		<frame name="frmMiddle" src="frmmiddle.asp" scrolling="no" noresize>
		<frame name="frmcontent" src="frmcontent.asp?id=<%=FormatDate(CDate(NewDate),false)%>" scrolling="auto" noresize>
	</frameset>
</frameset>
<noframes>
<body>
please obtain a frames-capable browser
</body>
</noframes>
<%
										end if
%>
</html>
