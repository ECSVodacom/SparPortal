<%@Language=VBScript%>
<%Option Explicit%>
<!--#include file="../includes/constants.asp"-->
<% 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", "private, no-cache, must-revalidate"  

	Dim DCId, CategoryIds
	Dim SubCategoryIds, ReasonIds, SubReasonIds, StatusApplicableIds, Ranges
	Dim SqlCommand
	Dim cnObj, rsObj
	Dim Output
	Dim Guid, IsGuid
	Dim EmailsApplicable
	Dim ClaimType
	
	If Request.QueryString("guid") = "0" Or  Request.QueryString("guid") =  "" Then
		IsGuid = False
	Else
		Guid = Request.QueryString("guid")
		IsGuid = True
	End If
	
	
	
	CategoryIds = Request.QueryString("categoryIds")
	SubCategoryIds = Request.QueryString("subCategoryIds")
	ReasonIds = Request.QueryString("reasonIds")
	SubReasonIds = Request.QueryString("subReasonIds")
	StatusApplicableIds = Request.QueryString("statusApplicableIds")
	DCId = Request.QueryString("dcId") 
	ClaimType = Request.QueryString("ClaimTypeId")
	
	
	
	EmailsApplicable = Request.QueryString("emailAddresses") 
	Ranges = Request.QueryString("ranges") 
	
	Dim status_code 
	status_code = -1
	
	If CategoryIds <> "" And DCId <> "" Then
		Set cnObj = Server.CreateObject("ADODB.Connection")
		cnObj.Open const_db_ConnectionString
		
		SqlCommand = "MaintainWClaimConfiguration @CategoryIds='" & CategoryIds _
			& "', @SubCategoryIds='" & SubCategoryIds _
			& "', @ReasonIds='" & ReasonIds _
			& "', @SubReasonIds='" & SubReasonIds _
			& "', @StatusesApplicableIds='" & StatusApplicableIds _
			& "', @DCId=" & DCId _
			& ", @EmailAddresses='" & EmailsApplicable & "'" _
			& ", @Ranges='" & Ranges & "'" _
			& ", @ClaimType=" & ClaimType 		
		
		
		If IsGuid Then
			SqlCommand = SqlCommand & ", @Guid='" & Guid & "'"
		End If
		
		
		'Response.Write SqlCommand
		'Response.End
		
		Set rsObj = cnObj.Execute(SqlCommand)   
		'Output = Output & "{""message"":""" & rsObj("ResultMessage") & """},"
		status_code = rsObj("ErrorCode")
		Output = Output & "{""message"":""" & rsObj("ResultMessage") & """, ""guid"":"""  & rsObj("Guid") &   """}"""
		
		Set rsObj = Nothing 
				
		cnObj.Close 
		Set cnObj = Nothing
		
		Output = Left(Output,Len(Output)-1)
		Response.Write "[" & Output & "]"
	End If
	Response.End
%> 

