<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/setuserdetails.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/xmlfunctions.asp"-->
<!--#include file="includes/doxmlstring.asp"-->
<!--#include file="../../sqlreports/sqlreportfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<%
										Server.ScriptTimeout = 360000

										' Determine if the user is logged in
										'Call CookieLoginTrackCheck(const_app_ApplicationRoot & "/tracktrace/buyer/frmcontent.asp?action=" & Request.QueryString("action") & "&id=" & Request.QueryString("id"))
										
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
										Dim Folder
										dim TrackDate
										'DIM MakeXMLInvoice
										
										
										if Request.QueryString("action") = "" or IsNull(Request.QueryString("action")) then
											if Session("Action") = "" then
												Session("Action") = 6
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
										
'										Response.Write NewDate

										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate)
										
										Dim DoAction 
										DoAction = Session("Action")

										If DoAction = 6 Then

											SQL = "exec listRemittanceAdvicesFileNames @RADate=" & MakeSQLText(NewDate) & ", @DSHorDC='DC', @DCId=" & Session("DCId") & ", @BuyerId=" & Session("ProcID")
											'SQL = "exec SparDS.dbo.listRemittanceAdvicesFileNames @RADate=" & MakeSQLText(NewDate) & ", @DSHorDC='DC', @DCId=" & Session("DCId") & ", @BuyerId=" & Session("ProcID")
											'Response.Write SQL
											
											XMLString = MakeERALinkXML(curConnection, SQL)
										
										ElseIf DoAction = 7 then
											if Session("Permission") > 0 Then
												SQL = "exec listSSBUInvoiceTrack @DCID=" & Session("DCID") & _
													  ", @TrackDate=" & MakeSQLText(NewDate) & _
													  ", @DoAction=" & DoAction
												'response.write  Session("ProcID")
												'Response.Write "<br>" & SQL & "<br>"
												'Response.End
												' Call the 
												XMLString = MakeXMLInvoice (curConnection, SQL)
											'XMLString = XMLRequest(SQL, "", "" ,False)
												
											elseif DoAction = 8 then
												'NewDate = "2017/6/19"
												SQL = "exec listSSBUInvoiceTrack @DCID=" & Session("DCID") & _
													  ", @TrackDate=" & MakeSQLText(NewDate) & _
													  ", @DoAction=" & DoAction
												'response.write  Session("ProcID")
												'Response.Write "<br>" & SQL & "<br>"
												'Response.End
												' Call the 
												XMLString = MakeXMLInvoice (curConnection, SQL)
															
											END IF
										
										ElseIF DoAction = 8 then
											if Session("Permission") > 1 Then
												XMLString = MakeSuperXML (curConnection, NewDate)
												
											else
												' Biuld the SQL Statement
												SQL = "exec listBuyerTrack @BuyerID=" & Session("ProcID") & _
													", @ReceiveDate=" & MakeSQLText(NewDate) & _
													", @Type=0" & _
													", @SSBU=1"
													
												
												XMLString = XMLRequest(SQL, "", "" ,False)
												'response.write Session("Permission")
												'response.end
												'response.write sql
												'response.end
											end if
										ELSE
										
											if Session("Permission") > 1 Then
												XMLString = MakeSuperXML (curConnection, NewDate)
												
											else
												' Biuld the SQL Statement
												SQL = "exec listBuyerTrack @BuyerID=" & Session("ProcID") & _
													", @ReceiveDate=" & MakeSQLText(NewDate) & _
													", @Type=" & Session("Permission") & _
													", @SSBU=0"
													
												
												XMLString = XMLRequest(SQL, "", "" ,False)
												
												'response.write sql
												'response.end
											end if
										End If
										'response.write SQL
										'response.end

										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										' Determine if this is a Super Buyer
										if DoAction = 6 Then
											Set XSLDoc = Server.CreateObject(const_app_XMLObject)
											XSLDoc.async = false
											'Response.Write Server.MapPath("remittanceAdvices.xsl")
											XSLDoc.Load(Server.MapPath("remittanceAdvices.xsl"))
											
										elseif DoAction = 7 Then
											if Session("Permission") = 0 then
												Set XSLDoc = Server.CreateObject(const_app_XMLObject)
												XSLDoc.async = false
												XSLDoc.Load(const_app_TrackPath & "buyer\invoicetrackreport.xsl")
											else
												Set XSLDoc = Server.CreateObject(const_app_XMLObject)
												XSLDoc.async = false
												XSLDoc.Load(const_app_TrackPath & "buyer\sinvoicetrackreport.xsl")
											end if
										elseif DoAction = 8 then
											if Session("Permission") > 1 Then
												' Load the XSL Style Sheet for the super buyer
												Set XSLDoc = Server.CreateObject(const_app_XMLObject)
												XSLDoc.async = false
												XSLDoc.Load(const_app_TrackPath & "buyer\SSBUsupertrackreport.xsl")
											else
												' Load the XSL Style Sheet
												Set XSLDoc = Server.CreateObject(const_app_XMLObject)
												XSLDoc.async = false
												XSLDoc.Load(const_app_TrackPath & "buyer\SSBUbtrackreport.xsl")
											end if
										
										else
											if Session("Permission") > 1 Then
												' Load the XSL Style Sheet for the super buyer
												Set XSLDoc = Server.CreateObject(const_app_XMLObject)
												XSLDoc.async = false
												XSLDoc.Load(const_app_TrackPath & "buyer\supertrackreport.xsl")
											else
												' Load the XSL Style Sheet
												Set XSLDoc = Server.CreateObject(const_app_XMLObject)
												XSLDoc.async = false
												XSLDoc.Load(const_app_TrackPath & "buyer\btrackreport.xsl")
											end if
										end if

										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										if DoAction <> 6 Then
											if Session("Permission") > 1 Then
												LoginUser = Session("FirstName") & " " & Session("Surname")
												DisplaySet = Replace(DisplaySet,"@@LoginUser",LoginUser)
											else
												' Get a collection of the orders
												Set XMLOrders = XMLDoc.selectNodes("//rootnode/pmmessage/order")										
											
												' Loop through the collection
												For OrdCount = 0 to XMLOrders.Length-1
													' Get the receiverean
													ReceiverEAN = XMLOrders.item(OrdCount).selectSingleNode("receiverean").text
													
												'	if XMLOrders.item(OrdCount).selectSingleNode("firstconfirmdate").text <> "" Then
												'		DisplaySet = Replace(DisplaySet,"@@xmlref" & OrdCount+1,Replace(XMLOrders.item(OrdCount).selectSingleNode("xmlref").text,"\","-"))
												'	end if
													'DisplaySet = Replace(DisplaySet,"@@Order" & OrdCount+1 & "Number",Mid(XMLOrders.item(OrdCount).selectSingleNode("number").text,1,len(XMLOrders.item(OrdCount).selectSingleNode("number").text)-4))
													Dim ordSplit
													ordSplit = split(XMLOrders.item(OrdCount).selectSingleNode("number").text,"s")
													DisplaySet = Replace(DisplaySet,"@@Order" & OrdCount+1 & "Number",ordSplit(0)) 


													' Detemine if this is an XML or EDI supplier
													if IsNumeric(ReceiverEAN) Then
														' Replace the variable in the XSL
														DisplaySet = Replace(DisplaySet,"@@Format" & OrdCount+1 & "Check","EDI")
													else
														' Replace the variable in the XSL
														DisplaySet = Replace(DisplaySet,"@@Format" & OrdCount+1 & "Check","XML")											
													end if
												Next
											end if
										end if

										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@Date",FormatLongDate(Request.QueryString("id"),false))
										
%>

<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<!--#include file="../../layout/headclose.asp"-->
<!--#include file="../../layout/bodystart.asp"-->
<body>
<br />&nbsp;
&nbsp;
<%
										' Write the XMLString 
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
