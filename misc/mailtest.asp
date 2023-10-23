<%@ Language=VBScript %>
<%
										'For Counter = 1 to 300
											' Create the Mail Object
											Set objMail = Server.CreateObject("CDONTS.NewMail")
		
											'BodyText = "<html><head></head><body><p>This is mail number <b>" & Counter & "</b> of <b>300</b> mails.</body></html>"
											BodyText = "This is a test." & "<br>"
											BodyText = BodyText & "test" & "<br>"
											BodyText = BodyText & "test1" & "<br>"
											BodyText = BodyText & "test2" & "<br>"
		
											' Build the rest of the mail object properties
											objMail.From = "chris.kennedy@gatewaycomms.com"
											objMail.To = "atg@gatewaycomms.com"
											objMail.Subject = "Testing Spar E-Mails"
											objMail.MailFormat = 0
											objMail.BodyFormat = 0
											objMail.Body = BodyText
											objMail.Send
		
											' Close the mail Object
											Set objMail = Nothing
										'Next
										
										Response.Write BodyText
%>