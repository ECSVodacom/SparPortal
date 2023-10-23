<%@Language=VBScript%>
<!--#include file="../includes/constants.asp"-->
<%
	
	
	Response.Write "[{""optionValue"":1,""optionDisplay"":""Testsss1"",""optionVendorCode"":1},{""optionValue"":2,""optionDisplay"":""Test2"",""optionVendorCode"":2}]"
	Response.End
	
	Dim ClaimCategoryId, Output
	Dim SqlSelect
	
	ClaimCategoryId = Request.QueryString("id")
	
	Output = ""
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	Set rsObj = ExecuteSql("ListClaimsCategoriesReasonCodes @ClaimTypeId=1, @ClaimCategoryId=" & ClaimCategoryId, cnObj) 
	If Not (rsObj.BOF And rsObj.EOF) Then
		While Not rsObj.EOF
			Output = Output & "{""optionValue"":" & rsObj("ClaimReasonId") & ", ""optionDisplay"": """ & rsObj("ReasonCode") & """},"
			
			rsObj.MoveNext
		Wend
	Else
		Output = "{""optionValue"":-1"", ""optionDisplay"": """ & "No reason codes linked to category" & """},"
	End If
	Output = Left(Output,Len(Output)-1)
	
	Response.Write Output 
	rsObj.Close 
	Set rsObj = Nothing 
		
	cnObj.Close 
	Set cnObj = Nothing
	
	
	
%> 

