<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										'NewDate = "20" & FormatDateTime(Date,2)
										NewDate = "2002/09/17"
										Const const_app_NumberDrive = "c:\SparNumbers\"
										
										' Build the SQL
										'SQL = "SELECT TRcOrderNumber, TRcSupplierCode FROM TrackTrace WHERE CONVERT(VARCHAR(50),TRdReceivedTime,111) = " & MakeSQLText(NewDate)
										SQL = "SELECT TRcOrderNumber, CMcEANNumber" & _
											" FROM TrackTrace" & _
											" INNER JOIN Buyer ON BRID = TRiBuyerID" & _
											" INNER JOIN Company ON CMID = BRiCompanyID" & _
											" WHERE CONVERT(VARCHAR(50),TRdReceivedTime,111) = " & MakeSQLText(NewDate)
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
										
										' Check if there are any records returned
										if ReturnSet.EOF Then
											' No records returned
											Response.Write	"There were no orders for " & FormatDateTime(Now(),2) & "."
										else
											' Create a file system 
											Set oFile = Server.CreateObject ("Scripting.FileSystemObject")

											' Check if the file exist
											if oFile.FileExists(const_app_NumberDrive & "listnumber.txt") Then
												' Delete the file
												oFile.DeleteFile(const_app_NumberDrive & "listnumber.txt")
											end if
											
											' Create the file
											Set MyFile = oFile.CreateTextFile(const_app_NumberDrive & "listnumber.txt",false)
											
											' Loop through the recordset
											While not ReturnSet.EOF
												Response.Write Mid(ReturnSet("TRcOrderNumber"),1,len(ReturnSet("TRcOrderNumber"))-4) & ", " & ReturnSet("CMcEANNumber") & "<br>"

												' Write to the file
												MyFile.WriteLine(Mid(ReturnSet("TRcOrderNumber"),1,len(ReturnSet("TRcOrderNumber"))-4) & ", " & ReturnSet("CMcEANNumber"))
																								
												ReturnSet.MoveNext
											Wend
											
											' Close the File System Object
											Set MyFile = Nothing
											Set oFile = Nothing
										end if
										
										' Close the Recordset
										Set ReturnSet = Nothing
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
%>