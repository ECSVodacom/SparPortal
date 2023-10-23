<%@Language=VBScript%>
<%Option Explicit%>
<!--#include file="../includes/constants.asp"-->
<% 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", "private, no-cache, must-revalidate"  

	Dim DCId, CategoryIds, SqlSelect, cnObj, rsObj, Output
	CategoryIds = Request.QueryString("categoryIds")
	DCId = Request.QueryString("dcId") 
	
	
	SqlSelect = "GetWarehouseDCsClaimCategories @ClaimCategoryId=" & CategoryIds & ", @DCId=" & DCId
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString

	Set rsObj = cnObj.Execute(SqlSelect) 
	
	If Not (rsObj.BOF And rsObj.EOF) Then
		Output = Output & "[{""mail"":""" & rsObj("DCEmailToNotifyForceCreditDisputed") & """}]"
	End If
	rsObj.Close
	
	Set rsObj = Nothing
	
	cnObj.Close
	Set cnObj = Nothing
	
	Response.Write Output
%>