<%@ Language=VBScript %>
<%OPTION EXPLICIT%>

<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim FolderName
										dim TotPages
										dim Band
										dim RecordCount
										dim MaxRecords
										dim RecordFrom
										dim RecordTo
										dim BandSize
										dim UserID
										dim Selected
										dim UserType
										dim OrdNum
										dim txtSupplier
										dim txtStore
										dim NewDate
										dim IsXML
										dim Folder
										dim strFilter
										dim strDC
										dim RetVal
										dim strDate
										dim strNewDate
																				
										UserID = Session("ProcID")
										UserType = Session("UserType")
										
										if Session("ProcEAN") = "GATEWAYCALLCEN" or Session("ProcEAN") = "SPARHEADOFFICE" then
											UserType = 2
											UserID = 0
										end if
										
										if Request.QueryString("id") = "" Then
											NewDate = Year(Now) & "/" & Month(Now) & "/" & Day(Now)
										else
											NewDate = Year(Request.QueryString("id")) & "/" & Month(Request.QueryString("id")) & "/" & Day(Request.QueryString("id"))
										end if
										
										'Response.Write(NewDate)
										

										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
										
										if Request.Form("drpFilter") = "" then
											strFilter = "-1"
										else
											strFilter = Request.Form("drpFilter")
										end if
										
										strDC = Session("DCID")
										
										If Request.Form("drpDC") <> "" Then
											strDC = Request.Form("drpDC") 
										ElseIf Session("DCID") = "" then
											if Request.Form("drpDC") = "" then
												strDC = "0"
											else
												strDC = Request.Form("drpDC")
											end if
										else
											strDC = Session("DCID")
										end if
										
										if Request.Form("txtFromDate") = "" then
											strDate = ""
											strNewDate = ""
										else
											strDate = Request.Form("txtFromDate")
											strNewDate = Year(strDate) & "/" & Month(strDate) & "/" & Day(strDate)
										end if

										' Call the menu items generation function
										Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate, IsXML)
				
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString

									
										
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/calendar2.js"></script>
<!--#include file="../layout/headclose.asp"-->
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<br>
<br>
<p class="bheader">Store List</p>
<form name="frmStore" id="frmStore" method="post" action="default.asp">
	<table width="100%" >
		<tr>
			<td valign="top">
				<table border="0" cellpadding="2" cellspacing="2">
					<tr>
						<td class="pcontent">DC:</td>
						<td class="pcontent">
							<select name="drpDC" id="drpDC" class="pcontent">
<%
										if Session("DCID") = 0 then
											if (UserType <> 2) OR (UserID = 0) then
%>
							<option value="0">-- Select a DC --</option>
<%
											End IF
										end if
											
										dim curConnection_DC
										' Set a connection
										Set curConnection_DC = Server.CreateObject ("ADODB.Connection")
										curConnection_DC.Open const_db_ConnectionString
													
										' Get a list of Stores
										Dim SQLStr
										DIM ReturnSet_DC
										
										SQLStr = "listDC"
										'if (UserType = 2) AND (UserID <> 0) then
										'	SQLStr = SQLStr & " @DC=" & UserID
										'end if
										
										'if Session("DCID") <> 0 then
											SQLStr = SQLStr & " @DC=" & Session("DCID")
										'end if
										
										'response.Write("<Option>" & SQLStr & "</Option>")
										'response.End 
										
										Set ReturnSet_DC = ExecuteSql(SQLStr, curConnection)
													
										Selected = ""
										
										
												
										' Loop through the recordset
										While not ReturnSet_DC.EOF
											'If (UserType = 2) Then
												if CInt(strDC) = CInt(ReturnSet_DC("DCID")) Then
													Selected = "selected"
												else
													Selected = ""
												end if
											'End If
%>
							<option <%=Selected%> value="<%=ReturnSet_DC("DCID")%>"><%=ReturnSet_DC("DCcName")%></option>
<%											
											ReturnSet_DC.MoveNext
										Wend
													
										' Close the Connection and RecordSet
										Set ReturnSet_DC = Nothing
										curConnection_DC.Close
										Set curConnection_DC = Nothing
