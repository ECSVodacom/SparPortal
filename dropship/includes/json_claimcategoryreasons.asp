<%@Language=VBScript%>
<!--#include file="../includes/constants.asp"-->
<% 
    pStr = "private, no-cache, must-revalidate" 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", pStr 
%>
<%
	
	
	Dim Output, CTypeId, AllowSubReasons
	Dim cnObj
	Dim RecordsCount
	Dim DoSearch
	Dim a
	Dim IsClaimsManageScreen
	
	
	CategoryId = Request.QueryString("id")
	CategoryId = Split(CategoryId,",")(0)
	CTypeId = Request.QueryString("typeId")
	CTypeId = Split(CTypeId,",")(0)
	DoSearch = Request.QueryString("doSearch")
	a = Request.QueryString("a")
	IsClaimsManageScreen = Request.QueryString("icms")
	If IsClaimsManageScreen = "" Then IsClaimsManageScreen = 0
	
	
	';Response.Write "ListClaimsCategoriesReasonCodes @ClaimTypeId=" & CTypeId & ", @ClaimCategoryId=" & CategoryId & ", @IsClaimManageScreen=" & IsClaimsManageScreen
	If (CategoryId = "-1" Or DoSearch) And (a <> 1) Then
		Output = "{""optionValue"":-1, ""optionDisplay"": ""All Reasons" & a & """},"
	Else
		Output = ""

		Set cnObj = Server.CreateObject("ADODB.Connection")
		cnObj.Open const_db_ConnectionString
		If CTypeId = 3 Then 
			CTypeId = 1
		End If
		Set rsObj = cnObj.Execute("ListClaimsCategoriesReasonCodes @ClaimTypeId=" & CTypeId & ", @ClaimCategoryId=" & CategoryId & ", @IsClaimManageScreen=" & IsClaimsManageScreen)    
		RecordsCount = 0
		If Not (rsObj.BOF And rsObj.EOF) Then
			rsObj.MoveFirst
			While Not rsObj.EOF
				RecordsCount = RecordsCount + 1
				Output = Output & "{""optionValue"":" & rsObj("ClaimReasonId") & ", ""optionDisplay"": """ & rsObj("ClaimReasonDescription") & """},"
				
				rsObj.MoveNext
			Wend
		Else
			'Output = "{""optionValue"":-1,""optionDisplay"":""-- No reasons for claim category --""},"
			Output = "{""optionValue"":-1,""optionDisplay"":""All Reasons""},"
		End If

		rsObj.Close 
		Set rsObj = Nothing 

			
		cnObj.Close 
		Set cnObj = Nothing
		
		If RecordsCount > 1 And DoSearch = 0 Then 
			Output =  "{""optionValue"":-1, ""optionDisplay"": ""All Reasons""}," & Output
		End If
	End If
	
	Output = Left(Output,Len(Output)-1)
	Response.Write "[" & Output & "]"
	Response.End
%> 

