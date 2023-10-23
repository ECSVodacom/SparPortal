<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
											
										end if
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
										dim SQL
										dim curConnection
										Dim GenDate
										Dim rrid
										Dim location
										
										'dim pos
										'pos = instr(1,request.QueryString("RRID"),"|")
										'rrid = left(request.QueryString("RRID"),pos - 1)
										'location = mid(request.QueryString("RRID"),pos + 1)
										Dim Val
										Val = Split(request.QueryString("RRID"),"|")
										rrid = Val(0)
										location = Val(1)
										'response.Write(rrid)
										'response.Write("<br>" & location)
										'response.End 
										
										GenDate = now()'FormatDate(Now(), "yyyy/MM/dd hh:mm:ss  tt")
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										SQL = "exec editReconView @RRDate=" & MakeSQLText(GenDate) & _
											", @EANNum=" & MakeSQLText(Session("ProcEAN")) & ", @RRID=" & rrid
											'response.Write(sql)
											'response.End 
										ExecuteSql SQL, curConnection
%>
<%
Response.redirect("https://spar.gatewayec.co.za/Francois")
%>
<!--
<body onload="document.FrmTmp.submit();">
<form name="FrmTmp" id="FrmTmp" method="post" action="https://spar.gatewayec.co.za/TEST/Default.aspx">
<input type="hidden" name="RRID" id="RRID" value="<%=rrid%>">
<input type="hidden" name="location" id="location" value="<%=location%>">
<input type="hidden" name="approot" id="approot" value="<%=const_app_ApplicationRoot%>">
</form>
Loading... Please wait... 
</body>-->



