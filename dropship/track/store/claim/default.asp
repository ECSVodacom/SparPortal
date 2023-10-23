<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions_bak20230116.asp"-->
<!--#virtual include="../../../includes/adovbs.inc"-->

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
										dim XMLDoc
										dim XSLDoc
										dim ClaimID
										dim DisplaySet
										dim strAddr
										dim dispAddr
										dim Count
										dim IsXML
										
										if Request.QueryString("item") = "" then
											ClaimID = 0
										else
											ClaimID = Request.QueryString("item")
										end if
										
										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
										
										' Biuld the SQL Statement for orders
										SQL = "exec itemClaim @ClaimID=" & ClaimID & _
											", @IsXML=" & IsXML
											
										'Response.Write SQL
										'response.end
										
										' Call the streaming function
										XMLString = XMLRequest(SQL, "", "" ,false)
										
										'Response.Write XMLString
										'Response.End
										
										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										XSLDoc.Load(Server.MapPath("default.xsl"))

										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										' Get the Supplier Address address
										strAddr = split(XMLDoc.selectSingleNode("//rootnode/smmessage/supplieraddr").text,",")
										
										' Loop through the address
										For Count = 0 to UBound(strAddr)
											dispAddr = dispAddr & strAddr(Count) & "<br>"
										Next
										
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@User",Session("FirstName"))
										'DisplaySet = Replace(DisplaySet,"@@OrdDate",FormatDateTime(XMLDoc.selectSingleNode("//rootnode/smmessage/receivedate").text,1))
										'DisplaySet = Replace(DisplaySet,"@@DelivDate",FormatDateTime(XMLDoc.selectSingleNode("//rootnode/smmessage/delivdate").text,1))
										DisplaySet = Replace(DisplaySet,"@@Address",dispAddr)
										DisplaySet = Replace(DisplaySet,"@@ClaimID",ClaimID)
%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<!--#include file="../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../../layout/end.asp"-->
