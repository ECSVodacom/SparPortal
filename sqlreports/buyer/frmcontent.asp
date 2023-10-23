<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/setuserdetails.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/xmlfunctions.asp"-->
<!--#include file="../../includes/adovbs.inc"-->
<!--#include file="includes/doxmlstring.asp"-->
<!--#include file="../../sqlreports/sqlreportfunctions.asp"-->
<%
										' Determine if the user is logged in
										Call CookieLoginTrackCheck(const_app_ApplicationRoot & "/tracktrace/buyer/frmcontent.asp?id=" & Request.QueryString("id"))
										
										dim SQL
										dim curConnection
										dim XMLString
										dim NewDate
										dim XMLDoc
										dim XSLDoc
										dim DisplaySet
										dim XMLOrders
										dim OrdCount
										dim ReceiverEAN
										dim LoginUser
										
										if Request.QueryString("id") = "" Then
											'NewDate = "20" & FormatDateTime(Date,2)
											NewDate = Year(Now) & "/" & Month(Now) & "/" &Day(Now)
										else
											'NewDate = "20" & FormatDateTime(Request.QueryString("id"),2)
											NewDate = Year(Request.QueryString("id")) & "/" & Month(Request.QueryString("id")) & "/" & Day(Request.QueryString("id"))
										end if
										
'										Response.Write NewDate

										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										Dim DoAction 
										DoAction = CInt(Request.QueryString("action"))
										If DoAction = 6 Then
											SQL = "exec SparDS.dbo.listRemittanceAdvicesFileNames @RADate=" & MakeSQLText(NewDate) 
											XMLString = MakeERALinkXML(curConnection, SQL)
										Else
											if Session("Permission") > 1 Then
												XMLString = MakeSuperXML (curConnection, NewDate)
											else
												' Biuld the SQL Statement
												SQL = "exec listBuyerTrack @BuyerID=" & Session("ProcID") & _
													", @ReceiveDate=" & MakeSQLText(NewDate) & _
													", @Type=" & Session("Permission")
												XMLString = XMLRequest(SQL, "", "" ,False)
											end if
										End If

										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										' Determine if this is a Super Buyer
										if DoAction = 6 Then
											Set XSLDoc = Server.CreateObject(const_app_XMLObject)
											XSLDoc.async = false
											XSLDoc.Load(const_app_SqlReportsPath & "remittanceAdvices.xsl")
										else
											if Session("Permission") > 1 Then
												' Load the XSL Style Sheet for the super buyer
												Set XSLDoc = Server.CreateObject(const_app_XMLObject)
												XSLDoc.async = false
												XSLDoc.Load(const_app_TrackPath & "buyer\supertrackreport.xsl")
											else
												' Load the XSL Style Sheet
												Set XSLDoc = Server.CreateObject(const_app_XMLObject)
												XSLDoc.async = false
												XSLDoc.Load(const_app_TrackPath & "buyer\btrackreport.xsl")
											end if
										end if

										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										if DoAction = 6 Then
										else
											if Session("Permission") > 1 Then
												LoginUser = Session("FirstName") & " " & Session("Surname")
												DisplaySet = Replace(DisplaySet,"@@LoginUser",LoginUser)
											else
												' Get a collection of the orders
												Set XMLOrders = XMLDoc.selectNodes("//rootnode/pmmessage/order")										
											
												' Loop through the collection
												For OrdCount = 0 to XMLOrders.Length-1
													' Get the receiverean
													ReceiverEAN = XMLOrders.item(OrdCount).selectSingleNode("receiverean").text
													
												'	if XMLOrders.item(OrdCount).selectSingleNode("firstconfirmdate").text <> "" Then
												'		DisplaySet = Replace(DisplaySet,"@@xmlref" & OrdCount+1,Replace(XMLOrders.item(OrdCount).selectSingleNode("xmlref").text,"\","-"))
												'	end if
													'DisplaySet = Replace(DisplaySet,"@@Order" & OrdCount+1 & "Number",Mid(XMLOrders.item(OrdCount).selectSingleNode("number").text,1,len(XMLOrders.item(OrdCount).selectSingleNode("number").text)-4))
													Dim ordSplit
													ordSplit = split(XMLOrders.item(OrdCount).selectSingleNode("number").text,"s")
													DisplaySet = Replace(DisplaySet,"@@Order" & OrdCount+1 & "Number",ordSplit(0)) 


													' Detemine if this is an XML or EDI supplier
													if IsNumeric(ReceiverEAN) Then
														' Replace the variable in the XSL
														DisplaySet = Replace(DisplaySet,"@@Format" & OrdCount+1 & "Check","EDI")
													else
														' Replace the variable in the XSL
														DisplaySet = Replace(DisplaySet,"@@Format" & OrdCount+1 & "Check","XML")											
													end if
												Next
											end if
										end if
										
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@Date",FormatLongDate(Request.QueryString("id"),false))
										
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<!--#include file="../../layout/headclose.asp"-->
<!--#include file="../../layout/bodystart.asp"-->
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../layout/end.asp"-->
