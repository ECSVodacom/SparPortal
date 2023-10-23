<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/xmlfunctions_bak20230116.asp"-->
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
										Dim URL
										
										
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" >
<%
	if Request.QueryString("Back") <> "" Then
%>
		<form >
			<input type=button value="Back" onCLick="history.back()" ID="Button1" NAME="Button1"/>
		</form>

<%
	end if
										
										
										If Request.QueryString("Total") <> "" Then
											SQL = "exec listWebReport_Display @Level = 3, @FromDate = '" & Request.QueryString("FromDate") & "', @Todate = '" & Request.QueryString("ToDate") & "', @ReportType = '" & Request.QueryString("ReportType") & "', @ReportOn = " & Request.QueryString("ReportOn") & ", @DC = " & Request.QueryString("DC") & ", @Supplier = " & Request.QueryString("Supplier") & ", @Store = " & Request.QueryString("Store")
										Else
											SQL = "exec listWebReport_Display @Level = 3, @FromDate = '" & GetFromDate(Request.QueryString("Month"),Request.QueryString("FromMonth"),Request.QueryString("FromDate"),Request.QueryString("Year")) & "', @Todate = '" & MakeToDate(Request.QueryString("Month"),Request.QueryString("Year"),Request.QueryString("ToDate")) & "', @ReportType = '" & Request.QueryString("ReportType") & "', @ReportOn = " & Request.QueryString("ReportOn") & ", @DC = " & Request.QueryString("DC") & ", @Supplier = " & Request.QueryString("Supplier") & ", @Store = " & Request.QueryString("Store")
										End if
										
										'Response.Write(SQL)
										'Response.End 
										
										Dim SQL_Download
										
										SQL_Download = Replace(SQL,"@Level = 3","@Level = 5")
										'Response.Write SQL_Download
										'Response.End
										Dim XMLURL, TXTURL
										
										XMLURL = "download.asp?Type=2&SQL=" & SQL_Download
										TXTURL = "download.asp?Type=3&SQL=" & SQL_Download
										
										
%>

<ul>
	<li class="pcontent">To download this in xml click <a href="<%=XMLURL%>" >here</a></li>
	<li class="pcontent">To download this in flat file click <a href="<%=TXTURL%>" >here</a></li>
</ul>

<%
										XMLString = "<Rootnode>" & XMLRequest(SQL,"","",false) & "</Rootnode>"
										'Response.Write(XMLString)
										'Response.End 
										
'										XMLString = DoThirdDrillDown(curConnection, SQL, Request.QueryString("Display"))
'										XMLString = Replace(XMLString,"&","??")
'										
'										' Load the String into an XML Dom
										'Response.Write SQL
										'Response.Write(XMLString)
										'Response.End 
'										
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										
										
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										
										XSLDoc.Load(Server.MapPath("detail.xsl"))
										
										'Response.End 
																				
										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										DisplaySet = Replace(DisplaySet,"@@Application",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@ReportType",Request.QueryString("Display"))
										DisplaySet = Replace(DisplaySet,"!!!@@@!!!","<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""100%"">")
										DisplaySet = Replace(DisplaySet,"~~~","</table><br/>")
										DisplaySet = Replace(DisplaySet,"??","&")
										DisplaySet = Replace(DisplaySet,"!!","/")
										
										
										
										'DisplaySet = Replace(DisplaySet,"@@FirstLocation",const_app_ApplicationRoot & "/report/billing/Third.asp?dc=")
										
										Response.Write(DisplaySet)
										
%>


<!--#include file="../../layout/end.asp"-->

<%
													'curConnection.Close 
													'StoreCurConnection.Close 
													'dcConnection.Close 
%>
