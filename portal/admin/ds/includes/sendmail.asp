<%
	function SendCDOMail (ToAddress, FromAddress, Subject, BodyText, MailFormat)
		' Author & Date: Chris Kennedy, 25 June 2002
		' Purpose: This function will send any mail according to the parameters provided.
		
		dim objMail
		
		' Create the Mail Object
		Set objMail = Server.CreateObject(const_app_MailObject)
		
		' Build the rest of the mail object properties
		objMail.From = FromAddress
		objMail.To = ToAddress
		objMail.Subject = Subject
		objMail.Body = BodyText
		objMail.MailFormat = 0
		objMail.Send
		
		' Close the mail Object
		Set objMail = Nothing
		
	end function
%>