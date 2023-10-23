<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="Formatting.asp"-->
<!--#include file="../../includes/genmenuitems.asp"-->




<%
										
									 
										if Request.Form("hidAction") <> "1" then
											if request.QueryString("id") = "" Then
												Session("IsLoggedIn") = 0
											end if
										end if 
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	/*if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('1.You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
	
	if (<%=Session("ProcEAN")%> = "") {
		window.alert ('2.You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};*/
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
										dim ReportConnection
										dim StoreCurConnection
										dim dcConnection
										Dim dcSQL
										dim SQL
										Dim StoreSQL
										dim ReturnSet
										Dim StoreReturnSet
										Dim dcReturnSet
										dim MCount
										dim TestDate
										dim NewDate
										Dim counter
										dim XMLString
										Dim DisplaySet
										Dim XMLDoc
										Dim XSLDoc
										Dim CustomDate
										Dim Folder
										dim IsXML
										Dim UserID
										Dim UserType
										dim Selected
										dim dcID
										
										Dim SelectedDCName
										SelectedDCName = "All"
										dcID = 0
										UserID = Session("ProcID")
										UserType = Session("UserType")
										
										if Session("ProcEAN") = "GATEWAYCALLCEN" or Session("ProcEAN") = "SPARHEADOFFICE" then
											UserType = 2
											UserID = 0
										else
											if session("DCID") = "" then
										        dcID = 0
										    else
												If IsNumeric(session("DCID")) Then
													dcID = CInt(session("DCID"))
												Else
													dcID = 0
												End If
										    end if
										end if
										
										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
																													
										'Call the menu items generation function
										Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate, IsXML)
										
																				
										'CustomDate = Month(now()) & "/" & Day(now()) & "/" & Year(Now())
										CustomDate = LZ(Day(now())) & "-" & LZ(Month(now())) & "-" & Year(now())
										
										'Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
									
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>
<script type="text/javascript" language="JavaScript" src="../../includes/calendar1.js"></script>
<script type="text/javascript" language="JavaScript" src="../../includes/calendar2.js"></script>
<script language="JavaScript1.2" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="javascript">
<!--

	function partialSupSearch(){
	
		if (document.FrmSearch.elements['txtPartialSup'].value==''){
			window.alert('You have to enter partial supplier name.');
			document.FrmSearch.elements['txtPartialSup'].focus();
			return false;	
		}
		var parNameSearch = document.FrmSearch.elements['txtPartialSup'].value;
		var dcId = document.FrmSearch.elements['drpDC'].value;
		window.open('../../search/partial_search.asp?value=' + parNameSearch + '&type=Stats&DCId=' + dcId,'PartialSearch', 'width=600,height=400,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');
	}

	function setSupplierSelectedVal() {
		// Set the selected supplier index
		document.FrmSearch.elements['hidSupplier'].value = document.FrmSearch.drpSupplier.options[document.FrmSearch.elements['drpSupplier'].selectedIndex].value;
	}

	function validate(obj) {
		// validate the FromDate
		if (!validateDate(obj.FromDate, obj.FromDate.value, "From Date")) return false;
		// validate the ToDate
		if (!validateDate(obj.ToDate, obj.ToDate.value, "To Date")) return false;
	};
	
	function validateDate(str_obj, str_date, str_type) {
		var RE_NUM = /^\-?\d+$/;
		var arr_date = str_date.split('-');

		if (arr_date.length != 3) {			window.alert ("Invalid " + str_type + " format: '" + str_date + "'.\nFormat accepted is dd-mm-yyyy.");
			str_obj.focus();			return false;			};
		if (!arr_date[0]) { 			window.alert ("Invalid date format: '" + str_date + "'.\nNo day of month value can be found.");
			str_obj.focus();			return false;		};		
		if (!RE_NUM.exec(arr_date[0])) {			window.alert ("Invalid day of month value: '" + arr_date[0] + "'.\nAllowed values are unsigned integers.");
			str_obj.focus();			return false;
		};						
		if (!arr_date[1]) {			window.alert ("Invalid date format: '" + str_date + "'.\nNo month value can be found.");
			str_obj.focus();			return false;
		};			
		if (!RE_NUM.exec(arr_date[1])) {			window.alert ("Invalid month value: '" + arr_date[1] + "'.\nAllowed values are unsigned integers.");
			str_obj.focus();			return false;
		};			
		if (!arr_date[2]) {			window.alert ("Invalid date format: '" + str_date + "'.\nNo year value can be found.");
			str_obj.focus();			return false;
		};			
		if (!RE_NUM.exec(arr_date[2])) {			window.alert ("Invalid year value: '" + arr_date[2] + "'.\nAllowed values are unsigned integers.");			str_obj.focus();
			return false;		};

		var dt_date = new Date();
		dt_date.setDate(1);

		if (arr_date[1] < 1 || arr_date[1] > 12) {			window.alert ("Invalid month value: '" + arr_date[1] + "'.\nAllowed range is 01-12.");			str_obj.focus();
			return false;		};		
		dt_date.setMonth(arr_date[1]-1);
		 
		if (arr_date[2] < 100) arr_date[2] = Number(arr_date[2]) + (arr_date[2] < NUM_CENTYEAR ? 2000 : 1900);
		dt_date.setFullYear(arr_date[2]);

		var dt_numdays = new Date(arr_date[2], arr_date[1], 0);
		dt_date.setDate(arr_date[0]);
		if (dt_date.getMonth() != (arr_date[1]-1)) {			window.alert ("Invalid day of month value: '" + arr_date[0] + "'.\nAllowed range is 01-"+dt_numdays.getDate()+".");			str_obj.focus();
			return false;		};				return true;
	};
	

	
	
	

