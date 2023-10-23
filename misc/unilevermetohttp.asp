<%@ Language=VBScript %>
<%

const const_app_ObjHTTP = "MSXML2.XMLHTTP"
dim objSrvHTTP
dim objXMLSend
dim objXMLReceive

'Set objXMLSend = Server.CreateObject("MSXML2.DomDocument")
'objXMLSend.async = false
'XMLFile = objXMLReceive = objXMLSend.loadXML ("<ShipmentDateUpdate><SenderEAN>6001087000000</SenderEAN><SupplierMailboxEAN>6001087000017</SupplierMailboxEAN><SendDate>20030827</SendDate><Order><BranchEAN>6001005001416</BranchEAN><OrderNo>286072</OrderNo><ShipmentDate>20030829</ShipmentDate><Reference>0021501134</Reference></Order></ShipmentDateUpdate>")
XMLFile = "<ShipmentDateUpdate><SenderEAN>6001087000000</SenderEAN><SupplierMailboxEAN>6001087000017</SupplierMailboxEAN><SendDate>20030827</SendDate><Order><BranchEAN>6001005001416</BranchEAN><OrderNo>286072</OrderNo><ShipmentDate>20030829</ShipmentDate><Reference>0021501134</Reference></Order></ShipmentDateUpdate>"
   
Set HttpRequest = Server.CreateObject(const_app_ObjHTTP)
Call HttpRequest.open ("POST","http://pathfinder.metro.co.za:8080/cgi-bin/receive.cgi",false)
HttpRequest.send (XMLFile)
Response.Write "Status = " & HttpRequest.Status & "<br>"
'Response.Write HttpRequest.StatusText & "<br>"
'Response.ContentType = "text/xml"
'Response.Write (HttpRequest.responseText)

%>