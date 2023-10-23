<%@Language=VBScript%>
<!--#include file="../includes/constants.asp"-->
<% 
    pStr = "private, no-cache, must-revalidate" 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", pStr 
%>
<%
	
	
	Dim ClaimCategoryId, Output, CTypeId, AllowSubReasons
	Dim SqlSelect, cnObj
	
	AllowSubReasons = 0
	
	ClaimCategoryId = Request.QueryString("id")
	ClaimCategoryId = Split(ClaimCategoryId,",")(0)
	
	CTypeId =  Request.QueryString("ctypeid")
	
	If CTypeId = "" Then
		CTypeId = 1
		AllowSubReasons = 1
	Else
		CTypeId = Split(CTypeId,",")(0)
		AllowSubReasons  = 0
	End If
	
	
	Output = ""
	If CInt(ClaimCategoryId) = -1 Then
		Output = "{""optionValue"":-1,""optionDisplay"":""-- Please select category --""},"
	Else
		Set cnObj = Server.CreateObject("ADODB.Connection")
		cnObj.Open const_db_ConnectionString
		Set rsObj = ExecuteSql("ListClaimsCategories @ClaimTypeId=" & CTypeId & ", @WithAllowSubReasons=" & AllowSubReasons & ", @ClaimCategoryId=" & ClaimCategoryId, cnObj)  
		If Not (rsObj.BOF And rsObj.EOF) Then
			rsObj.MoveFirst
			While Not rsObj.EOF
				Output = Output & "{""optionValue"":" & rsObj("ClaimReasonId") & ", ""optionDisplay"": """ & rsObj("ReasonCode") & " - " & rsObj("ClaimReasonDescription") & """},"
				
				rsObj.MoveNext
			Wend
		Else
			Output = "{""optionValue"":-1,""optionDisplay"":""-- No reason codes linked to category --""},"
		End If

		rsObj.Close 
		Set rsObj = Nothing 

			
		cnObj.Close 
		Set cnObj = Nothing

	End If
	
	Output = Left(Output,Len(Output)-1)
	Response.Write "[" & Output & "]"
	Response.End
%> 