%>									
						</select>
						</td>
					</tr>
					<tr>
						<td class="pcontent">List Type:</td>
						<td class="pcontent">
							<select name="drpFilter" id="drpFilter" class="pcontent">
								<option <%if strFilter = "-1" then Response.Write "selected" end if%> value="-1">FULL LIST</option>
								<option <%if strFilter = "0" then Response.Write "selected" end if%> value="0">NEW STORES</option>
								<option <%if strFilter = "1" then Response.Write "selected" end if%> value="1">UPDATED STORES</option>
								<option <%if strFilter = "2" then Response.Write "selected" end if%> value="2">DELETED STORES</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="pcontent">Store&nbsp;Format:</td>
						<td class="pcontent">
							<select name="cboStoreFormat" id="cboStoreFormat" class="pcontent">
							<% 	
								Dim SqlCommand, RecordSet
								If Session("UserType") <> 3 Then 
									SqlCommand = "GetStoreFormats @StoreId=0"
							%>
									<option value="All Formats">All Formats</option>	
								
							<% 
								Else
									SqlCommand = "GetStoreFormats @StoreId=" & Session("ProcID") 
								End If 
									
									
									
									selected = ""
									Set RecordSet = ExecuteSql(SqlCommand, curConnection)
									If Not (RecordSet.EOF And RecordSet.BOF) Then
										While NOT RecordSet.EOF
											If Trim(RecordSet("StoreType")) = Trim(Request.Form("cboStoreFormat")) Then 
												selected = "selected"
											Else
												selected = ""
											End If 
								%>
										<option <%=selected%> value="<%=RecordSet("StoreType")%> " ><%=RecordSet("StoreType")%></option>
								<%
											RecordSet.MoveNext
										Wend
									End If		
									RecordSet.Close
									
									Set RecordSet = Nothing

								%>
							</select>
						</td>
					</tr>
					
					
					<span id="s_Date" class="pcontent">
						<tr>
							<td>&nbsp;</td>	
							<td class="pcontent" colspan="2">*Only select a date if you selected "NEW" or "DELETED" STORES from the list above.</td>
						</tr>
						<tr>
							<td class="pcontent">Date:</td>
							<td>								
								<input type="text" name="txtFromDate" id="txtFromDate" value="<%=strDate%>" class="pcontent" size="25">
								<a href="javascript:cal5.popup();"><img align="top" border="0" height="21" id="FromDateImg" src="../Calendar/calendar.gif" style="POSITION: relative" width=34></a><br>
							</td>
						</tr>
					</span>
					<tr>
						<td>&nbsp;</td>
						<td class="pcontent"><input type="submit" name="btnSubmit" id="btnSubmit" value="Filter" class="button"></td>
					</tr>
<%
							Dim StoreFormat, SqlSelect
							StoreFormat = Trim(Request.Form("cboStoreFormat"))
							SqlSelect = "listStores @Filter=" & strFilter _ 
								& ",@DCID=" & strDC& ", @Date=" & MakeSQLText(strNewDate) _
								& ",@StoreFormat='" & StoreFormat & "'"
							Set ReturnSet = ExecuteSql(SqlSelect, curConnection)  
							
							If Not (ReturnSet.BOF And ReturnSet.EOF) Then
							RetVal = Returnset("returnvalue")
							if RetVal = 0 then
%>			
					<tr>	
						<td>&nbsp;</td>
						<td class="pcontent" colspan="2">
							<a class="linknavmain" href="download.asp?filter=<%=strFilter%>&dc=<%=strDC%>&type=xml&sf=<%=StoreFormat%>">Download list in XML format</a><br>
							<a class="linknavmain" href="download.asp?filter=<%=strFilter%>&dc=<%=strDC%>&type=flat&sf=<%=StoreFormat%>">Download list in Flat format</a>&nbsp;
							(The download may take moment or so depending on the file size. Please be patient)</td>
					</tr>
<%
							end if
%>			
					</tr>
				</table>
			</td>
<%
										If RetVal = 0 then
%>
			<td>
				<p class="pcontent" align="right">
				<table >
					<tr>
						<td class="pcontent"><b>Legend Keys</b></td>
						<td></td>
					</tr>
					<tr>
						<td class="pcontent">Active</td>
						<td class="pcontent">= Store active on electronic dropshipment</td>
					</tr>
					<tr>
						<td class="pcontent">Inactive</td>
						<td class="pcontent">= Store not active on electronic dropshipment</td>
					</tr>
					<tr>
						<td class="pcontent">Test</td>
						<td class="pcontent">= Store in "testing" on electronic dropshipment</td>
					</tr>
					<tr>
						<td class="pcontent">New</td>
						<td class="pcontent">= Added since last full store update from SPAR</td>
					</tr>
					<tr>
						<td class="pcontent">Existing</td>
						<td class="pcontent">= Existed on last full store update from SPAR</td>
					</tr>
					<tr>
						<td class="pcontent">Deleted</td>
						<td class="pcontent">= Store closed by SPAR</td>
					</tr>
				</table>
				</p>
			</td>
<%
										end if
%>
		</Tr>	
	</table>
</form>
<%
										if RetVal <> 0 then
%>
<p class="pcontent">There are no stores listed for the selected filter.</p>
<%										
										else
