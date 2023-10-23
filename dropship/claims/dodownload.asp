<!--#include file="DownloadFunction.asp"-->
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->


<%	if Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	end if %>
<script type="text/javascript">
if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	}
</script>
<%

	Id = Request.QueryString("Id")
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	Set rsObj = ExecuteSql("GetClaimAttachments @Claim_Id=" & Id, cnObj)  
	If Not (rsObj.EOF And rsObj.BOF) Then
		DoDownload rsObj("UserFileName"), Replace(rsObj("SystemGeneratedFileName"),"'","''")
	Else
		Response.Write "<table><tr><td class='tdcontent'>The file no longer exists</td></tr></table>"
	End If
	
	
	Set cnObj = Nothing
	Set rsObj = Nothing
	
%>