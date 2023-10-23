<%
Function XMLRequest(requestString, requestDropDown, XSLRef ,DoTransform)
	dim curConnection		' ADODB Connection Object
 
	dim XMLDoc
	dim XSLDoc

	Dim rsObj, XmlString
	Dim HeaderName
	Dim ColumnHeaders
	Dim HeaderNameArray
	Dim OldHeaderName
	Dim NewHeaderName
	Dim DoOpenTag, DoCloseTag, SmMessageIsDone
	Dim ElementValue
	 
	XmlString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
	XmlString = XmlString & "<rootnode>"
 
	'RequestString = "exec itemClaim_pw @ClaimID=8167753, @IsXML=1"
	Set curConnection = Server.CreateObject("ADODB.Connection")
	curConnection.ConnectionString = const_db_ConnectionString
	curConnection.Open
	Set rsObj = curConnection.Execute(RequestString)
	If Not (rsObj.BOF And rsObj.EOF) Then
		rsObj.MoveFirst
		OldHeaderName = ""
		DoOpenTag = True
		DoCloseTag = False
		SmMessageIsDone = False
		While Not rsObj.EOF
			For ColumnHeaders = 0 To rsObj.Fields.Count - 1
				HeaderName = rsObj(ColumnHeaders).Name
				HeaderNameArray = Split(HeaderName,"!")
				NewHeaderName = HeaderNameArray(0)
				
				If (HeaderName <> "Tag" And HeaderName <> "Parent" And NewHeaderName <> "smmessage") Or (NewHeaderName = "smmessage" And SmMessageIsDone = False)  Then
					If NewHeaderName <> "smmessage"  And SmMessageIsDone = False Then
						DoCloseTag = False
					Else
						If NewHeaderName <> OldHeaderName Or DoOpenTag Then
							XmlString = XmlString & "<" & NewHeaderName & ">"
							DoOpenTag = False
							DoCloseTag = True
						End If
						
						ElementValue = rsObj(ColumnHeaders)
						If Not IsNull(ElementValue) And Not IsNumeric(ElementValue) Then
							ElementValue = Server.HtmlEncode(ElementValue)
						End If
						
						If IsNumeric(ElementValue) Then
							ElementValue = Replace(ElementValue,",",".")
						End If
						
						If UBound(HeaderNameArray) > 1 Then
							XmlString = XmlString & "<" & HeaderNameArray(2) & ">" & ElementValue  & "</" & HeaderNameArray(2) & ">"
						Else
							XmlString = XmlString & "<" & HeaderName & ">" & ElementValue   & "</" & HeaderName & ">" 
						End If
					End If
					 
					OldHeaderName = NewHeaderName
				End If
			Next 
			
			SmMessageIsDone = True
			If DoCloseTag Then XmlString = XmlString & "</" & OldHeaderName & ">"
			DoOpenTag = True
		
			rsObj.MoveNext
		Wend 
	End If
	curConnection.Close
	
	XmlString = XmlString & "</smmessage>"
 	XmlString = XmlString & "</rootnode>"
	
	' Response.Write XmlString
'Response.End 
	' Determine if the user requested that the xml should be transformed
 
	if DoTransform Then
		' Transform the XML
		' Load the String into an XML Dom
		Set XMLDoc = Server.CreateObject(const_app_XMLObject)
		XMLDoc.async = false
		XMLDoc.LoadXML(XmlString)

		' Load the XSL Style Sheet
		Set XSLDoc = Server.CreateObject(const_app_XMLObject)
		XSLDoc.async = false
		XSLDoc.Load(XSLRef)

		' Transform the xml doc with the xsl doc and return 
		XMLRequest = XMLDoc.TransformNode(XSLDoc)
	else
		' Return the xml string
		XMLRequest = XmlString
	end if
	
End Function
%>	
