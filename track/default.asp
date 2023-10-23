<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>

<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
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
										
										PageTitle = "SPAR Portal"

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
										
										'NewDate = Year(Now) & "/" & Month(Now) & "/" & Day(Now)
										
										'StrText = "<pre>"
										StrText = StrText & "<!--" & VbCrLf
										StrText = StrText & "var tocTab = new Array();var ir=0;" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('0', 'Menu', '');" & VbCrLf
										'StrText = StrText & "tocTab[ir++] = new Array ('0', '', '');" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('1', 'Distribution Centre', '" & const_app_ApplicationRoot & "/track/frmcontent.asp?id=DC" & "');" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('1.1', 'Reports', '" & const_app_ApplicationRoot & "/track/frmcontent.asp?id=DCReport" & "');" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('1.1.1', 'Statistical Data', '" & const_app_ApplicationRoot & "/report/stats/default.asp" & "');" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('1.1.2', 'Supplier Compliance per Buyer', '" & const_app_ApplicationRoot & "/report/supplier/default.asp" & "');" & VbCrLf
										
										' Disable Seminars
									If False Then
										' Determine what DC is logging in
										Select Case Session("UserType")
										Case 1
											' SR DC logged in
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3', 'Seminars (SR)', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar/default.asp?dc=1" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.2', 'Seminars - Phase 2', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=1" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.3', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=1" & "');" & VbCrLf
										Case 2
											' NR DC logged in
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3', 'Seminars (NR)', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=2" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.2', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=2" & "');" & VbCrLf
										Case 3
											' KZN DC logged in
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3', 'Seminars (KZN)', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=3" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.2', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=3" & "');" & VbCrLf
										Case 4
											' EC DC logged in
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3', 'Seminars (EC)', '');" & VbCrLf											
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=4" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.2', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=4" & "');" & VbCrLf
										Case 5
											' WC DC logged in
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3', 'Seminars (WC)', '');" & VbCrLf						
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=5" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.2', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=5" & "');" & VbCrLf
										Case Else
											' Call centre user logged in
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3', 'Seminars (SR)', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar/default.asp?dc=1" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.2', 'Seminars - Phase 2', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=1" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.3.3', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=1" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.4', 'Seminars (NR)', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.4.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=2" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.4.2', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=2" & "');" & VbCrLf
											
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.5', 'Seminars (KZN)', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.5.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=3" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.5.2', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=3" & "');" & VbCrLf
											
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.6', 'Seminars (EC)', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.6.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=4" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.6.2', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=4" & "');" & VbCrLf											
											
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.7', 'Seminars (WC)', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.7.1', 'Seminars - Phase 1', '" & const_app_ApplicationRoot & "/report/seminar_phase2/default.asp?dc=5" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.1.7.2', 'Totals', '" & const_app_ApplicationRoot & "/report/seminar_phase2/totals.asp?dc=5" & "');" & VbCrLf											
										End Select
									End If

									
										if Session("Permission") = 2 then
											StrText = StrText & "tocTab[ir++] = new Array ('1.2', 'Administration', '" & const_app_ApplicationRoot & "/track/frmcontent.asp?id=DCAdmin" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.1', 'Buyers', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.1.1', 'List Buyers', '" & const_app_ApplicationRoot & "/admin/dc/buyer');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.1.2', 'Add new Buyer', '" & const_app_ApplicationRoot & "/admin/dc/buyer/item.asp');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.1.3', 'Track a Buyer', '" & const_app_ApplicationRoot & "/admin/dc/buyer/search/default.asp');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.2', 'Suppliers', '');" & VbCrLf										
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.2.1', 'List Suppliers', '" & const_app_ApplicationRoot & "/admin/dc/supplier');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.2.2', 'Add new Supplier', '" & const_app_ApplicationRoot & "/admin/dc/supplier/item.asp');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.3', 'Lookup', '" & const_app_ApplicationRoot & "/admin/dc/password/');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.4', 'Generate Mail', '" & const_app_ApplicationRoot & "/admin/dc/mail/');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('1.2.5', 'Order Search', '" & const_app_ApplicationRoot & "/OrderSearch/');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2', 'Drop Shipment', '" & const_app_ApplicationRoot & "/track/frmcontent.asp?id=DS" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.1', 'Reports', '" & const_app_ApplicationRoot & "/track/frmcontent.asp?id=DSReport" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2', 'Administration', '" & const_app_ApplicationRoot & "/track/frmcontent.asp?id=DSAdmin" & "');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.1', 'Stores', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.1.1', 'List Stores', '" & const_app_ApplicationRoot & "/admin/ds/store/');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.1.2', 'Add new Store', '" & const_app_ApplicationRoot & "/admin/ds/store/item.asp');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.2', 'Suppliers', '');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.2.1', 'List Suppliers', '" & const_app_ApplicationRoot & "/admin/ds/supplier');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.2.2', 'Add new Supplier', '" & const_app_ApplicationRoot & "/admin/ds/supplier/item.asp');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.2.3', 'Create new Supplier', '" & const_app_ApplicationRoot & "/admin/ds/supplier/CreateSupplier.asp');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.3', 'Search', '" & const_app_ApplicationRoot & "/admin/ds/search/default.asp');" & VbCrLf
											StrText = StrText & "tocTab[ir++] = new Array ('2.2.4', 'Lookup', '" & const_app_ApplicationRoot & "/admin/ds/password/default.asp');" & VbCrLf
											
											'StrText = StrText & "tocTab[ir++] = new Array ('3', 'Ackermans', '" & const_app_ApplicationRoot & "/track/frmcontent.asp?id=AckAdmin" & "');" & VbCrLf
											'StrText = StrText & "tocTab[ir++] = new Array ('3.1', 'Suppliers', '" & const_app_ApplicationRoot & "/admin/ack/supplier/default.asp');" & VbCr
											'StrText = StrText & "tocTab[ir++] = new Array ('3.1.1', 'List Suppliers', '" & const_app_ApplicationRoot & "/admin/ack/supplier/default.asp');" & VbCr
											'StrText = StrText & "tocTab[ir++] = new Array ('3.1.2', 'Add new Supplier', '" & const_app_ApplicationRoot & "/admin/ack/supplier/item.asp');" & VbCr
											'StrText = StrText & "tocTab[ir++] = new Array ('3.2', 'Search', '" & const_app_ApplicationRoot & "/admin/ack/search/default.asp');" & VbCr
