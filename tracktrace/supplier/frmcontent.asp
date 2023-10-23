<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/setuserdetails.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/xmlfunctions.asp"-->
<!--#include file="includes/makeorders.asp"-->
<!--#include file="includes/generatetabfile.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<!--#include file="../../sqlreports/sqlreportfunctions.asp"-->
<%
											'curConnection.ConnectionTimeout = 36000
										' Determine if the user is logged in
										Call CookieLoginTrackCheck(const_app_ApplicationRoot & "/tracktrace/supplier/frmcontent.asp?id=" & Request.QueryString("id"))
										'Call CookieLoginCheck(const_app_ApplicationRoot & "/tracktrace/supplier/frmcontent.asp?id=" & Request.QueryString("id"))
										
										
										dim SQL
										dim curConnection
										dim ReturnSet
										dim XMLString
										dim NewDate
										dim XMLDoc
										dim XSLDoc
										dim DisplaySet
										dim XMLOrders
										dim OrdCount
										dim ReceiverEAN
										dim CreateFile
										dim IsEDI
										dim DCName 
										dim cnt
										dim doTab
										Dim Folder
										
										 doTab = false         
										
										if Request.QueryString("action") = "" or IsNull(Request.QueryString("action")) then
											if Session("Action") = "" then
												Session("Action") = 1
											end if
										else
											Session("Action") = Request.QueryString("action")
										end if
										
										if Request.QueryString("id") = "" Then
											'NewDate = "20" & FormatDateTime(Date,2)
											NewDate = Year(Now) & "/" & Month(Now) & "/" &Day(Now)
										else
											'NewDate = "20" & FormatDateTime(Request.QueryString("id"),2)
											NewDate = Year(Request.QueryString("id")) & "/" & Month(Request.QueryString("id")) & "/" & Day(Request.QueryString("id"))
										end if
										
																	
										' Set the connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
				
										
										Dim DoAction 
										DoAction = Session("Action")
										If DoAction = 6 Then ' Remittance Advices
											SQL = "listRemittanceAdvicesFileNames @RADate=" & MakeSQLText(NewDate) _
												& ", @DSHorDC='DC', @DCId=" & Session("DCId") & ", @SupplierEan='" & Session("UserName") & "'"
											
											
											XMLString = MakeERALinkXML(curConnection, SQL)
										Else ' Default to orders
											' Set the XMLString
											XMLString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
											XMLString = XMLString & "<rootnode><pmmessage>"
											XMLString = XMLString & "<requesttype>ListSupplierTrack</requesttype>"
											
											' Biuld the SQL Statement
											SQL = "listSupplierTrackCO @SupplierID=" & Session("ProcID") & _
												", @ReceiveDate=" & MakeSQLText(NewDate)
				'	Response.Write SQL
					'response.end
											Set ReturnSet = ExecuteSql(SQL, curConnection)   
							
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 Then
												' An error occured - Build the error xml string
												XMLString = XMLString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
												XMLString = XMLString & "<errormessage>" & ReturnSet("errormessage") & "</errormessage>"
												XMLString = XMLString & "</pmmessage></rootnode>"
											else
												' There are no errors - Continue
												' Check if this is an EDI or XML Supplier
												if IsNumeric(ReturnSet("SupplierEAN")) then
													IsEDI = 1
												else
													IsEDI = 0
												end if
												
												XMLString = XMLString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
												XMLString = XMLString & "<suppliername>" & ReturnSet("SupplierName") & "</suppliername>"
												XMLString = XMLString & "<supplierean>" & ReturnSet("SupplierEAN") & "</supplierean>"
												XMLString = XMLString & "<checkorder>" & IsEDI & "</checkorder>"
												
												' Loop through the recordset
												While not ReturnSet.EOF
													'XMLString = XMLString & "<detail>"
													cnt = cnt + 1
													
													If DCName <> ReturnSet("DCName") Then
														XMLString = XMLString & "<detail>"
														XMLString = XMLString & "<dcname>" & ReturnSet("DCName") & "</dcname>"
													end if
													
													XMLString = XMLString & "<buyer>"
													XMLString = XMLString & "<firstname>" & ReturnSet("BuyerName") & "</firstname>"
													XMLString = XMLString & "<surname>" & ReturnSet("BuyerSurname") & "</surname>"
													' Build the orders
													XMLString = XMLString & MakeXMLOrders (curConnection, XMLString, Session("ProcID"), ReturnSet("BuyerID"), NewDate)
													XMLString = XMLString & "</buyer>"
													XMLString = XMLString & "</detail>"
													
													ReturnSet.MoveNext
												Wend

												XMLString = XMLString & "</pmmessage></rootnode>"
											end if
																					
											' Replace all the invalid characters
											XMLString = Replace(XMLString,"&","&amp;")
											'Response.Write XMLString
											' Close the Recordset and Connection
											Set ReturnSet = Nothing
										
										End If
										curConnection.Close
										Set curConnection = Nothing
										
										Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate)				
										
										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)

										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										If DoAction = 6  Then
											XSLDoc.Load(const_app_TrackPath & "supplier\remittanceAdvices.xsl")
											DisplaySet = XMLDoc.TransformNode(XSLDoc)
										Else
											XSLDoc.Load(const_app_TrackPath & "supplier\strackreport.xsl")
											DisplaySet = XMLDoc.TransformNode(XSLDoc)
											' Check if the returnvalue is 0
											if XMLDoc.selectSingleNode("//rootnode/pmmessage/returnvalue").text = 0 Then
												' Get the SupplierEAN
												ReceiverEAN = XMLDoc.selectSingleNode("//rootnode/pmmessage/supplierean").text
												
												doTab = True
												
												' Create the tabfile
												CreateFile = CreateTabFile(ReceiverEAN, NewDate)
												
												'DisplaySet = Replace(DisplaySet,"@@Download",const_app_XMLDownloadOutPath & CreateFile)
												DisplaySet = Replace(DisplaySet,"@@Download",const_app_ApplicationRoot & "/tracktrace/supplier/downloadtabfile.asp?id=" & CreateFile)
												
												' Detemine if this is an XML or EDI supplier
												if IsNumeric(ReceiverEAN) Then
													' Replace the variable in the XSL
													DisplaySet = Replace(DisplaySet,"@@Format","EDI")											
												else
													' Replace the variable in the XSL
													DisplaySet = Replace(DisplaySet,"@@Format","XML")											
												end if
											end if
										End If
																				
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@Date",FormatLongDate(Request.QueryString("id"),false))
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<!--#include file="../../layout/globaljavascript.asp"-->
<!--#include file="../../layout/headclose.asp"-->
<body>
&nbsp;
<%
										' Write the XMLString 
										Response.Write "<br/><br/>"
										Response.Write DisplaySet
%>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/tracktrace/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/tracktrace/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	
	
		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>

<!--#include file="../../layout/end.asp"-->
