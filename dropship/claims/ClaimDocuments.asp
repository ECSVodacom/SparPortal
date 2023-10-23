<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->

<%	if Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	end if %>
<script type="text/javascript">
if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	}
</script>
<%
	Dim Folder, i, ClaimCategoryId, SqlUpdate, Deleted, ButtonAction, DocumentIds
	Dim ClaimId, IsDisabled
	
	If Request.Form("ClaimId") <> "" Then
		ClaimId = Request.Form("ClaimId")
	Else
		ClaimId = Request.QueryString("cid")
	End If
	
	Dim cnObj, rsObj
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	
	
	Deleted = ""
	ButtonAction = Request.Form("ButtonAction")
	If Request.Form("chkSelect") <> ""  Then 
		DocumentIds = Split(Request.Form("chkSelect"),",")
		If ButtonAction = "Delete" Then 
			For i = 0 To UBound(DocumentIds)
				SqlUpdate = "ManageClaimSupportingDocument @Id = " & Trim(DocumentIds(i))
				
				Set rsObj = ExecuteSql(SqlUpdate, cnObj)

				Deleted = Deleted & "<b>" & rsObj("ErrorDescription") & "</b><br />"
			Next 
		ElseIf ButtonAction = "Save" Then
			For i = 0 To UBound(DocumentIds)
				SqlUpdate = "ManageClaimSupportingDocument @Id = " & Trim(DocumentIds(i)) & ", @NewName='" & Request.Form("filename_" & Trim(DocumentIds(i))) & "'"
				
				Set rsObj = ExecuteSql(SqlUpdate, cnObj)

				Deleted = Deleted & "<b>" & rsObj("ErrorDescription") & "</b><br />"
			Next 
		End If 
	End If
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<style>
.warning
{
    BORDER-RIGHT: #eeeeee 1px;
    BORDER-TOP: #eeeeee 1px;
    FONT-SIZE: 8pt;
    BACKGROUND: #ffffff;
    BORDER-LEFT: #eeeeee 1px;
    COLOR: red;
    BORDER-BOTTOM: #eeeeee 1px;
    FONT-FAMILY: Arial, Helvetica, sans-serif
}
</style>
<script type="text/javascript" src="../includes/jquery.min.js"></script>
<script type="text/javascript">
	
	$(function(){
		$.getJSON("json_listattachments.asp",{cid: <%=ClaimId%>}, function(l){
			var links = '';
					
			for (var i = 0; i < l.length; i++) {
				links += l[i].filelink;
			}
			//alert(links); 
			var document_list = $("[name=document_list]", window.opener.document);
			document_list.html(links);
		})
	})
	
	
	function onRename()
	{
		for (var i = 0; i < claimdocuments.elements.length; i++ ) {
			if (claimdocuments.elements[i].type == 'checkbox') {
				if (claimdocuments.elements[i].checked == true) {
					return true;
				}
			}
		}
		
		alert('You have not selected any documents to be renamed');
		
		return false;
	}
	
	function OnDelete(obj) {
		// Verify at least on box selected
		for (var i = 0; i < claimdocuments.elements.length; i++ ) {
			if (claimdocuments.elements[i].type == 'checkbox') {
				if (claimdocuments.elements[i].checked == true) {
					result = confirm("This will remove the attachment, ok to confirm?");
					if (result == false)
						return false
					else
						return true;
				}
			}
		}
		
		alert('You have not selected any documents to be deleted');
		
		return false;
	}

	
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="claimdocuments" id="claimdocuments" method="post" action="claimdocuments.asp?cid=<%=ClaimId%>" >
	<table border="0" class="pcontent">
		<tr>
			<td class="bheader" align="left" valign="top">MANAGE SUPPORTING DOCUMENTS</td>
		</tr>
	</table>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
	<table>
		<tr>
			<td>
				<input class="button" type="submit" name="ButtonAction" id="btnRefresh" style="width: 98px" value="Refresh"/>
			</td>
			<td>
				<input type="button"align="center" name="btnCloseWindow" id="btnCloseWindow" style="width: 98px" value="Close Window" class="button" onclick="javascript:window.close();">
			</td>
			
			<td>
				<% If ButtonAction = "Rename" Then %>
					<input class="button" type="submit" name="ButtonAction" id="btnSave" style="width: 98px"  onclick="javascript:return onsave();" value="Save"/>
					<input class="button" type="submit" name="ButtonAction" id="btnCancel" style="width: 98px"  value="Cancel"/>
				<% Else %>
					<input class="button" type="submit" name="ButtonAction" id="btnRename" onclick="javascript:return onRename()" style="width: 98px"  value="Rename"/>
				<% End If %>
			</td>
			<td>
			</td>
			<td>
				<input class="button" type="submit" name="ButtonAction" onclick="javascript:return OnDelete(this)" style="width: 98px" value="Delete"/>
			</td>
		</tr>
		<tr>
			<td colspan="5" class="pcontent">
				<i>Only the user who uploaded the document is allowed to Delete it</i>
			</td>
		</tr>
	</table>