'											StrText = StrText & "tocTab[ir++] = new Array ('3.3', 'Password Lookup', '" & const_app_ApplicationRoot & "/admin/ack/password/default.asp');" & VbCr
'											StrText = StrText & "tocTab[ir++] = new Array ('3.4', 'Generate Email', '" & const_app_ApplicationRoot & "/admin/ack/mail/default.asp');" & VbCr
											
											StrText = StrText & "tocTab[ir++] = new Array ('4', 'System Monitor', '" & const_app_ApplicationRoot & "/track/frmcontent.asp?id=Monitor" & "');" & VbCrLf
											
											NewCount = 0
											DayCount = 0
											
											For Counter = 1 to 7
												StrCount = Counter
												StrDisplay = FormatLongDate(Date - DayCount,false)
												
												NewCount = NewCount + 1
												StrCount = 4 & "." & NewCount
													
												StrDisplay = FormatLongDate(Date - DayCount,false)
												
												StrText = StrText & "tocTab[ir++] = new Array ('" & StrCount & "', '" & StrDisplay & "', '" & const_app_ApplicationRoot & "/monitor/default.asp?id=" & FormatLongDate(Date - DayCount,false) & "');" & VbCrLf
												
												DayCount = DayCount + 1
											Next											
											
											StrText = StrText & "tocTab[ir++] = new Array ('5', 'Logout', '" & const_app_ApplicationRoot & "/logout/default.asp" & "');" & VbCrLf
										else
											StrText = StrText & "tocTab[ir++] = new Array ('2', 'Logout', '" & const_app_ApplicationRoot & "/logout/default.asp" & "');" & VbCrLf
										
										'StrText = StrText & "tocTab[ir++] = new Array ('5', 'Logout', '" & const_app_ApplicationRoot & "/logout/progressbar.asp" & "');" & VbCrLf
										'else
										'	StrText = StrText & "tocTab[ir++] = new Array ('2', 'Logout', '" & const_app_ApplicationRoot & "/logout/progressbar.asp" & "');" & VbCrLf
										
										end if
	
										StrText = StrText & "var nCols = 4;" & VbCrLf
										StrText = StrText & "//-->" & VbCrLf
										'StrText = StrText & "</pre>"
										
										
										' Create the file system object
										Set oFile = Server.CreateObject("Scripting.FileSystemObject")
										' Open the text file
										'		Response.Write const_app_PortalPath & "includes\portalmenu.js"
										'Response.End		
										Set File = oFile.OpenTextFile (const_app_PortalPath & "includes\portalmenu.js",2,True)
																						
										' write the string to the text file
										File.Write StrText
																		
										' Close the file system object
										Set File = Nothing
										Set oFile = Nothing
%>
<script language="JavaScript" src="../includes/portalmenu.js"></script>
<script language="JavaScript" src="../includes/tocParas.js"></script>
<script language="JavaScript" src="../includes/displayToc.js"></script>
<!--#include file="../layout/headclose.asp"-->
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
<frameset rows="117,*" border="0">
	<frame name="frmTop" src="frmtop.asp" scrolling="no" noresize>
	<frameset cols="200,5,*" border="1" onload="reDisplay('0',true)">
		<!--<frameset rows="40 ,*" onload="reDisplay('0',true)">
			<frame name="frmtitle" src="frmtitle.asp" scrolling="no" noresize>-->
			<frame name="toc" src="toc.htm" scrolling="auto" noresize>
		<!--</frameset>-->
		<frame name="frmMiddle" src="frmmiddle.asp" scrolling="no" noresize>
		<frame name="frmcontent" src="frmcontent.asp?id=Home" scrolling="auto" noresize>
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
