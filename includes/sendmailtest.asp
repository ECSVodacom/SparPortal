<%
	'function SendCDOMail (ToAddress, FromAddress, Subject, BodyText, MailFormat)
		' Author & Date: Chris Kennedy, 25 June 2002
		' Purpose: This function will send any mail according to the parameters provided.
		
		'Response.Write FromAddress
		'Response.End
		
		dim objMail
		
		FromAddress = "ckennedy@gatewaycomms.co.za; dviviers@gatewaycomms.co.za"
		
		MyAddress = Split (FromAddress,";")

Response.Write MyAddress(0)
Response.End

		' Create the Mail Object
		Set objMail = Server.CreateObject("CDONTS.NewMail")
		
		' Build the rest of the mail object properties
		objMail.From = MyAddress(0)
		'objMail.From = "ckennedy@gatewaycomms.co.za;dviviers@gatwaycomms.co.za"
		objMail.To = "ckennedy@gatewaycomms.co.za"
		'objMail.BCc = "sbouwer@gatewaycomms.co.za"
		objMail.Subject = "test"
		objMail.MailFormat = 0
		objMail.BodyFormat = 0
		objMail.Body = "BodyText"
		objMail.Send
		
		' Close the mail Object
		Set objMail = Nothing
		
'	end function
%>