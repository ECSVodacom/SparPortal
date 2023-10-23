<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/freeASPUpload.asp"-->
<!--#include file="../../includes/logincheck.asp"-->

<%	if Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	end if %>
<script type="text/javascript">
if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	}
</script>

<style>

	
.alert-danger {
    color: #a94442;
    background-color: #f2dede;
    border-color: #ebccd1;
    padding: 10px;
    border: 1px solid;
    border-radius: 2px;
    font-size: 15px;
    width: 400px;
    font-family: Arial;
    text-align: center;
	
	
}
</style>
<%
	On Error Goto 0

	Claim_Id = Request.QueryString("cid") 
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	NewPath = Year(Now) & "\" & Month(Now) 
	
	
	Set NetworkObject = CreateObject("WScript.Network")
	Set fs = CreateObject("Scripting.FileSystemObject")
	
	'if Not fs.DriveExists("x:") Then
	'	NetworkObject.MapNetworkDrive "x:", ServerShare, false
	'End If
	
	if Not fs.DriveExists("q:") Then
		NetworkObject.MapNetworkDrive "q:", ServerShare, false
	End If
	
	if Not fs.DriveExists("y:") Then
		NetworkObject.MapNetworkDrive "y:", AwsServerShare, false
	End If
	
	
	Set Upload = New FreeASPUpload
	Upload.Save(Const_App_ClaimsUploadDir  & NewPath)
	'Upload.Save(Const_App_ClaimsUploadDirBackup  & NewPath)
	Upload.Save(Const_App_AwsClaimsUploadDir  & NewPath)
	
	AwsNewPath = Const_App_AwsClaimsUploadDir & NewPath
	SavePath = "documents\spar\dropship\claims\upload\" & NewPath
	'NewPathBackup = Const_App_ClaimsUploadDirBackup & NewPath
	NewPath = Const_App_ClaimsUploadDir & NewPath
	
	
	MakeDir NewPath 
	'MakeDir NewPathBackup 
	MakeDir AwsNewPath
	
	
	If Err.Number = 3004 Then 
%>
	<p>
		<div class="alert alert-danger alert-dismissible fade in"><strong>File failed to upload.</br> If the problem persist please log a service request.</strong></div>
	</p>
	
