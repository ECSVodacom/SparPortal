<!DOCTYPE html>
<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->

<%
	Function IsGuid(byval stringGuid)
      If IsNull(stringGuid) Then
        IsGuid = False
        Exit Function
      End If
      Dim RegEx
      Set RegEx = New RegExp
      RegEx.Pattern = "^({|\()?[A-Fa-f0-9]{8}-([A-Fa-f0-9]{4}-){3}[A-Fa-f0-9]{12}(}|\))?$"
      IsGuid = RegEx.Test(stringGuid)
      Set RegEx = Nothing
	End Function

	Dim BatchId 
	BatchId = Request.QueryString("Guid") 
	
	if Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	end if
	
	Dim cnObj
	Dim rsObj
	Dim Folder
	
	Select Case Session("UserType") 
		Case 1,4
			Folder = "supplier"
		Case 2
			Folder = "dc"
		Case 3	
			Folder = "store"
		Case Else
			Folder = "dc"
	End Select
	
	
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
%>
	

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SPAR</title>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
//-->
</script>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="setSupplierSelectedVal(false);">
<form name="MassUpdateTracking" id="MassUpdateTracking" action="MassUpdateTracking.asp" method="post" autocomplete = "off" > 
	<table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top"><h3>Batch Update Tracking - Detail</h3></td>
			
        </tr>
    </table>
	<table border="1" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="bheader" align="left" colspan="12"></td>
		</tr>	
<%       
	Dim SqlSelect 
	If IsGuid(BatchId) Then
		SqlSelect = "ListClaimsBatchUpdateDetail @BatchId='" & BatchId & "'"
		Set rsObj = ExecuteSql(SqlSelect, cnObj)   
		If Not (rsObj.BOF And rsObj.EOF) Then
	%>
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" align="center"><b>Supplier</b></td>
				<td class="tdcontent" align="center"><b>Store</td>
				<td class="tdcontent" align="center"><b>Claim Number</b></td>
				<td class="tdcontent" align="center"><b>Claim Received</b></td>
				<td class="tdcontent" align="center"><b>Status</b></td>
			</tr>
		<%
			While Not rsObj.EOF
		%>
			<tr>
				<td class="pcontent" align="center"><%=rsObj("SPcName")%></td>
				<td class="pcontent" align="center"><%=rsObj("STcName")%></td>
				<td class="pcontent" align="center"><a href="<%=const_app_ApplicationRoot%>/track/<%=Folder%>/claim/default.asp?item=<%=rsObj("CLID")%>" target="_blank"><%=rsObj("CLcClaimNumber")%></a></td>
				<td class="pcontent" align="center"><%=rsObj("ClaimDateReceived")%></td>
				<td class="pcontent" align="center"><%=rsObj("Status")%></td>
			</tr>
		<%                                            
				rsObj.MoveNext  
			Wend
		Else
	%>
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center">
				<b>No batch records found</b>
			</td>
		</tr>
	<%
		End If
		
		rsObj.Close
		cnObj.Close
		
		Set rsObj = Nothing
		Set cnObj = Nothing
	Else
	%>
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center">
				<b>Batch not found</b>
			</td>
		</tr>
	<%	
	End If
	
	
%>
	
</table>
<table>
	<tr>
		<td>
			<input type="button" align="center" name="btnCloseWindow" id="btnCloseWindow" value="Close Window" class="button" onclick="javascript:window.close();">
		</td>
	</tr>
</table>
</form>


</body>
</html>

