<%@Language=VBScript%>
<%Option Explicit%>
<!--#include file="../includes/constants.asp"-->
<% 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", "private, no-cache, must-revalidate"  

	
	Dim cnObj, rsObj, SqlCommand
	Dim Output
	Dim Guid, IsGuid
	
	Guid = Request.QueryString("guid")
	If Request.QueryString("guid") = "0" Or  Request.QueryString("guid") =  "" Then
		IsGuid = False
	Else
		Guid = Request.QueryString("guid")
		IsGuid = True
	End If
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	If IsGuid Then
		SqlCommand = "ListWarehouseClaimLevels @Guid='" & Guid & "'"
	Else
		SqlCommand = "ListWarehouseClaimLevels"
	End If
	
	Dim ClaimLevelsCount
	ClaimLevelsCount = 0
	Set rsObj = cnObj.Execute(SqlCommand)
	If Not (rsObj.EOF And rsObj.BOF) Then
		While NOT rsObj.EOF
			
			Output = Output & "{""from"":""" & rsObj("From") & """, ""to"":""" & rsObj("To") & """, ""email"":""" & rsObj("EmailAddress") & """},"
			
			ClaimLevelsCount = ClaimLevelsCount + 1
			
			rsObj.MoveNext
		Wend
	End If
	
	Set rsObj = Nothing 
		
	cnObj.Close 
	Set cnObj = Nothing
	
	If ClaimLevelsCount = 0 Then
		Output = Output & "{""from"":"""", ""to"":"""", ""email"":""""},"
	End If
	Output = Left(Output,Len(Output)-1)
	Response.Write "[" & Output & "]"

	Response.End
%> 

