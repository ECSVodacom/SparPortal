<%@ Language=VBScript %>
<% Option Explicit%>
<!doctype html>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/freeASPUpload.asp"-->
<%
	Dim SavedQueryString, cnObj, rsObj, NewStatusId
	
	If UBound(Split(Request.QueryString("id"),"|")) <> 2 Then
		Response.Write "Invalid request"
		Response.End
	Else
		SavedQueryString = Request.QueryString("id")
	End If
	
	Function MakeSqlSafe(InputValue)
		If Len(InputValue) > 0 Then 
			MakeSqlSafe = Replace(InputValue,"'","''")
		Else
			MakeSqlSafe = ""
		End If
	End Function

	Dim DcId, ClaimTypeId, SupplierId
	Dim QueryStringArray
	QueryStringArray = Split(Request.QueryString("id"),"|")
	DcId = QueryStringArray(0)
	SupplierId = QueryStringArray(1)
	ClaimTypeId = QueryStringArray(2)
	
	Dim DcName
	Dim SupplierName
	Dim ClaimType
	
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	Set rsObj = ExecuteSql("GetUploadScheduleDetail @DcId=" & DcId & ", @SupplierId=" & SupplierId & ",@ClaimTypeId=" & ClaimTypeId, cnObj)     
	If Not (rsObj.BOF And rsObj.EOF) Then
		DcName = rsObj("DcName")
		SupplierName = rsObj("SupplierName")
		ClaimType = rsObj("ClaimType")
	End If
	rsObj.Close
	Set rsObj = Nothing
	
	If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
		Dim Upload
		Set Upload = New FreeASPUpload
		Upload.Save(Const_ClaimsBatchUpload)
	
		Dim Keys
		Keys = Upload.UploadedFiles.Keys
		
		Dim FileUploadResponse
		Dim FileName, FileSize, FileKey, ErrorMessage
		If (UBound(Upload.UploadedFiles.Keys) <> -1) Then
			For Each FileKey in Upload.UploadedFiles.Keys
				FileUploadResponse = FileUploadResponse & Upload.UploadedFiles(FileKey).FileName & " (" & Upload.UploadedFiles(FileKey).Length & "B) "
				FileName = Upload.UploadedFiles(FileKey).FileName 
				FileSize = Upload.UploadedFiles(FileKey).Length 
		
				
				Dim FileDestination
				FileDestination = Const_ClaimsBatchUpload & FileName
				
				Const Before2003 = "xls"
				Const After2003 = "xlsx"
				Dim FileNameArray
				FileNameArray = Split(FileName,".")
				

				ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & FileDestination & ";Extended Properties='Excel 12.0 Xml;HDR=YES; IMEX=1'"
			
				
				Dim cnWorkBook, ConnectionString, SqlCommand
				Dim rsWorkBook
				Dim StoreClaimNumber, CurrentStatus, NewStatus
				Dim ClaimsBatchUpdate_Id
				Dim ClaimIds
				ClaimIds = ""
				
				SqlCommand = "ClaimsBatchValidate @DcId=" & DcId & ",@ClaimTypeId=" & ClaimTypeId & ",@SupplierId=" & SupplierId _
					& ",@UserName='" & Session("UserName") & "',@FileName='" & MakeSqlSafe(FileName) &  "',@FileSize=" & FileSize
					

					
					
				Set rsObj = ExecuteSql(SqlCommand, cnObj)     					
				ClaimsBatchUpdate_Id = rsObj("ClaimsBatchUpdate_Id")
				rsObj.Close
				Set rsObj = Nothing
				
				
				Set cnWorkBook = Server.CreateObject("ADODB.Connection")
				cnWorkBook.Open ConnectionString
				
				Set rsWorkBook = cnWorkBook.Execute("SELECT * FROM  [Sheet1$]")
				
			
				Do While Not rsWorkBook.EOF 
					StoreClaimNumber = rsWorkBook.Fields.Item(0).Value
					CurrentStatus = rsWorkBook.Fields.Item(1).Value
					NewStatus = rsWorkBook.Fields.Item(2).Value
					
					If StoreClaimNumber <> "" Then
						SqlCommand = "ClaimsBatchValidateDetail @ClaimsBatchUpdate_Id=" & ClaimsBatchUpdate_Id & ",@StoreClaimNumber='" & MakeSqlSafe(StoreClaimNumber) _
							& "', @CurrentStatus='" & MakeSqlSafe(CurrentStatus) & "', @NewStatus='" & MakeSqlSafe(NewStatus)  _
							& "',@DcId=" & DcId & ",@ClaimTypeId=" & ClaimTypeId & ",@SupplierId=" & SupplierId 
							'response.write SqlCommand
						Set rsObj = ExecuteSql(SqlCommand, cnObj)     		
						If rsObj("ErrorCode") = -1 Then
							ErrorMessage = rsObj("ResponseMessage")
							ClaimIds = ""
							Exit Do
						Else
							ClaimIds = ClaimIds & "|" & rsObj("ClaimId") & "|"
						End If
						
						NewStatusId = rsObj("NewClaimStatusId")
						
						rsObj.Close
						Set rsObj = Nothing
					End If
					
					rsWorkBook.MoveNext
				Loop
				
				
				
				rsWorkBook.Close
				Set rsWorkBook = Nothing
				
				cnWorkBook.Close
				Set cnWorkBook = Nothing
			Next
		Else
			ErrorMessage = "No file to upload"
		End If	
	End If
	
	cnObj.Close
	Set cnObj = Nothing
	
