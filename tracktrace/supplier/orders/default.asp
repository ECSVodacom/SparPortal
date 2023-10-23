<%@ Language=VBScript %>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="includes/makeselecteditem.asp"-->
<%								
										Call CookieLoginCheck (const_app_ApplicationRoot & "/orders/Buyer/default.asp?id=" & Request.QueryString("id"))
										
										dim ListBox
										
										' Check if there is a querystring parameter
										if Request.QueryString("id") = "" Then
											'Response.Write const_app_ApplicationRoot
											Response.Redirect const_app_ApplicationRoot & "/Spar"
										else
%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<script language="javascript">
<!--
	
//-->
</script>
<!--#include file="../../../layout/headclose.asp"-->
<!--#include file="../../../layout/bodystart.asp"-->
<%

											' Load the XMl Document
											Set XMLDoc = Server.CreateObject(const_app_XMLObject)
											XMLDoc.async = false
											XMLDoc.Load(const_app_SparArcPath & Request.QueryString("id"))
											
											' Load the XSL Style Sheet
											Set XSLDoc = Server.CreateObject(const_app_XMLObject)
											XSLDoc.async = false

											' Determine what option the user selected
											Select Case Request.Form("hidFilter")
											Case "0"
												' Load XSL file - showall.xsl
												XSLDoc.Load(Server.MapPath("displayorder.xsl"))
											Case "1"
												' Load XSL file - showallexp.xsl
												XSLDoc.Load(Server.MapPath("displayorder.xsl"))
											Case "2"
												' Load XSL file - showQtyExp.xsl
												XSLDoc.Load(Server.MapPath("displayQtyExp.xsl"))
											Case "3"
												' Load XSL file - showPriceExp.xsl
												XSLDoc.Load(Server.MapPath("displayPriceExp.xsl"))
											Case "4"
												' Load XSL file - showComment.xsl
												XSLDoc.Load(Server.MapPath("displayComment.xsl"))
											Case "7"
												' Load XSL file - showall.xsl
												XSLDoc.Load(Server.MapPath("displayorder.xsl"))
											Case "8"
												' Load XSL file - showConfirmItems.xsl
												XSLDoc.Load(Server.MapPath("displayConfirmItems.xsl"))
											Case "9"
												' Load XSL file - showUnconfirmItems.xsl
												XSLDoc.Load(Server.MapPath("displayUnconfirmItems.xsl"))
											Case "10"
												' Load XSL file - showNewItems.xsl
												XSLDoc.Load(Server.MapPath("displayNewItems.xsl"))
											Case Else
												' Load the default showall.xsl file
												XSLDoc.Load(Server.MapPath("displayorder.xsl"))
											End Select

											' Transform the xml doc with the xsl doc
											DisplaySet = XMLDoc.TransformNode(XSLDoc)
											
											' Replace the values in the XSL File
											DisplaySet = Replace(DisplaySet,"@@XMLFile",Request.QueryString("id"))
											DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
											DisplaySet = Replace(DisplaySet,"@@ListBox",MakeSelectedItem (Request.Form("hidFilter")))
											
											' Get a list of orders
											Set OrdList = XMLDoc.selectNodes("//DOCUMENT/UNB/UNH/OLD")
											
											' Loop through the OrdList
											For OrdCount = 0 to OrdList.Length-1
												' Determine if there are any Quantity discrepancies
												'if CLng(OrdList.item(OrdCount).selectSingleNode("QNTO/NROU").text) = CLng(OrdList.item(OrdCount).selectSingleNode("QNTO/NROUC").text) Then
												if OrdList.item(OrdCount).selectSingleNode("QNTO/NROU").text = OrdList.item(OrdCount).selectSingleNode("QNTO/NROUC").text Then
													' Replace the QtyColor to green
													DisplaySet = Replace(DisplaySet,"@@Qty" & OrdCount+1 & "Color","#006633")
													DisplaySet = Replace(DisplaySet,"@@Qty" & OrdCount+1 & "Class","tdcontent")
												else
													' Determine if the Qty * vendor = confirmed qty
													'if CLng(OrdList.item(OrdCount).selectSingleNode("QNTO/NROU").text) * CLng(OrdList.item(OrdCount).selectSingleNode("QNTO/TMEA").text) = CLng(OrdList.item(OrdCount).selectSingleNode("QNTO/NROUC").text) Then
													if OrdList.item(OrdCount).selectSingleNode("QNTO/NROU").text * OrdList.item(OrdCount).selectSingleNode("QNTO/TMEA").text = OrdList.item(OrdCount).selectSingleNode("QNTO/NROUC").text Then
														' Replace the QtyColor to green
														DisplaySet = Replace(DisplaySet,"@@Qty" & OrdCount+1 & "Color","#006633")
														DisplaySet = Replace(DisplaySet,"@@Qty" & OrdCount+1 & "Class","tdcontent")
													else
														' Determine if the Qty * store = confirmed qty
														'if CLng(OrdList.item(OrdCount).selectSingleNode("QNTO/NROU").text) * CLng(OrdList.item(OrdCount).selectSingleNode("QNTO/CONU").text) = CLng(OrdList.item(OrdCount).selectSingleNode("QNTO/NROUC").text) Then
														if OrdList.item(OrdCount).selectSingleNode("QNTO/NROU").text * OrdList.item(OrdCount).selectSingleNode("QNTO/CONU").text = OrdList.item(OrdCount).selectSingleNode("QNTO/NROUC").text Then
															' Replace the QtyColor to green
															DisplaySet = Replace(DisplaySet,"@@Qty" & OrdCount+1 & "Color","#006633")
															DisplaySet = Replace(DisplaySet,"@@Qty" & OrdCount+1 & "Class","tdcontent")
														else
															' Replace the QtyColor to green
															DisplaySet = Replace(DisplaySet,"@@Qty" & OrdCount+1 & "Color","red")	
															DisplaySet = Replace(DisplaySet,"@@Qty" & OrdCount+1 & "Class","tdcontentred")
														end if
													end if
												end if
												
												' Determine if there are any Price discrepancies
												if OrdList.item(OrdCount).selectSingleNode("COST/COSP").text = OrdList.item(OrdCount).selectSingleNode("COST/COSPC").text Then
													' Replace the QtyColor to green
													DisplaySet = Replace(DisplaySet,"@@Pr" & OrdCount+1 & "Color","#006633")
													DisplaySet = Replace(DisplaySet,"@@Pr" & OrdCount+1 & "Class","tdcontent")
												else
													' Determine if the price/vendor = confirmed price
													if OrdList.item(OrdCount).selectSingleNode("COST/COSP").text / OrdList.item(OrdCount).selectSingleNode("QNTO/TMEA").text = OrdList.item(OrdCount).selectSingleNode("QNTO/NROUC").text Then
														' Replace the QtyColor to green
														DisplaySet = Replace(DisplaySet,"@@Pr" & OrdCount+1 & "Color","#006633")
														DisplaySet = Replace(DisplaySet,"@@Pr" & OrdCount+1 & "Class","tdcontent")
													else
														' Replace the QtyColor to green
														DisplaySet = Replace(DisplaySet,"@@Pr" & OrdCount+1 & "Color","red")
														DisplaySet = Replace(DisplaySet,"@@Pr" & OrdCount+1 & "Class","tdcontentred")
													end if
												end if
												
												' Determine if this is an XML or EDI Order
												if IsNumeric(XMLDoc.selectSingleNode("DOCUMENT/UNB/Receiver/ReceiverID").text) Then
													' Replace the XSL variable @@Confirm
													DisplaySet = Replace(DisplaySet,"@@Confirm","<td class=" & chr(34) & "pcontent" & chr(34) & "><i>Confirm<br/>Value<br/></i></td>")

													' Check if the Order Value = Confirm Value
													if OrdList.item(OrdCount).selectSingleNode("NELC").text = OrdList.item(OrdCount).selectSingleNode("NELCC").text Then
														' Replace the color with green
														DisplaySet = Replace(DisplaySet,"@@Net" & OrdCount+1 & "Price","<td bgcolor=" & chr(34) & "#006633" & chr(34) &  "align=" & chr(34) & "right" & chr(34) & "valign=" & chr(34) & "middle" & chr(34) & "class=" & chr(34) & "tdcontent" & chr(34) & ">R" & FormatNumber(OrdList.item(OrdCount).selectSingleNode("NELC").text,2,0,0,-1) & "</td>")
													else
														' Replace the color with red
														'DisplaySet = Replace(DisplaySet,"@@Net" & OrdCount+1 & "Price","<td bgcolor=" & chr(34) & "red" & chr(34) &  "align=" & chr(34) & "right" & chr(34) & "valign=" & chr(34) & "middle" & chr(34) & "class=" & chr(34) & "tdcontentred" & chr(34) & ">R" & FormatNumber(OrdList.item(OrdCount).selectSingleNode("NELCC").text,2,0,0,-1) & "</td>")
														DisplaySet = Replace(DisplaySet,"@@Net" & OrdCount+1 & "Price","<td bgcolor=" & chr(34) & "red" & chr(34) &  "align=" & chr(34) & "right" & chr(34) & "valign=" & chr(34) & "middle" & chr(34) & "class=" & chr(34) & "tdcontentred" & chr(34) & ">R" & OrdList.item(OrdCount).selectSingleNode("NELC").text & "</td>")
													end if
												else
													' Replace the XSL variable @@Confirm
													DisplaySet = Replace(DisplaySet,"@@Confirm","")

													' Replace the td with blank
													DisplaySet = Replace(DisplaySet,"@@Net" & OrdCount+1 & "Price","")
												end if
											Next

											' Write the Transformation
											response.write DisplaySet
%>
<!--#include file="../../../layout/end.asp"-->
<%
										end if
%>