//-->
</script>
<!--#include file="../../layout/headclose.asp"-->

<!--<IFRAME STYLE="display:none;position:absolute;width:148;height:194;z-index=100" ID="CalFrame" MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO SRC="../../Calendar/calendar.htm"></IFRAME>-->
<!--<SCRIPT LANGUAGE="javascript" SRC="../../Calendar/calendar.js"></SCRIPT>-->
<!--<SCRIPT FOR="document" EVENT="onclick()">-->
<!--
window.alert('call iframe');
document.all.CalFrame.style.display="none";
//-->
<!--</SCRIPT>-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="setSupplierSelectedVal();">
<br/><br/>
<%
										' Check if the user selected a month
									if Request.Form("hidAction") = "1" then
%>
	<table border="0" cellpadding="2" cellspacing="2" width="100%" ID="Table2">
	<tr>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2" ID="Table3">
				<tr>
					<td class="bheader" align="left">Spar Web Reports</td>
				</tr>
				<tr>
					<td class="pcontent"><br>Below is the results on the following criteria:
						<ul>
							<li class="pcontent">From Date = <b><%= Request.Form("FromDate")%></b></li>
							<li class="pcontent">To Date = <b><%= Request.Form("toDate")%></b></li>
							<li class="pcontent">DC = <b>
<%
										if Request.Form("drpDC") = "0" Then
											Response.Write("All")
										else
											Response.Write(request.Form("dcName")) 
										end if
%>
								</b></li>
							<li class="pcontent">Supplier = <b>
<%
										if Request.Form("hidSupplier") = "-1" Then
											Response.Write("All")
										else
											If Request.Form("txtPartialSup") = "" Then
												Response.Write(request.Form("supName"))
											Else
												Response.Write(request.Form("txtPartialSup"))
											End If
										end if
%>
								</b></li>
							<li class="pcontent">Store = <b>
<%	
												
										if Request.Form("drpStore") = "-1" Then
											'Response.Write "PIE"
											'Response.Write Request.Form("drpStore")
											Response.Write "All"
										else
											'Response.Write Request.Form("drpStore")
											Response.Write(request.Form("storeName"))
										end if
%>
								</b></li>
							<li class="pcontent">Report On = <b>
