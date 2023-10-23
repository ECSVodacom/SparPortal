<%@ Language=VBScript %>
<%
                              Function MakeSQLText(DateToChange)

											dim TempDate
											
											If IsNull(DateToChange) OR DateToChange = "" then
												MakeSQLText = "null"
											else
												MakeSQLText = "'" & DateToChange & "'"
											end if
											
										End Function
										
										Function GetSuffix (OrdNum)

											' Check what suffix should be used
											Select Case CStr(OrdNum)
											Case "6001008999956"
												GetSuffix = "sNTH"
											Case "6001008999949"
												GetSuffix = "sERD"
											Case "6001008999963"
												GetSuffix = "sPLZ"
											Case "6001008999970"
												GetSuffix = "sCPT"
											Case "6001008999987"
												GetSuffix = "sNTL"
											Case Else
												GetSuffix = "sNTH"
											End Select
										End Function
                              
                              const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPAR"
                              const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/"
                              const const_app_ObjXML = "MSXML2.DomDocument"
										const const_app_NewMail = "CDONTS.NewMail"
										const const_app_MailCC = "sbouwer@gatewaycomms.co.za;sparmon@gatewaycomms.co.za"
										const const_app_XMLPath = "D:\SparOrders\"
										const const_app_Path = "D:\"
										

                              ' Get the current server date
										ArchiveDate = Replace(FormatDateTime(Date,2),"/","")

										' Create the connection
										Set curConnection = CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
                              
										' Create a FileSytem Object
										Set oFile = Server.CreateObject ("Scripting.FileSystemObject")
										
										Set FolderObject = oFile.GetFolder("D:\FTP_CLIENTS\TigerBrands\In\")

										For Each ImportFileObject In FolderObject.Files
											
											FileName = ImportFileObject.Name
											
											'   Open the Current File For Read Input
											Set TextStreamObject = ImportFileObject.OpenAsTextStream(1, -2)
                            
											'   Read the First Line in the Text Stream
											FileHead = TextStreamObject.ReadLine
											
											' Build the SQL Statement to update TrackTrace table
											SQL = "exec editTigerInvoice @OrderNumber=" & MakeSQLText(Trim(CDbl(mid(FileHead,2,20))) & GetSuffix(mid(FileHead,35,13))) & _
											", @ExtractTime=" & MakeSQLText("20" & FormatDateTime(Now,2) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now)) & _
											", @InvoiceNumber=" & MakeSQLText(mid(FileHead,63,20)) 
											
											Response.Write SQL
											Response.End
											
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												' An error occured
												Response.Write ReturnSet("errormessage") & "<br>"
												
												' Check if the folder does not exist
												if Not oFile.FolderExists(const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate) Then
													' Create the folder
													oFile.CreateFolder (const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate)
												end if
														
												' Save the File to this folder
												oFile.MoveFile const_app_Path & "FTP_CLIENTS\TigerBrands\In\" & FileName ,const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate & "\" & FileName
			
												' Close the XML object
												Set objXML = Nothing
												
												' Create the Mail Object
												Set objMail = CreateObject(const_app_NewMail)
	
												' Build the rest of the mail object properties
												objMail.From = "spar@gatewayec.co.za" 
												objMail.To = "sbouwer@gatewaycomms.co.za; sparmon@gatewaycomms.co.za"
												objMail.BCc = "ckennedy@gatewaycomms.co.za"
												objMail.Subject = "Spar Tyger Tax Invoice Error"
												objMail.Importance = 2
												objMail.Body = ReturnSet("errormessage") & " Source File: " & const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate & "\" & FileName
												objMail.BodyFormat = 1
												objMail.MailFormat = 1
												objMail.Send
	
												' Close the mail Object
												Set objMail = Nothing
											else
												' No error occured - continue
												XMLRef = ReturnSet("XMLRef")
												SupplierName = ReturnSet("SupplierName")
												
												Delimiter = ""
														
												' Get the Buyer Email address - Loop through the recordset
												While not ReturnSet.EOF
													BuyerEmail = BuyerEmail & Delimiter & ReturnSet("BuyerEmail")
															
													' Set the delimeter
													Delimiter = "; "
															
													ReturnSet.MoveNext
												Wend

												' Get the Origional xml file to update 
												Set objXML = Server.CreateObject("MSXML2.DomDocument")
												objXML.async = False
												objXML.load (const_app_XMLPath & XMLRef)
													
												' Update the Application ref and invoice number
												objXML.selectSingleNode("//DOCUMENT/UNB/APRF").text = "Source Tax Invoice"
												objXML.selectSingleNode("//DOCUMENT/UNB/SOURCEREFERNCENUMBER").text = mid(FileHead,63,20)
												
												' Get the BuyerCode
												BuyerCode = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORIG/NAME").text
													
												' Close the recordset
												Set ReturnSet = Nothing

												Response.Write "<b>Header</b>" & "<br>"
												Response.Write "Rec_Type = " & left(FileHead,1) & "<br>"
												Response.Write "Order # = " & Trim(mid(FileHead,2,20)) & "<br>"
												Response.Write "Sender = " & mid(FileHead,21,14) & "<br>"
												Response.Write "Recipient = " & mid(FileHead,35,13) & "<br>"
												Response.Write "Unit ID = " & mid(FileHead,48,2) & "<br>"
												Response.Write "Cust Ord Point = " & mid(FileHead,50,13) & "<br>"
												Response.Write "Invoice # = " & mid(FileHead,63,20) & "<br><br>"
												Response.Write "<b>Line Details</b>" & "<br>" 
											
												' Now read the rest of the line items
												While Not TextStreamObject.AtEndOfStream
													FileLine = TextStreamObject.ReadLine
													
													' Build the SQL Statement to update OrderDetails table
													SQL = "exec editTigerInvoiceDetail @OrderNumber=" & MakeSQLText(Trim(CDbl(mid(FileHead,2,20))) & GetSuffix(mid(FileHead,35,13))) & _
													", @ProdCode=" & MakeSQLText(mid(FileLine,7,14)) & _
													", @Qty=" & MakeSQLText(CInt(mid(FileLine,22,11))) & _
													", @LinePrice=" & MakeSQLText(CDbl(Round(mid(FileLine,33,14),5))) 

													Response.Write SQL & "<br>"
													
													' Execute the SQL
													Set ReturnSet = ExecuteSql(SQL, curConnection)
											
													' Check the returnvalue
													if ReturnSet("returnvalue") = 0 then
														' No error occured - continue

														' Set the list of lone items for the origional order
														Set LineItems = objXML.selectNodes("//DOCUMENT/UNB/UNH/OLD")
															
														' Loop through this line item collection
														For LineCount = 0 to LineItems.Length-1
														' Check if the EANCNum exists in this XML Doc
															if Trim(mid(FileLine,7,14)) = Trim(LineItems.item(LineCount).selectSingleNode("PROC/SUPC").text) Then
																' Update the origional XML doc with the status, quantity, costprice and netprice
																LineItems.item(LineCount).setAttribute "status", "Confirmed"
																LineItems.item(LineCount).selectSingleNode("QNTO/NROUC").text = CInt(mid(FileLine,22,11))
																LineItems.item(LineCount).selectSingleNode("COST/COSPC").text = CDbl(Round(mid(FileLine,33,14),5))
																LineItems.item(LineCount).selectSingleNode("NELCC").text = LineItems.item(LineCount).selectSingleNode("NELC").text
																LineItems.item(LineCount).selectSingleNode("NARR").text = Trim(LineItems.item(LineCount).selectSingleNode("NARR").text)
															end if
														Next
							
														' Save the XML Back to the directory
														objXML.save(const_app_XMLPath & XMLRef)
	
														Response.Write "Rec_Type = " & mid(FileLine,1,1) & "<br>"
														Response.Write "Line # = " & CInt(mid(FileLine,2,5)) & "<br>"
														Response.Write "Item Code = " & mid(FileLine,7,14) & "<br>"
														Response.Write "Qty = " & CInt(mid(FileLine,22,11)) & "<br>"
														Response.Write "Price = " & CDbl(Round(mid(FileLine,33,14),5)) & "<br><br>"

														if TextStreamObject.AtEndOfStream Then
															Response.Write "<br><hr><br>"
														end if
													end if
													
													' Close the recordset
													Set ReturnSet = Nothing
												Wend
												
												' Close the XMLObject
												Set objXML = Nothing
							
												' Close the textstream object
												Set TextStreamObject = Nothing
												
												' Delete the file from the in folder
												oFile.DeleteFile "D:\FTP_CLIENTS\TigerBrands\In\" & FileName, True
												
												' Build the BodyText
												BodyText = "<html><body><p><font face='Arial' size='2'>This e-mail contains information on Purchase Orders sent via Gateway Communications.</font></p>"
												BodyText = BodyText & "<p><font face='Arial' size='2'>Please do not reply to this e-mail.</font></p>" 
												BodyText = BodyText & "<p><font face='Arial' size='2'>The following Purchase Order Confirmation(s) was/were received:</font></p>" 
												BodyText = BodyText & "<p><font face='Arial' size='2'><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/buyer/default.asp?id=" & XMLRef & "&type=1" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/buyer/default.asp</a></font></p>"
												BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</font></p></body></html>"

Response.Write BodyText & "<br><br>"

												' Create the Mail Object
												Set objMail = CreateObject(const_app_NewMail)
	
												' Build the rest of the mail object properties
												objMail.From = "spar@gatewayec.co.za"
												objMail.To = BuyerMail
												objMail.BCc = "ckennedy@gatewaycomms.co.za"
												objMail.Subject = "Purchase Order Notifications from Supplier " & SupplierName & " (For Buyer Code: " & CStr(BuyerCode) & " )"
												objMail.Importance = 2
												objMail.Body = BodyText
												objMail.MailFormat = 0
												objMail.BodyFormat = 0
												objMail.Send
	
'												' Close the mail Object
												Set objMail = Nothing
											end if
										Next
					
										' Close the FolderObject
										Set FolderObject = Nothing
										
                              ' Close the Object
                              Set oFile = Nothing
                              
                              ' Close the Connection
                              curConnection.Close
                              Set curConnection = Nothing
                              
%>