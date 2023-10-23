<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--Store val -->
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="includes/mqtoswitch.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<%
	response.buffer = true
	response.flush
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
	
	function partialSupSearch(){
		if (document.FrmSearch.elements['txtPartialSup'].value==''){
			window.alert('You have to enter partial supplier name.');
			document.FrmSearch.elements['txtPartialSup'].focus();
			return false;	
		}
		var parNameSearch = document.FrmSearch.elements['txtPartialSup'].value;
		window.open('../search/partial_search.asp?value=' + parNameSearch + '&type=Store','PartialSearch', 'width=600,height=400,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');
	}

	function setSupplierSelectedVal() {
		// Set the selected supplier index
		document.FrmSearch.elements['hidSupplier'].value = document.FrmSearch.drpSupplier.options[document.FrmSearch.elements['drpSupplier'].selectedIndex].value;
	}
//-->
</script>
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<%

										dim curConnection
										dim SQL
										dim ReturnSet
										dim cnt
										dim stroreID
										dim erro
										dim sResult
										dim oFile
										dim cFile
										dim storeID
										dim Folder
										dim NewDate
										dim IsXML
										dim StoreName
										dim allExcept
										Dim UserID
										Dim UserType
										dim Selected
										dim strDC
										dim strSupplier
										
										UserID = Session("ProcID")
										UserType = Session("UserType")
										
										if Session("ProcEAN") = "GATEWAYCALLCEN" or Session("ProcEAN") = "SPARHEADOFFICE" then
											UserType = 2
											UserID = 0
										end if
																				
										allExcept = true
										
										if Request.Form("txtDate") <> "" then
											Session("dispDate") = Month(Request.Form("txtDate")) & "/" & Day(Request.Form("txtDate")) & "/" & Year(Request.Form("txtDate"))
											Session("curDate") = Year(Request.Form("txtDate")) & "/" & Month(Request.Form("txtDate")) & "/" & Day(Request.Form("txtDate"))
											
											allExcept = false
										else
											Session("dispDate") = ""
											Session("curDate") = ""
										end if
										
										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
																				
										erro = 0
										
										'Response.Write(Request.Form("hidAction"))
										'Response.End 
										
										NewDate = Year(Now) & "/" & Month(Now) & "/" & Day(Now)
										
										' Call the menu items generation function
										Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate, IsXML)

										if Session("UserID") = "" then
											Session("UserID") = 0
										end if										

										if CInt(Request.Form("hidAction")) > 0 then
											' Set a connection
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											SQL = "exec addExceptionAudit @ExceptID=" & Request.Form("hidMessID") & _
												", @UserID=" & Session("UserID") & _
												", @Action=" & Request.Form("hidAction") & _
												", @StoreEAN=" & MakeSQLText(Request.Form("hidStoreEAN"))
												
												'response.write SQL
												'response.end
												
											' Get a list of Stores
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											if ReturnSet("returnvalue") <> 0 then
												erro = 1
											end if
												
											Set ReturnSet = Nothing
											curConnection.close
											Set curConnection = Nothing											
											
											if Request.Form("hidAction") = "1" and erro = 0 then
												' Create a file
												Set oFile = Server.CreateObject("Scripting.FileSystemObject")
												
												Set cFile = oFile.CreateTextFile(const_app_MQPath & Request.Form("hidFileRef") & ".in",true)
												
												cFile.WriteLine Request.Form("hidFileRef")
												
												Set cFile = Nothing
												
												Set oFile = Nothing
											
												sResult = MQFile (Request.Form("hidType"), Request.Form("hidFileRef"))
											end if
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/calendar2.js"></script>
<script language="javascript">
<!--
		if (<%=erro%>==1) {
			window.alert('The selected exception (' + '<%=request.form("hidMessNum")%>' + ') can not be released. \nYou will need to either add the new store or set the store to a live status and then try again');
		};	
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" onload="setSupplierSelectedVal();">
<br><br>
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="bheader" align="left">Store Validation - Exceptions</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<form name="FrmSearch" id="FrmSearch" method="post" action="default.asp">
<table cellSpacing="0" cellPadding="0" border="0">
	<tr>
		<td>
			<table cellSpacing="4" cellPadding="2" border="0">
				<tr>
					<td class="pcontent" colspan="2">Select a date and click on the seach buton to seach for archive records</td>				
				</tr>
				<tr bgColor="#f0f8ff" class="pcontent">
					<td>DC:</td>
					<td>
						<select name="drpDC" id="drpDC" class="pcontent">