<%
										if Request.Form("drpReport") = "-1" Then
											Response.Write("All")
										else
											Response.Write(request.Form("reportName"))
										end if
%>
								</b></li>
							</ul>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%

dim a, str, strto
a = Request.Form("FromDate")
str = mid(a,4,2) & "/" & mid(a,1,2) & "/" & mid(a,7)
a = Request.Form("ToDate")
strto = mid(a,4,2) & "/" & mid(a,1,2) & "/" & mid(a,7)

			SQL = "exec listWebReport @FromDate='" & str & "', @Todate='" & strto & "', @ReportType='" & Request.Form("ReportType") & "', @ReportOn=" & Request.Form("drpReport") & ", @DC=" & Request.Form("drpDC") & ", @Supplier=" & Request.Form("hidSupplier") & ", @Store=" & Request.Form("drpStore")
										
									'	Response.Write("<br>" & SQL)
									'Response.Write("hello")
									'Response.End 
										XMLString = DoReport(curConnection, SQL)
										
										
									
										'Response.Write(XMLString)
										'Response.End 
										curConnection.Close
										Set curConnection = Nothing
										
										
										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										'Response.Write XMLString
										'Response.End
										
										' Close the connection
										'ReportConnection.Close
										'Set ReportConnection = Nothing
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										
										XSLDoc.Load(Server.MapPath("display.xsl"))
										
										'Response.End 
																				
										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										DisplaySet = Replace(DisplaySet,"@@Application",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@ReportType",getDisplay(Request.Form("hidType")))
										DisplaySet = Replace(DisplaySet,"??","&")
										DisplaySet = Replace(DisplaySet,"!!","/")
										DisplaySet = Replace(DisplaySet,"@@FirstLocation",const_app_ApplicationRoot & "/Stats/billing/first.asp?dc=")
										DisplaySet = Replace(DisplaySet,"@@Location",const_app_ApplicationRoot & "/Stats/billing/third.asp?dc=")
																				
										Response.Write(DisplaySet)
										
%>
<p><hr color="#333366"></p>
<!--<p class="bheader" id="Name" name="Name"><%=getNameDisplay(request.Form("hidID"))%></p>-->
<p class="bheader" id="Desc" name="Desc"><%=getDisplay(request.Form("hidType"))%></p>
<%
									end if
									
%>
	
		<!--<p class="bheader" id="Name" name="Name"><%=getNameDisplay(request.QueryString("id"))%></p>-->
		<p class="bheader" id="P1" name="Desc"><%=getDisplay(request.QueryString("type"))%></p>
<form name="FrmSearch" id="FrmSearch" method="post" action="<%=const_app_ApplicationRoot%>/stats/billing/default.asp?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);" autocomplete = "off">
	<table border="0" cellpadding="2" cellspacing="2" ID="Table1">
		<tr>
			<td class="pcontent"><b>From Date:</b></td>
			<td>
<%
									if request.QueryString("id") = "ds" or request.Form("hidID") = "ds" Then
%>
				<input type=text name="FromDate" class="pcontent" value="<%= CustomDate%>" size=8 ID="FromDate">&nbsp;<a href="javascript:cal1.popup();"><img align="top" border="0" height="21" id="FromDateImg" src="../../Calendar/calendar.gif" style="POSITION: relative" width=34></a>
<%
									else
%>
				<!--<input type=text name="ReqDate" class="text" value="<%= FormatDateTime(DateAdd("w", 1, now()),2)%>" readonly size=8 ID="Text2">&nbsp;<A href="javascript:ShowCalendar(document.FrmSearch.dateimg2,document.FrmSearch.ReqDate,null, '<%= FormatDateTime(DateAdd("w", 1, now()),2)%>', '<%= FormatDateTime(DateAdd("yyyy", 3, now()),2)%>')" onclick=event.cancelBubble=true;><IMG align=top border=0 height=21 id="Img1" src="../../Calendar/calendar.gif" style="POSITION: relative" width=34></A>-->
				<input type=text name="FromDate" class="pcontent" value="<%= CustomDate%>" size=8 ID="Text1">&nbsp;<A href="javascript:ShowCalendar(document.FrmSearch.FromDateImg,document.FrmSearch.FromDate,null, '<%= FormatDateTime(DateAdd("d", -21, CustomDate),2)%>', '')" onclick=event.cancelBubble=true;><IMG align=top border=0 height=21 id="IMG1" src="../../Calendar/calendar.gif" style="POSITION: relative" width=34></A>
<%
									end if
										
%>
			</td>
		</tr>
		<tr>
			<td class="pcontent"><b>To Date:</b></td>
			<td>
<%
									if request.QueryString("id") = "ds" or request.Form("hidID") = "ds" Then
%>
				<input type=text name="ToDate" class="pcontent" value="<%= CustomDate%>" size=8 ID="ToDate">&nbsp;<a href="javascript:cal2.popup();"><img align="top" border="0" height="21" id="ToDateImg" src="../../Calendar/calendar.gif" style="POSITION: relative" width=34></a>
<%
									else
%>
				<!--<input type=text name="ReqDate" class="text" value="<%= FormatDateTime(DateAdd("w", 1, now()),2)%>" readonly size=8 ID="Text2">&nbsp;<A href="javascript:ShowCalendar(document.FrmSearch.dateimg2,document.FrmSearch.ReqDate,null, '<%= FormatDateTime(DateAdd("w", 1, now()),2)%>', '<%= FormatDateTime(DateAdd("yyyy", 3, now()),2)%>')" onclick=event.cancelBubble=true;><IMG align=top border=0 height=21 id="Img1" src="../../Calendar/calendar.gif" style="POSITION: relative" width=34></A>-->
				<input type=text name="ToDate" class="pcontent" value="<%= CustomDate%>" size=8 ID="Text2">&nbsp;<A href="javascript:ShowCalendar(document.FrmSearch.ToDateImg,document.FrmSearch.ToDate,null, '<%= FormatDateTime(DateAdd("d", -21, CustomDate),2)%>', '<%= FormatDateTime(CustomDate,2)%>')" onclick=event.cancelBubble=true;><IMG align=top border=0 height=21 id="IMG2" src="../../Calendar/calendar.gif" style="POSITION: relative" width=34></A>
<%
									end if
										
%>
			</td>
		</tr>
		<tr class="pcontent">
			<td><b>DC:</b></td>
			<td>
				<select name="drpDC" id="drpDC" class="pcontent" onchange="document.FrmSearch.dcName.value=document.FrmSearch.drpDC.options[document.FrmSearch.drpDC.selectedIndex].text;">
<%
										if dcID = 0 then
											if (UserType <> 2) OR (UserID = 0) then
%>
<option value="-1">-- All DC --</option>
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
											SQLStr = SQLStr & " @DC=" & dcID
										'end if
										
										'Response.Write SQLStr
										'esponse.End
										
										Set ReturnSet = ExecuteSql(SQLStr, curConnection)
													
										Selected = ""
											
										Dim iCountTheDcs
										iCountTheDcs = 0
										' Loop through the recordset
										While not ReturnSet.EOF
											iCountTheDcs = iCountTheDcs + 1
											'If (UserType = 2) Then
												if dcID = ReturnSet("DCID") Then
													Selected = "selected"
												else
													Selected = ""
												end if
											'End If
%>
					<option <%=Selected%> value="<%=ReturnSet("DCID")%>"><%=ReturnSet("DCcName")%></option>
<%											

												SelectedDCName = ReturnSet("DCcName")
											ReturnSet.MoveNext
										Wend
													
										If iCountTheDcs > 1 Then
											SelectedDCName = "All"
										End If
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>									
				</select>
			</td>
		</tr>
		<tr class="pcontent">
			<td ><b>Supplier:</b></td>
			<td >
						<select name="drpSupplier" id="drpSupplier" class="pcontent" onchange="document.FrmSearch.supName.value=document.FrmSearch.drpSupplier.options[document.FrmSearch.drpSupplier.selectedIndex].text; setSupplierSelectedVal();">
<%
										if (UserType <> 1 AND UserType <> 4) OR (UserID = 0) then
%>
							<option value="-1"><%= AddWithSpace("-- All Suppliers --",127) %></option>
<%
										End If
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
													
										' Get a list of Stores
										'Response.write("exec listSupplier @SupplierID=" & UserID & ", @UserType=" & UserType)
										'Response.End 
										
										Dim CommandText 
										CommandText = "exec listSupplier @SupplierID=" & UserID & ", @UserType=" & UserType & ", @DCId=" & Session("DCId")
										
										Set ReturnSet = ExecuteSql(CommandText, curConnection)
													
										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											If (UserType = 1) Then
												if UserID = ReturnSet("SupplierID") Then
													Selected = "selected"
												else
													Selected = ""
												end if
											End If
%>
							<option <%=Selected%> value="<%=ReturnSet("SupplierID")%>"><%=ReturnSet("SupplierName")%></option>
<%											
											ReturnSet.MoveNext
										Wend
													
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>									
						</select>
						<%
							
						%>
					</td>
<%
									If CInt(Session("UserType")) <> 1 and CInt(Session("UserType")) <> 4 then
%>					
		</tr>
		<tr class="pcontent"> 
					<td class="pcontent"></td>
					<td class="pcontent"><b>OR</b>&nbsp;Supplier Partial Name&nbsp;<input type="text" name="txtPartialSup" id="txtPartialSup" class="pcontent" size="60"><button name="btnFilter" id="btnFilter" value="Find" type="button" class="button" OnClick="javascript:partialSupSearch();">Find</button></td>
<%
									end if
%>					
		</tr>
<%
									if (request.QueryString("id") = "ds") or (request.Form("hidID") = "ds") then
%>
		<tr class="pcontent">
			<td><b>Store:</b></td>
			<td>
				<select name="drpStore" id="drpStore" class="pcontent" onchange="document.FrmSearch.storeName.value=document.FrmSearch.drpStore.options[document.FrmSearch.drpStore.selectedIndex].text;">
<%
										If (UserType <> 3) then
%>
					<option value="-1"><%= AddWithSpace("-- All Stores --",129) %></option>
<%
										End IF
										
										
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
													
										' Get a list of Stores
										SQLStr = "exec listStores"
										if (UserType = 2) AND (UserID <> 0) then
											'SQLStr = SQLStr & " @Admin=0, @All = 1, @DCID=" & UserID
											SQLStr = SQLStr & " @Admin=0, @DCID=" & UserID
											'SQLStr = SQLStr & " @SupplierID=" & UserID & ", @UserType=" & UserType & ", @DCID=0"
											'exec listStores @SupplierID=" & UserID & ", @UserType=" & UserType & ", @DCID=" & Session("DCId")
										ElseIf (UserType = 3) Then
											SQLStr = SQLStr & " @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCID=0" 
										end if
										
									
										'response.Write("<option>" & SQLStr & "</option>")
										'Response.End 
										
										Set ReturnSet = ExecuteSql(SQLStr, curConnection)
													
										Selected = ""
										Dim	StoreName													
										' Loop through the recordset
										While not ReturnSet.EOF
											
%>
					<option <%=Selected%> value="<%=ReturnSet("StoreID")%>"><%=ReturnSet("StoreName")%></option>
					
<%											StoreName = ReturnSet("StoreName")
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
<%
								end if
%>
		<tr>
			<td class="pcontent" width=""><b>Report On:</b></td>
			<td>
				<select name="drpReport" id="drpReport" class="pcontent" onchange="document.FrmSearch.reportName.value=document.FrmSearch.drpReport.options[document.FrmSearch.drpReport.selectedIndex].text;">
					<option value="-1"><%= AddWithSpace("-- All Orders, invoices, claims and credit notes --",109)%></option>	
					<option value="17">All orders with matching invoices, claims and credit notes</option>
					<option value="1">All orders</option>
					<option value="2">All invoices</option>
					<option value="3">All orders with no invoices</option>
					<option value="4">All invoices with no orders</option>
					<option value="5">All orders with matching invoices</option>
<%
								if request.QueryString("id") = "ds" or request.Form("hidID") = "ds" then
%>
					<option value="6">All orders with matching claims</option>
					<option value="7">All orders with matching credit notes</option>
					<option value="8">All claims</option>
					<option value="9">All credit notes</option>
					<option value="10">All claims with credit notes</option>
					<option value="11">All credit notes with claims</option>
					<option value="12">All claims with no credit notes</option>
					<option value="13">All credit notes with no claims</option>
					<option value="14">All invoices with matching claims</option>
					<option value="15">All invoices with matching credit notes</option>
					<option value="18">All invoices without acknowledgements</option>
					<option value="20">All creditnotes without acknowledgements</option>
					<option value="16">Recon Reports</option>
					
<%
								end if
%>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td colspan="2">
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Generate" class="button">&nbsp;
				<input type="reset" name="btnReset" id="btnReset" value="Reset " class="button" onclick="document.all.Desc.innerText=document.FrmSearch.hidDesc.value;">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
				<input type="hidden" name="hidSupplier" id="hidSupplier" value="-1">
<%
								if Request.Form("hidAction") = "1" then
%>
				<input type="hidden" name="hidType" id="hidType" value="<%=request.Form("hidType")%>">
				<input type="hidden" name="hidDesc" id="hidDesc" value="<%=request.Form("hidDesc")%>">
				<input type="hidden" name="hidID" id="hidID" value="<%=request.Form("hidID")%>">
				<input type="hidden" name="sup" id="sup" value="<%=request.Form("sup")%>">
				<input type="hidden" name="hidName" id="hidName" value="<%=request.Form("hidName")%>">
				<input type="hidden" name="dcName" id="dcName" value="<%=request.Form("dcName")%>">
				<input type="hidden" name="supName" id="supName" value="<%=request.Form("supName")%>">
				<input type="hidden" name="storeName" id="storeName" value="<%=request.Form("storeName")%>">
				<input type="hidden" name="reportName" id="reportName" value="<%=request.Form("reportName")%>">
<%
								else
%>
				<input type="hidden" name="hidType" id="Hidden1" value="<%=request.QueryString("type")%>">
				<input type="hidden" name="hidDesc" id="Hidden2" value="<%=getDisplay(request.QueryString("type"))%>">
				<input type="hidden" name="hidID" id="Hidden3" value="<%=request.QueryString("id")%>">
				<input type="hidden" name="sup" id="Hidden4" value="<%=request.QueryString("sup")%>">
				<input type="hidden" name="hidName" id="Hidden5" value="<%=getDisplay(request.QueryString("type"))%>">
				<input type="hidden" name="dcName" id="Hidden6" value="<%=SelectedDCName%>">
				<input type="hidden" name="supName" id="Hidden7" value="All">
				<% If (UserType <> 3) then %>
					<input type="hidden" name="storeName" id="Hidden8" value="All">	
				<% Else %>
					<input type="hidden" name="storeName" id="Hidden8" value="<%=StoreName%>">	
				<% End If %>
				
				<input type="hidden" name="reportName" id="Hidden9" value="All">
<%
								end if
%>
				<input type="hidden" name="ReportType" id="ReportType" value="stat">
			</td>
		</tr>
	</table>
</form>
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
	var cal1 = new calendar1(document.forms['FrmSearch'].elements['FromDate']);
	cal1.year_scroll = false;
	cal1.time_comp = false;		var cal2 = new calendar1(document.forms['FrmSearch'].elements['ToDate']);
	cal2.year_scroll = false;
	cal2.time_comp = false;
//-->
</script>
<!--#include file="../../layout/end.asp"-->

<%
													'curConnection.Close 
													'StoreCurConnection.Close 
													'dcConnection.Close 
%>