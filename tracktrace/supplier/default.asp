<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/setuserdetails.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%
										' Determine if the user is logged in
										Call CookieLoginTrackCheck(const_app_ApplicationRoot & "/tracktrace/supplier/default.asp")
										
										dim StrText
										dim NewCount
										dim Counter
										dim StrCount
										dim StrDisplay
										dim oFile
										dim File
										dim DayCount
										dim NoDisplay
										
										PageTitle = "Track and Trace : Supplier"
										
										' Check if the user is a supplier
										if Session("UserType") <> 2 Then
											NoDisplay = True
										else
											NoDisplay = False
											'StrText = "<pre>"
											StrText = StrText & "<!--" & VbCrLf
											StrText = StrText & "var tocTab = new Array();var ir=0;" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('0', 'Date Menu', '" & const_app_ApplicationRoot & "/tracktrace/supplier/frmcontent.asp?id=" & FormatLongDate(Date,false) & "');" & VbCrLf
											'StrText = StrText & "tocTab[ir++] = new Array ('0', 'Date Menu', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1', '" & FormatLongDate(Date,false) & "', '" & const_app_ApplicationRoot & "/tracktrace/supplier/frmcontent.asp?id=" & FormatLongDate(Date,false) & "');" & VbCrLf

											NewCount = 0
											DayCount = 0

											For Counter = 2 to 30
												DayCount = DayCount + 1
												StrCount = Counter
												StrDisplay = FormatLongDate(Date - DayCount,false)
												
												if Counter >= 9 Then
													if Counter = 9 Then
														StrCount = 9 
													else
														NewCount = NewCount + 1
														StrCount = 9 & "." & NewCount
													end if
													
													if NewCount = 0 Then
														StrDisplay = "Before " & FormatLongDate(Date - DayCount,false)
													else
														StrDisplay = FormatLongDate(Date - DayCount,false)
													end if
												end if
												
												StrText = StrText & "tocTab[ir++] = new Array ('" & StrCount & "', '" & StrDisplay & "', '" & const_app_ApplicationRoot & "/tracktrace/supplier/frmcontent.asp?id=" & FormatLongDate(Date - DayCount,false) & "');" & VbCrLf
											Next
										
											StrText = StrText & "var nCols = 4;" & VbCrLf
											StrText = StrText & "//-->" & VbCrLf
											'StrText = StrText & "</pre>"
										
											' Create the file system object
											Set oFile = Server.CreateObject("Scripting.FileSystemObject")

											' Open the text file
											Set File = oFile.OpenTextFile (const_app_IncludePath & "suppliernav.js",2,True)
																					
											' write the string to the text file
											File.Write StrText
																					
											' Close the file system object
											Set File = Nothing
											Set oFile = Nothing
										end if
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script language="JavaScript" src="../../includes/suppliernav.js"></script>
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
<frameset  rows="117,*" border="0">
	<frame name="frmTop" src="<%=const_app_ApplicationRoot%>/tracktrace/supplier/frmtop.asp" scrolling="no" noresize>
		<frameset  cols="200,5,*" border="0" onload="reDisplay('0',true)">
			<!--<frameset  rows="50,*" onload="reDisplay('0',true)">
				<frame name="frmtitle" src="<%=const_app_ApplicationRoot%>/tracktrace/supplier/frmtitle.asp" scrolling="no" noresize>-->
				<frame name="toc" src="<%=const_app_ApplicationRoot%>/tracktrace/supplier/toc.htm" scrolling="auto" noresize>
			<!--</frameset>-->
			<frame name="frmMiddle" src="<%=const_app_ApplicationRoot%>/tracktrace/supplier/frmmiddle.asp" scrolling="no" noresize>
			<frame name="frmcontent" src="<%=const_app_ApplicationRoot%>/tracktrace/supplier/frmcontent.asp?id=<%=FormatLongDate(Date,false)%>" scrolling="auto" noresize>
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
