<!--#include file="../includes/constants.asp"-->
<%	
	Dim DcId, CommandText
	DcId = Request.QueryString("dcId")
	
	Dim cnObj, rsObj
	Set cnObj = Server.CreateObject ("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	If Session("UserType") = 2 Then 
		CommandText = "ListSuppliers @DCId=" & DcId & ",@SupplierId=" & Session("ProcId")
	Else
		CommandText = "ListSuppliers @DCId=" & DcId
	End If
	'Response.Write CommandText
	Set rsObj = ExecuteSql(CommandText, cnObj)   
	If Not (rsObj.BOF And rsObj.EOF) Then
		While Not rsObj.EOF
			Output = Output & "{""SPID"":" & rsObj("SPID") & ", ""VendorName"": """ & Replace(rsObj("VendorName") ,",","") & """,  ""Vendor"": """ & rsObj("Vendor")  & """,""VendorCode"": """ & rsObj("VendorCode") & """},"
		
			rsObj.MoveNext
		Wend
		
		Output = Left(Output,Len(Output)-1)
		Response.Write "[" & Output & "]"
	End If
	
	rsObj.Close
	Set rsObj = Nothing
	
	cnObj.Close
	Set cnObj = Nothing
	
	Response.End
%>