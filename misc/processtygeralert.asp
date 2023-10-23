<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<%
										dim oFile
										dim oFolder
										dim Files_Collection
										dim FileCount
										dim BodyText
										dim objMail
										
										const const_app_FolderPath = "D:\FTP_CLIENTS\TigerBrands\Out"
										const const_mailList = "sparmon@gatewayec.co.za;diana.vanderschyff@za.didata.com;janet.joubert@za.didata.com;mike.bennet@za.didata.com"
										
										' Create the file system object
										Set oFile = Server.CreateObject("Scripting.FileSystemObject")
										
										' Get the folder
										Set oFolder = oFile.GetFolder (const_app_FolderPath)
										
										' Get a collection of the files in this folder
										Set Files_Collection = oFolder.Files
	
										' Check if there are files in the folder
										FileCount = Files_Collection.Count
										
										' Check if the FileCount is greater or equal to 10
										if FileCount >= 10 then
											' Build the bodytext
											BodyText = BodyText & "To Whom it May Concern" & VbCrLf & VbCrLf
											BodyText = BodyText & "Note that the Tiger Brands folder contains more than 10 SPAR orders." & VbCrLf
											BodyText = BodyText & "Please check the Di Data FTP connection to the Gateway FTP Server" & VbCrLf
											BodyText = BodyText & "Thank You, " & VbCrLf
											BodyText = BodyText & "Gateway Communications - 0821951"
											
											' Send an e-mail alert to the helpdesk and the relevant contacts at Di Data
											Set objMail = Server.CreateObject ("CDONTS.NewMail")
											
											objMail.From = "spar@gatewayec.co.za" 
											objMail.To = const_mailList
											objMail.BCc = "ckennedy@gatewaycomms.co.za"
											objMail.Subject = "SPAR - TIGER BRANDS ORDER ALERT"
											objMail.Importance = 2
											objMail.Body = BodyText
											objMail.BodyFormat = 1
											objMail.MailFormat = 1
											objMail.Send
											
											' Close the mail object
											Set objMail = Nothing
										end if
										
										' Close the file system object
										Set oFile = Nothing

%>