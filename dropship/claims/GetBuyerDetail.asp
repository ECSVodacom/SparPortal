<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<%	
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString
	
	BuyerId = Split(Request.QueryString("BuyerId"),",")(0)
	Set rsBuyer =  ExecuteSql("ListBuyers @BuyerId=" & BuyerId, SqlConnection)    
	If Not (rsBuyer.BOF And rsBuyer.EOF) Then
		Response.Write "{""Name"":"""  & rsBuyer("BuyerName") & ""","
		Response.Write """Email"":"""  & rsBuyer("BuyerEmailAddress") & """}"
	End If
	
	rsBuyer.Close
	Set rsBuyer = Nothing
	SqlConnection.Close
	Set SqlConnection = Nothing
%>
