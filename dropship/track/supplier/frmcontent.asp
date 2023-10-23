<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<%
										Server.ScriptTimeout = 360000

										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/xmlfunctions.asp"-->
<!--#include file="includes/makeorders.asp"-->
<!--#include file="../../includes/genmenuitems.asp"-->
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
	
	
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

					
										dim SQL
										dim curConnection
										dim XMLString
										dim NewDate
										dim XMLDoc
										dim XSLDoc
										dim DisplaySet
										dim XMLOrders
										dim OrdCount
										dim ReceiverEAN
										dim LoginUser
										dim Folder
										dim IsXML
										dim UserType
										dim IsWarehouseUser

										'Session("Action") = 0
										' Check where the user was last
										If Session("Action") = 0 Then Session("Action") = 1
										
										
											if Request.QueryString("action") = "" or IsNull(Request.QueryString("action")) then
												if Session("Action") = "" And Session("UserType") <> 4 then
													Session("Action") = 1
												ElseIf Session("Action") = "" And Session("UserType") = 4 Then
													Session("Action") = 3
												Else
													Session("Action") = Session("Action") 
												End if
											else
												Session("Action") = Request.QueryString("action")
											end if
											
										'if Request.QueryString("action") = "" or IsNull(Request.QueryString("action")) then
										'	if Session("Action") = "" Or Not IsNumeric(Session("Action")) then
										'		Session("Action") = 1
										'	else
										'		Session("Action") = Session("Action") 
										'	end if
										'else
										'	Session("Action") = Request.QueryString("action")
										
										'end if
										
										'if Request.QueryString("action") = "" or IsNull(Request.QueryString("action")) then
										'	if Session("Action") = "" Then 'And Session("UserType") <> 4 then
										'		Session("Action") = 1
											'ElseIf Session("UserType") = 4 Then
											'	Session("Action") = 3
