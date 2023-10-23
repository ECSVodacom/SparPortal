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
	Dim rsUsers 
	Dim SqlSelect
	Dim UserName
	
	UserName = Request.QueryString("u")
	
	If UserName = "" Then Response.End
	
	SqlSelect = "GetSuggestedNames @UserName=" & UserName  
	
	
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString
	Set rsUsers = ExecuteSql(SqlSelect, SqlConnection)  	
	
	
	If Not (rsUsers.EOF And rsUsers.BOF) Then
		Response.Write "["	
		While Not rsUsers.EOF
			Response.Write """" & Replace(Replace(rsUsers("StatusChangedByUserName"),"\",""),"'","") & """"
			
			rsUsers.MoveNext
			If Not (rsUsers.EOF) Then
				Response.Write ","
			End If
		Wend
		Response.Write "]"
	End if
	
	
	SqlConnection.Close
	Set SqlConnection = Nothing
	
	Function MakeSqlSafe(input)
		input = Replace(input,"'","''")
		MakeSqlSafe = input
	End Function
%>