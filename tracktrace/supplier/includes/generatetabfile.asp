<%
	function CreateTabFile (SupplierCode, DownloadDate)
		' This function will generate a tab delimeted file for the supplier to download to his local drive.
		
		dim StrTab
		dim StrFileName
		dim oFile
		dim OpenFile
		dim ErrorFlag

		' Create a connection
		Set curConnection = Server.CreateObject("ADODB.Connection")
		curConnection.ConnectionTimeout = 36000
		Server.ScriptTimeOut = 36000
		curConnection.Open const_db_ConnectionString
		'REsponse.Write SupplierCode & " ||" & DownloadDate
		'response.end
		'response.Write "exec procOrderTab @SupplierCode = '" & SupplierCode & "',@DownloadDate='" & DownloadDate & "'"
		'response.end
		'' Execute the SQL
		Set ReturnSet = 	ExecuteSql("procOrderTab @SupplierCode = '" & SupplierCode & "',@DownloadDate='" & DownloadDate & "'", curConnection)  
		'Response.Write "exec procOrderTab @SupplierCode = '" & SupplierCode & "',@DownloadDate='" & DownloadDate & "'"
		' Check the returnvalue
		if Returnset("returnvalue") <> 0 Then
			' There are no orders for the selcted supplier and current day
			ErrorFlag = 1
			StrFileName = ""
		else
			' There are records returned
			' Create the File System Object
			Set oFile = Server.CreateObject("Scripting.FileSystemObject")
			
			StrFileName = SupplierCode & Replace(FormatDateTime(DownloadDate,2),"/","") & ".rpt"
			
			'Response.Write "exec procOrderTab @SupplierCode = '" & SupplierCode & "',@DownloadDate='" & DownloadDate & "'"
			'Response.Write const_app_XMLDownloadTabPath
			'Response.End
			' Create the file
			oFile.CreateTextFile const_app_XMLDownloadTabPath & StrFileName,true
		
			' Open the text file
			Set OpenFile = oFile.OpenTextFile(const_app_XMLDownloadTabPath & StrFileName, 8,false)
			
			StrTab =  "PRODUCT DESCRIPTION" & chr(09) & chr(09) & "STORENAME" & chr(09) & chr(09) & "PRODUCT CODE / ITEM CODE" & chr(09) & "ORDERNO" & chr(09) & "DELIVERY DATE" & chr(09) & "QUANTITY" & chr(09) & "UNIT COST" & chr(09) & "LINE COST" & VbCrLf
			
			' Loop through the recordset
			While not ReturnSet.EOF
				' Check if the file 
				StrTab = StrTab & ReturnSet("ProdDescr") & chr(09) & chr(09) & ReturnSet("StoreName") & chr(09) & chr(09) & ReturnSet("ProdCode") & chr(09) & _
					ReturnSet("OrderNumber") & chr(09) & ReturnSet("DeliveryDate") & chr(09) & ReturnSet("ProdQty") & chr(09) & _
					ReturnSet("UnitCost") & chr(09) & ReturnSet("LineCost") & VbCrLf
					
				ReturnSet.MoveNext
			Wend
			
			' Write to the file
			OpenFile.Write(StrTab)	
		
			ErrorFlag = 0
		
			' Close the Objects
			Set OpenFile = Nothing
			Set oFile = Nothing
			Set ReturnSet = Nothing
		end if
		
		' close the connection
		curConnection.Close
		Set curConnection = Nothing
		
		' Return the indicator
		CreateTabFile = StrFileName
		
	end function
%>