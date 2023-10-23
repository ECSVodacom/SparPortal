<%@ Language=VBScript %>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
	};
//-->
</script>
<%
										ErrorFlag = False
										'XMLRef = mid(Replace(Request.QueryString("date"),"/",""),3,len(Replace(Request.QueryString("date"),"/",""))) & "\" & Request.QueryString("id") & ".xml"
										
										' Check if there is a querystring parameter
										if Request.QueryString("id") = "" Then
											ErrorFlag = True
										end if
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										SQL = "exec itemOrder @OrderNumber=" & MakeSQLText(Request.QueryString("id"))
										
										Set ReturnSet = ExecuteSql(SQL, curConnection)
										
										' Check the returnvalue
										if Returnset("returnvalue") <> 0 then
											ErrorFlag = True
										else
											ErrorFlag = False
											
											' Get the Folder
											XMLRefReturnSet("XMLRef")
										end if
										
										Set ReturnSet = Nothing
										
										' Close the Connection
										curConnection.Close
										Set curConnection = Nothing
										
										Set oFile = Server.CreateObject("Scripting.FileSystemObject")
										
										' Check if the file exist
										if oFile.FileExists (const_app_SparArcPath & XMLRef) = True Then
											ErrorFlag = False
										else
									
											ErrorFlag = True
										end if
										
										' Close the file
										Set oFile = Nothing
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<%
										' Check if there is an error
										if ErrorFlag Then
											' Display an error message
%>
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td><img src="<%=const_app_ApplicationRoot%>/layout/images/sparlogo.gif"></td>
		<td class="iheader" align="left">ORDER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td class="pcontent" align="right">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="pcontent" valign="middle">
						<a class="stextnav" href="javascript:window.print();"><img src="<%=const_app_ApplicationRoot%>/layout/images/print_new.gif" border="0" alt="Print this Order...">&nbsp;Print this Order</a><br/>
						<a class="stextnav" href="javascript:window.close();"><img src="<%=const_app_ApplicationRoot%>/layout/images/close.gif" border="0" alt="Close this Order...">&nbsp;Close this Order</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<p class="pcontent" align="center"><b>Due to the Order not being extracted and/or confirmed within 21 days, the data is not available for viewing.</b></p>
<%											
										else												
											' Load the XMl Document
											Set XMLDoc = Server.CreateObject(const_app_XMLObject)
											XMLDoc.async = false
											XMLDoc.Load(const_app_SparArcPath & XMLRef)

											' Load the XSL Style Sheet
											Set XSLDoc = Server.CreateObject(const_app_XMLObject)
											XSLDoc.async = false
											XSLDoc.Load(Server.MapPath("vieworder.xsl"))

											' Transform the xml doc with the xsl doc
											DisplaySet = XMLDoc.TransformNode(XSLDoc)
											
											' Get the value of the OrderNumber
											OrderNum = XMLDoc.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text

											' Replace the values in the XSL File
											DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
													
											' Write the Transformation
											response.write DisplaySet
%>
<!--#include file="../../layout/end.asp"-->
<%
										end if
%>