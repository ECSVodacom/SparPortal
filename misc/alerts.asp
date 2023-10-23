<%@ Language=VBScript %>
<%

	dim curConnection
	dim SQL
	dim ReturnSet
	dim objMail
	dim BodyText
	dim BuyerID
	
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=TECHNICAL_03"
	
	' Create a connection
	Set curConnection = CreateObject("ADODB.Connection")
	curConnection.Open const_db_ConnectionString
	
	' Execute the sp - proc45Alert
	Set ReturnSet = ExecuteSql("listBuyer", curConnection)   

	' Check the returnvalue
	if ReturnSet("returnvalue") = 0 Then
		' No errors occured - Loop through the recordset
		While not ReturnSet.EOF
			' Set the BuyerID
			BuyerID = ReturnSet("BuyerID")

			' Build the bodytext for the firstline
			'BodyText = "Below is the order(s) that are not yet opened by the supplier:" & VbCrLf & VbCrLf
			BodyText = "Below is the order(s) that are not yet opened by the supplier:<br>"
			
			' Execute the second sp - procAlerts
			Set AlertSet = ExecuteSql("procAlerts @BuyerID=" & BuyerID, curConnection)    

			' Check the returnvalue
			if AlertSet("returnvalue") = 0 Then
				' Loop through the recordset
				While not AlertSet.EOF
					' Build the BodyText
					'BodyText = BodyText & "Order Number: " & AlertSet("OrderNumber") & VbCrLf
					BodyText = BodyText & "Order Number: " & AlertSet("OrderNumber") & "<br>"								

					AlertSet.MoveNext
				Wend
			end if

			' Close the AlertSet
			Set AlertSet = Nothing
			
			Response.Write BodyText & "<br><hr><br>"

			' Create the Mail Object
'			Set objMail = CreateObject("CDONTS.NewMail")
	
			' Build the rest of the mail object properties
'			objMail.From = "admin@firstnet.co.za"
'			objMail.To = ReturnSet("BuyerMail")
		'	objMail.To = "ckennedy@firstnet.co.za"
'			objMail.Subject = "Purchase Order Notification: Supplier did not open order yet"
'			objMail.Importance = 2
'			objMail.Body = BodyText
'			objMail.MailFormat = 0
'			objMail.Send
'	
'			' Close the mail Object
'			Set objMail = Nothing
			
			ReturnSet.MoveNext
		Wend
	end if
	
	' Close the recordset and connection
	Set ReturnSet = Nothing
	curConnection.Close
	Set curConnection = Nothing

%>
