<%
Function SetDcConfigurationSessions()

	If Session("DCId") = "" Then
		Response.Redirect const_app_ApplicationRoot
	End If

	Dim cnObj, rsObj
	
	Set cnObj = Server.CreateObject("ADODB.Connection")

	
	cnObj.Open const_db_ConnectionString
	Dim SqlSelectCommand 
	Set SqlSelectCommand = Server.CreateObject("ADODB.Command")
	SqlSelectCommand.ActiveConnection = cnObj
	SqlSelectCommand.CommandText = "GetDcConfiguration"
	SqlSelectCommand.CommandType = adCmdStoredProc

	SqlSelectCommand.Parameters("@DCId") = Session("DCId")
	
	
	
	If (Session("UserType") = 3) Then _
		SqlSelectCommand.Parameters("@StoreId") = Session("ProcID")
		Set rsObj = SqlSelectCommand.Execute 
		If Not (rsObj.EOF And rsObj.BOF) Then
			Session("AllowClaimCaptureForSupplier") = rsObj("AllowClaimCaptureForSupplier")
			Session("AllowClaimCaptureForAdminDC") = rsObj("AllowClaimCaptureForAdminDC")
			Session("AllowDCsToMaintainSupplierClaims") = rsObj("AllowDCsToMaintainSupplierClaims")
			Session("DCEmailAddressForAdminDCClaims") = rsObj("DCEmailAddressForAdminDCClaims")
			Session("DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims") = rsObj("DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims")
			Session("IsStoreAllowedCaptureClaimForSuppliers") = rsObj("IsStoreAllowedCaptureClaimForSuppliers")
			Session("IsStoreLive") = rsObj("IsStoreLive")
			Session("IsDCAllowedToUploadForceCredits") = rsObj("IsDCAllowedToUploadForceCredits")
			Session("IsDCToCaptureAdminDCClaims") = rsObj("IsDCToCaptureAdminDCClaims")
			Session("AllowDCManageBuildIt") = rsObj("AllowDCManageBuildIt")
			Session("AllowDCGenerateForceCredits") = rsObj("AllowDCGenerateForceCredits")
			Session("IsdcAllowedAutoMatchingOfAdminClaim") = rsObj("IsdcAllowedAutoMatchingOfAdminClaim")
			
		Else
		
			Session("AllowClaimCaptureForSupplier") = 0
			Session("AllowClaimCaptureForAdminDC") = 0
			Session("AllowDCsToMaintainSupplierClaims") = 0
			Session("DCEmailAddressForAdminDCClaims") = ""
			Session("DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims") = ""
			Session("IsStoreAllowedCaptureClaimForSuppliers") = 0
			Session("IsStoreLive") = 0
			Session("IsDCAllowedToUploadForceCredits") = 0
			Session("IsDCToCaptureAdminDCClaims") = 0
			Session("AllowDCManageBuildIt") = 0
			Session("AllowDCGenerateForceCredits") = 0
			Session("IsdcAllowedAutoMatchingOfAdminClaim") = 0

		End If
	SET SqlSelectCommand = Nothing
	cnObj.Close

	
	SetDcConfigurationSessions = True
	
End Function
%>