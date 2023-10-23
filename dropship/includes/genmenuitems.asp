<script type="text/javascript" language="javascript">
function iniMsgBox() {
		window.confirm=function(msgStr) {
		
		return vb_confirm(msgStr)
	}
}
</script>
<script type="text/vbs" language="vbscript">
	iniMsgBox()

	Function vb_confirm(msgStr)
		vb_confirm = MsgBox(msgStr, vbYesNo + vbQuestion + vbDefaultButton2, "Confirm Exit") 
	End Function
</script>
<!--#include file="globalfunctions.asp"-->

<%
	Function GenMenu (UsType, UsPermission, ApplicationRoot, MenuDate, IsXML)
		
		' Author & Date: Chris Kennedy, 12 Aug 2004
		' Purpose: This function will generate the menu items per the parameters passed. It will then overwrite the current
		'			.js file.
		'response.Write(UsPermission)
		'response.End 
		dim strMenu
		dim Folder
		dim oFile
		dim File
		dim cFile
		

		Dim StrClaimMenu
	
		Dim AllowClaimCaptureForDc, AllowClaimCaptureForSupplier, CaptureClaimForSupplierIndicator, AllowClaimCaptureForAdminDc, AllowDCsToMaintainSupplierClaims, IsStoreAllowedCaptureClaimForSuppliers
		Dim IsDCAllowedToUploadForceCredits, IsDCToCaptureAdminDCClaims, AllowDCManageBuildIt, AllowDCGenerateForceCredits
		
		SetDcConfigurationSessions()
					
		AllowClaimCaptureForSupplier = Session("AllowClaimCaptureForSupplier")
		AllowClaimCaptureForAdminDc = Session("AllowClaimCaptureForAdminDC")
		AllowDCsToMaintainSupplierClaims = Session("AllowDCsToMaintainSupplierClaims")
		CaptureClaimForSupplierIndicator = Session("AllowClaimCaptureForAdminDC")
		IsStoreAllowedCaptureClaimForSuppliers = Session("IsStoreAllowedCaptureClaimForSuppliers")
		IsDCAllowedToUploadForceCredits = Session("IsDCAllowedToUploadForceCredits")
		IsDCToCaptureAdminDCClaims = Session("IsDCToCaptureAdminDCClaims")
		AllowDCManageBuildIt = Session("AllowDCManageBuildIt")
		AllowDCGenerateForceCredits = Session("AllowDCGenerateForceCredits")
		
		Select Case UsType
		Case 1,4
			Folder = "supplier"
		Case 2
			Folder = "dc"
		Case 3	
			Folder = "store"
		Case Else
			Folder = "dc"
		End Select

		'response.write(Session("ProcEAN"))
		'response.write(Session("DCcEANNumber"))
		
		strMenu = strMenu & "var MENU_ITEMS = [" & VbCrLf
		StrClaimMenu =  "['Claims', '" & ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?action=3&id=" & FormatDate(MenuDate,false) & "',null," & vbcrlf
		StrClaimMenu = StrClaimMenu & "['Claim Tracking', '" & ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?action=3&id=" & FormatDate(MenuDate,false) & "']," & vbcrlf
		
		' Permissions
		If ((Session("UserType") = 3 And Session("IsStoreLive") = 1) And AllowClaimCaptureForSupplier = 1 And IsStoreAllowedCaptureClaimForSuppliers)  Then
			'StrClaimMenu = StrClaimMenu & "['Capture Supplier Claims Old', 'javascript:newWin(10);']," & vbcrlf
			StrClaimMenu = StrClaimMenu & "['Capture Supplier Claims', 'javascript:newWin(23);']," & vbcrlf
		End If
		If ((Session("UserType") = 3 And Session("IsStoreLive") = 1 ) OR (Session("UserType") = 2)) And AllowClaimCaptureForAdminDc = 1 Then
			StrClaimMenu = StrClaimMenu & "['Capture Admin DC Claims', 'javascript:newWin(22);']," & vbcrlf
			
			'StrClaimMenu = StrClaimMenu & "['Capture Admin DC Claims Old', 'javascript:newWin(10);']," & vbcrlf
		End If

		If ((Session("UserType") = 3 And Session("IsStoreLive") = 1 And Session("StoreFormat") = "Build-It" ) OR (Session("UserType") = 2)) And AllowClaimCaptureForAdminDc = 1 Then
			StrClaimMenu = StrClaimMenu & "['Admin DC Claim – Build IT WHS ', 'javascript:newWin(27);']," & vbcrlf
		End If
		
		If Session("IsWarehouseUser") And Session("ProcEAN") <> "6004930012137" Then 
			StrClaimMenu = StrClaimMenu & "['Capture DC Vendor Claims', 'javascript:newWin(25);']," & vbcrlf ' IsWarehouse
			
		End If
		
		If (Session("ClaimCaptureOverrideIndicator") = "Y" OR Session("IsWarehouseUser")) And Session("ProcEAN") <> "6004930012137"   Then 
			StrClaimMenu = StrClaimMenu & "['Capture Warehouse Claims', 'javascript:newWin(24);']," & vbcrlf
		End If
		
		
		If Session("StoreFormat") = "Build-It" Or Session("ProcEAN") = "6004930012137" Then StrClaimMenu = StrClaimMenu & "['Capture Build IT DC Claims', 'javascript:newWin(26);']," & vbcrlf  
		
		'If (Session("UserType") = 2 And IsDCToCaptureAdminDCClaims) Or (Session("ProcEAN") = Session("DCcEANNumber")) Then
		'	StrClaimMenu = StrClaimMenu & "['Capture DC Vendor Claims', 'javascript:newWin(10);']," & vbcrlf
		'End If
		If (((Session("UserType") = 3 And Session("IsStoreLive") = 1) Or Session("UserType") = 2) And AllowClaimCaptureForAdminDc = 1 Or (Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE")) Or (Session("ProcEAN") = Session("DCcEANNumber")) Then
			StrClaimMenu = StrClaimMenu & "['Admin DC Claim Management', 'javascript:newWin(8);']," & vbcrlf
		ElseIf Session("ProcEAN") = "6004930012137"  Then
			'StrClaimMenu = StrClaimMenu & "['Capture Admin DC Claims', 'javascript:newWin(22);']," & vbcrlf
			StrClaimMenu = StrClaimMenu & "['Admin DC Claim Management', 'javascript:newWin(8);']," & vbcrlf
		End If
		
		
		'If (Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE") Or (Session("UserType") = 2 Or Session("UserType") = 4) Then 
		'	StrClaimMenu = StrClaimMenu & "['DC Status Management', 'javascript:newWin(8);']," & vbcrlf
		'End If
		
		StrClaimMenu = StrClaimMenu & "['Supplier Claim Management', 'javascript:newWin(11);']," & vbcrlf
		
		If (Session("UserType") = 2 And IsDCToCaptureAdminDCClaims) Or (Session("ProcEAN") = Session("DCcEANNumber")) Then
			'StrClaimMenu = StrClaimMenu & "['Mass Update of Claims', 'javascript:newWin(17);']," & vbcrlf

		End If
		'response.write "<br/><br/>"
		'response.write Session("UserType") &" <br/>"
		'response.write Session("IsSuperUser")& " <br/>"
		'response.write Session("ProcEAN")&" <br/>"
		'response.write Session("DCcEANNumber")&" <br/>"
		
		If (Session("UserType") = 2  and Session("IsSuperUser")) = 1    Then
			StrClaimMenu = StrClaimMenu & "['Mass Update of Claims', 'javascript:newWin(17);']," & vbcrlf

		End If
		'StrClaimMenu = StrClaimMenu & "['Claim History', 'javascript:newWin(9);']]," & vbcrlf
		StrClaimMenu = StrClaimMenu & "]," & vbcrlf
	
		strMenu = strMenu & "['Orders', '" & ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?action=1&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
    		
		' Check if this should be displayed
		if IsXML then
			strMenu = strMenu & "['Invoices', '" & ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?action=2&id=" & FormatDate(MenuDate,false) & "',null," & vbcrlf
			strMenu = strMenu & "]," & vbcrlf
		else
			strMenu = strMenu & "['Invoices', '" & ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?action=2&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
		end if
		
		strMenu = strMenu & StrClaimMenu
		
		strMenu = strMenu & "['Credit Notes', '" & ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?action=4&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
		
		if UsType <> 3 then
			strMenu = strMenu & "['Store Functions', null,null," & vbcrlf
			strMenu = strMenu & "['Store List', '" & ApplicationRoot & "/storelist/default.asp',null]," & vbcrlf
			strMenu = strMenu & "['Store Validation', '" & ApplicationRoot & "/storeval/default.asp',null]," & vbcrlf
			strMenu = strMenu & "]," & vbcrlf
		End If
			
		strMenu = strMenu & "['Reports', null,null," & vbcrlf
		'strMenu = strMenu & "['Claim Stats Reports', 'javascript:newWin(12);']," & vbcrlf Old report removed
		strMenu = strMenu & "['Claim Stats Report', 'javascript:newWin(21);']," & vbcrlf
		strMenu = strMenu & "['Weekly Matched Claim', 'javascript:newWin(29);']," & vbcrlf
		strMenu = strMenu & "['Stats', '" & ApplicationRoot & "/Stats/billing/default.asp?id=ds&type=stat',null]," & vbcrlf
		if UsType = 1 or UsType = 2 or UsType = 3 or Session("ProcEAN") = "GATEWAYCALLCEN" or Session("ProcEAN") = "SPARHEADOFFICE" Then
				'strMenu = strMenu & "['Stats', '" & ApplicationRoot & "/Stats/billing/default.asp?id=ds&type=stat',null]," & vbcrlf
				strMenu = strMenu & "['Suppliers linked to DC', 'javascript:newWin(7);']," & vbcrlf
				
		end if
			
		If UsType <> 3 Then
			strMenu = strMenu & "['Electronic Remittance', '" & ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?action=6&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
			strMenu = strMenu & "['Recon Report', '" & ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?action=5&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
			

			' DC UsType = 2
			If UsType = 2 Or Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" then
				strMenu = strMenu & "['All Suppliers Listed on Gateway', 'javascript:newWin(5);']," & vbcrlf
				'strMenu = strMenu & "['Suppliers linked to DC', 'javascript:newWin(7);']," & vbcrlf
			End If
			
		End if		
		strMenu = strMenu & "]," & vbcrlf
		strMenu = strMenu & "['Search', '" & ApplicationRoot & "/search/default.asp?id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
		
		' Only DCs must have access to the schedules, suppiers must have access to the new claim status managament functionality, code removed UsType = 4 or
		if  UsType = 2 then
		    strMenu = strMenu & "['Schedules', null,null," & vbcrlf
		    
		    if UsPermission <> 1 then
			    strMenu = strMenu & "['Upload new Schedule', '" & ApplicationRoot & "/schedule/new/default.asp?fc=false',null]," & vbcrlf
				
				
			end if
			
		    strMenu = strMenu & "['List Schedules', '" & ApplicationRoot & "/schedule/search/default.asp?fc=false',null]," & vbcrlf

			if (UsPermission <> 1 And IsDCAllowedToUploadForceCredits) OR Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" Then
				If Session("ProcEAN") <> "GATEWAYCALLCEN" And Session("ProcEAN") <> "SPARHEADOFFICE" Then
					strMenu = strMenu & "['Upload Force Credits &amp; Reversals', '" & ApplicationRoot & "/schedule/new/default.asp?fc=true',null]," & vbcrlf
				End If
				
				strMenu = strMenu & "['List Force Credits &amp; Reversals', '" & ApplicationRoot & "/schedule/search/default.asp?fc=true',null]," & vbcrlf
			End If
			
			strMenu = strMenu & "['Upload new Rewards Schedule', '" & ApplicationRoot & "/schedule/new/default.asp?rw=True',null]," & vbcrlf
			If Session("IsdcAllowedAutoMatchingOfAdminClaim") Then strMenu = strMenu & "['Upload new Admin Schedule', '" & ApplicationRoot & "/schedule/new/default.asp?as=true',null]," & vbcrlf
			strMenu = strMenu & "['List Rewards Schedule', '" & ApplicationRoot & "/schedule/search/default.asp?rw=True',null]," & vbcrlf
			'strMenu = strMenu & "['Upload SPAR Stamps', '" & ApplicationRoot & "/schedule/new/default.asp?st=True',null]," & vbcrlf
			'strMenu = strMenu & "['List SPAR Stamps', '" & ApplicationRoot & "/schedule/search/default.asp?st=True',null]," & vbcrlf
			
		

			
		    strMenu = strMenu & "]," & vbcrlf   
		end if
		
		
		strMenu = strMenu & "['Admin', null,null," & vbcrlf
		' If DC logged in UsType = 2
		If USType = 2 Then 
			strMenu = strMenu & "['DC Claim Configuration', 'javascript:newWin(6);']," & vbcrlf
						
		End If
		
		If USType = 2 Or Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" Or (USType = 1 And Session("IsWarehouseUser")) Then
			strMenu = strMenu & "['Maintain Buyers', 'javascript:newWin(28);']," & vbcrlf
		End If
		
		
		If USType <> 3 Then
			strMenu = strMenu & "['DC Order Configuration', 'javascript:newWin(13);']," & vbcrlf
		End If
		
		If USType = 2 Then 
			strMenu = strMenu & "['Web Ordering Configuration', 'javascript:newWin(19);']," & vbcrlf
						
		End If
		
		' If DC logged in UsType = 2
		' Claim configuration should ONLY be available to Warehouse Claim Profiles AND Head office Profile

		If USType = 2 OR (Session("ProcEAN") = "LOWVELDDC") Then 
			strMenu = strMenu & "['Search User Details', 'javascript:newWin(14);']," & vbcrlf
			
		End If
		
		If Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" Or Session("IsWarehouseUser") Then
			strMenu = strMenu & "['Warehouse Claim Configuration', 'javascript:newWin(15);']," & vbcrlf
			
        End If
		
		If Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" Then
			strMenu = strMenu & "['Warehouse Claim Sub Categories', 'javascript:newWin(16);']," & vbcrlf
		End If
		
		If Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" Then
			
			strMenu = strMenu & "['Admin DC Claim Categories', '" & ApplicationRoot & "/claims/DCAdminClaimsCategories.asp" & "',null]," & vbcrlf
			strMenu = strMenu & "['Admin DC Claim Reasons', '" & ApplicationRoot & "/claims/DCAdminReasonCodes.asp" & "',null]," & vbcrlf
			
			strMenu = strMenu & "['Supplier Claim Categories', '" & ApplicationRoot & "/claims/SupplierAdminClaimsCategories.asp" & "',null]," & vbcrlf
			strMenu = strMenu & "['Supplier Claim Reasons', '" & ApplicationRoot & "/claims/SupplierAdminReasonCodes.asp" & "',null]," & vbcrlf
			strMenu = strMenu & "['Supplier Claim Sub Reasons', '" & ApplicationRoot & "/claims/SupplierAdminSubReasonCodes.asp" & "',null]," & vbcrlf

			strMenu = strMenu & "['Claim Capture - Store Exceptions', '" & ApplicationRoot & "/claims/SupplierClaimCaptureStoreExceptions.asp" & "',null]," & vbcrlf
			strMenu = strMenu & "['Claim Status Management', '" & ApplicationRoot & "/claims/ClaimStatusManagement.asp" & "',null]," & vbcrlf
			strMenu = strMenu & "['Maintain claim ean', '" & ApplicationRoot & "/claims/MaintainClaimSupplierEan.asp" & "',null]," & vbcrlf
			'strMenu = strMenu & "]," & vbcrlf
						
		End If		
		
		strMenu = strMenu & "['Print Page', 'javascript:window.print();']," & vbcrlf
		strMenu = strMenu & "['Report a Bug', 'javascript:newWin(3);']]," & vbcrlf
		
	
		if UsType <> 1 then
			strMenu = strMenu & "['Whats new/Whats Changed',null,null," & vbcrlf 							'whats new request from Lesley
			strMenu = strMenu & "['New Release For Store Use', '" & ApplicationRoot & "/news/For Store Use - Claims Changes.pptx','_blank']," & vbcrlf
			strMenu = strMenu & "['New Release For FOR DC Use', '" & ApplicationRoot & "/news/FOR DC Use - Claims Phase 7 Changes.pptx','_blank']," & vbcrlf
			strMenu = strMenu & "['Gateway Vat Changes', '" & ApplicationRoot & "/news/Gateway Vat Changes.pptx','_blank']," & vbcrlf
			strMenu = strMenu & "]," & vbcrlf
			
			
		End If
		
		
		strMenu = strMenu & "['Logout', 'javascript:newWin(4);']," & vbcrlf
		
		
				
			strMenu = strMenu & "];" & VbCrLf
		
		
	
		
		GenMenu = strMenu
	End Function

%>
