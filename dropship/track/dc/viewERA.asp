<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%
										If Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										End If
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		window.parent.opener.top.location.href = "<%=const_app_ApplicationRoot%>";
		close();
	};
//-->
</script>
<%
                                        Dim sqlCommand
										Dim curConnection
										Dim GenDate
                                        Dim XML_UID
                                        Dim FileLocation
                                        Dim DoAction
										Dim arrParameters
                                        Dim DoReport
                                        Dim ViewOnly
                                        Dim URL
                                        Dim OrderBy
                                        
                                        OrderBy = Request.Form("OrderLineItems")
                                        
										arrParameters = Split(Request.Form("ViewReportType"),"|")
										XML_UID = arrParameters(0)
										FileLocation = arrParameters(1)
										DoAction = arrParameters(2)
										
										If UBound(arrParameters) > 2 Then
										    ViewOnly = arrParameters(3)
										End If
										
										
										GenDate = now()
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										
										Select Case DoAction
										    ' Electronic Remittance Advice Statement
										    Case "era"
										        DoReport = "remittance_advice"
										        sqlCommand = "updateRAViewedDate @XML_UID=" & XML_UID
										        sqlCommand = sqlCommand & ", @LastViewedDate = '" & GenDate & "'"
										        sqlCommand = sqlCommand & ", @EAN_Number='" & Session("ProcEAN") & "'"
										    ' Tax Invoice
                                            Case "ti"
                                                DoReport = "tax_invoice"
										        sqlCommand = "updateRATaxViewedData @XML_UID=" & XML_UID
										        sqlCommand = sqlCommand & ", @LastViewedDate = '" & GenDate & "'"
										        sqlCommand = sqlCommand & ", @EAN_Number='" & Session("ProcEAN") & "'"
										End Select
                                        
										
										ExecuteSql sqlCommand, curConnection
										
										
                                        
										
										curConnection.Close
                                        
                                        Set curConnection = Nothing
                                        
                                        URL = "http://spar.gatewayec.co.za/era/Default.aspx?XML_ID=" & XML_UID & "&doReport=" & DoReport & "&showOnly=" & ViewOnly
%>
<body onload="document.FrmTmp.submit();">

<%
										If ("view" = "view") Then
%>
<form name="FrmTmp" id="Form1" method="post" action="<%=URL%>">
<%
										Else
%>
<form name="FrmTmp" id="FrmTmp" method="post" action="http://spar.gatewayec.co.za/ReconDetail/Default.aspx">
<%
										End If
%>
<input type="hidden" name="XML_UID" id="XML_UID" value="<%=XML_UID%>">
<input type="hidden" name="FileLocation" id="FileLocation" value="<%=FileLocation%>">
<input type="hidden" name="doReport" id="doReport" value="<%=DoReport%>">
<input type="hidden" name="approot" id="approot" value="<%=const_app_ApplicationRoot%>">
<input type="hidden" name="OrderBy" id="OrderBy" value="<%=OrderBy %>"></form>
Loading... Please wait... 
</body>