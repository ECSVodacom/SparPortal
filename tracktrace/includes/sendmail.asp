<%
	function SendCDOMail (ToAddress, FromAddress, Subject, BodyText, MailFormat)
		' Author & Date: Chris Kennedy, 25 June 2002
		' Purpose: This function will send any mail according to the parameters provided.
		
		dim objMail
		dim CheckAddr
		dim FromArray
		
		if FromAddress = "" or isNULL(FromAddress) Then
			CheckAddr = "spar@gatewayec.co.za"
		else
			FromArray = Split (FromAddress,";")
			CheckAddr = FromArray(0)
		end if

		
		
		
		Call GenMail (CheckAddr, ToAddress, "", "", Subject, BodyText, 0, 0, 0)
		
		' Create the Mail Object
		'Set objMail = Server.CreateObject("CDONTS.NewMail")
		
		' Build the rest of the mail object properties
		'objMail.From = CheckAddr
		'objMail.To = ToAddress
		'objMail.Subject = Subject
		'objMail.MailFormat = 0
		'objMail.BodyFormat = 0
		'objMail.Body = BodyText
		'objMail.Send
		
		' Close the mail Object
		'Set objMail = Nothing
		
	end function
	
	
Function GenMail (FromAddress, ToAddress, CCAddress, BCcAddress, Subject, BodyText, Importance, MailFormat, BodyFormat)
	Dim Command	

	Command = "sp_send_cdosysmail " _
		& "@From='" & FromAddress _
		& "', @To='" & ToAddress _
		& "',@Cc='" &  CCAddress _
		& "',@Subject='" & Replace(Subject,"'","''") _
	 	& "',@Body='" & Replace(BodyText,"'","''") & "'"

	Dim MailConnection
	
	Set MailConnection= CreateObject ("ADODB.Connection")
	MailConnection.Open "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=ECsqlOnline!;Initial Catalog=SparDS;Data Source=192.168.101.36,1433"
	
	ExecuteSql Command, MailConnection
	
	
End Function
%>