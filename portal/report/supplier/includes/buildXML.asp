<%
	Function BuildItemXML (DBConnection, SQLString)
		
		dim strXML
		dim strDCName
		dim strBuyerName
		dim strSupplierName
		
		strDCName = ""
		strBuyerName = ""
		strSupplierName = ""		
		
		Set ReturnSet = ExecuteSql(SQLString, DBConnection)  
 
		
		if ReturnSet("returnvalue") <> 0 then
			strXML = "<rootnode><smmessage><requesttype>ListBuyerSupplier</requesttype><returnvalue>-1004</returnvalue><errormessage>There are no repformance results for the selected month. Select another month from the dropdown box and try again.</errormessage></smmessage><rootnode>"
		else
			strXML = "<rootnode><smmessage><requesttype>ListBuyerSupplier</requesttype><returnvalue>0</returnvalue>"
			
			' Loop through the recordset
			While not ReturnSet.EOF
				if ReturnSet("DCName") <> strDCName then
					strDCName = ReturnSet("DCName")
					
					strXML = strXML & "<dc>"
					strXML = strXML & "<name>" & ReturnSet("DCName") & "</name>"
				end if
				
				if ReturnSet("BuyerName") & " " & ReturnSet("BuyerSurname") <> strBuyerName then
					strBuyerName = ReturnSet("BuyerName") & " " & ReturnSet("BuyerSurname")
					strXML = strXML & "<buyer>"
					strXML = strXML & "<name>" & ReturnSet("BuyerName") & "</name>"
					strXML = strXML & "<surname>" & ReturnSet("BuyerSurname") & "</surname>"
				end if
				
				if ReturnSet("SupplierName") <> strSupplierName then
					strSupplierName = ReturnSet("SupplierName")
					strXML = strXML & "<supplier>"
					strXML = strXML & "<name>" & ReturnSet("SupplierName") & "</name>"
				end if
		
				ReturnSet.MoveNext
			Wend
			strXML = strXML & "</smmessage></rootnode>"
		end if
		
		BuildItemXML = strXML
		
	End Function

%>
