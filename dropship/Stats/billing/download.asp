<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="downloadfunction.asp"-->
<!--#include file="Formatting.asp"-->
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
										dim ReturnString
										Dim DisplaySet
										Dim XMLDoc
										Dim XSLDoc
										Dim URL
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										
										curConnection.Open const_db_ConnectionString
										'Set ReportConnection = Server.CreateObject("ADODB.Connection")
										'ReportConnection.Open const_db_ConnectionString
										
										'Set StoreCurConnection = Server.CreateObject("ADODB.Connection")
										'StoreCurConnection.Open const_db_ConnectionString
										
										'Set dcConnection = Server.CreateObject("ADODB.Connection")
										'dcConnection.Open const_db_ReportConnection
										
											'SQL = "exec listWebReport_Display @Level = 4, @FromDate = '" & GetFromDate(Request.QueryString("Month"),Request.QueryString("FromMonth"),Request.QueryString("FromDate"),Request.QueryString("Year")) & "', @Todate = '" & MakeToDate(Request.QueryString("Month"),Request.QueryString("Year")) & "', @ReportType = '" & Request.QueryString("ReportType") & "', @ReportOn = " & Request.QueryString("ReportOn") & ", @DC = " & Request.QueryString("DC") & ", @Supplier = " & Request.QueryString("Supplier") & ", @Store = " & Request.QueryString("Store")
											SQL = Request.QueryString("SQL")
											'Response.Write(SQL)
											'response.End 
											If Request.QueryString("Type") = 1 Then
												ReturnString = XML_Download(curConnection, SQL)
											end if
											
											If Request.QueryString("Type") = 2 Then
												ReturnString = XML_Detail_Download(curConnection, SQL)
											end if
											
											If Request.QueryString("Type") = 3 Then
												ReturnString = Flat_Download(curConnection, SQL)
											end if
											
											ReturnString = Replace(ReturnString, "&", "&amp;")
											
											Dim fs,fw
											Set fs = Server.CreateObject("Scripting.FileSystemObject")
											Dim FileName, Folder
											
											If Request.QueryString("Type") = 1 or Request.QueryString("Type") = 2 Then
												FileName = Session.SessionID & "_" & now() & ".xml"
											Else
												FileName = Session.SessionID & "_" & now() & ".txt"
											End if
											
											FileName = Replace(FileName,"/","")
											FileName = Replace(FileName,":","")
											FileName = Replace(FileName," ","")
											
											
											Folder = const_app_WebReportFixedPath
											'Response.Write Folder & FileName
											Set fw = fs.CreateTextFile(Folder & FileName)
											
											fw.WriteLine(ReturnString)
											fw.Close
											
											call DownloadFile(Folder,"",Filename)			
											curConnection.Close 
													'StoreCurConnection.Close 
													'dcConnection.Close 
%>
