<%
	' ERA - Electronic Remittance Advices
	Function MakeERALinkXML(DBConnection, SQL)
	    ' Author & Date: Petrus Daffue, 22 September 2008
	    ' Purpose: This function will build the ERA doc XML
	    Dim ReturnSet
	    Dim MyString
	    
	    MyString = "<?xml version=" & Chr(34) & "1.0" & Chr(34) & "?>"
		MyString = MyString & "<rootnode>"
		MyString = MyString & "<smmessage>"
	    
	    Set ReturnSet = ExecuteSql(SQL, DBConnection)

	    If ReturnSet("returnvalue") <> 0 Then
	        ' Error occured, build the error message
	        MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
	        MyString = MyString & "<errormessage>" & ReturnSet("errormessage") & "</errormessage>"
	    Else
	        Dim DCName, SupplierName
	        Dim HasDC, HasSupplier
	        DCName = ""
	        SupplierName = ""
	        HasDC = False
	        HasSupplier = False
	        
	        While NOT ReturnSet.EOF 
	            If DCName <> ReturnSet("DCName") Then
	                DCName = ReturnSet("DCName")
                    If HasDC Then
                        MyString = MyString & "</supplier>"
                        MyString = MyString & "</DC>"
                        HasSupplier = False
                        SupplierName = ""
                    End If
                    
                    HasDC = True
                    MyString = MyString & "<DC>"
	                MyString = MyString & "<name>" & DCName & "</name>"
                End If    	            
    	            
    	            
    	       If SupplierName <> ReturnSet("SupplierName") Then
    	            SupplierName = ReturnSet("SupplierName")
    	            If HasSupplier Then
    	                MyString = MyString & "</supplier>"
    	            End If
    	       
    	            HasSupplier = True   
                    MyString = MyString & "<supplier><name>" & SupplierName & "</name>"
     	       End If
     	       
     	       
     	       
				MyString = MyString & "<file>"
				MyString = MyString & "<viewfile>viewERA.asp?postData=" & ReturnSet("Id") & "</viewfile>"
				MyString = MyString & "<viewed>" & ReturnSet("LastViewedDate") & "</viewed>"
				'MyString = MyString & "<path>" & const_app_ApplicationRoot & "/Includes/downloadfile.asp?ref=" &  ReturnSet("LocationOfFile") &  ReturnSet("FileName") & "</path>"
				MyString = MyString & "<RADate>" & ReturnSet("RADate") & "</RADate>"
				MyString = MyString & "<PaymentNumber>" & ReturnSet("PaymentNumber") & "</PaymentNumber>"
                        MyString = MyString & "<downloadXML>viewDownload.asp?rid=" & ReturnSet("Id") & "</downloadXML>"
                        MyString = MyString & "<reportId>" & Mid(ReturnSet("Id"),2,Len(ReturnSet("Id"))-2) & "</reportId>"
                        MyString = MyString & "<viewPrintReportOptions>viewPrintReportOptions.asp?rid=" & ReturnSet("Id") & "|StoreType=" & ReturnSet("RAType") & "</viewPrintReportOptions>"
				MyString = MyString & "<DateRecievedByGateWay>" & ReturnSet("CreatedAt") & "</DateRecievedByGateWay>"
				MyString = MyString & "</file>"
				
				

                ReturnSet.MoveNext
            Wend            

            MyString = MyString & "</supplier>"
            MyString = MyString & "</DC>"
	    End If
	    
	    ' Close the connection and recordset
		Set ReturnSet = Nothing
		
		MyString = MyString & "</smmessage>"
		MyString = MyString & "</rootnode>"
		'Response.Write(MyString)
	    'Response.End 
		

				
		MakeERALinkXML = MyString
	End Function
%>