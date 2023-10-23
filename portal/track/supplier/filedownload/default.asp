<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
//-->
</script>
<%						
										dim SQL
										dim curConnection
										dim XMLString
										dim NewDate
										dim XMLDoc
										dim XSLDoc
										dim DisplaySet
										dim Page
										dim RecordCount
										dim MaxRecords
										dim RecordFrom
										dim RecordTo
										dim BandSize
										dim Nav
										dim Counter
										dim TotPages
										dim Nar
										dim DisplayNar
										dim Dilimiter
										dim ExtractDate
										dim ReturnSet
										dim LineItem
										dim LineCount
										dim oFile
										dim CreateFile
										dim Display
										dim result
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
					
										if Request.QueryString("action") = "inv" then
											' call the itemInvoice sp
											SQL = "exec itemInvoice_New @InvoiceID=" & Request.QueryString("id")
										else
											' Biuld the SQL Statement for orders
											SQL = "exec itemOrder @OrderID=" & Request.QueryString("id") & _
												", @IsXML=0"
										end if

										' Call the 
										XMLString = XMLRequest(SQL, "", "", False)

										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject("MSXML2.DomDocument")
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject("MSXML2.DomDocument")
										XSLDoc.async = false
										XSLDoc.Load(Server.MapPath("default.xsl"))	

										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										' Now we need to generate the XML download file - Load the XML String into a dom object

										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject("MSXML2.DomDocument")
										XSLDoc.async = false
										
										if Request.QueryString("type") = "xml" then
											if Request.QueryString("action") = "inv" then
												XSLDoc.Load(Server.MapPath("ConvertToInvXML.xsl"))	
											else
												XSLDoc.Load(Server.MapPath("ConvertToOrdXML.xsl"))	
											end if
											
											'Set up the resulting document.
											Set result = CreateObject("MSXML2.DomDocument")
											result.async = False
											result.validateOnParse = True
										
											' Parse results into a result DOM Document.
											Display = XMLDoc.transformNodeToObject(XSLDoc, result)
											
											if Request.QueryString("action") = "inv" then									
												result.save "C:\Inetpub\wwwroot\Spar\dropship\track\supplier\downloadfiles\xmlinv_" & Request.QueryString("id") & ".xml"
												DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
												DisplaySet = Replace(DisplaySet,"@@loadfile","xmlinv_" & Request.QueryString("id") & ".xml&type=xml")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=xmlinv_" & Request.QueryString("id") & ".xml")
											else
												result.save "C:\Inetpub\wwwroot\Spar\dropship\track\supplier\downloadfiles\xmlord_" & Request.QueryString("id") & ".xml"
												DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
												DisplaySet = Replace(DisplaySet,"@@loadfile","xmlord_" & Request.QueryString("id") & ".xml&type=xml")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=xmlord_" & Request.QueryString("id") & ".xml")
											end if
										else
											if Request.QueryString("action") = "inv" then
												XSLDoc.Load(Server.MapPath("ConvertToInvTxt.xsl"))	
											else
												XSLDoc.Load(Server.MapPath("ConvertToOrdTxt.xsl"))	
											end if
											
											Display = XMLDoc.transformNode(XSLDoc)
											
											' Create a file system object
											Set oFile = Server.CreateObject("Scripting.FileSystemObject")
											
											if Request.QueryString("action") = "inv" then
												' Create the Text File
												Set CreateFile = oFile.CreateTextFile ("C:\Inetpub\wwwroot\Spar\dropship\track\supplier\downloadfiles\txtinv_" & Request.QueryString("id") & ".txt",True)
											else
												' Create the Text File
												Set CreateFile = oFile.CreateTextFile ("C:\Inetpub\wwwroot\Spar\dropship\track\supplier\downloadfiles\txtord_" & Request.QueryString("id") & ".txt",True)
											end if
											
											' Write the text to the File
											CreateFile.WriteLine (Display)
											
											' Close the object
											CreateFile.Close
											Set oFile = Nothing
											
											DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
											
											if Request.QueryString("action") = "inv" then
												DisplaySet = Replace(DisplaySet,"@@loadfile","txtinv_" & Request.QueryString("id") & ".txt&type=txt")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=txtinv_" & Request.QueryString("id") & ".txt")
											else
												DisplaySet = Replace(DisplaySet,"@@loadfile","txtord_" & Request.QueryString("id") & ".txt&type=txt")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=txtord_" & Request.QueryString("id") & ".txt")
											end if
										end if
										
										if Request.QueryString("action") = "inv" then
											DisplaySet = Replace(DisplaySet,"@@DownloadType","INVOICE")
										else
											DisplaySet = Replace(DisplaySet,"@@DownloadType","ORDER")
										end if
%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<!--#include file="../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../../layout/end.asp"-->
