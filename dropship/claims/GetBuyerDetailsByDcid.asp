<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<%	
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString
	
	DcId = Split(Request.QueryString("DcID"),",")(0)
	Set rsBuyer = ExecuteSql("ListBuyers @DcId=" & DcId, SqlConnection)  
	If Not (rsBuyer.BOF And rsBuyer.EOF) Then
		Output = ""
		
		Output = Output & "{""optionValue"":" & "0" & ", ""optionDisplay"": """ & "All Buyers" & """},"
		While Not rsBuyer.EOF 
			Output = Output & "{""optionValue"":" & rsBuyer("BUID")& ", ""optionDisplay"":""" & rsBuyer("BuyerName") & """},"
			rsBuyer.MoveNext
		Wend
		Output = Left(Output,Len(Output)-1)
		
		Response.Write "[" & Output & "]"
		
	End If
	SqlConnection.Close
	Set SqlConnection = Nothing
%>