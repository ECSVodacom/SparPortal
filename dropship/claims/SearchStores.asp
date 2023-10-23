<%@Language=VBScript%>
<!--#include file="../includes/constants.asp"-->
<%	

    pStr = "private, no-cache, must-revalidate" 
    Response.ExpiresAbsolute = #2000-01-01# 
    Response.AddHeader "pragma", "no-cache" 
    Response.AddHeader "cache-control", pStr 
	

	Dim StoreName
	Dim DcId
	
	DcId = Request.QueryString("dcId")
	StoreName = Request.QueryString("storename")
	

	Dim Output
	Dim cnObj, rsObj
	Dim RecordsFound
	Dim SqlSelect
	
	If DcId = "0" Then
		SqlSelect = "SearchStores @StoreName='"  & StoreName & "', @DcId=0"
	Else
		SqlSelect = "SearchStores @StoreName='"  & StoreName & "', @DcId=" & DcId
	End If	
	
	RecordsFound = False
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	Set rsObj = ExecuteSql(SqlSelect, cnObj)  
	If Not (rsObj.BOF And rsObj.EOF) Then
			
		While Not rsObj.EOF
			RecordsFound = True
			Output = Output & "{""id"":" & rsObj("STID") & ", ""label"": """ & Trim(rsObj("STcName"))  & " (" & rsObj("STcCode") & ")"",""value"":""" & Trim(rsObj("STcName")) & """},"
			
			rsObj.MoveNext
		Wend
		
		Response.Write "[" & Left(Output,Len(Output)-1) & "]"
	Else
		Response.Write "[{""id"":0, ""label"": ""No match found"",""value"":""No match found""}]"
	End If

	rsObj.Close 
	Set rsObj = Nothing 
	cnObj.Close 
	Set cnObj = Nothing
		
	Response.End
%>



	