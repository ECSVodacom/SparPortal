<%@Language=VBScript%>
<!--#include file="../includes/constants.asp"-->
<% 
    pStr = "private, no-cache, must-revalidate" 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", pStr 
	
	Dim Output
	Dim cnObj, DCId
	Dim ClaimCategoryIds
	Dim Guid
	Dim SqlCommand
	Dim ClaimReasonId
	Dim ClaimReasonIds
	
	Guid = Request.QueryString("guid")
	ClaimCategoryIds = Request.QueryString("categoryIds")
	DCId = Request.QueryString("dcId")
	ClaimReasonId = Request.QueryString("crid")
	If ClaimReasonId = "" Then ClaimReasonId = 0
	ClaimReasonIds = Request.QueryString("crids")
	
	If Request.QueryString("guid") = "0" Or  Request.QueryString("guid") =  "" Then
		IsGuid = False
	Else
		Guid = Request.QueryString("guid")
		IsGuid = True
	End If
	
	If ClaimCategoryIds <> "" And DCId <> "" Then
		Set cnObj = Server.CreateObject("ADODB.Connection")
		cnObj.Open const_db_ConnectionString
		
		If IsGuid Then
			SqlCommand = "ListWClaimSubReasons @ClaimCategoryIds='" & ClaimCategoryIds & "', @DCId=" & DCId & ", @Guid='" & Guid & "', @ClaimReasonId=" & ClaimReasonId
		Else
			SqlCommand = "ListWClaimSubReasons @ClaimCategoryIds='" & ClaimCategoryIds & "', @DCId=" & DCId & ",@ClaimReasonId=" &  ClaimReasonId
		End If
		
		If ClaimReasonIds <> "" Then SqlCommand = SqlCommand & ",@ClaimReasonIds='" & ClaimReasonIds & "'"
		
		'Response.Write SqlCommand
		Set rsObj = cnObj.Execute(SqlCommand)  
		If Not (rsObj.BOF And rsObj.EOF) Then
			rsObj.MoveFirst
			While Not rsObj.EOF
				Output = Output & "{""claimSubReasonId"":" & rsObj("claimSubReasonId") & ", ""description"": """ & rsObj("Description")  & """, ""isChecked"": """ & rsObj("IsChecked") & """},"
				
				rsObj.MoveNext
			Wend
		End If

		rsObj.Close 
		Set rsObj = Nothing 
					
		cnObj.Close 
		Set cnObj = Nothing
		
		Output = Left(Output,Len(Output)-1)
		Response.Write "[" & Output & "]"
	End If
	Response.End
%> 

