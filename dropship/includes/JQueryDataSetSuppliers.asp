<!--#include file="../includes/constants.asp"-->
<%
	Dim DC, DCId, IsRewardsNumeric, ClaimTypeId
	Dim SqlSelect
	DC = Request.QueryString("id")
	DCId = Split(DC,",")(0)
	IsRewardsNumeric = Request.QueryString("IsRewardsNumeric")
	IsStampsNumeric = Request.QueryString("IsStampsNumeric")
	IsForceCreditNumeric = Request.QueryString("IsForceCreditNumeric")
	
	If Request.QueryString("ClaimTypeId") = "" Then
		ClaimTypeId = 0
	Else
		ClaimTypeId = Split(Request.QueryString("ClaimTypeId"),",")(0)
	End If
	Dim SupplierName
	
	Dim Output
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open const_db_ConnectionString
	
	If DCId = "-1" Then DCId = 0
	If IsForceCreditNumeric = "" Then IsForceCreditNumeric = 0
	If IsRewardsNumeric = "" Then IsRewardsNumeric = 0

	If IsRewardsNumeric = 1 Then 
		SqlSelect = "listScheduleSupplier @SupplierID=0, @DCId=" &  DCId  & ", @HiddenIsForceCredit=" & IsForceCreditNumeric & ", @IsRewardsNumeric=1"
	ElseIf IsStampsNumeric = 1 Then 
		SqlSelect = "listScheduleSupplier @SupplierID=0, @DCId=" &  DCId  & ", @HiddenIsForceCredit=" & IsForceCreditNumeric & ", @IsStampsNumeric=1"
	Else
		If Session("UserType") <> 1 And Session("UserType") <> 4 And Session("UserType") <> 2 Then
			SqlSelect = "listSupplier @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCId=" & DCId
			SqlSelect = "listSupplier @SupplierID=0, @UserType=3, @DCId=" & DCId & ",@ClaimTypeId="&ClaimTypeId
			
		Else
			If Session("UserType") = 4  Then
				SqlSelect = "listScheduleSupplier @SupplierID=" & Session("ProcID")  & ",  @DCId=" & DCId & ",@ClaimTypeId="&ClaimTypeId
			Else
				
				If Session("IsWarehouseUser")  Then
					SqlSelect = "listSupplier @SupplierID=0, @UserType=" & Session("UserType") & ", @DCId=" & DCId & ",@ClaimTypeId="&ClaimTypeId
				Else
					SqlSelect = "listSupplier @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCId=" & DCId & ",@ClaimTypeId="&ClaimTypeId
				End If
			End If
		End If
	End If
	
	'Response.Write SqlSelect
	'Response.End
	
	Dim SupplierCount
	SupplierCount = 0
	
	Set rs =  ExecuteSql(SqlSelect, Conn)    
	If Not (rs.BOF And rs.EOF) Then
		Output = ""

		While Not rs.EOF 
			SupplierName = Replace(Replace(Replace(Replace(rs("SupplierName"),"'","\'"),"\","\\"),"""",""),"amp;","AND")
			
			If (rs("ParentIt") <> Session("ProcID") And rs("ParentIt")<>0) And rs("SupplierId")<> Session("ProcID") Then
				SupplierCount = SupplierCount + 1
			End If
			
			
			If DCId = 0 Then
				Output = Output & "{""optionValue"":" & rs("SupplierId") & ", ""optionDisplay"":""" & SupplierName & """,""optionVendorCode"":""-1""},"
			Else
				Output = Output & "{""optionValue"":" & rs("SupplierId") & ", ""optionDisplay"":""" & SupplierName  & """,""optionVendorCode"":""" & rs("VendorCode") & """},"
			End If
			
			rs.MoveNext
		Wend
		If SupplierCount > 1 Then
			Output =  "{""optionValue"":" & """-1""" & ", ""optionDisplay"": """ & "All suppliers" & """,""optionVendorCode"":""-1""}," & Output
		End If
		Output = Left(Output,Len(Output)-1)
		
		Response.Write "[" & Output & "]"
	Else 
		Response.Write "[{""optionValue"":" & """0""" & ", ""optionDisplay"": """ & "No suppliers available" & """,""optionVendorCode"":""0""}]"
	End If 

	rs.Close : Set rs = Nothing : Conn.Close : Set Conn = Nothing
	
%> 

