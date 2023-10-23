<% 
	Response.Buffer = True
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1

 %>
<!--#include file="../includes/constants.asp"-->
<%
	Dim SqlSelect, cnObj, rsObj, ClaimId, UserFileName
	Dim FileLink
	
	'Response.Write "[{ ""filelink"": ""petur"" }]"
	'Response.End
	ClaimId = Request.QueryString("cid")
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString

	SqlSelect =  "GetClaimAttachments @Claim_Id=" & ClaimId
	
	
	Set rsObj = ExecuteSql(SqlSelect, cnObj)  
	If Not (rsObj.BOF And rsObj.EOF) Then 
		While Not rsObj.EOF
			UserFileName = rsObj("UserFileName")
			
			FileLink = FileLink & "{""filelink"":"
			
			If Session("UserName") = "SPARHEADOFFICE" Then
				Response.Write "<p></p>"
			End If
			
			FileLink = FileLink & """<tr><td class='pcontent' align='left' colspan='2'>"
			'FileLink = FileLink & "<a href='#' onclick=\""window.open('dodownload.asp?id=" & rsObj("Id") & "','_self');\"">" & UserFileName & "</a>"
			FileLink = FileLink & "<a target='_blank' href='" & const_app_DocumentRoot & rsObj("SystemGeneratedFileName") & "'>" & UserFileName & "</a>"
			FileLink = FileLink & "</td>"
			FileLink = FileLink & "</tr>""},"
		
		
			rsObj.MoveNext
		Wend
	Else
		FileLink = FileLink & "{""filelink"":""""},"
	End If
	rsObj.Close
	
	Set rsObj = Nothing
	
	cnObj.Close
	
	Set cnObj = Nothing
		
	FileLink = Mid(FileLink,1,Len(FileLink)-1)
	Response.Write "[" & FileLink & "]"
%>
	
