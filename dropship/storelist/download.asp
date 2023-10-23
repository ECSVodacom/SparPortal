<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="downloadfunction.asp"-->
<%
Server.ScriptTimeout = 30000
										dim curConnection
										dim ReportConnection
										dim StoreCurConnection
										dim dcConnection
										Dim dcSQL
										dim SQL
										Dim StoreSQL
										dim ReturnSet
										Dim StoreReturnSet
										Dim dcReturnSet
										dim MCount
										dim TestDate
										dim NewDate
										Dim counter
										dim XMLString
										Dim DisplaySet
										Dim XMLDoc
										Dim XSLDoc
										Dim URL
										dim strStatus
										dim strAction
										dim strActionDate
										dim strOutput
										dim extention
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										Set ReturnSet = ExecuteSql("listStores @Filter=" & Request.QueryString("filter") & ", @DCID=" & Request.QueryString("dc")  & ", @StoreFormat='" & Replace(Request.QueryString("sf"),"'","''") & "'", curConnection) 

										if Request.QueryString("type") = "xml" then
											extention = ".xml"
											strOutput = "<storeList>"
										
											' Loop through the recordset
											While not ReturnSet.EOF
												strOutput = strOutput & "<store>"
												strOutput = strOutput & "<name>" & ReturnSet("StoreName") & "</name>"
												strOutput = strOutput & "<code>" & ReturnSet("StoreCode") & "</code>"
												strOutput = strOutput & "<vatNumber>" & ReturnSet("StoreVatNo") & "</vatNumber>"
												strOutput = strOutput & "<eanNumber>" & ReturnSet("StoreEAN") & "</eanNumber>"
												strOutput = strOutput & "<phoneNumber>" & ReturnSet("StorePhone") & "</phoneNumber>"
												strOutput = strOutput & "<faxNumber>" & ReturnSet("StoreFax") & "</faxNumber>"
												strOutput = strOutput & "<address>" & ReturnSet("StoreAddress") & "</address>"
												strOutput = strOutput & "<ownerName>" & ReturnSet("StoreOwner") & "</ownerName>"
												strOutput = strOutput & "<managerName>" & ReturnSet("StoreManager") & "</managerName>"
												strOutput = strOutput & "<dcEANNumber>" & ReturnSet("DCEANNumber") & "</dcEANNumber>"
												
												
												Select Case Returnset("StoreStatus")
												case 0
													strStatus = "Inactive"
												case 1
													strStatus = "Active"
												case 2
													strStatus = "Test"
												end select
										
												strOutput = strOutput & "<status>" & strStatus & "</status>"
										
												select case Returnset("StoreAction")
												case 0
													strAction = "New"
												case 1
													strAction = "Updated"
												case 2
													strAction = "Deleted"
												case else
													strAction = "New"
												End Select
										
												strOutput = strOutput & "<action>" & strAction & "</action>"																				
												strOutput = strOutput & "<actionDate>" & ReturnSet("ActionDate") & "</actionDate>"										
												strOutput = strOutput & "<managerEmail>" & ReturnSet("Email") & "</managerEmail>"
												strOutput = strOutput & "<formatTypeDescription>" & ReturnSet("FromatTypeDesc") & "</formatTypeDescription>"
												strOutput = strOutput & "<countryCode>" & ReturnSet("CountryCode") & "</countryCode>"
												strOutput = strOutput & "<captureClaimForSupplierYN>" & ReturnSet("ClaimsforSuppInd") & "</captureClaimForSupplierYN>"

												strOutput = strOutput & "</store>"
												
												Returnset.MoveNext
											Wend
										
											strOutput = strOutput & "</storeList>"
										
											strOutput = Replace(strOutput,"&","&amp;")
										else
											extention = ".txt"
											strOutput = "StoreName|StoreCode|StoreVatNo|StoreEANNumber|StoreTelNo|StoreFaxNo|StoreAddress|StoreOwner|StoreManager|DCEANNumber|Status|Action|actiondate|ManagerEmail|FormatTypeDescription|CountryCode|CaptureClaimForSupplierYN" & vbcrlf
											
											

											
											While Not ReturnSet.EOF
												Select Case Returnset("StoreStatus")
												case 0
													strStatus = "Inactive"
												case 1
													strStatus = "Active"
												case 2
													strStatus = "Test"
												end select
										
												select case Returnset("StoreAction")
												case 0
													strAction = "New"
												case 1
													strAction = "Updated"
												case 2
													strAction = "Deleted"
												case else
													strAction = "New"
												End Select	
												
												strOutput = strOutput & ReturnSet("StoreName") & "|" & ReturnSet("StoreCode") & "|" & ReturnSet("StoreVatNo") & "|" & ReturnSet("StoreEAN") & "|" & _
													ReturnSet("StorePhone") & "|" & ReturnSet("StoreFax") & "|" & ReturnSet("StoreAddress") & "|" & ReturnSet("StoreOwner") & "|" & ReturnSet("StoreManager") & "|" & _
													ReturnSet("DCEANNumber") & "|" & strStatus& "|" & strAction  & "|" & ReturnSet("ActionDate") & "|"  & _
													ReturnSet("Email") & "|" & ReturnSet("FromatTypeDesc")& "|" & ReturnSet("CountryCode")  & "|" & ReturnSet("ClaimsforSuppInd") & "|" & vbcrlf
													
													
												ReturnSet.MoveNext
											Wend
										end if

										
										Set ReturnSet = Nothing
										curConnection.Close 
										
										'Response.Write strOutput
										'Response.End										
										
										Dim fs,fw
										Set fs = Server.CreateObject("Scripting.FileSystemObject")
										Dim FileName, Folder
										FileName = Session.SessionID & "_" & now() & extention
										FileName = Replace(FileName,"/","")
										FileName = Replace(FileName,":","")
										FileName = Replace(FileName," ","")
										'Response.Write(FileName)
										'Response.End 
										
										Folder = Const_StoreList_TempSave
										Set fw = fs.CreateTextFile(Folder & FileName)

										'Response.Write(folder&filename)
										'Response.end
											
										fw.WriteLine(strOutput)
										fw.Close
										'Response.end
											
										call DownloadFile(Folder,"",Filename)			
%>
