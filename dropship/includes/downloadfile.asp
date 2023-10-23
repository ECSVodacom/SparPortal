<%@ Language=VBScript %>
<!--#include file="constants.asp"-->
<!--#include file="downloadfunction.asp"-->
<!--#include file="formatfunctions.asp"-->
<%
											' Set the File system object											
											Set oFile = Server.CreateObject("Scripting.FileSystemObject")
											
											' Check if the fiel exist
											'response.Write(const_app_ReconXMLFixedPath & "," &  Replace(Request.QueryString("ref"),",","\") & "," &  Replace(Request.QueryString("ref"),",","\"))
											'response.End 
											
											if oFile.FileExists (const_app_ReconXMLFixedPath & Replace(Request.QueryString("ref"),",","\")) = True Then
											'	Response.Write "Exist"
											
												'Set MyFile  = oFile.GetFile (const_app_ReconXMLFixedPath & Replace(Request.QueryString("ref"),",","\"))
											
												'Set TextStreamObject = MyFile.OpenAsTextStream(1, -2)
												                            
												'   Read the First Line in the Text Stream
												'While Not TextStreamObject.AtEndOfStream
												'    TempString = TempString & TextStreamObject.ReadLine
												'Wend
												
												'response.BinaryWrite StreamObject.ReadAll
											
												'Response.Write  TempString
												
												call DownloadFile(const_app_ReconXMLFixedPath, "", Replace(Request.QueryString("ref"),",","\"))
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