<%
	End If

	If Err.Number = 0 Then   
		Dim fs 
		Set fs=Server.CreateObject("Scripting.FileSystemObject")
		SaveFiles = ""
		ks = Upload.UploadedFiles.keys
		InvalidFile = False
		
		
		
		AllowedExtensions = ".doc.docx.xls.png.bmp.jpeg.txt.xlsx.tiff.msg.tif.pdf.jpg"
		If (UBound(ks) <> -1) Then
		
			For Each fileKey In ks
				OriginalFileName = Upload.UploadedFiles(fileKey).FileName
				
				OriginalFileNameArray = Split(OriginalFileName,".")
				OriginalFileNameArrayUbound = UBound(OriginalFileNameArray)
				
				OriginalFileExtension = LCase(OriginalFileNameArray(OriginalFileNameArrayUbound))
				If InStr(AllowedExtensions,OriginalFileExtension) = 0 Then
					InvalidFile = True
					
					
					fs.DeleteFile(NewPath & "\" & OriginalFileName)
					
						
				Else	
					UploadedFileName = Replace(Upload.UploadedFiles(fileKey).FileName," ","_")
					UploadedFileExtension = Mid(UploadedFileName, InstrRev(UploadedFileName, "."))
					NewFileName = Replace(UploadedFileName,UploadedFileExtension,Session.SessionId & Year(Now) & Month(Now) & Day(Now) & Hour(Now) & Minute(Now) & Second(Now) & UploadedFileExtension)
					
					UserFileName = Upload.Form("txtUserFileName")
					If UserFileName = "" Then
						UserFileName = Upload.UploadedFiles(fileKey).FileName
					End If
					UserFileName = Replace(UserFileName,"'","''")
					NewFileName = Replace(NewFileName,"'","''")
					NewFileName = Replace(NewFileName,"#","")
					
			
					fs.MoveFile AwsNewPath & "\" & Upload.UploadedFiles(fileKey).FileName, AwsNewPath & "\" & NewFileName
					fs.MoveFile NewPath & "\" & Upload.UploadedFiles(fileKey).FileName, NewPath & "\" & NewFileName
					'fs.MoveFile NewPathBackup & "\" & Upload.UploadedFiles(fileKey).FileName, NewPathBackup & "\" & NewFileName
					
					QueryString = "exec AddClaimAttachment " & _
						"@Claim_Id=" & Claim_Id & _
						",@UserFileName=" & UserFileName & _
						",@PathAndName=" & SavePath & "\" & NewFileName & _
						",@FileSize=" & Upload.UploadedFiles(fileKey).Length & _
						",@UserId=" & CInt(Session("UserId"))
					
					
					Set rsObj = ExecuteSql(QueryString, cnObj)
				
				
								
				
					SaveFiles = SaveFiles & UserFileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) uploaded successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now) &  "<br />"
			
					
				End If
			Next
			
			
			
		End If
		
		Set fs = Nothing
		
		
		
	End If
	
	Function MakeDir(strFolder)
	
		Dim objFSO, pathArray, pathDir 
		Set objFSO = Server.CreateObject("Scripting.FileSystemObject")

		' See if the folder already exists.
		' If not, create it, else do nothing
		If Not objFSO.FolderExists(strFolder) Then
			' Split path into individual folders
			pathArray = Split(strFolder, "\")

			' Step through path and create each folder as needed.
			' In the first iteration of this loop, using the strFolder
			' example above, it will look for "C:\". In the second
			' iteration, "C:\inetpub\", the 3rd "C:\InetPub\wwwroot\Spar\",
			' and so on until the entire structure has been created.
			pathDir = ""
			For i=0 To UBound(pathArray)
				pathDir = pathDir & pathArray(i) & "\"
				' See if the folder already exists.
				' If not, create it, else do nothing
				If Not objFSO.FolderExists(pathDir) Then
					objFSO.CreateFolder(pathDir)
				End If
			Next
		End If
		' Cleanup
		Set objFSO = Nothing
	End Function 
	
	
	
%>

<form name="UploadClaim" id="UploadClaim" method="post" action="upload.asp?cid=<%=Claim_Id%>" enctype="multipart/form-data" >

	<table border="0" class="pcontent">
		<tr>
			<td class="bheader" align="left" valign="top">ADD NEW SUPPORTING DOCUMENT</td>
		</tr>
	</table>
	<tr><td class="pcontent"><input type="file"  name="txtFile" id="txtFile" size="60" class="pcontent" onchange="return doUpload();" ></td></tr>
	
	
	<!--<input type="text" id="txtUserFileName"  name="txtUserFileName" />-->
	<table>
	<tr>
		<td class="warning" colspan="3" wrap="virtual"><b><noscript><br />Your javascript is disabled. For a better website experience, please enable javascript<br />Documents will not be automatically uploaded, click on the upload button, then Refresh when upload is complete<br /><br /><input type="submit" value="Upload"/></noscript></b></td>
	</tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="3" class="warning"><b>
				<%
					If InvalidFile Then
						Response.Write "Files with extension <b>." & OriginalFileExtension & "</b> not allowed<br/>"
						Response.Write "Only <b>" & Replace(AllowedExtensions,".","&nbsp;.") & "</b> extensions are allowed"
					 ElseIf  SaveFiles <> "" Then
						'Response.Write SaveFiles & "<br />" & "Click refresh to see the upload"
						Response.Write "<script type='text/javascript'>" _
							& "var v = window.parent.location.href.indexOf('cid='); " _
							& "if (v = 0) { window.parent.location = window.parent.location.href += '?cid=" & Claim_Id & "' } else { " _
							& "window.parent.location = window.parent.location.href };</script>"
					End If
				%>
			</b></td>
			
		</tr>
		
	</table>
</form>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<script>
function doUpload()
	{
		try
		{
			document.forms[0].submit();
		}
		catch (e)
		{
			alert('Your IE is unable to upload the file programmatigly, please make use of the browse button  ' + e.message);
			
		}
	};
	
	
</script>

