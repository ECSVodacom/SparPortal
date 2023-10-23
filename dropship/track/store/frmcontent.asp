<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<%
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
										
										
										If  Session("Action")  = 0 THen  Session("Action")  = 1
										' Check where the user was last
										if Request.QueryString("action") = "" or IsNull(Request.QueryString("action")) then
											if Session("Action") = "" then
												Session("Action") = 1
											else
												Session("Action") = Session("Action") 
											end if
										else
											Session("Action") = Request.QueryString("action")
										end if
										
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
										
										' Call the menu items generation function
										If Not Session("HideMenu") Then  Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate, IsXML)

										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString

										Select Case CInt(Session("Action"))
										Case 1
											' Biuld the SQL Statement for orders
											SQL = "exec listStoreOrderTrack @StoreID=" & Session("ProcID") & _
												", @TrackDate=" & MakeSQLText(NewDate)

											' Call the 
											XMLString = MakeXMLOrders (curConnection, SQL)
	
										Case 2
											' Biuld the SQL Statement for orders
											SQL = "exec listStoreInvoiceTrack @StoreID=" & Session("ProcID") & _
												", @TrackDate=" & MakeSQLText(NewDate)

											' Call the 
											XMLString = MakeXMLInvoice(curConnection, SQL)													
										Case 3
											' Biuld the SQL Statement for Claims
											SQL = "exec listClaim @ClaimDate=" & MakeSQLText(NewDate) & _
												", @EANNum=" & MakeSQLText(Session("ProcEAN")) & _
												", @Type=" & UserType
												
											'response.write "<br>" & SQL
											
											' Call the 
											XMLString = MakeXMLClaims (curConnection, SQL)	
										Case 4
											' Biuld the SQL Statement for Credit Notes
											SQL = "exec listCreditNote @CNDate=" & MakeSQLText(NewDate) & _
												", @EANNum=" & MakeSQLText(Session("ProcEAN")) & _
												", @Type=" & UserType
												
											' Call the 
											XMLString = MakeXMLCreditNote (curConnection, SQL)		
										' Case 7
											' Response.Redirect const_app_ApplicationRoot & "/storelist/default.asp"
										' Case 8
											' Response.Redirect const_app_ApplicationRoot & "/schedule/search/default.asp?fc=false"
										' Case 9
											' Response.Redirect const_app_ApplicationRoot & "/schedule/search/default.asp?fc=true"
										' Case 10
											' 'Response.Redirect Response.Write("<script>window.open('" & const_app_ApplicationRoot & "/claims/integrate.asp?id=2','_blank');</script>")
											' Response.Redirect const_app_ApplicationRoot & "/claims/integrate.asp?id=2"
										' Case 11 ' Supplier Claims
											' Response.Redirect const_app_ApplicationRoot & "/claims/index.asp?id=1"
										' Case 12 ' Admin DC Claims
											' Response.Redirect const_app_ApplicationRoot & "/claims/index.asp"
											' 'Response.Write "<script>window.open('" & const_app_ApplicationRoot & "/claims/index.asp','_blank');</script>"
												' ' Biuld the SQL Statement for Claims
											' 'SQL = "exec listClaim @ClaimDate=" & MakeSQLText(NewDate) & _
											' '	", @EANNum=" & MakeSQLText(Session("ProcEAN")) & _
											' '	", @Type=" & UserType
												
											' 'response.write "<br>" & SQL
											
											' ' Call the 
											' 'XMLString = MakeXMLClaims (curConnection, SQL)	
										' Case 13 ' Claims Capture
											' Response.Redirect const_app_ApplicationRoot & "/claims/integrate.asp?id=1"
										' Case 14 ' Claims Capture
											' Response.Redirect const_app_ApplicationRoot & "/storeval/default.asp"
										' Case 15
											' Response.Redirect const_app_ApplicationRoot & "/search/default.asp?id=10"
										' Case 16 ' Stats report
											' Response.Redirect const_app_ApplicationRoot & "/track/dc/dcclaimoptions.asp"
										' Case 17 ' DC Claim Configuration
											' Response.Redirect const_app_ApplicationRoot & "/track/dc/dcclaimoptions.asp"
										' Case 18
											' Response.Redirect const_app_ApplicationRoot & "/track/dc/OrderConfigurations.asp"
										' Case 19
											' Response.Redirect const_app_ApplicationRoot & "/track/dc/WebOrderingConfig.asp"
										' Case 20
											' Response.Redirect const_app_ApplicationRoot & "/usernames/usernames.asp"
										' Case 21
											' Response.Redirect const_app_ApplicationRoot & "/track/dc/WarehouseClaimConfig.asp"
										' Case 22
											' Response.Redirect const_app_ApplicationRoot & "/claims/WarehouseclaimCategories.asp"
										' Case 23
											' Response.Redirect const_app_ApplicationRoot & "/claims/DCAdminClaimsCategories.asp"
										' Case 24
											' Response.Redirect const_app_ApplicationRoot & "/claims/DCAdminReasonCodes.asp"
										' Case 25
											' Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminClaimsCategories.asp"
										' Case 26
											' Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminReasonCodes.asp"
										' Case 27
											' Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminSubReasonCodes.asp"
										' Case 28 
											' Response.Redirect const_app_ApplicationRoot & "/claims/SupplierClaimCaptureStoreExceptions.asp"
										' Case 29
											' Response.Redirect const_app_ApplicationRoot & "/claims/ClaimStatusManagement.asp"
										' case 30
											' Response.Redirect const_app_ApplicationRoot & "/claims/MaintainClaimSupplierEan.asp"
										' 0
										End Select
										
										'Response.Write SQL
										'Response.End

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
										Case 3, 12
											XSLDoc.Load(Server.MapPath("sclaimtrackreport.xsl"))
										Case 4
											XSLDoc.Load(Server.MapPath("screditnotetrackreport.xsl"))
										End Select										

										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@Date",FormatDate(Request.QueryString("id"),false))
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" >
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		<%=Folder%>	
		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>
<!--#include file="../../layout/end.asp"-->
