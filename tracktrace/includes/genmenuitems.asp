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
<%
	Function GenMenu (UsType, UsPermission, ApplicationRoot, MenuDate)
		' UsType 1. Buyer
		'		 2. Supplier
		dim strMenu

			'response.write USType
		
		strMenu = strMenu & "var MENU_ITEMS = [" & VbCrLf
		if UsType = 1 then
			strMenu = strMenu & "['SSBU Tracking', null,null," & vbcrlf
			
				strMenu = strMenu & "['SSBU Orders', '" & ApplicationRoot & "/tracktrace/buyer/frmcontent.asp?action=8&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
				strMenu = strMenu & "['SSBU Invoices', '" & ApplicationRoot & "/tracktrace/buyer/frmcontent.asp?action=7&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
			
			strMenu = strMenu & "]," & vbcrlf
		end if
		
		If UsType = 1 Then
			strMenu = strMenu & "['Orders', '" & ApplicationRoot & "/tracktrace/buyer/frmcontent.asp?action=1&id=" & FormatDate(MenuDate,false) & "',null," & vbcrlf
			
			
			If Session("Permission") = 2 Then
				strMenu = strMenu & "['Search Orders', '" & ApplicationRoot & "/tracktrace/buyer/search/default.asp',null]," & vbcrlf
			End If
			strMenu = strMenu & "]," & vbcrlf
		ElseIf USType = 2 Then
			strMenu = strMenu & "['Orders', '" & ApplicationRoot & "/tracktrace/supplier/frmcontent.asp?action=1&id=" & FormatDate(MenuDate,false) & "',null," & vbcrlf
			strMenu = strMenu & "]," & vbcrlf
		End If
		
		
		strMenu = strMenu & "['Search', '" & ApplicationRoot & "/tracktrace/search/default.asp?id=" & FormatDate(MenuDate,false) & "',null,],"
			
		
		strMenu = strMenu & "['Reports', null,null," & vbcrlf
		If UsType = 1  Then
			strMenu = strMenu & "['Electronic Remittance', '" & ApplicationRoot & "/tracktrace/buyer/frmcontent.asp?action=6&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
		ElseIf USType = 2 Then
			strMenu = strMenu & "['Electronic Remittance', '" & ApplicationRoot & "/tracktrace/supplier/frmcontent.asp?action=6&id=" & FormatDate(MenuDate,false) & "',null]," & vbcrlf
		End If		
		
	'strMenu = strMenu & "['Logistics', 'javascript:newWin(2);',null]," & vbcrlf
		If Session("FirstName") = "ORANGELOGISTx" Then
			strMenu = strMenu & "['Logistics', 'javascript:newWin(2);',null]," & vbcrlf
		End If
		
		strMenu = strMenu & "]," & vbcrlf
	

		strMenu = strMenu & "['Notice',null,null," & vbcrlf 							'whats new request from Lesley
		strMenu = strMenu & "['EDI - Case Ordering Change', '" & ApplicationRoot & "/TrackTrace/DCNews/EDI - Case Ordering Change.pdf','_blank']," & vbcrlf
		strMenu = strMenu & "]," & vbcrlf

		'SSBU
		'strMenu =  strMenu & "['SSBU PO Tracking', '" & ApplicationRoot & "/tracktrace/buyer/frmcontent.asp?action=1&id=" & FormatDate(MenuDate,false) & "',null," & vbcrlf
		'strMenu = strMenu & "]," & vbcrlf
				

		'strMenu = strMenu & "['Search', '" & ApplicationRoot & "/TrackTrace/search/default.asp','_blank']," & vbcrlf
		strMenu = strMenu & "['Logout', 'javascript:newWin(1);']," & vbcrlf
		strMenu = strMenu & "];" & VbCrLf
			
		GenMenu = strMenu
	End Function
%>
