<!DOCTYPE html>
<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->

<%
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
function SetPage(pagenumber)
	{
		document.MassUpdateTracking.elements['hidCurrentPageNumber'].value = pagenumber;
		window.document.MassUpdateTracking.submit();
	}
</script>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="setSupplierSelectedVal(false);">
<form name="MassUpdateTracking" id="MassUpdateTracking" action="MassUpdateTracking.asp" method="post" autocomplete = "off" > 
	<table border="0" class="pcontent">
        <tr>
            <td colspan="2" class="bheader" align="left" valign="top"><h3>Batch Update Tracking</h3></td>
        </tr>
		<tr>
			<td>DC:</td>
			<td colspan="8">		
				<select name="cboDC" id="cboDC" class="pcontent">
					<% If Session("DCId") = 0 Then %>				
						<option value="-1,Not Selected">-- Select a DC --</option>
					<%
						End If
						
						selected = ""
						SqlCommand = "exec listDC @DC="  & Session("DCId")
						
						Set rsObj = ExecuteSql(SqlCommand, cnObj)  
						If Not (rsObj.EOF And rsObj.BOF) Then
							While NOT rsObj.EOF
								If rsObj("DCId") & "," & rsObj("DCcName") = Request.Form("cboDC") Then
									selected = "selected"
								Else 	
									selected = ""
								End If
					%>
							<option <%=selected%> value="<%=rsObj("DCID")%>,<%=rsObj("DCcName")%>"><%=rsObj("DCcName")%></option>
					<%
								rsObj.MoveNext
							Wend
						End If
					%>
				</select>
			</td>
		</tr>
		

		<tr><td>&nbsp;</td></tr>
    </table>
	<table class="pcontent" border="1" width="100%">
		
		
<%       
	Dim DCId 
	
	If Request.Form("cboDC") <> "" Then
		DCId = Split(Request.Form("cboDC"),",")(0)
	Else 	
		DCId = Session("DCId")
	End If
	
	CurrentPageNumber = Request.Form("hidCurrentPageNumber")
	If CurrentPageNumber = "" Then
		CurrentPageNumber = 1
	End If
	Set rsObj = ExecuteSql("ListClaimsBatchUpdate @DCId=" & DCId & ", @PageNumber=" & CurrentPageNumber, cnObj)     
	If Not (rsObj.BOF And rsObj.EOF) Then
%>
<tr>
			<td class="pcontent" align="center" colspan="2">Displaying <%If rsObj("PageSize") > rsObj("TotalRecords") Then Response.Write rsObj("TotalRecords") Else Response.Write rsObj("PageSize")%> records out of a total of <%=rsObj("TotalRecords")%> records.</td>
			<td class="pcontent" align="center">Records <%=rsObj("RowNumber")%> to 
			<%
				If CLng(rsObj("RowNumber")) + CLng(rsObj("PageSize")) > rsObj("TotalRecords") Then
					Response.Write rsObj("TotalRecords")
				Else
					Response.Write CLng(rsObj("RowNumber")) - 1 + CLng(rsObj("PageSize"))
				End If
			%> are currently displayed.</td>
			<td class="pcontent" align="left" colspan="15">
			<%
				If Not IsNumeric(Request.Form("hidCurrentPageNumber")) Or Request.Form("hidCurrentPageNumber") = "" Then
					hidCurrentPageNumber = 1
				Else
					hidCurrentPageNumber = CInt(Request.Form("hidCurrentPageNumber"))
				End If
			
				If hidCurrentPageNumber > 1 Then
					Response.Write "<a href='javascript: SetPage(" & hidCurrentPageNumber - 1 & ")'>Previous Page</a>" & " | " 
				End If
			
				If hidCurrentPageNumber < Int(rsObj("TotalRecords") / rsObj("PageSize") + 1) Then
					Response.Write "<a href='javascript: SetPage(" & hidCurrentPageNumber + 1 & ")'>Next Page</a>" & " | " 
				End If

				Dim TotalPages 
				TotalPages = Int(rsObj("TotalRecords") / rsObj("PageSize") + 1)
				FromPage = hidCurrentPageNumber - 4
				ToPage = hidCurrentPageNumber + 4
				If FromPage < 1 Then
					FromPage = 1
				End If
				If ToPage > TotalPages Then
					ToPage = TotalPages
				End If

				If hidCurrentPageNumber <> 1 Then
					Response.Write "<a href='javascript: SetPage(1)'>First Page</a>" & " | "
				End If
			
				If hidCurrentPageNumber = 0 Then
					Response.Write "<b>Page 1 |</b> "
				End If
				For i = FromPage To ToPage 
					If Cint(hidCurrentPageNumber) = i Then
						Response.Write "<b>Page " & i & " |</b> "
					Else
						Response.Write "<a href='javascript: SetPage(" & i & ")'>Page " & i & "</a>" & " | "
					End If
				Next
				If  hidCurrentPageNumber <> ToPage  Then
					Response.Write "<a href='javascript: SetPage(" &  TotalPages & ")'>Last Page</a>" & " | "
				End If
			%>
			</td>
		</tr>
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center"><b>DC</b></td>
			<td class="tdcontent" align="center"><b>Batch Number</td>
			<td class="tdcontent" align="center"><b>Previous Status</b></td>
			<td class="tdcontent" align="center"><b>New Status</b></td>
			<td class="tdcontent" align="center"><b>Date Created</b></td>
			<td class="tdcontent" align="center"><b>Date Updated</b></td>
			<td class="tdcontent" align="center"><b>Number Of Documents</b></td>
			<td class="tdcontent" align="center"><b>Changed By</b></td>
			<td class="tdcontent" align="center"><b>Status</b></td>
		</tr>
	<%
		While Not rsObj.EOF
	%>
		<tr>
			<td class="pcontent" align="center"><%=rsObj("DC")%></td>
			<td class="pcontent" align="center"><a target="_blank" href="MassUpdateTrackingDetail.asp?Guid=<%=rsObj("BatchGuid")%>"><%=rsObj("BatchNumber")%></></td>
			<td class="pcontent" align="center"><%=rsObj("PreviousStatus")%></td>
			<td class="pcontent" align="center"><%=rsObj("NewStatus")%></td>
			<td class="pcontent" align="center"><%=rsObj("DateRequested")%></td>
			<td class="pcontent" align="center"><%If IsNull(rsObj("DateProcessed")) Then Response.Write "-" else Response.Write rsObj("DateProcessed") End If%></td>
			<td class="pcontent" align="center"><%=rsObj("NumberOfDocuments")%></td>
			<td class="pcontent" align="center"><%If IsNull(rsObj("UserName")) Then Response.Write "-" Else Response.Write rsObj("UserName") End If %></td>
			<td class="pcontent" align="center"><%If IsNull(rsObj("UpdateStatus")) Then Response.Write "-" Else Response.Write rsObj("UpdateStatus") End If %></td>
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
%>
	
</table>
<table>
	<tr>
		<td>
			<input type="button" align="center" name="btnCloseWindow" id="btnCloseWindow" value="Close Window" class="button" onclick="javascript:window.close();">
			<input type="submit" class="button" name="btnSearch" id="btnSearch" value="Search" />
			<input type="hidden" name="hidCurrentPageNumber" id="hidCurrentPageNumber" >
		</td>
	</tr>
</table>
</form>


</body>
</html>

