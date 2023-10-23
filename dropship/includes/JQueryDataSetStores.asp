<!--#include file="../includes/constants.asp"-->
<%
	Dim DC, DCId
	Dim SqlSelect
	DC = Request.QueryString("id")
	DCId = Split(DC,",")(0)
	
	StoreFormat = Request.QueryString("storeformat")
	
	
	Dim Output
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open const_db_ConnectionString
	
	If DCId = "-1" Then DCId = 0
	
	SqlSelect = "listStores @DCID=" & DCId & ",@StoreFormat='" & Replace(StoreFormat,"'","''") & "'"
	
	response.write SqlSelect
	Set rs = ExecuteSql(SqlSelect, Conn)   
	If Not (rs.BOF And rs.EOF) Then
		Output = ""
		
		Output = Output & "{""optionValue"":" & "-1" & ", ""optionDisplay"": """ & "All Stores" & """,""optionVendorCode"":-1},"
		' " (" & RecordSet("StoreCode") 
		While Not rs.EOF 
			Output = Output & "{""optionValue"":" & rs("StoreId") & ", ""optionDisplay"":""" & Replace(Replace(rs("StoreName"),"\",""),"""","") & " (" & rs("StoreCode") & ")" & """,""optionVendorCode"":-1},"
			rs.MoveNext
		Wend
		Output = Left(Output,Len(Output)-1)
		
		Response.Write "[" & Output & "]"
	Else 
		Response.Write "[{""optionValue"":" & "-1" & ", ""optionDisplay"": """ & "No stores available" & """,""optionVendorCode"":-1}]"
	End If 

	rs.Close : Set rs = Nothing : Conn.Close : Set Conn = Nothing
	
%> 

