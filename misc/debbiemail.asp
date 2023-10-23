<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<%
										BodyText = "<html><head></head><body><p><font face='Arial' size='2'>Dear SPAR Supplier,</font></p>"
										BodyText = BodyText & "<p><font face='Arial' size='2'>You recently received correspondence from SPAR Central Office regarding potential changes to the existing electronic ordering facility. The telephone number provided for Lesley Roberts is incorrect. Please contact her on (031) 719-1900 or (031) 719-1955.</font></p>"
'										BodyText = BodyText & "<p><font face='Arial' size='2'>SPAR have done the following changes to the DC Order layout:</font></p>"
'										BodyText = BodyText & "<p><ul><li><font face='Arial' size='2'>At header level - In the narrative field " & chr(34) & "promotional order" & chr(34) & " will be displayed.  This will allow for the supplier to know that the entire order is for promotions.</font></li>"
'										BodyText = BodyText & "<li><font face='Arial' size='2'>At line item level - The TI & HI is an addition to the message.  This has to do with the way the products are delivered to the DC and it's mainly for smaller suppliers.</font></li></ul></p>"
'										BodyText = BodyText & "<p><font face='Arial' size='2'>PLEASE READ THE ATTACHED LETTER TO FAMILIARISE YOURSELF WITH THE CONTENT THEREOF.</font></p>"
'										BodyText = BodyText & "<p><font face='Arial' size='2'>Gateway will be implementing the change on Sunday 15-08-2004. </font></p>"
'										BodyText = BodyText & "<p><font face='Arial' size='2'>EDI suppliers may have to amend/develop on their side to accommodate for these changes and can contact their Gateway Account Managers for any assistance on development if necessary.</font></p>"
'										BodyText = BodyText & "<p><font face='Arial' size='2'>For any other queries contact the Vodacom Call Centre on 0821951.</font></p>"
'										BodyText = BodyText & "<p><font face='Arial' size='2'>Your assistance and co-operation in this matter will be appreciated.</font></p>"
										BodyText = BodyText & "<p><font face='Arial' size='2'>Regards,</font></p>"
										BodyText = BodyText & "<p><font face='Arial' size='2'>Gateway Communications</font><br>"
'										BodyText = BodyText & "<font face='Arial' size='2'><b>Project Manager</b></font><br>"
'										BodyText = BodyText & "</body></html>"										


'response.write BodyText

										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										SQL = "SELECT SPcEmail AS SupplierEmail FROM Supplier"

										Set ReturnSet = ExecuteSql(SQL, curConnection)

										While not ReturnSet.EOF
											Counter = Counter + 1

											' Create the Mail Object
											Set objMail = Server.CreateObject("CDONTS.NewMail")
		
											' Build the rest of the mail object properties
											objMail.From = "spar@gatewayec.co.za"
											objMail.To = ReturnSet("SupplierEmail")
											objMail.BCc = "chris.kennedy@gatewaycomms.com"
											objMail.Subject = "SPAR EDI Purchase Order Changes"
											objMail.MailFormat = 0
											objMail.BodyFormat = 0
											objMail.Body = BodyText
'											objMail.AttachFile "F:\uploads\mails\attach\Changes_to_the_SPAR_Electronic_Order_Message_23_Aug.doc","Changes_to_the_SPAR_Electronic_Order_Message_23_Aug.doc"
'											objMail.AttachFile "F:\uploads\mails\attach\Example_of_txt_message.doc","Example_of_txt_message.doc"
											objMail.Send
		
											' Close the mail Object
											Set objMail = Nothing
											
											ReturnSet.MoveNext
										Wend
										
										Response.Write "Total Supplier Mails: " & Counter 

										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>