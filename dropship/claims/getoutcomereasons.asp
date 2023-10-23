<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<%		
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString

	DcId = Split(Request.QueryString("dcId"),",")(0)
	
	SqlCommand = "ListClaimOutcomeReason @DCid="  & DcId & ",@ReturnOnlyActive=1"
	
	
	Set rsOutcomeCodes = ExecuteSql(SqlCommand, SqlConnection)  
	If Not (rsOutcomeCodes.EOF And rsOutcomeCodes.BOF) Then
		While NOT rsOutcomeCodes.EOF
			
			OutputText = OutputText & "{""Id"":"""  & rsOutcomeCodes("Id") & ""","
			OutputText = OutputText & """Value"":"""  & rsOutcomeCodes("Value") & """},"
			
			rsOutcomeCodes.MoveNext
		Wend
	End If
	
	Response.Write "[" & Mid(OutputText,1,Len(OutputText)-1) & "]"
	
	rsOutcomeCodes.Close
	Set rsOutcomeCodes = Nothing
	SqlConnection.Close
	Set SqlConnection = Nothing
	
%>