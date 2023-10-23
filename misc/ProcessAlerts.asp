 <%
' '**********************************************************************
' '  Visual Basic ActiveX Script
' '************************************************************************

' 'Function Main()

	' dim curConnection
	' dim SQL
	' dim ReturnSet
	' dim objMail
	' dim BodyText
	' dim BuyerID
	
	' const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPARNEW1\SPAR"
	
	' ' Create a connection
	' Set curConnection = CreateObject("ADODB.Connection")
	' curConnection.Open const_db_ConnectionString
	
	' ' Execute the sp - listBuyer
	' 'Set ReturnSet = curConnection.Execute ("exec listBuyer")

	' ' Check the returnvalue
' '	if ReturnSet("returnvalue") = 0 Then
		' ' No errors occured - Loop through the recordset
' '		While not ReturnSet.EOF
			' ' Set the BuyerID
' '			BuyerID = ReturnSet("BuyerID")

			' ' Build the bodytext for the firstline
			' BodyText = "This e-mail contain information on Purchase Orders sent via Gateway Communications." & VbCrLf & VbCrLf
			' BodyText = "Please do not reply to this e-mail.." & VbCrLf & VbCrLf
			' BodyText = "The following Order(s) has/have not been extracted:" & VbCrLf & VbCrLf
			
			' ' Execute the second sp - procAlerts
			' Set AlertSet = curConnection.Execute ("exec procAlerts @BuyerID=1")

			' ' Check the returnvalue
			' if AlertSet("returnvalue") <> 0 Then
				' BodyText = BodyText & "No orders were received or extracted."
			' else
				' ' Loop through the recordset
				' While not AlertSet.EOF
					' ' Build the BodyText
					' BodyText = BodyText & "Order Number: " & Mid(AlertSet("OrderNumber"),1,len(AlertSet("OrderNumber"))-4) & ",  Receiver: "  & AlertSet("SupplierName")  & "[EAN No: " & AlertSet("SupplierNumber") & "], Received by Gateway Communications at: " & AlertSet("ReceiveTime") & VbCrLf & VbCrLf

					' AlertSet.MoveNext
				' Wend
			' end if

			' BodyText = BodyText  & VbCrLf & VbCrLf & "Thank You"

' response.write BodyText & "<br>"

			' ' Close the AlertSet
			' Set AlertSet = Nothing

			' ' Create the Mail Object
			' Set objMail = CreateObject("CDONTS.NewMail")
	
			' ' Build the rest of the mail object properties
			' objMail.From = "spar@gatewaycomms.co.za"
			' 'objMail.To = ReturnSet("EMail")
			' objMail.To = "chris.kennedy@gatewaycomms.com"
			' 'objMail.BCc = "jyzelle@gatewaycomms.co.za"
			' 'objMail.BCc = "jkingsley@gatewaycomms.co.za"
			' objMail.Subject = "Alert Notifications (For Buyer: JEAN MUNDHOSS)"
			' objMail.Importance = 2
			' objMail.Body = BodyText
			' objMail.BodyFormat = 1
			' objMail.MailFormat = 1
			' objMail.Send
	
			' ' Close the mail Object
			' Set objMail = Nothing
			
' '			ReturnSet.MoveNext
' '		Wend
' '	end if
	
	' ' Close the recordset and connection
	' Set ReturnSet = Nothing
	' curConnection.Close
	' Set curConnection = Nothing

' '	Main = DTSTaskExecResult_Success
' 'End Function
 %>