'											else
'												Session("Action") = Session("Action") 
										'	end if
										'else
										'	Session("Action") = Request.QueryString("action")
										'end if
										
										if request.querystring("RRID") <> "" Then
											Session("Action") = 5
											RRID = request.QueryString("RRID")
										End if
										
										if Request.QueryString("id") = "" Then
											NewDate = Year(Now) & "/" & Month(Now) & "/" & Day(Now)
										else
											NewDate = Year(Request.QueryString("id")) & "/" & Month(Request.QueryString("id")) & "/" & Day(Request.QueryString("id"))
										end if

										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
										
										if Session("ProcEAN") = "GATEWAYCALLCEN" or Session("ProcEAN") = "SPARHEADOFFICE" then
											UserType = 0
										else
											UserType = Session("UserType")
										end if
										
										If Session("IsWarehouseUser")  then 
											IsWarehouseUser = 1
										else
											IsWarehouseUser = 0
										end if
										
										' Call the menu items generation function
										If Not Session("HideMenu") Then Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate, IsXML)

										'response.write const_db_ConnectionString
										'response.end
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
					
										'response.write Session("Action")
										'response.end
										
										Select Case CInt(Session("Action"))
										Case 1
											' Biuld the SQL Statement for orders
											SQL = "exec listSupplierOrderTrack @SupplierID=" & Session("ProcID") & _
												", @TrackDate=" & MakeSQLText(NewDate) & _
												", @DC=" & Session("DCID")

											'Response.Write "<br>" & SQL
											'Response.End

											' Call the 
											XMLString = MakeXMLOrders (curConnection, SQL)
	
										Case 2
											' Biuld the SQL Statement for orders
											SQL = "exec listSupplierInvoiceTrack @SupplierID=" & Session("ProcID") & _
												", @TrackDate=" & MakeSQLText(NewDate) & _
												", @DC=" & Session("DCID")

											'Response.Write "<br>" & SQL
											'Response.End

											' Call the 
											XMLString = MakeXMLInvoice(curConnection, SQL)											
										Case 3
											' Biuld the SQL Statement for Claims
											SQL = "exec listClaim @ClaimDate=" & MakeSQLText(NewDate) & _
												", @EANNum=" & MakeSQLText(Session("ProcEAN")) & _
												", @Type=" & UserType & _
												", @DC=" & Session("DCID") &_
												", @IsWarehouse=" & IsWarehouseUser
												
											'Response.Write "<br>" & SQL
											'Response.End
											'response.write Session("IsWarehouseUser")
											'response.end
											' Call the 
											XMLString = MakeXMLClaims (curConnection, SQL)	
										Case 4
											' Biuld the SQL Statement for Credit Notes
											SQL = "exec listCreditNote @CNDate=" & MakeSQLText(NewDate) & _
												", @EANNum=" & MakeSQLText(Session("ProcEAN")) & _
												", @Type=" & UserType & _
												", @DC=" & Session("DCID")
												
												'Response.Write "<br>" & SQL
												'Response.End
											
											' Call the 
											
											XMLString = MakeXMLCreditNote (curConnection, SQL)		
											
										Case 5
											' Biuld the SQL Statement for Credit Notes
											if UserType = 0 or UserType = 2 then
												SQL = "exec listReconFileNames @RRDate=" & MakeSQLText(NewDate) & _
													", @EANNum=Super" & _
													", @DCID=" & Session("DCID")
													
												if request.querystring("RRID") <> "" Then
													SQL = "exec listReconFileNames @RRID=" & RRID & _
													", @EANNum=Super" & _
													", @DCID=" & Session("DCID")
												end if
											else
												SQL = "exec listReconFileNames @RRDate=" & MakeSQLText(NewDate) & _
													", @EANNum=" & MakeSQLText(Session("ProcEAN")) & _
													", @DCID=" & Session("DCID")
													
												if request.querystring("RRID") <> "" Then
													SQL = "exec listReconFileNames @RRID=" & RRID & _
													", @EANNum=" & MakeSQLText(Session("ProcEAN")) & _
													", @DCID=" & Session("DCID")
												end if
											end if
												
												'Response.Write "<br>" & SQL
												'Response.End
											
											' Call the 
											XMLString = MakeReconLinkXML (curConnection, SQL)	
											'response.Write(XMLString)
											'response.End
										Case 6
										    'SQL = "exec listRemittanceAdvicesFileNames @RADate=" & MakeSQLText(NewDate) & ", @DSHorDC='DSH'"
										    SQL = "exec listRemittanceAdvicesFileNames_Latest @RADate=" & MakeSQLText(NewDate) & ", @DSHorDC='DSH', @DCID=" & Session("DCID") & ", @SupplierEan='" & Session("ProcEAN") & "'"
											
											'response.write SQL
										    'response.Write  "<br/><br/><br/>" & Session("ProcEAN")
										    
    										XMLString = MakeERALinkXML(curConnection, SQL) 		
										'Case 6
										
											'XSLDoc.Load(Server.MapPath("remittanceAdvices.xsl"))
											'Response.Write const_app_SqlReportsPath
											'Response.End
										    'XSLDoc.Load(const_app_SqlReportsPath & "remittanceAdvices.xsl")
										' Case 7
											' Response.Redirect const_app_ApplicationRoot & "/dropship/storelist/default.asp"
										' Case 8
											' Response.Redirect const_app_ApplicationRoot & "/dropship/schedule/search/default.asp?fc=false"
										' Case 9
											' Response.Redirect const_app_ApplicationRoot & "/dropship/schedule/search/default.asp?fc=true"
										' Case 10
											' Response.Redirect const_app_ApplicationRoot & "/dropship/claims/integrate.asp?id=2"
										' Case 11 ' Supplier Claims
											' Response.Redirect const_app_ApplicationRoot & "/dropship/claims/index.asp?id=1"
										' Case 12 ' Admin DC Claims
											' Response.Redirect const_app_ApplicationRoot & "/dropship/claims/index.asp"
										' Case 13 ' Claims Capture
											' Response.Redirect const_app_ApplicationRoot & "/dropship/claims/integrate.asp?id=1"
										' Case 14 ' Claims Capture
											' Response.Redirect const_app_ApplicationRoot & "/dropship/storeval/default.asp"
										' Case 15
											' Response.Redirect const_app_ApplicationRoot & "/dropship/search/default.asp?id=10"
										End Select

'response.Write Session("Action")
'response.end

'exec listClaim @ClaimDate='2017/7/21', @EANNum='6004930012137', @Type=4, @DC=0, @IsWarehouse=1
'6004930012137
	'response.write SQL
	'response.end
