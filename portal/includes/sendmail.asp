<%
	function SendCDOMail (ToAddress, FromAddress, Subject, BodyText, MailFormat)
		' Author & Date: Chris Kennedy, 25 June 2002
		' Purpose: This function will send any mail according to the parameters provided.
		
		dim objMail

		' Create the Mail Object
		Set objMail = Server.CreateObject("CDONTS.NewMail")
		
		' Build the rest of the mail object properties
		objMail.From = FromAddress
		objMail.To = ToAddress
		'objMail.To = "ckennedy@gatewaycomms.co.za"
		objMail.BCc = "hannes.kingsley@gatewaycomms.com;chris.kennedy@gatewaycomms.com"
		objMail.Subject = Subject
		objMail.MailFormat = 0
		objMail.BodyFormat = 0
		objMail.Body = BodyText
		objMail.Send
		
		' Close the mail Object
		Set objMail = Nothing
		
	end function
%>