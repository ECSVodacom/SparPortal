<%@ Language=VBScript %>
<%
	server.ScriptTimeout = 600

	Dim objSvrHTTP
	Dim PostData
	
	'Set objSvrHTTP = Server.CreateObject("Msxml2.ServerXMLHTTP")
	Set objSvrHTTP = Server.CreateObject("MSXML2.XMLHTTP")
	'Set objSvrHTTP = Server.CreateObject("Microsoft.XMLHTTP")
	'objSvrHTTP.open "GET", "http://www.gatewaycomms.com/billing_20040214.txt", true
	objSvrHTTP.open "POST", "http://10.34.49.4/pdcRequest/soapserver.asp", true
'	objSvrHTTP.setRequestHeader "Content-type", "text/html" 
	objSvrHTTP.send

	'Response.Write objSvrHTTP.Status & "<br>"
	'Response.Write objSvrHTTP.StatusText  
	'Response.End
	Response.Write objSvrHTTP.responseText
%>