'										    response.Write  "<br/><br/><br/>" & Session("ProcEAN")
										' Load the String into an XML Dom
										
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										'Response.Write XMLString
										'Response.End
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										
										Select Case CInt(Session("Action"))
										Case 1
											if Session("Permission") = 0 then
												XSLDoc.Load(Server.MapPath("ordertrackreport.xsl"))
											else
												XSLDoc.Load(Server.MapPath("sordertrackreport.xsl"))
											end if
										Case 2
											if Session("Permission") = 0 then
												XSLDoc.Load(Server.MapPath("invoicetrackreport.xsl"))
											else
												XSLDoc.Load(Server.MapPath("sinvoicetrackreport.xsl"))
											end if
										Case 3
											XSLDoc.Load(Server.MapPath("sclaimtrackreport.xsl"))
										Case 4
											XSLDoc.Load(Server.MapPath("screditnotetrackreport.xsl"))
										Case 5
											XSLDoc.Load(Server.MapPath("recon_select.xsl"))
										Case 6
											XSLDoc.Load(Server.MapPath("remittanceAdvices.xsl"))
											'XSLDoc.Load(const_app_SqlReportsPath & "remittanceAdvices.xsl")
										'Case 7
										'	XSLDoc.Load(Server.MapPath("remittanceAdvices.xsl"))
											'XSLDoc.Load(const_app_SqlReportsPath & "remittanceAdvices.xsl")
										Case 7
											Response.Redirect const_app_ApplicationRoot & "/storelist/default.asp"
										Case 8
											Response.Redirect const_app_ApplicationRoot & "/schedule/search/default.asp?fc=false"
										Case 9
											Response.Redirect const_app_ApplicationRoot & "/schedule/search/default.asp?fc=true"
										Case 10
											'Response.Redirect Response.Write("<script>window.open('" & const_app_ApplicationRoot & "/claims/integrate.asp?id=2','_blank');</script>")
											Response.Redirect const_app_ApplicationRoot & "/claims/integrate.asp?id=2"
										Case 11 ' Supplier Claims
											Response.Redirect const_app_ApplicationRoot & "/claims/index.asp?id=1"
										Case 12 ' Admin DC Claims
											Response.Redirect const_app_ApplicationRoot & "/claims/index.asp"
										Case 13 ' Claims Capture
											Response.Redirect const_app_ApplicationRoot & "/claims/integrate.asp?id=1"
										Case 14 ' Claims Capture
											Response.Redirect const_app_ApplicationRoot & "/storeval/default.asp"
										Case 15
											Response.Redirect const_app_ApplicationRoot & "/search/default.asp?id=10"
										Case 16 ' Stats report
											Response.Redirect const_app_ApplicationRoot & "/track/dc/dcclaimoptions.asp"
										Case 17 ' DC Claim Configuration
											Response.Redirect const_app_ApplicationRoot & "/track/dc/dcclaimoptions.asp"
										Case 18
											Response.Redirect const_app_ApplicationRoot & "/track/dc/OrderConfigurations.asp"
										Case 19
											Response.Redirect const_app_ApplicationRoot & "/track/dc/WebOrderingConfig.asp"
										Case 20
											Response.Redirect const_app_ApplicationRoot & "/usernames/usernames.asp"
										Case 21
											Response.Redirect const_app_ApplicationRoot & "/track/dc/WarehouseClaimConfig.asp"
										Case 22
											Response.Redirect const_app_ApplicationRoot & "/claims/WarehouseclaimCategories.asp"
										Case 23
											Response.Redirect const_app_ApplicationRoot & "/claims/DCAdminClaimsCategories.asp"
										Case 24
											Response.Redirect const_app_ApplicationRoot & "/claims/DCAdminReasonCodes.asp"
										Case 25
											Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminClaimsCategories.asp"
										Case 26
											Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminReasonCodes.asp"
										Case 27
											Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminSubReasonCodes.asp"
										Case 28 
											Response.Redirect const_app_ApplicationRoot & "/claims/SupplierClaimCaptureStoreExceptions.asp"
										Case 29
											Response.Redirect const_app_ApplicationRoot & "/claims/ClaimStatusManagement.asp"
										case 30
											Response.Redirect const_app_ApplicationRoot & "/claims/MaintainClaimSupplierEan.asp"
										case 31
											
											Response.Redirect const_app_ApplicationRoot & "/track/dc/supplierlinkedtodc.asp"
										End Select		
													
										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@Date",FormatDate(Request.QueryString("id"),false))
										
										' Check if this is an XML Supplier
										if IsNumeric(Session("ProcEAN")) then
											DisplaySet = Replace(DisplaySet,"@@GenInv"," ")
										else								
											DisplaySet = Replace(DisplaySet,"@@GenInv","&#160;/&#160;<a href=" & chr(34) & "JavaScript: newWindow = openWin('" & const_app_ApplicationRoot & "/track/supplier/invoice/new.asp', 'GenInvoice', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');" & chr(34) &  " class=" & chr(34) & "NavLink" & chr(34) & " target=" & chr(34) & "frmcontent" & chr(34) & ">Generate Blank Invoice</a>")
										end if
										
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script language="JavaScript1.2" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript1.2" src="<%=const_app_ApplicationRoot%>/includes/globalfunctions.js"></script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<%
										' Write the XMLString 
											
										
											Response.Write DisplaySet
%>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	
		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>
<!--#include file="../../layout/end.asp"-->
