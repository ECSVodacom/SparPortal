<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<%	
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString
	
	DcId = Request.QueryString("DcId")
	ClaimCategoryId = Request.QueryString("ClaimCategoryId")
	ClaimCategoryId = Mid(ClaimCategoryId,1,Len(ClaimCategoryId)-1)
	Set rsCategory = ExecuteSql("GetWarehouseDCsClaimCategories @ClaimCategoryId=" & ClaimCategoryId & ", @DcId=" & DcId, SqlConnection)    
	If Not (rsCategory.BOF And rsCategory.EOF) Then
		Response.Write "{""ForceCreditDisputed"":"""  & Trim(rsCategory("DCEmailToNotifyForceCreditDisputed")) & ""","
		Response.Write """PricingEmail"":"""  & Trim(rsCategory("DCCategoryPricingEmail")) & """}"
	End If
	
	rsCategory.Close
	Set rsCategory = Nothing
	SqlConnection.Close
	Set SqlConnection = Nothing
%>
