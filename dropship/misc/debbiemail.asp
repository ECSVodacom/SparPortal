<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<%
										BodyText = "<html><head></head><body><p><font face='Comic Sans' size='2'>Dear SPAR Store Owner and/Manager,</font></p>"
										BodyText = BodyText & "<p><font face='Comic Sans' size='2'>With reference to the SPAR Drop Shipment Project.</font></p>"
										BodyText = BodyText & "<p><font face='Comic Sans' size='2'>A SPAR Roll Out Team will be doing various software installations to accommodate for the Drop Shipment Project.</font></p>"
										BodyText = BodyText & "<p><font face='Comic Sans' size='2'>As part of this project, Gateway Communications will be providing a facility called Track & Trace.  The SPAR Roll Out Team will be handling all training on this facility.</font></p>"
										BodyText = BodyText & "<p><font face='Comic Sans' size='2'>Therefore please find attached, the Drop Shipment Track & Trace User Guide.  You will be required to have printed out the User Guide before or on the day that the SPAR Roll Out Team will be implementing at your premises.</font></p>"
										BodyText = BodyText & "<p><font face='Comic Sans' size='2'>If you have any queries regarding the Track & Trace facility once implemented, please feel free to contact the Gateway Call Center on 0821951.</font></p>"
										BodyText = BodyText & "<p><font face='Comic Sans' size='2'>Kind Regards,</font></p>"
										BodyText = BodyText & "<p><font face='Comic Sans' size='3'>Marius van Heerden</font><br>"
										BodyText = BodyText & "<font face='Comic Sans' size='3'><b>Project Manager</b></font><br>"
										BodyText = BodyText & "<font face='Comic Sans' size='3' color='blue'><b>Gateway Communications</b></font><br>"
										BodyText = BodyText & "<font face='Comic Sans' size='2'>Direct Telephone:	+27 (0) 11 797 3353</font><br>"
										BodyText = BodyText & "<font face='Comic Sans' size='2'>Switchboard:	      +27 (0) 11 797 3300</font><br>"
										BodyText = BodyText & "<font face='Comic Sans' size='2'>Cellular:		      +27 (0) 83 226 0074</font><br>"
										BodyText = BodyText & "<font face='Comic Sans' size='2'>Facsimile:		   +27 (0) 11 797 3364</font><br>"
										BodyText = BodyText & "<font face='Comic Sans' size='2'>Email address:	   marius.vanheerden@gatewaycomms.com</font></p>"
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										SQL = "SELECT SEcEmail AS StoreEmail FROM StoreEmail"

										Set ReturnSet = ExecuteSql(SQL, curConnection)

										While not ReturnSet.EOF
											response.write BodyText & "<br><hr><br>"
											Counter = Counter + 1
											' Create the Mail Object
											Set objMail = Server.CreateObject("CDONTS.NewMail")
		
											' Build the rest of the mail object properties
											objMail.From = "marius.vanheerden@gatewaycomms.com"
											objMail.To = ReturnSet("StoreEmail")
											objMail.Subject = "RE: DS TRACK & TRACE USER GUID"
											'objMail.AttachFile
											objMail.AttachFile "d:\inetpub\wwwroot\Spar\DropShip\misc\UserGuideDSDraft.doc","Dropshipment User Guide", 0									
											objMail.MailFormat = 0
											objMail.BodyFormat = 0
											objMail.Body = BodyText
											objMail.Send
		
											' Close the mail Object
											Set objMail = Nothing
											
											ReturnSet.MoveNext
										Wend

Response.Write Counter

										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>