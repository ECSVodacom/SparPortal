<%
	function MakeSelectedItem (SelectedID)
		' Author & Date: Chris Kennedy, 17 July 2002
		' Purpose: This function will generate the the option strings and set the selected option value
		
		dim strList
		
		' Generate the select lists
		strList = "<td align=" & chr(34) & "center" & chr(34) & "><select id=" & chr(34) & "sortlst" & chr(34) & " name=" & chr(34) & "sortlst" & chr(34) & " onchange=" & chr(34) & "document.FormFilter.hidFilter.value=document.FormFilter.sortlst[document.FormFilter.sortlst.selectedIndex].value; document.FormFilter.submit();" & chr(34) & ">" & VbCrLf
		strList = strList & BuildOption ("-1", "-- Choose an Option --", SelectedID)
		strList = strList & BuildOption ("0", "Show All Items", SelectedID)
		strList = strList & BuildOption ("1", "Show All Items with Exceptions", SelectedID)
		strList = strList & BuildOption ("2", "Show Only Items with Quantity Exceptions", SelectedID)
		strList = strList & BuildOption ("3", "Show Only Items with Price Exceptions", SelectedID)
		strList = strList & BuildOption ("4", "Show Only Items with Supplier Comments", SelectedID)
		strList = strList & "</select></td>" & VbCrLf
              
		'strList = strList & "<select id=" & chr(34) & "convertlst" & chr(34) & " name=" & chr(34) & "convertlst" & chr(34) & " onchange=" & chr(34) & "document.FormFilter.hidFilter.value=document.FormFilter.convertlst[document.FormFilter.convertlst.selectedIndex].value; document.FormFilter.submit();" & chr(34) & ">" & VbCrLf		               
		'strList = strList & "<td align=" & chr(34) & "center" & chr(34) & "><select id=" & chr(34) & "convertlst" & chr(34) & " name=" & chr(34) & "convertlst" & chr(34) & ">" & VbCrLf		               
		'strList = strList & BuildOption ("-1", "-- Choose an Option --", SelectedID)
		'strList = strList & BuildOption ("5", "Supplier Confirms in Vendor Packs", SelectedID)
		'strList = strList & BuildOption ("6", "Supplier Confirms in Store Packs", SelectedID)
		'strList = strList & "</select></td>" & VbCrLf
      
      strList = strList & "<td align=" & chr(34) & "center" & chr(34) & "><select id=" & chr(34) & "origlst" & chr(34) & " name=" & chr(34) & "origlst" & chr(34) & " onchange=" & chr(34) & "document.FormFilter.hidFilter.value=document.FormFilter.origlst[document.FormFilter.origlst.selectedIndex].value; document.FormFilter.submit();" & chr(34) & ">" & VbCrLf		               
      strList = strList & BuildOption ("-1", "-- Choose an Option --", SelectedID)
		strList = strList & BuildOption ("7", "Show Confirmed, Unconfirmed and New Items", SelectedID)
		strList = strList & BuildOption ("8", "Show Confirmed Items Only", SelectedID)
		strList = strList & BuildOption ("9", "Show Unconfirmed Items Only", SelectedID)
		strList = strList & BuildOption ("10", "Show New Items Only", SelectedID)
		strList = strList & "</select></td>" & VbCrLf
		
		' Return the string
		MakeSelectedItem = strList
		
	end function
	
	function BuildOption (ID, Value, CheckID)
		' Check if the we need to set the selected option
		if ID = CheckID Then
			' Set the selected option value
			BuildOption = "<option selected value=" & chr(34) & ID & chr(34) & ">" & Value & "</option>" & VbCrLf
		else
			' Set the selected option value to blank
			BuildOption = "<option value=" & chr(34) & ID & chr(34) & ">" & Value & "</option>" & VbCrLf
		end if
		
	end function
%>