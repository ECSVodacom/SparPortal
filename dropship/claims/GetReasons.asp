<!--#include file="../includes/constants.asp"-->
<%
	Dim CategoryId
	Dim SqlSelect
	CategoryId = Request.QueryString("id")
	
	Dim Output
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open const_db_ConnectionString
	
	SqlSelect = "ListClaimsCategoriesReasonCodes @ClaimTypeID=1, @ClaimCategoryId=" & CategoryId
	
	Set rs =  	ExecuteSql(SqlSelect, Conn)    
	If Not (rs.BOF And rs.EOF) Then
		Output = ""
		
		Output = Output & "{""optionValue"":" & "-1" & ", ""optionDisplay"": """ & "-- Claim Reason Code --" & """},"
		
		While Not rs.EOF 
			Output = Output & "{""optionValue"":" & rs("ClaimReasonId") & ", ""optionDisplay"":""" & rs("ReasonCode") & """},"
			rs.MoveNext
		Wend
		Output = Left(Output,Len(Output)-1)
		
		Response.Write "[" & Output & "]"
	Else 
		Response.Write "[{""optionValue"":" & "-1" & ", ""optionDisplay"": """ & "-- Claim Reason Code --" & """,""optionVendorCode"":-1}]"
	End If 

	rs.Close : Set rs = Nothing : Conn.Close : Set Conn = Nothing

	
%> 