<%
										if Session("DCID") = 0 then
											if (UserType <> 2) OR (UserID = 0) then
%>
							<option value="-1">-- Select a DC --</option>
<%
											End IF
										end if
											
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
													
										' Get a list of Stores
										Dim SQLStr
										
										SQLStr = "exec listDC"
										'if (UserType = 2) AND (UserID <> 0) then
										'	SQLStr = SQLStr & " @DC=" & UserID
										'end if
										
										'if Session("DCID") <> 0 then
											SQLStr = SQLStr & " @DC=" & Session("DCID")
										'end if
										
										Set ReturnSet = ExecuteSql(SQLStr, curConnection)
													
										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											If (UserType = 2) Then
												if UserID = ReturnSet("DCID") Then
													Selected = "selected"
												else
													Selected = ""
												end if
											End If
%>
							<option <%=Selected%> value="<%=ReturnSet("DCID")%>"><%=ReturnSet("DCcName")%></option>
<%											
											ReturnSet.MoveNext
										Wend
										
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>									
						</select>
					</td>
				</tr>
				<tr bgColor="#f0f8ff" class="pcontent">
					<td >Supplier:</td>
					<td >
						<select name="drpSupplier" id="drpSupplier" class="pcontent"  onchange="setSupplierSelectedVal();">
<%
										if (UserType <> 1 And UserType<>4) OR (UserID = 0) then
%>
							<option value="-1">-- Select a Supplier --</option>
<%
										End If
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
													
										
										Set ReturnSet = ExecuteSql("listSupplier @SupplierID=" & UserID & ", @UserType=" & UserType & ", @DCId=" & Session("DCId"), curConnection) 
												
										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											If (UserType = 1 Or UserType = 4) Then
												if UserID = ReturnSet("SupplierID") Then
													Selected = "selected"
												else
													Selected = ""
												end if
											End If
%>
							<option <%=Selected%> value="<%=ReturnSet("SupplierEAN")%>"><%=ReturnSet("SupplierName")%></option>
<%											
											ReturnSet.MoveNext
										Wend
													
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>									
						</select>
					</td>
<%
									If CInt(Session("UserType")) <> 1 and CInt(Session("UserType")) <> 4 then
%>					
					<td class="pcontent"><b>OR</b></td>
					<td class="pcontent">Supplier Partial Name</td>
					<td><input type="text" name="txtPartialSup" id="txtPartialSup" class="pcontent" size="60"><button name="btnFilter" id="btnFilter" value="Find" class="button" OnClick="javascript:partialSupSearch();">Find</button></td>
<%
									end if	
%>					
				</tr>
				<tr vAlign="top" bgColor="#f0f8ff" class="pcontent">
					<td >Select Date: </td>
					<td>								
							<input type="text" name="txtDate" id="txtDate" value="<%=Session("dispDate")%>" class="pcontent" size="25" readonly="true">
							<a href="javascript:cal5.popup();"><img align="top" border="0" height="21" id="FromDateImg" src="../Calendar/calendar.gif" style="POSITION: relative" width=34></a><br>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<input type="submit" id="UpdateDisplayButton" value="Search" class="button">&nbsp;
						<a class="menu" href="<%=const_app_ApplicationRoot%>/storeval/default.asp">View all exceptions</a>
						<input type="hidden" name="hidSearch" id="hidSearch" value="1">
						<input type="hidden" name="hidSupplier" id="hidSupplier" value="-1">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table><br>
</form>				
	<table border="0" cellpadding="4" cellspacing="1" class="tbl">
