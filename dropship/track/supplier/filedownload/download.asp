<%
Response.Buffer = True
'strFileName="boston09.jpg"
strFileName=Request.QueryString("id")
strFilePath=server.mappath("/dropship/track/supplier/downloadfiles/" & strFilename)
strFilename = Replace(strFilename ,"..","")
strFilename = Replace(strFilename ,"/","")

'Response.Write strFilePath
'Response.End
set fso=createobject("scripting.filesystemobject")
set f=fso.getfile(strfilepath)
strFileSize = f.size
set f=nothing: set fso=nothing
Const adTypeBinary = 1
Response.Clear
Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = adTypeBinary
objStream.LoadFromFile strFilePath
'strFileType = "image/jpeg" ' change to the correct content type for your file
strFileType = "text/xml" ' change to the correct content type for your file
Response.AddHeader "Content-Disposition", "attachment; filename=" & strFileName
Response.AddHeader "Content-Length", strFileSize
Response.Charset = "UTF-8"
Response.ContentType = strFileType
Response.BinaryWrite objStream.Read
Response.Flush
objStream.Close
Set objStream = Nothing
%>