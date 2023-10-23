<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<!--#include file="../../dc/includes/makeorders.asp"-->
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
					
										Select Case Request.QueryString("action")
										Case "inv"
											' call the itemInvoice sp
											SQL = "exec itemInvoice_New @InvoiceID=" & Request.QueryString("id")
											
											'response.write(SQL)
											'response.end
											
											' Call the 
											XMLString = XMLRequest(SQL, "", "", False)
										Case "clm"
											' Biuld the SQL Statement for orders
											SQL = "exec itemClaim @ClaimID=" & Request.QueryString("id") & _
												", @IsXML=0"
												
											' Call the 
											XMLString = XMLRequest(SQL, "", "", False)												
										Case "cn"
											' Biuld the SQL Statement for orders
											SQL = "exec itemCreditNote_New @CNID=" & Request.QueryString("id") & _
												", @IsXML=0"
												
											' Call the 
											XMLString = MakeCreditNoteItemXML (curConnection, SQL)											
										Case else
											' Biuld the SQL Statement for orders
											SQL = "exec itemOrder @OrderID=" & Request.QueryString("id") & _
												", @IsXML=0"
												
											' Call the 
											XMLString = XMLRequest(SQL, "", "", False)												
										End Select
										
										'Response.Write XMLString
										'Response.End

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
										
										'response.write(DisplaySet)
										'response.end
										
										' Now we need to generate the XML download file - Load the XML String into a dom object

										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject("MSXML2.DomDocument")
										XSLDoc.async = false
										
										if Request.QueryString("type") = "xml" then
											Select Case Request.QueryString("action")
											Case "inv"
												XSLDoc.Load(Server.MapPath("ConvertToInvXML.xsl"))
											Case "clm"
												XSLDoc.Load(Server.MapPath("ConvertToClmXML.xsl"))	
											Case "cn"
												XSLDoc.Load(Server.MapPath("ConvertToCnXML.xsl"))	
											Case else
												XSLDoc.Load(Server.MapPath("ConvertToOrdXML.xsl"))	
											End Select
																					
											'Set up the resulting document.
											Set result = CreateObject("MSXML2.DomDocument")
											result.async = False
											result.validateOnParse = True
										
											' Parse results into a result DOM Document.
											Display = XMLDoc.transformNodeToObject(XSLDoc, result)
											
											'response.write(Display)
											'response.end
											
											Select Case Request.QueryString("action")
											Case "inv"
												result.save "C:\Inetpub\wwwroot\sparv2\dropship\track\supplier\downloadfiles\xmlinv_" & Request.QueryString("id") & ".xml"
												DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
												DisplaySet = Replace(DisplaySet,"@@loadfile","xmlinv_" & Request.QueryString("id") & ".xml&type=xml")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=xmlinv_" & Request.QueryString("id") & ".xml")
											Case "clm"
												result.save "C:\Inetpub\wwwroot\sparv2\dropship\track\supplier\downloadfiles\xmlclm_" & Request.QueryString("id") & ".xml"
												DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
												DisplaySet = Replace(DisplaySet,"@@loadfile","xmlclm_" & Request.QueryString("id") & ".xml&type=xml")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=xmlclm_" & Request.QueryString("id") & ".xml")
											Case "cn"
												result.save "C:\Inetpub\wwwroot\sparv2\dropship\track\supplier\downloadfiles\xmlcn_" & Request.QueryString("id") & ".xml"
												DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
												DisplaySet = Replace(DisplaySet,"@@loadfile","xmlcn_" & Request.QueryString("id") & ".xml&type=xml")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=xmlcn_" & Request.QueryString("id") & ".xml")
											Case else
												result.save "C:\Inetpub\wwwroot\sparv2\dropship\track\supplier\downloadfiles\xmlord_" & Request.QueryString("id") & ".xml"
												DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
												DisplaySet = Replace(DisplaySet,"@@loadfile","xmlord_" & Request.QueryString("id") & ".xml&type=xml")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=xmlord_" & Request.QueryString("id") & ".xml")
											End Select
										else
											Select Case Request.QueryString("action")
											Case "inv"
												XSLDoc.Load(Server.MapPath("ConvertToInvTxt.xsl"))
											Case "clm"
												XSLDoc.Load(Server.MapPath("ConvertToClmTxt.xsl"))
											Case "cn"
												XSLDoc.Load(Server.MapPath("ConvertToCnTxt.xsl"))														
											Case else
												XSLDoc.Load(Server.MapPath("ConvertToOrdTxt.xsl"))	
											End Select
																		
											Display = XMLDoc.transformNode(XSLDoc)
											
											' Create a file system object
											Set oFile = Server.CreateObject("Scripting.FileSystemObject")
											
											Select Case Request.QueryString("action")
											Case "inv"
												' Create the Text File
												Set CreateFile = oFile.CreateTextFile ("C:\Inetpub\wwwroot\sparv2\dropship\track\supplier\downloadfiles\txtinv_" & Request.QueryString("id") & ".txt",True)
											Case "clm"
												' Create the Text File
												Set CreateFile = oFile.CreateTextFile ("C:\Inetpub\wwwroot\sparv2\dropship\track\supplier\downloadfiles\txtclm_" & Request.QueryString("id") & ".txt",True)
											Case "cn"
												' Create the Text File
												Set CreateFile = oFile.CreateTextFile ("C:\Inetpub\wwwroot\sparv2\dropship\track\supplier\downloadfiles\txtcn_" & Request.QueryString("id") & ".txt",True)												
											Case else
												' Create the Text File
												Set CreateFile = oFile.CreateTextFile ("C:\Inetpub\wwwroot\sparv2\dropship\track\supplier\downloadfiles\txtord_" & Request.QueryString("id") & ".txt",True)
											End Select

											' Write the text to the File
											CreateFile.WriteLine (Display)
											
											' Close the object
											CreateFile.Close
											Set oFile = Nothing
											
											DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
											
											Select Case Request.QueryString("action")
											Case "inv"
												DisplaySet = Replace(DisplaySet,"@@loadfile","txtinv_" & Request.QueryString("id") & ".txt&type=txt")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=txtinv_" & Request.QueryString("id") & ".txt")
											Case "clm"
												DisplaySet = Replace(DisplaySet,"@@loadfile","txtclm_" & Request.QueryString("id") & ".txt&type=txt")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=txtclm_" & Request.QueryString("id") & ".txt")
											Case "cn"
												DisplaySet = Replace(DisplaySet,"@@loadfile","txtcn_" & Request.QueryString("id") & ".txt&type=txt")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=txtcn_" & Request.QueryString("id") & ".txt")												
											Case else
												DisplaySet = Replace(DisplaySet,"@@loadfile","txtord_" & Request.QueryString("id") & ".txt&type=txt")
												DisplaySet = Replace(DisplaySet,"@@FilePath",const_app_applicationRoot & "/track/supplier/filedownload/download.asp?id=txtord_" & Request.QueryString("id") & ".txt")
											End Select
										end if
										
										Select Case Request.QueryString("action")
										Case "inv"
											DisplaySet = Replace(DisplaySet,"@@DownloadType","INVOICE")
										Case "clm"
											DisplaySet = Replace(DisplaySet,"@@DownloadType","CLAIM")
										Case "cn"
											DisplaySet = Replace(DisplaySet,"@@DownloadType","CREDITNOTE")											
										Case else
											DisplaySet = Replace(DisplaySet,"@@DownloadType","ORDER")
										End Select
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