<%
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										if request.querystring("exceptid") = "" then
											if allExcept then
												SQL = "exec listStoreValExcept_New @All=1"
											else
												SQL = "exec listStoreValExcept_New @Date=" & MakeSQLText(Session("curDate"))
											end if
										else
											SQL = "exec listStoreValExcept_New @ID=" & request.querystring("exceptid")
										end if

										'Response.write SQL
										'Response.end
										'Response.Write("Search" & request.Form("HidSearch"))
										if (request.Form("HidSearch") <> "1") then
											if Session("UserType") = 1 Or Session("UserType") = 4 Then
												SQL = SQL & ", @Supplier=" & MakeSQLText(Session("ProcEAN"))		
											end if
										
											if (Session("UserType") = 2) AND (UserID <> 0) Then
												SQL = SQL & ", @DC=" & UserID		
											'end if
											else
											
												if Session("DCID") <> 0 then
													SQL = SQL & ", @DC=" & Session("DCID")	
												end if
											end if
										Else
										'Response.Write("ELSE")
											if request.Form("hidSupplier") <> "-1" Then
												SQL = SQL & ", @Supplier=" & MakeSQLText(request.Form("hidSupplier"))		
											end if
											
											if (request.Form("drpDC") <> "-1") Then
												SQL = SQL & ", @DC=" & request.Form("drpDC")	
											end if
										end if
										
										if request.Form("hidAction") = "0" or request.Form("hidAction") = "" then
											strSupplier = Session("ProcEAN")
											strDC = "-1"
										else
											strSupplier = request.Form("hidSupplier")
											strDC = request.Form("drpDC")
											
										end if

										' Get a list of Stores
										'Response.write("<br>" & SQL)
										'Response.EnD
										Set ReturnSet = ExecuteSql(SQL, curConnection)
										
										if ReturnSet("returnvalue") <> 0 then
											' no exceptions
%>
		<tr>
			<td class="pcontent">There are no store validation exception records for the selected date.</td>
		</tr>
<%											
										else
%>
		<tr>
<%
											'if Session("UserType") = 1 Then
%>
			<!--<td class="pcontent" colspan="10">Below is a list of all store validation exceptions. You can just view it. You don't have permission to delete / fix / release the exception.<br><br></td>-->
<%
											'Else
%>
			<td class="pcontent" colspan="10">Below is a list of up to 100 store validation exceptions. You can either delete the selected exception or you can fix / release the exception by clicking on the "Delete", "Fix" or "Release" action buttons.<br><br></td>
<%
											'end if
%>
		</tr>
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent"><b>Message Number</b></td>
			<td class="tdcontent"><b>Message Type</b></td>
			<td class="tdcontent"><b>DC Name</b></td>
			<td class="tdcontent"><b>DC EAN</b></td>
			<td class="tdcontent"><b>Store Name</b></td>
			<td class="tdcontent"><b>Store EAN</b></td>
			<td class="tdcontent"><b>Supplier Name</b></td>
			<td class="tdcontent"><b>Supplier EAN</b></td>
			<td class="tdcontent"><b>Date Received</b></td>
			<td class="tdcontent"><b>Detailed Exception</b></td>
<%
												'If Session("UserType") <> 1 Then
%>
			<td class="tdcontent"><b>Action</b></td>
<%
												'End IF
%>
		</tr>
<%
											' Loop through the recordset
											While not ReturnSet.EOF
												cnt = cnt + 1
												
												if IsNull(ReturnSet("StoreID")) or ReturnSet("StoreID") = "" then
													storeID = 0
												else
													storeID = ReturnSet("StoreID")
												end if
												
												if IsNull(Returnset("StoreName")) then 
													if IsNull(Returnset("StoreDisName")) then 
														StoreName = "-" 
													else 
														StoreName = Returnset("StoreDisName") 
													end if 
												else 
													StoreName = Returnset("StoreName") 
												end if
												
												'if cnt = 238 or cnt = 237 Then
												'	Response.Write(Returnset("MessageID") & " MessageID<br/>")
												'	Response.Write(storeID & " StoreID<br/>")
												'	Response.Write(StoreName & " StoreName<br/>")
												'	Response.Write(ReturnSet("StoreMail") & " StoreMail<br/>")
												'	Response.Write(ReturnSet("StoreEAN") & " StoreEAN<br/>")
												'	Response.Write(ReturnSet("DCID") & " DCID<br/>")
												'	'response.End
												'end if
												
