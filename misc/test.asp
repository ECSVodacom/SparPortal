<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<%
										dim StrText
										dim NewCount
										dim Counter
										dim StrCount
										dim StrDisplay
										dim oFile
										dim File
										dim DayCount
										
										PageTitle = "Track and Trace : Buyer"
										
										StrText = "<pre>"
										StrText = StrText & "<!--" & VbCrLf
										StrText = StrText & "var tocTab = new Array();var ir=0;" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('0', 'Date Menu', '');" & VbCrLf
										StrText = StrText & "tocTab[ir++] = new Array ('1', '" & FormatLongDate(Date,false) & "', '" & const_app_ApplicationRoot & "/tracktrace/frames/frmcontent.asp?id=" & FormatLongDate(Date,false) & "');" & VbCrLf

										NewCount = 0
										DayCount = 0

										For Counter = 2 to 30
											DayCount = DayCount + 1
											StrCount = Counter
											StrDisplay = FormatLongDate(Date - DayCount,false)
											
											if Counter >= 9 Then
												if Counter = 9 Then
													StrCount = 9 
												else
													NewCount = NewCount + 1
													StrCount = 9 & "." & NewCount
												end if
												
												if NewCount = 0 Then
													StrDisplay = "Before " & FormatLongDate(Date - DayCount,false)
												else
													StrDisplay = FormatLongDate(Date - DayCount,false)
												end if
											end if
											
											StrText = StrText & "tocTab[ir++] = new Array ('" & StrCount & "', '" & StrDisplay & "', '');" & VbCrLf
										Next
										
										StrText = StrText & "var nCols = 4;" & VbCrLf
										StrText = StrText & "//-->" & VbCrLf
										StrText = StrText & "</pre>"
										
										' Create the file system object
										Set oFile = Server.CreateObject("Scripting.FileSystemObject")

										' Open the text file
										Set File = oFile.OpenTextFile ("C:\Inetpub\wwwroot\Spar\includes\navigation.js",2,True)
																				
										' write the string to the text file
										File.Write StrText
																				
										' Close the file system object
										Set File = Nothing
										Set oFile = Nothing
										
										Response.Write StrText
											
%>