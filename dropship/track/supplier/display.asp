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

										dim curConnection
										dim SQL
										dim ReturnSet
										dim ErrorFlag
										dim CreateCookie
										dim UsType

										ErrorFlag = 0
										
										' Check if the user selected to login
										if Request.Cookies("DSLogin") <> "" Then

											' Set the connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											' Create the SQL for the cookie login
											SQL = "exec procCookieLogin @LoginName=" & MakeSQLText(Request.Cookies("DsLogin"))
												
											CreateCookie = False
																						
											'Response.Write SQL
											'Response.End

											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 Then
												' An error occured - Set the error flag
												ErrorFlag = 1
												
												' Close the Recodset
												Set ReturnSet = Nothing
																				
												' Close the connection
												curConnection.Close
												Set curConnection = Nothing
												
												Response.Redirect const_app_ApplicationRoot
												
											else
												' No error occured - Log the user into the site
												' Check if the user has to change his password
												if ReturnSet("ChangePwd") = 1 Then
													' redirect the user to the change password screen
													Response.Redirect const_app_ApplicationRoot & "/profile/default.asp?id=" & Request.Form("txtUserName")
												else
													' Set the Session variables
													Call SetUserDetails (ReturnSet("UserID"), ReturnSet("UserName"), ReturnSet("FirstName"), ReturnSet("UserType"), ReturnSet("Permission"), ReturnSet("PhysAddress"), ReturnSet("ProcID"), ReturnSet("ProcEAN"), ReturnSet("ProcName"), ReturnSet("IsXML"))
													
													' Close the Recodset
													Set ReturnSet = Nothing
																					
													' Close the connection
													curConnection.Close
													Set curConnection = Nothing
													
												end if
											end if
										else 'no cookies availiable
											Response.Redirect const_app_ApplicationRoot
										end if
										
										

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
										
										Dim url
										url = request.QueryString
										
										PageTitle = "Drop Shipment: Track and Trace"

										Select Case Session("UserType")
										Case 1
											' This is a Supplier
											Folder = "supplier"
										Case 2
											' This is a DC
											Folder = "supplier"
										Case 3
											' This is a Store
											Folder = "supplier"
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
										Set File = oFile.OpenTextFile (const_app_IncludePath & Folder & "datemenu.js",2,True)
																						
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
										'response.Redirect("viewfile.asp?" & url)
										'response.End()
%>
<frameset  rows="117,*" border="0">
	<frame name="frmTop" src="frmtop.asp" scrolling="no" noresize>
	<frameset cols="150,10,*" border="1" onload="reDisplay('0',true)">
		<!--<frameset rows="40 ,*" onload="reDisplay('0',true)">
			<frame name="frmtitle" src="frmtitle.asp" scrolling="no" noresize>-->
			<frame name="toc" src="toc.htm" scrolling="auto" noresize>
		<!--</frameset>-->
		<frame name="frmMiddle" src="frmmiddle.asp" scrolling="no" noresize>
		<frame name="frmcontent" src="viewfile.asp?<%=url%>" scrolling="auto" noresize>
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