%>
		<tr>
			<td class="tbldata"><%=Returnset("MessageNumber")%></td>
			<td class="tbldata"><%=Returnset("MessageType")%></td>
			<td class="tbldata"><%if IsNull(Returnset("DCName")) then Response.Write "-" else Response.Write Returnset("DCName") end if%></td>
			<td class="tbldata"><%if IsNull(Returnset("DCEAN")) then Response.Write "-" else Response.Write Returnset("DCEAN") end if%></td>
			<td class="tbldata"><%=Replace(StoreName,Chr(10)," ")%>&nbsp;</td>
			<td class="tbldata"><%if IsNull(Returnset("StoreEAN")) then Response.Write "-" else Response.Write Replace(Returnset("StoreEAN"),Chr(10)," ") end if%></td>
			<td class="tbldata"><%if IsNull(Returnset("SupplierName")) then Response.Write "-" else Response.Write Replace(Returnset("SupplierName"),Chr(10)," ") end if%></td>
			<td class="tbldata"><%if IsNull(Returnset("SupplierEAN")) then Response.Write "-" else Response.Write Replace(Returnset("SupplierEAN"),Chr(10)," ") end if%></td>
			<td class="tbldata"><%=Returnset("DateReceived")%></td>
			<td class="tbldata"><%=Returnset("Exception")%></td>
<%
												Dim Admin
												Admin = false
												
												'response.Write(Session("UserType"))
												If Session("UserType") = 1 Then
													if Ucase(Returnset("MessageType")) = "INVOICE" or Ucase(Returnset("MessageType")) = "CREDIT" Then
														Admin = True
													End IF
												else
													Admin = True
												end if
												If Admin Then
												'if cnt = 238 Then
												'response.End
												'end if
%>
			<td class="tbldata">
				<form name="FrmExcept<%=cnt%>" id="FrmExcept<%=cnt%>" method="post" action="default.asp">
					<input type="button" name="btnFix" id="btnFix" value="Fix" class="button" onclick="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/admin/ds/store/item.asp?messid=<%=Returnset("MessageID")%>&id=<%=storeID%>&type=1&storename=<%=Replace(StoreName,Chr(10)," ")%>&storemail=<%=ReturnSet("StoreMail")%>&storeean=<%=Replace(ReturnSet("StoreEAN"),Chr(10)," ")%>&dcid=<%=ReturnSet("DCID")%>', 'StoreDetail', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');">
					<input type="submit" name="btnDelete" id="btnDelete" value="Delete" class="button" onclick="JavaScript: document.FrmExcept<%=cnt%>.hidAction.value=2">
					<input type="submit" name="btnRelease" id="btnRelease" value="Release" class="button" onclick="JavaScript: document.FrmExcept<%=cnt%>.hidAction.value=1">
					<input type="hidden" name="hidAction" id="hidAction" value="0">
					<input type="hidden" name="hidMessID" id="hidMessID" value="<%=Returnset("MessageID")%>">
					<input type="hidden" name="hidFileRef" id="hidFileRef" value="<%=Returnset("FileRef")%>">
					<input type="hidden" name="hidType" id="hidType" value="<%=Returnset("MessageType")%>">
					<input type="hidden" name="txtDate" id="txtDate" value="<%=Session("dispDate")%>">
					<input type="hidden" name="hidStoreEAN" id="hidStoreEAN" value="<%=Returnset("StoreEAN")%>">
					<input type="hidden" name="hidMessNum" id="hidMessNum" value="<%=Returnset("MessageNumber")%>">
					
					<input type="hidden" name="drpDC" id="drpDC" value="<%=strDC%>">
					<input type="hidden" name="drpSupplier" id="drpSupplier" value="<%=strSupplier%>">
					<!--<input type="hidden" name="txtDate" id="txtDate" value="<%=MakeSQLText(Session("curDate"))%>">-->
					<input type="hidden" name="hidSearch" id="hidSearch" value="1">
					
				</form>
			</td>
<%
												Else
%>
			<td class="tbldata">You don't have permission to administrate this message
			</td>
<%
												End IF
%>
		</tr>
	
<%											
												ReturnSet.MoveNext
											Wend
										end if
													
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
										
%>									
	</table>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	
		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>
<script language="JavaScript">
<!-- // create calendar object(s) just after form tag closed
	 // specify form element as the only parameter (document.forms['formname'].elements['inputname']);
	 // note: you can have as many calendar objects as you need for your application
	var cal5 = new calendar2(document.forms['FrmSearch'].elements['txtDate']);
	cal5.year_scroll = true;
	cal5.time_comp = false;
//-->
</script>
<!--#include file="../layout/end.asp"-->
