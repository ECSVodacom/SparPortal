<%@ Language=VBScript %>
<!--#include file="../../../includes/constants.asp"-->
<%
										' Create a file system object
										Set oFile = Server.CreateObject("Scripting.FileSystemObject")

										' Open the textfile
										Set GetFile = oFile.GetFile("C:\Inetpub\wwwroot\Spar\dropship\track\supplier\downloadfiles\" & Request.QueryString("id"))
										
										Set TextStreamObject = GetFile.OpenAsTextStream(1, -2)

										While Not TextStreamObject.AtEndOfStream
											if Request.QueryString("type") = "xml" then
												XMLString= XMLString & Replace(TextStreamObject.ReadLine,"<br>","")
											else
												TxtString = TxtString & TextStreamObject.ReadLine & "<br>"
											end if
										Wend

										if Request.QueryString("type") = "xml" then
											' Load the String into an XML Dom
											Set XMLDoc = Server.CreateObject("MSXML2.DomDocument")
											XMLDoc.async = false
											XMLDoc.LoadXML(XMLString)
									
											Response.Write XMLDoc.xml	
										else
											Response.Write TxtString
										end if
																			
										' Close the file
										Set oFile = Nothing
%>