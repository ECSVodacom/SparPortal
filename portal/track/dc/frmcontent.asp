<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/xmlfunctions.asp"-->
<!--#include file="includes/makeorders.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
//-->
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
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
					
										if CInt(Session("Action")) = 2 then
											' Biuld the SQL Statement for orders
											SQL = "exec listDCInvoiceTrack @DCID=" & Session("ProcID") & _
												", @TrackDate=" & MakeSQLText(NewDate)

											' Call the 
											XMLString = MakeXMLInvoice(curConnection, SQL)	
										else
											' Biuld the SQL Statement for orders
											SQL = "exec listDCOrderTrack @DCID=" & Session("ProcID") & _
												", @TrackDate=" & MakeSQLText(NewDate)

											' Call the 
											XMLString = MakeXMLOrders (curConnection, SQL)
										end if

										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										
										if CInt(Session("Action")) = "2" Then
											if Session("Permission") = 0 then
												'XSLDoc.Load(const_app_ApplicationRoot & "/track/dc/invoicetrackreport.xsl")
												XSLDoc.Load(Server.MapPath("invoicetrackreport.xsl"))
											else
												'XSLDoc.Load(const_app_ApplicationRoot & "/track/dc/sinvoicetrackreport.xsl")								
												XSLDoc.Load(Server.MapPath("sinvoicetrackreport.xsl"))
											end if
										else
											if Session("Permission") = 0 then
												'XSLDoc.Load(const_app_ApplicationRoot & "/track/dc/ordertrackreport.xsl")
												XSLDoc.Load(Server.MapPath("ordertrackreport.xsl"))
											else
												'XSLDoc.Load(const_app_ApplicationRoot & "/track/dc/sordertrackreport.xsl")
												XSLDoc.Load(Server.MapPath("sordertrackreport.xsl"))
											end if
										end if

										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@Date",FormatDate(Request.QueryString("id"),false))
										
										' Check if GATEWAYCALLCEN user is logged in
										if Session("ProcEAN") = "GATEWAYCALLCEN" then
											DisplaySet = Replace(DisplaySet,"@@GenInv","&#160;/&#160;<a href=" & chr(34) & "JavaScript: newWindow = openWin('" & const_app_ApplicationRoot & "/track/supplier/invoice/new.asp', 'GenInvoice', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');" & chr(34) &  " class=" & chr(34) & "NavLink" & chr(34) & " target=" & chr(34) & "frmcontent" & chr(34) & ">Generate Blank Invoice</a>")
										else								
											DisplaySet = Replace(DisplaySet,"@@GenInv"," ")											
										end if
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../layout/end.asp"-->
