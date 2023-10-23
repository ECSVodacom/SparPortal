<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincookie.asp"-->
<%
	Dim cnObj, EnabledCaptureSupplierClaim, AllowClaimCaptureForAdminDC
	
	If Session("AllowClaimCaptureForSupplier") = 1 And Session("IsStoreAllowedCaptureClaimForSuppliers") Then
		EnabledCaptureSupplierClaim = 1
	Else 
		EnabledCaptureSupplierClaim = 0
	End If
	
	AllowClaimCaptureForAdminDC =  Session("AllowClaimCaptureForAdminDC") 
	If AllowClaimCaptureForAdminDC = "" Then AllowClaimCaptureForAdminDC = 0
	
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_SparClaimsConnectionString
	GetSessionIdCommand = "CreateSessionRequest @UserId=" & Session("UserID") & ",@UserName='" & Session("UserName") & "',@UserType=" & Session("UserType") & ",@AllowClaimCaptureForAdminDC=" & AllowClaimCaptureForAdminDC & ",@AllowClaimCaptureForSupplier=" & EnabledCaptureSupplierClaim 
	Set ReturnValue = 	cnObj.Execute(GetSessionIdCommand)
		If Not (ReturnValue.BOF And ReturnValue.EOF) Then
			SessionId = ReturnValue(0)
		End If
		ReturnValue.Close
	cnObj.Close

	SessionId = Mid(SessionId,2,Len(SessionId)-2)
	Url = ""
	If Request.QueryString("id") = 1 Then
		Url = Const_App_New & "Authenticate.aspx?UserName=" & Server.URLEncode(Session("UserName")) & "&SessionId=" & Server.URLEncode(SessionId) & "&ReturnUrl=" & Server.URLEncode("/sparclaims/page/CaptureClaim") & ".aspx"
	ElseIf Request.QueryString("id") = 2 Then
		Url = "http://ecweb.vbecom.co.za/sparreport/#/?userId=" & Session("UserID") & "&procId=" & Session("ProcId")
	ElseIf Request.QueryString("id") = 3 Then
		claimType = Request.QueryString("claimType")
		isDc = "no"
		UserType = Session("UserType")
		If UserType = 2 Or Session("IsWarehouseUser")  Then isDc = "yes"
		dcId = Session("DCID")
		StoreCode = Session("StoreCode")
		If UserType = 3 Then  StoreEan = Session("ProcEAN")
		 
		 
		If claimType = "VCL" Then
			isDc = "no"
			Select Case dcId 
				Case 1 ' SOUTH RAND
					StoreCode = "99932"
					StoreEan = "6001008000001"
				Case 2 ' NORTH RAND
					StoreCode = "99925"
					StoreEan = "6001008000002"
				Case 3 ' KZN
					StoreCode = "99995"
					StoreEan = "6001008000008"
				Case 4 ' EASTERN CAPE
					StoreCode = "99918"
					StoreEan = "6001008000005"
				CASE 5 ' WESTERN CAPE
					StoreCode = "99901"
					StoreEan = "6001008000004"
				CASE 8 ' LOWVELD
					StoreCode = "99911"
					StoreEan = "6001008000006"
				CASE 9 ' BOTSWANA
					StoreCode = "99984"
					StoreEan = "6001008000007"
			End Select
		End If
		
		ContainerEan = Session("ProcEAN")
		'If UserType = 2 Then ContainerEan = Session("ProcEAN")
		If USerType = 3 Then ContainerEan = StoreEan
		If UserType = 1 Or UserType = 4 Then ContainerEan = Session("ProcEAN")

		If ContainerEan = "6004930012137" Then isDc = "yes"
		
		Url = "http://ecweb.vbecom.co.za/SparPortal/#/sparclaimcapture/claimhistory?dcId=" & DCId & "&userTypeId=" & UserType & "&StoreCode=" & StoreCode & "&StoreEan=" & StoreEan & "&ContainerEan=" & ContainerEan & "&isDC=" & isDc & "&claimType=" & claimType
	'	Response.Write Url
	'	Response.End
	ElseIf Request.QueryString("id") = 4 Then
		Url = "http://ecweb.vbecom.co.za/sparreport/#/MatchedClaims/?userId=" & Session("UserID") & "&procId=" & Session("ProcId")
	Else
		Url = "http://ecweb.vbecom.co.za/reporting/ClaimsReport.aspx?UserID=" & Session("UserID")
	End If					
	
	Response.Redirect Url
%>