%>
	<p class="pcontent">Below is a list of all stores in the system database.</p>
	<table border="1" cellpadding="2" cellspacing="2">
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent"><b>Store Name</b></td>
			<td class="tdcontent"><b>Store Code</b></td>
			<td class="tdcontent"><b>Store EAN</b></td>
			<td class="tdcontent"><b>Store VAT No</b></td>
			<td class="tdcontent"><b>Phone Number</b></td>
			<td class="tdcontent"><b>Fax Number</b></td>
			<td class="tdcontent"><b>Owner Name</b></td>
			<td class="tdcontent"><b>Manager Name</b></td>
			<td class="tdcontent"><b>Address</b></td>
			<td class="tdcontent"><b>DC EAN</b></td>
			<td class="tdcontent"><b>Store Manager Email</b></td>
			<td class="tdcontent"><b>Format Type Description</b></td>
			<td class="tdcontent"><b>Country Code</b></td>
			<td class="tdcontent"><b>Claims Enabled</b></td>
			<td class="tdcontent"><b>Status</b></td>
			<td class="tdcontent"><b>Date Added</b></td>
			<td class="tdcontent"><b>Action</b></td>
			<td class="tdcontent"><b>Action Date</b></td>
		</tr>
<%
											While not ReturnSet.EOF
%>
		<tr>
			<td class="pcontent"><%=Returnset("StoreName")%></td>
			<td class="pcontent"><%if IsNull(Returnset("StoreCode")) or Returnset("StoreCode") = "" then Response.Write " - " else Response.Write Returnset("StoreCode") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("StoreEAN")) or Returnset("StoreEAN") = "" then Response.Write " - " else Response.Write Returnset("StoreEAN") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("StoreVatNo")) or Returnset("StoreVatNo") = "" then Response.Write " - " else Response.Write Returnset("StoreVatNo") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("StorePhone")) or Returnset("StorePhone") = "" then Response.Write " - " else Response.Write Returnset("StorePhone") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("StoreFax")) or Returnset("StoreFax") = "" then Response.Write " - " else Response.Write Returnset("StoreFax") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("StoreOwner")) or Returnset("StoreOwner") = "" then Response.Write " - " else Response.Write Returnset("StoreOwner") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("StoreManager")) or Returnset("StoreManager") = "" then Response.Write " - " else Response.Write Returnset("StoreManager") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("StoreAddress")) or Returnset("StoreAddress") = "" then Response.Write " - " else Response.Write UCase(Returnset("StoreAddress")) end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("DCEANNumber")) or Returnset("DCEANNumber") = "" then Response.Write " - " else Response.Write Returnset("DCEANNumber") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("Email")) or Returnset("Email") = "" then Response.Write " - " else Response.Write Returnset("Email") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("FromatTypeDesc")) or Returnset("FromatTypeDesc") = "" then Response.Write " - " else Response.Write Returnset("FromatTypeDesc") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("CountryCode")) or Returnset("CountryCode") = "" then Response.Write " - " else Response.Write Returnset("CountryCode") end if%></td>
			<td class="pcontent"><%if IsNull(Returnset("ClaimsforSuppInd")) or Returnset("ClaimsforSuppInd") = "" then Response.Write " - " else Response.Write Returnset("ClaimsforSuppInd") end if%></td>
			<td class="pcontent">
<%
												Select Case Returnset("StoreStatus")
												case 0
													Response.Write "Inactive"
												case 1
													Response.Write "Active"
												case 2
													Response.Write "Test"
												end select
%>
			</td>
			<td class="pcontent"><%if IsNull(Returnset("CreateDate")) then Response.Write " - " else Response.Write Returnset("CreateDate") end if%></td>														
			<td class="pcontent">
<%
												select case Returnset("StoreAction")
												case 0
													Response.Write "New"
												case 1
													Response.Write "Updated"
												case 2
													Response.Write "Deleted"
												case else
													Response.Write "New"
												End Select
%>
		<td class="pcontent"><%if IsNull(Returnset("ActionDate")) then Response.Write " - " else Response.Write Returnset("ActionDate") end if%></td>														
		</tr>
<%											
												Returnset.MoveNext
											Wend
						End If ' RetVal
					
					Else
%>
<p class="pcontent">There are no stores listed for the selected filter.</p>
<%	
					End If
					
											
					Set ReturnSet = Nothing
					curConnection.Close
					set curConnection = Nothing
%>		
	</table>
<%
%>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	
		new menu (MENU_ITEMS, MENU_POS);

		var cal5 = new calendar2(document.forms['frmStore'].elements['txtFromDate']);
		cal5.year_scroll = true;
		cal5.time_comp = false;//-->
</script>
<!--#include file="../layout/end.asp"-->