<%	
	Dim Already

	Set rsObj = ExecuteSql("GetClaimAttachments @Claim_Id='" & ClaimId & "'", cnObj)
	
	
		If Not (rsObj.BOF And rsObj.EOF) Then
		
	%>	
			<table cellSpacing="2" cellPadding="4" border="0" style="width: 50%%">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center" style="width: 5%"><b>Select</b></td>
					<td class="tdcontent" align="center" style="width: 40%"><b>Document</b></td>
				</tr>
				
			
	<%
			While Not rsObj.EOF
				
				If Session("UserId") = rsObj("User_Id") Then
					IsDisabled = ""
				Else
					IsDisabled = "disabled"
				End If

				Response.Write "<tr>"
			
				If ButtonAction = "Rename" Then 
					Already = False			
					For i = 0 To UBound(DocumentIds)
						If rsObj("Id") = CLng(Trim(DocumentIds(i))) Then	
							Response.Write "	<td class='pcontent'>"%><input type="checkbox" checked name="chkSelect" <%=IsDisabled%> value="<%=rsObj("Id")%>"/></td><%
							Response.Write "	<td class='pcontent'>"%><input type="text" name="filename_<%=rsObj("Id")%>" class='pcontent' style="width: 100%" value="<%=rsObj("UserFileName")%>" /></td><%
							Already = True
							Exit For
						End If
				
					Next 
					If Not Already Then 
						Response.Write "	<td class='pcontent'>"%><input type="checkbox" name="chkSelect" <%=IsDisabled%> value="<%=rsObj("Id")%>"/></td><%
						Response.Write "	<td class='pcontent'><a href='#' onclick=""window.open('dodownload.asp?id=" & rsObj("Id") & "','_self');"">" & rsObj("UserFileName")  & "</a></td>"
						'Response.Write "	<td class='pcontent'><a href='#' target=""_blank"" onclick=""window.open('dodownload.asp?id=" & rsObj("Id") & "','_self');"">" & rsObj("UserFileName")  & "</a></td>"
						Response.Write "	<td class='pcontent'><a target='_blank' href='" & const_app_DocumentRoot & GetDocumentPath(rsObj("SystemGeneratedFileName")) & "'>" & rsObj("UserFileName") & "</a></td>"
					End If
				Else
					Response.Write "	<td class='pcontent'>"%><input type="checkbox" name="chkSelect" <%=IsDisabled%> value="<%=rsObj("Id")%>"/></td><%
					'Response.Write "	<td class='pcontent'><a href='#' onclick=""window.open('dodownload.asp?id=" & rsObj("Id") & "','_self');"">" & rsObj("UserFileName")  & "</a></td>"
					Response.Write "	<td class='pcontent'><a target='_blank' href='" & const_app_DocumentRoot & GetDocumentPath(rsObj("SystemGeneratedFileName")) & "'>" & rsObj("UserFileName") & "</a></td>"
				End If
			
				'Response.Write "</tr>"
			
				rsObj.MoveNext
			Wend
	%>
			</table>
			

	<%
		Else
	%>
			<table border="1" cellpadding="0" cellspacing="0" width="50%">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center">No supporting documents</td>
				</tr>
			</table>
	<%	
		End If
	
		cnObj.Close


	
	
	If Deleted <> "" Then
%>	
		<table>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="3" class="warning">
					<%=Deleted%>
					<input type="hidden" name="IsSubmit" id="IsSubmit" value="1"/>
				</td>
				
			</tr>
		</table>
<%
	End If
%>

	<input name="ClaimId" type="hidden" value="<%=ClaimId%>" />
	
</form>

<% If Session("UserName") <> "SPARHEADOFFICE"  Then %>
	<iframe height="500" width="950" frameborder="0" border="0" marginwidth="0" marginheight="0" scrolling="no" src="upload.asp?cid=<%=ClaimId%>"></iframe>
<% End If %>
<!--#include file="../layout/end.asp"-->
<%
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
	
	Function GetDocumentPath(path)
		GetDocumentPath = ""
		Dim docPath 
		docPath = Replace(ServerShare & "\" & path, "documents\", "")
		'Dim docPathBackup 
		'docPathBackup = Replace(Const_App_ClaimsUploadDirBackupWhack & path, "documents\", "")
		Dim docPathAws
		docPathAws = Replace(AwsServerShare &  "\" & path, "documents\", "")
	
		Dim fs 
		Set fs=Server.CreateObject("Scripting.FileSystemObject")
		
		If fs.FileExists(docPath) Then
			GetDocumentPath = path
		ElseIf fs.FileExists(docPathAws) Then
			GetDocumentPath = Replace(path, "documents", "awsDocumentsBackup")
		Else
			GetDocumentPath = Replace(path, "documents", "awsDocumentsBackup")
			'GetDocumentPath = Replace(path, "documents", "documentsBackup")
		End If

		
	End Function
%>