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
										dim FileName
										dim strFileArray
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString

  									    Set RetSet = ExecuteSql("itemSchedule @ScheduleID=" & Request.QueryString("id"), curConnection)
  									   
   										extention = ".xls"
   										
   										FileName = RetSet("FileName")   										
   										   										
   										strFileArray = split(FileName, ".")
										FileName =  strFileArray(0)	 & extention
										
										Response.ContentType = "application/vnd.ms-excel"
                                        Response.AddHeader "Content-Disposition", "attachment; filename=" & FileName 
										
										response.write "<table border=1>"
										response.Write "<tr><td>Store Code</td><td>Store Name</td><td>Doc Number</td><td>Doc Date</td><td>Amount Excl</td><td>Vat</td><td>Amount Incl</td><td>Invoice Reference</td><td>Claim Reference</td></tr>"
										
										While Not RetSet.EOF

                                            response.write "<tr><td>" & RetSet("StoreCode") & "</td><td>" & RetSet("StoreName") & "</td><td>" & RetSet("DocNumber") & "</td><td>" & _
                                            RetSet("DocDate") & "</td><td>" & RetSet("AmtExcl") & "</td><td>" & RetSet("Vat") & "</td><td>" & RetSet("AmtIncl") & "</td><td>" & _
                                            RetSet("InvRef") & "</td><td>" & RetSet("ClaimRef") & "</td></tr>"

											RetSet.MoveNext
										Wend
										
										response.write "</table>"
										
										Set RetSet = Nothing
										curConnection.Close 
										
												
%>
