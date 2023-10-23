<%
dim objSrvHTTP
dim objXMLSend
dim objXMLReceive
Set objSrvHTTP = Server.CreateObject("MSXML2.XMLHTTP")
objSrvHTTP.open "GET","http://ecommerce.gatewayec.co.za/ackermans",false
'objSrvHTTP.open "POST","http://pathfinder.metro.co.za:8080/cgi-bin/receive.cgi",false
objSrvHTTP.send ()
'Response.ContentType = "text/xml"
'Response.Write (Response.Write (objSrvHTTP.responseText))

Response.Write objSvrHTTP.Status & "<br>"
Response.Write objSvrHTTP.StatusText  

%>