<%@ Language=VBScript %>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/downloadfunction.asp"-->
<%

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

  									    Set RetSet = ExecuteSql("exec itemSchedule @ScheduleID=" & Request.QueryString("id"), curConnection)   
  									   
   										extention = ".csv"
										
										While Not RetSet.EOF
											FileName = RetSet("FileName")
											strOutput = strOutput & RetSet("StoreCode") & "," & chr(34) & RetSet("StoreName") & chr(34) & "," & RetSet("DocNumber") & "," & RetSet("DocDate") & "," & _
												RetSet("AmtExcl") & "," & RetSet("Vat") & "," & RetSet("AmtIncl") & vbcrlf
													
											RetSet.MoveNext
										Wend
										
										Set RetSet = Nothing
										curConnection.Close 
										
										Dim fs,fw
										Set fs = Server.CreateObject("Scripting.FileSystemObject")
										Dim FileName, Folder, strFileArray
										'FileName = Session.SessionID & "_" & now() & extention
										'FileName = Replace(FileName,"/","")
										'FileName = Replace(FileName,":","")
										'FileName = Replace(FileName," ","")
										strFileArray = split(FileName, ".")
										FileName =  strFileArray(0) & extention									
										
										'Response.Write(FileName)
										'Response.End 
										Folder = const_app_schedDownloadDir
										Set fw = fs.CreateTextFile(Folder & FileName)

										'Response.Write(folder&filename)
										'Response.end
											
										fw.WriteLine(strOutput)
										fw.Close
										'Response.end
											
										call DownloadFile(Folder,"",Filename)			
%>
