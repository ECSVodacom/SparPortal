<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="Formatting.asp"-->

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
									
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										'Set ReportConnection = Server.CreateObject("ADODB.Connection")
										'ReportConnection.Open const_db_ConnectionString
										
										'Set StoreCurConnection = Server.CreateObject("ADODB.Connection")
										'StoreCurConnection.Open const_db_ConnectionString
										
										'Set dcConnection = Server.CreateObject("ADODB.Connection")
										'dcConnection.Open const_db_ReportConnection
										
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" >

<%
										if Request.QueryString("ReportOn") = "16" Then
											SQL = "exec listWebReport_Display @Level = 1, @FromDate = '" & GetFromDate(Request.QueryString("Month"),Request.QueryString("FromMonth"),Request.QueryString("FromDate"),Request.QueryString("Year")) & "', @Todate = '" & MakeToDate(Request.QueryString("Month"),Request.QueryString("Year"),Request.QueryString("ToDate")) & "', @ReportType = 'recon', @ReportOn = " & Request.QueryString("ReportOn") & ", @DC = " & Request.QueryString("DC") & ", @Supplier = " & Request.QueryString("Supplier") & ", @Store = " & Request.QueryString("Store")
										else
											SQL = "exec listWebReport_Display @Level = 1, @FromDate = '" & GetFromDate(Request.QueryString("Month"),Request.QueryString("FromMonth"),Request.QueryString("FromDate"),Request.QueryString("Year")) & "', @Todate = '" & MakeToDate(Request.QueryString("Month"),Request.QueryString("Year"),Request.QueryString("ToDate")) & "', @ReportType = '" & Request.QueryString("ReportType") & "', @ReportOn = " & Request.QueryString("ReportOn") & ", @DC = " & Request.QueryString("DC") & ", @Supplier = " & Request.QueryString("Supplier") & ", @Store = " & Request.QueryString("Store")
										End If
										'Response.Write(SQL)
										'Response.End 
										
										XMLString = DoFirstDrillDown(curConnection, SQL, Request.QueryString("Display"))
										XMLString = Replace(XMLString,"&","??")
									
										
										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										
										XSLDoc.Load(Server.MapPath("display.xsl"))
										
										
																				
										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
																				
										DisplaySet = Replace(DisplaySet,"@@Application",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@ReportType",Request.QueryString("Display"))
										DisplaySet = Replace(DisplaySet,"??","&")
										DisplaySet = Replace(DisplaySet,"!!","/")
										DisplaySet = Replace(DisplaySet,"@@FirstLocation",const_app_ApplicationRoot & "/Stats/billing/second.asp?dc=")
										'Response.write("Hello")
										'Response.End 
										
										Response.Write(DisplaySet)
%>


<!--#include file="../../layout/end.asp"-->

<%
													curConnection.Close 
													'StoreCurConnection.Close 
													'dcConnection.Close 
%>
