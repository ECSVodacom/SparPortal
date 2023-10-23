<%@ Language=VBScript %>
<!--#include file="../../includes/constants.asp"-->
<%
											' Set the File system object											
											Set oFile = Server.CreateObject("Scripting.FileSystemObject")
											
											' Check if the fiel exist
												if oFile.FileExists (const_app_SparArcPath & Replace(Request.QueryString("ref"),",","\")) = True Then
											'	Response.Write "Exist"
												
												'Set MyFile  = oFile.GetFile (const_app_SparArcPath & Replace(Request.QueryString("ref"),",","\"))
											
												'Set TextStreamObject = MyFile.OpenAsTextStream(1, -2)
                            
												'   Read the First Line in the Text Stream
												'While Not TextStreamObject.AtEndOfStream
												'    TempString = TempString & TextStreamObject.ReadLine
												'Wend
											
												'Response.Write  TempString
												
												
												
												 Response.Buffer = False
												Dim objStream
												Set objStream = Server.CreateObject("ADODB.Stream")
												objStream.Type = 1 'adTypeBinary
												objStream.Open
												objStream.LoadFromFile(const_app_TabFile &  StrFileName)
												Response.ContentType = "application/x-unknown"
												Response.Addheader "Content-Disposition", "attachment; filename=" & Replace(Request.QueryString("ref"),",","\")
												Response.BinaryWrite objStream.Read
												objStream.Close
												Set objStream = Nothing
												
											else
												'	The file does not exist - Display an error message
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<!--#include file="../../layout/headclose.asp"-->
<!--#include file="../../layout/bodystart.asp"-->
<p class="pheader">XML File Download</p>
<p class="errortext">The file does not exist on our server. Please contact the Systems Administrator.</p>
<!--#include file="../../layout/end.asp"-->
<%												
											end if
%>