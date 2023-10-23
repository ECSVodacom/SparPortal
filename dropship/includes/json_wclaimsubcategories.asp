<%@Language=VBScript%>
<!--#include file="../includes/constants.asp"-->
<% 
    pStr = "private, no-cache, must-revalidate" 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", pStr 

	Dim DCId, ClaimCategoryIds, Guid
	Dim SqlCommand
	
	ClaimCategoryIds = Request.QueryString("categoryIds")
	DCId = Request.QueryString("dcId")
	
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
			SqlCommand = "ListClaimSubCategories @ClaimCategoryIds='" & ClaimCategoryIds & "', @DCId=" & DCId & ", @Guid='" & Guid & "'"
		Else
			SqlCommand = "ListClaimSubCategories @ClaimCategoryIds='" & ClaimCategoryIds & "', @DCId=" & DCId
		End If

		
		Set rsObj = cnObj.Execute(SqlCommand) 
		If Not (rsObj.BOF And rsObj.EOF) Then
			rsObj.MoveFirst
			While Not rsObj.EOF
				Output = Output & "{""subCategoryId"":" & rsObj("SubCategoryId") & ", ""subCategoryDisplay"": """ & rsObj("ClaimSubCategoryName")  & """, ""isChecked"": """ & rsObj("IsChecked") & """},"
				
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

