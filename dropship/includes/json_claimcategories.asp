<%@Language=VBScript%>
<!--#include file="../includes/constants.asp"-->
<% 
    pStr = "private, no-cache, must-revalidate" 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", pStr 
%>
<%
	
	Dim IsCodeMaintenance
	
	Dim Output, CTypeId, AllowSubReasons
	Dim cnObj, DCId
	
	If Request.QueryString("isCodeMaintenance") <> "" Then
		IsCodeMaintenance = Request.QueryString("isCodeMaintenance")
	Else
		IsCodeMaintenance = False
	End If
	
	CTypeId = Request.QueryString("id")
	CTypeId = Split(CTypeId,",")(0)
	
	If CTypeId = "-1" Then
		CTypeId = -1
	End If
	
	DCId = Request.QueryString("dcid")
	DCId = Split(DCId,",")(0)
	If DCId = "-1" Then
		DCId = -1
	End If
	
	Output = "{""optionValue"":-1, ""optionDisplay"": ""All Categories""},"

	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	Set rsObj = cnObj.Execute("ListClaimsCategories @ClaimTypeId=" & CTypeId & ", @ClaimCategoryId=-1, @DCId=" & DCId & ",@IsCodeMaintenance=" & IsCodeMaintenance)   
	If Not (rsObj.BOF And rsObj.EOF) Then

		rsObj.MoveFirst
		While Not rsObj.EOF
			Output = Output & "{""optionValue"":" & rsObj("ClaimCategoryId") & ", ""optionDisplay"": """ & rsObj("ClaimCategory")  & """},"
			
			rsObj.MoveNext
		Wend
	Else
		Output = "{""optionValue"":-1,""optionDisplay"":""-- No categories for claim type --""},"
	End If

	rsObj.Close 
	Set rsObj = Nothing 

		
	cnObj.Close 
	Set cnObj = Nothing
	
	Output = Left(Output,Len(Output)-1)
	Response.Write "[" & Output & "]"
	Response.End
%> 