%>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>SPAR</title>
	<script language="javascript">
	<!--
		if (<%=Session("IsLoggedIn")%> != 1) {
			top.location.href = "<%=const_app_ApplicationRoot%>";
		};
	//-->
	
	
	
	</script>
	<script type="text/javascript">
		function onClose()
		{
			if (window.opener && window.opener.document) {
				if (window.opener.document.getElementById('AddClaimIds') !== "undefined") {
					window.opener.document.getElementById('AddClaimIds').value = document.frmClaimsMassUploadRequest.txtClaimIds.value
					window.opener.document.getElementById('BatchUploadId').value = document.frmClaimsMassUploadRequest.txtBatchUploadId.value
					window.opener.document.getElementById('IsFileUpload').value = true;
					window.opener.document.getElementById('NewStatusId').value = '<%=NewStatusId%>';
					
					var indexForm = window.opener.document.getElementById("MassUpdateIndex");
					indexForm.submit();
				}
			}
			window.close();
		}
	</script>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" >
	<form name="frmClaimsMassUploadRequest" method="post" action="massuploadnew.asp?id=<%=SavedQueryString%>" enctype="multipart/form-data">
		<table border="0" class="pcontent">
			<tr>
				<td colspan="2" class="bheader" align="left" valign="top"><h3>UPLOAD SCHEDULE OF CHANGES</h3></td>
			</tr>
			<tr>
				<td colspan="3">Please click <b>close window</b> to refresh results page<br/><br/></td>
			<tr>
				<td>DC:</td>
				<td><%=DcName%></td>
			<tr>
			<tr>
				<td>Claim Type:</td>
				<td><%=ClaimType%></td>
			<tr>
			<tr>
				<td>Supplier:</td>
				<td><%=SupplierName%></td>
			<tr>
			<tr>
				<td><b>File:</b></td>
				<td>
					<input name="txtFile" id="txtFile" size="60" class="pcontent" type="file">
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">
					<input name="btnClose" id="btnClose" onclick="onClose();" value="Close Window" class="button" type="button">
					<input name="btnSubmit" id="btnSubmit" value="Upload / Validate" class="button" type="submit">
					<input type="hidden" name="txtClaimIds" id="txtClaimIds" value="<%=ClaimIds%>">
					<input type="hidden" name="txtBatchUploadId" id="txtBatchUploadId" value="<%=ClaimsBatchUpdate_Id%>">
	
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2"><%
					If ErrorMessage <> "" Then
						Response.Write "Batch <b>" & FileName & "</b>  rejected: " & ErrorMessage
					ElseIf ClaimsBatchUpdate_Id <> "" Then
						Response.Write "Batch <b>" & FileName & "</b> has been accepted. Batch Id " & ClaimsBatchUpdate_Id 
						Response.Write "<br/>ClaimIds" & ClaimIds
					End If %>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>

