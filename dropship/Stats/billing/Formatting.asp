<%
	function getDisplay (MsgType)
		' Author & date: Francois Robb, 28 June 2006
		' Purpose: This function will convert a type as string to a valid type Description
		
		if MsgType = "stat" Then
			getDisplay = "Spar Web Reports"
		end if
		if MsgType = "bill" Then
			getDisplay = "Spar Web Reports"
		end if
	end function
	
	function getNameDisplay (ID)
		' Author & date: Francois Robb, 11 July 2006
		' Purpose: This function will convert a ID as string to a valid Description
		
		if ID = "ds" Then
			getNameDisplay = "SPAR Drop Shipment"
		end if
		if ID = "dc" Then
			getNameDisplay = "SPAR Distribution Centre"
		end if
	end function
	
	function addWithSpace (Text, Length)
		' Author & date: Francois Robb, 11 July 2006
		' Purpose: This function will add a number of spaces to a string
		dim c
		dim tot
		tot = Length - len(Text)
		dim tmp
		tmp = Text
		for c = 1 to tot
			tmp = tmp & "&nbsp;"			
		next
		addWithSpace = tmp
	end function
	
	function getFromDate (Month, FromMonth, FromDate, Year)
		if Datepart("yyyy",FromDate) < Year Then
			getFromDate = Year & "/" & right("00" & Month,2) & "/01"
		else
			If month = FromMonth Then
				getFromDate = FromDate
			Else
				getFromDate = Year & "/" & right("00" & Month,2) & "/01"
			End IF
		end if
	end function
	
	function MakeToDate (Month, Year, ToDate)
		Dim tmpDate
		Month = "00" & Month
		tmpDate = Year & "/" & right(Month,2) & "/01"
		Dim sNextMonth
		'response.Write(tmpdate & " ")
		'response.Write(todate & " ")
		'response.End 
		sNextMonth = DateAdd("m", 1, tmpDate)
		sNextMonth = sNextMonth - DatePart("d", sNextMonth)
		Dim saveDate
		
		'Response.Write(Datepart("m",ToDate,sNextMonth))
		'Response.End 
		
		IF DateDiff("d",ToDate,sNextMonth) > 0 Then
			saveDate = ToDate
		else
			saveDate = datepart("yyyy",sNextMonth) & "/" & right("00" & datepart("m",sNextMonth),2) & "/" & right("00" & datepart("d",sNextMonth),2)
		End IF
		
		'response.Write(saveDate)
		'response.End 
		'response.Write(sNextMonth - DatePart("d", sNextMonth))
		'response.End 
		'MakeToDate = "20" & sNextMonth - DatePart("d", sNextMonth)
		MakeToDate = savedate
	end function
	
	Function DoReport (DBConnection, SQL)
		dim ReturnSet
		dim MyString
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		dim DC
		Dim ReportOn
		Dim Supplier, Store, FromDate, ToDate
				
		MyString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
		MyString = MyString & "<rootnode>"
		MyString = MyString & "<spmessage>"
				
		' Execute the SQL
		On Error resume next
		Set ReturnSet = DBConnection.Execute (SQL)
		'Response.write("end")
		'Response.End 
		
		If Err.number <> 0 Then
			%>
				<script language="javascript">
					<!--
						window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
						top.location.href = "<%=const_app_ApplicationRoot%>";
				//-->
				</script>
			<%
		else
		
		MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
		' Check if there are any errors
		if ReturnSet("returnvalue") <> 0 then
			' An error occured - Build the error message
			MyString = MyString & "<errormessage>" & ReturnSet("errormessage") & "</errormessage>"
		else
		
		ReportOn = ReturnSet("ReportOn")
		Supplier = ReturnSet("Supplier")
		Store = ReturnSet("Store")
		FromDate = ReturnSet("FromDate")
		ToDate = ReturnSet("ToDate")
		
		MyString = MyString & "<drildown>ok</drildown>"
		MyString = MyString & "<drildown2>ok</drildown2>"
		
		Dim URL
		SQL = Replace(SQL,"listWebReport","listWebReport_XML")
		URL = "download.asp?Type=1&SQL=" & SQL
		'Response.Write("This URL written" & URL)
		'Response.End 
		'If Request.QueryString("Download") = "False" Then
%>
			<p class="pcontent">To Download these stats in XML click below<br/><a href="<%=URL%>" >Click here.</a></p>
<%
			MyString = MyString & "<Main><HeadingRow>"
			MyString = MyString & "<Header><Header_Value>Month</Header_Value></Header>"
			if ReturnSet("TotDC") = "-1" Then
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC1") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC2") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC3") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC4") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC5") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC8") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC9") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC12") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>" & ReturnSet("DC13") & "</Header_Value><Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>TOTALS</Header_Value><Multi>Yes</Multi></Header>"
			Else
				MyString = MyString & "<Header>"
				SELECT CASE (ReturnSet("TotDC"))
					CASE 1
						MyString = MyString & "<Header_Value>" & ReturnSet("DC1") & "</Header_Value>"
					CASE 2
						MyString = MyString & "<Header_Value>" & ReturnSet("DC2") & "</Header_Value>"
					CASE 3
						MyString = MyString & "<Header_Value>" & ReturnSet("DC3") & "</Header_Value>"
					CASE 4
						MyString = MyString & "<Header_Value>" & ReturnSet("DC4") & "</Header_Value>"
					CASE 5
						MyString = MyString & "<Header_Value>" & ReturnSet("DC5") & "</Header_Value>"
					CASE 8
						MyString = MyString & "<Header_Value>" & ReturnSet("DC8") & "</Header_Value>"
					CASE 9
						MyString = MyString & "<Header_Value>" & ReturnSet("DC9") & "</Header_Value>"
					CASE 12
						MyString = MyString & "<Header_Value>" & ReturnSet("DC12") & "</Header_Value>"
					CASE 13
						MyString = MyString & "<Header_Value>" & ReturnSet("DC13") & "</Header_Value>"
				END SELECT
				MyString = MyString & "<Multi>Yes</Multi></Header>"
				MyString = MyString & "<Header><Header_Value>TOTALS</Header_Value></Header>"
			End IF
			'MyString = MyString & "<Header><Header_Value>Pricing</Header_Value></Header>"
			MyString = MyString & "</HeadingRow>"	
			'Response.Write("While")
			'Response.End 
			Dim Totals(14)
			Totals(0) = "DC Total"
			Totals(1) = 0
			Totals(2) = 0
			Totals(3) = 0
			Totals(4) = 0
			Totals(5) = 0
			Totals(6) = 0
			Totals(7) = 0
			Totals(8) = 0
			Totals(9) = 0
			Totals(10) = 0
			Totals(11) = 0
			Totals(12) = 0
			Totals(13) = 0
			' The UBound will be used for totalling
			Dim ManyDC
			ManyDC = ReturnSet("TotDC")
			Dim count
			Dim ID
			ID = ""
			Dim ToMonth, useValue
			toMonth = ReturnSet("ToMonth")
			Dim toYear
			toYear = ReturnSet("ToYear")
			
			if int(toYear) < int(Datepart("yyyy",date())) Then
				toYear = Datepart("yyyy",date())
			end if
			
			'response.Write(toYear)
			
			Dim a
			a = toYear - ReturnSet("FromYear")
			dim c
			for c = 1 to a
				toMonth = toMonth + 12
			next
			
			'response.Write(toMonth)
			'response.End 
			Dim OldYear
			'response.Write(ReturnSet("FromMonth"))
			useValue = ReturnSet("FromMonth")
			OldYear = ReturnSet("FromYear")
			For count = ReturnSet("FromMonth") to toMonth
								
				on error resume next
								
				If useValue > 12 Then
					useValue = useValue - 12
					OldYear = OldYear + 1
				end if
				'Response.Write(useValue)
				
				if ReturnSet.EOF Then
					EXIT FOR
				end if
							
				MyString = MyString & "<DetailRow>"
				MyString = MyString & "<Detail><Detail_Value>" & MonthName(useValue) & " " & OldYear & "</Detail_Value></Detail>"
				'Response.Write(ManyDC)
				'Response.End 
				
				If ManyDC = -1 Then
					Dim runner
					Dim total
					total = 0
					Dim disp
					dim temp
					temp = ""
					
					For runner = 1 to 13
						If Runner <> 6 And Runner <> 7 And Runner <> 10 And Runner <> 11 Then
							MyString = MyString & "<Detail>"
							'Response.Write("Month " & ReturnSet("MonthID") & "<br/>")
							'Response.Write("count " & count & "<br/>")
							'Response.Write("DC " & ReturnSet("DC") & "<br/>")
							'Response.Write("Runner " & runner & "<br/><br/>")
							
							If (ReturnSet("MonthID") = useValue) and (ReturnSet("DC") = runner) Then
								MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
								disp = getDisplay (ReturnSet("ReportType")) & " on " & ReturnSet("DCName") & " for the month of " & MonthName(useValue)
								MyString = MyString & "<Detail_URL>" & ReturnSet("DC") & "??Supplier=" & ReturnSet("Supplier") & "??ReportType=" & ReturnSet("ReportType") & "??ReportOn=" & ReturnSet("ReportOn") & "??Month=" & ReturnSet("MonthID") & "??Year=" & ReturnSet("YearValue") & "??Store=" & ReturnSet("Store") & "??FromDate=" & ReturnSet("FromDate") & "??ToDate=" & ReturnSet("ToDate") & "??FromMonth=" & ReturnSet("FromMonth") & "??Display=" & disp & "</Detail_URL>"
								
								total = total + ReturnSet("Val")
								Totals(runner) = Totals(runner) + ReturnSet("Val")
								'Response.Write("D:" & runner & ":" & Totals(runner)) & vbCrLf
								
								Totals(UBound(Totals)) = Totals(UBound(Totals)) + ReturnSet("Val")
								
								if err.number = 0 Then
									if ReportOn <> 16 Then
										MyString = MyString & "</Detail><Detail><Detail_Value>Detail</Detail_Value>"
										MyString = MyString & "<URL>" & ReturnSet("DC") & "??Supplier=" & ReturnSet("Supplier") & "??ReportType=" & ReturnSet("ReportType") & "??ReportOn=" & ReturnSet("ReportOn") & "??Month=" & ReturnSet("MonthID") & "??Year=" & ReturnSet("YearValue") & "??Store=" & ReturnSet("Store") & "??FromDate=" & ReturnSet("FromDate") & "??ToDate=" & ReturnSet("ToDate") & "??FromMonth=" & ReturnSet("FromMonth") & "??Display=" & disp & "</URL>"
										Temp = "-1??Supplier=" & ReturnSet("Supplier") & "??ReportType=" & ReturnSet("ReportType") & "??ReportOn=" & ReturnSet("ReportOn") & "??Month=" & ReturnSet("MonthID") & "??Year=" & ReturnSet("YearValue") & "??Store=" & ReturnSet("Store") & "??FromDate=" & ReturnSet("FromDate") & "??ToDate=" & ReturnSet("ToDate") & "??FromMonth=" & ReturnSet("FromMonth") & "??Display=" & getDisplay (ReturnSet("ReportType")) & " on All DCs for the month of " & MonthName(useValue)
									Else
										MyString = MyString & "<Multi>Yes</Multi>"
									End IF
								end if
						
								ReturnSet.MoveNext
							Else
								Dim DebugString
								DebugString =  ReturnSet("MonthID") & "|" & useValue & "|" & ReturnSet("DC") & "|" & runner 
								DebugString = ""
								MyString = MyString & "<Detail_Value>No Data" & DebugString & "</Detail_Value><Multi>Yes</Multi>"
							End IF
							
							if err.number <> 0 Then
								MyString = MyString & "<Detail_Value>No Data</Detail_Value><Multi>Yes</Multi>"
							end if
							MyString = MyString & "</Detail>"
						
						End if
					Next
					if total > 0 Then
						MyString = MyString & "<Detail><Special>yes</Special><Detail_Value>" & total & "</Detail_Value></Detail>"
						if ReportOn <> 16 Then
							MyString = MyString & "<Detail><Special>yes</Special><Detail_Value>Detail</Detail_Value><URL>" & temp & "</URL></Detail>"
						End IF
					else
						MyString = MyString & "<Detail><Special>yes</Special><Detail_Value>" & total & "</Detail_Value><Multi>Yes</Multi></Detail>"
					end if
				Else
					MyString = MyString & "<Detail>"
					if ReturnSet.EOF Then
						MyString = MyString & "<Detail_Value>No Data</Detail_Value><Multi>Yes</Multi>"
						MyString = MyString & "</Detail><Detail>"
						MyString = MyString & "<Special>yes</Special><Detail_Value>0</Detail_Value>"
					end if
					If ReturnSet("MonthID") = useValue Then
						MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
						disp = getDisplay (ReturnSet("ReportType")) & " on DC " & ReturnSet("DCName") & " for the month of " & MonthName(useValue)
						MyString = MyString & "<Detail_URL>" & ReturnSet("DC") & "??Supplier=" & ReturnSet("Supplier") & "??ReportType=" & ReturnSet("ReportType") & "??ReportOn=" & ReturnSet("ReportOn") & "??Month=" & ReturnSet("MonthID") & "??Year=" & ReturnSet("YearValue") & "??Store=" & ReturnSet("Store") & "??FromDate=" & ReturnSet("FromDate") & "??ToDate=" & ReturnSet("ToDate") & "??FromMonth=" & ReturnSet("FromMonth") & "??Display=" & disp & "</Detail_URL>"
						
						if err.number = 0 Then
							if ReportOn <> 16 Then
								MyString = MyString & "</Detail><Detail><Detail_Value>Detail</Detail_Value>"
								MyString = MyString & "<URL>" & ReturnSet("DC") & "??Supplier=" & ReturnSet("Supplier") & "??ReportType=" & ReturnSet("ReportType") & "??ReportOn=" & ReturnSet("ReportOn") & "??Month=" & ReturnSet("MonthID") & "??Year=" & ReturnSet("YearValue") & "??Store=" & ReturnSet("Store") & "??FromDate=" & ReturnSet("FromDate") & "??ToDate=" & ReturnSet("ToDate") & "??FromMonth=" & ReturnSet("FromMonth") & "??Display=" & disp & "</URL>"
							Else
								MyString = MyString & "<Multi>Yes</Multi>"
							End if
						end if
						
						MyString = MyString & "</Detail><Detail><Special>yes</Special>"
						MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
						'MyString = MyString & "</Detail><Detail><Special>yes</Special>"
						'MyString = MyString & "<Detail_Value>" & Pricing(ReturnSet("Val")) & "</Detail_Value>"
						Totals(1) = Totals(1) + ReturnSet("Val")
						Totals(2) = Totals(2) + ReturnSet("Val")
						ReturnSet.MoveNext
					Else
						MyString = MyString & "<Detail_Value>No Data</Detail_Value><Multi>Yes</Multi>"
						MyString = MyString & "</Detail><Detail>"
						MyString = MyString & "<Special>yes</Special><Detail_Value>0</Detail_Value>"
					End IF
					
					MyString = MyString & "</Detail>"
				End IF
				MyString = MyString & "</DetailRow>"
				useValue = useValue + 1
			Next
			'ReturnSet.MoveNext
			
			Dim end_For
			If ManyDC = "-1" Then
				end_For = UBound(Totals) 
			else
				end_For = 2
			end if
			MyString = MyString & "<FinalRow>"
			for count = 0 to end_For + 1
				'Response.Write(Totals(count) & "::" & count) & vbCrLf
				If (Count <> 6 And Count <> 7 And Count <> 10 And Count <> 11) Then
					if count <= end_For Then
						MyString = MyString & "<Final>"
						MyString = MyString & "<Final_Value>" & Totals(count) & "</Final_Value>"
						
						If count <> 0 Then
							If reportOn <> 16 and Totals(count) <> 0 Then
								If count = end_for and end_For = 2 Then
									
								Else
									MyString = MyString & "</Final><Final>"
									MyString = MyString & "<Final_Value>Detail</Final_Value>"
									Dim tmp
									If ManyDC = -1 Then
										tmp = count
										if count = end_for Then
											tmp = "-1"
										End If
									else
										tmp = ManyDC
									End IF
									MyString = MyString & "<URL>" & tmp & "??Total=yes??Supplier=" & Supplier & "??ReportType=Stat??ReportOn=" & ReportOn & "??Store=" & Store & "??FromDate=" & FromDate & "??ToDate=" & ToDate & "??Display=Spar Web Reports Totals</URL>"
								End IF
							Else
								MyString = MyString & "<Multi>Yes</Multi>"
							End IF
						End If
						MyString = MyString & "</Final>"
					Else
					'	MyString = MyString & "<Final>"
					'	MyString = MyString & "<Final_Value>~~</Final_Value>"
					'	MyString = MyString & "</Final>"
					End IF
				End If
			next
			MyString = MyString & "</FinalRow>"
			
			'Pricing
			'MyString = MyString & "<FinalRow>"
			'MyString = MyString & "<Final>"
			'MyString = MyString & "<Final_Value>Pricing Information</Final_Value>"
			'MyString = MyString & "</Final>"
			'for count = 1 to end_For
			'	if count < end_For Then
			'		MyString = MyString & "<Final>"
			'		MyString = MyString & "<Final_Value>" & Pricing(Totals(count)) & "</Final_Value>"
			'		MyString = MyString & "</Final>"
			'	Else
			'		MyString = MyString & "<Final>"
			'		MyString = MyString & "<Final_Value>~~</Final_Value>"
			'		MyString = MyString & "</Final>"
			'	End IF
			'next
			'MyString = MyString & "<Final>"
			'MyString = MyString & "<Special>yes</Special>"
			'MyString = MyString & "<Final_Value>" & Pricing(Totals(end_For)) & "</Final_Value>"
			'MyString = MyString & "</Final>"
			'MyString = MyString & "</FinalRow>"
		end if
		
		
		MyString = MyString & "</Main></spmessage>"
		MyString = MyString & "</rootnode>"
		
		'Response.Write (Mystring)
		'Response.End
		end if
		DoReport = MyString
	End Function
	
	Function Pricing (Value)
		Dim PriceVal
		PriceVal = 0
		If Value <= 49999 Then
			PriceVal = Value * 1.25
		Else
			If Value <= 99999 Then
				PriceVal = Value * 0.8
			Else
				If Value <= 149999 Then
					PriceVal = Value * 0.7
				Else
					PriceVal = Value * 0.65
				End If
			End If
		End IF
		Pricing = "R " & PriceVal
	End Function
	
	Function DoFirstDrillDown (DBConnection, SQL, Display)
		dim ReturnSet
		dim MyString
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		dim DC
		Dim disp
		
		Dim Recon
		Recon = False
						
		MyString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
		MyString = MyString & "<rootnode>"
		MyString = MyString & "<spmessage>"
				
		' Execute the SQL
		''Response.Write(SQL)
		Set ReturnSet = ExecuteSql(SQL, DBConnection) 
		'Response.write("end")
		'Response.End 
		
		MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
		' Check if there are any errors
		if ReturnSet("returnvalue") <> 0 then
			' An error occured - Build the error message
			MyString = MyString & "<errormessage>" & ReturnSet("errormessage") & "</errormessage>"
		else
			MyString = MyString & "<drildown>ok</drildown>"
			MyString = MyString & "<Main><HeadingRow>"
			if ReturnSet("ColumnID") = 5 Then
				MyString = MyString & "<Header><Header_Value>Suppliers</Header_Value></Header>"
			Else
				MyString = MyString & "<Header><Header_Value>Stores</Header_Value></Header>"
			End if
			
			if ReturnSet("ReportOn") = "-1" Then
				MyString = MyString & "<Header><Header_Value>Orders</Header_Value></Header>"
				MyString = MyString & "<Header><Header_Value>Invoices</Header_Value></Header>"
				MyString = MyString & "<Header><Header_Value>Claims</Header_Value></Header>"
				MyString = MyString & "<Header><Header_Value>Credit Notes</Header_Value></Header>"
			Else
				MyString = MyString & "<Header>"
				SELECT CASE (ReturnSet("ColumnID"))
					CASE 1
						MyString = MyString & "<Header_Value>Orders</Header_Value>"
					CASE 2
						MyString = MyString & "<Header_Value>Invoices</Header_Value>"
					CASE 3
						MyString = MyString & "<Header_Value>Claims</Header_Value>"
					CASE 4
						MyString = MyString & "<Header_Value>Credit Notes</Header_Value>"
					CASE 5
						MyString = MyString & "<Header_Value>Recon Reports</Header_Value>"
						Recon = true
				END SELECT
				MyString = MyString & "</Header>"
			End IF
			MyString = MyString & "<Header><Header_Value>Message Total</Header_Value></Header>"
			MyString = MyString & "</HeadingRow>"	
			'Response.Write("While")
			'Response.End 
			Dim Totals(6)
			Totals(0) = "Total"
			Totals(1) = 0
			Totals(2) = 0
			Totals(3) = 0
			Totals(4) = 0
			Totals(5) = 0
			Dim ReportOn
			ReportOn = ReturnSet("ReportOn")
			Dim count
			
			Dim end_For
			If ReportOn = "-1" Then
				end_For = 5
			else
				end_For = 2
			end if
			
'			response.Write(ReportOn)
'			Response.End
			
			While not ReturnSet.EOF
				Dim StoreID
				StoreID = ReturnSet("StoreID")
				MyString = MyString & "<DetailRow>"
				MyString = MyString & "<Detail><Detail_Value>" & ReturnSet("StoreName") & "</Detail_Value>"
				disp = Display & " on Store " & ReturnSet("StoreName")
				
				if not Recon Then
					MyString = MyString & "<Detail_URL>" & ReturnSet("DC") & "??Supplier=" & ReturnSet("Supplier") & "??ReportType=" & ReturnSet("ReportType") & "??ReportOn=" & ReturnSet("ReportOn") & "??Month=" & ReturnSet("MonthID") & "??Year=" & ReturnSet("YearValue") & "??Store=" & ReturnSet("StoreID") & "??FromDate=" & ReturnSet("FromDate") & "??ToDate=" & ReturnSet("ToDate") & "??FromMonth=" & ReturnSet("FromMonth") & "??Display=" & disp & "</Detail_URL>"
				End if
				MyString = MyString & "</Detail>"
				
				If ReportOn = "-1" Then
					Dim runner
					Dim total
					total = 0
					
					For runner = 1 to end_For - 1
						on error resume next
						MyString = MyString & "<Detail>"
						Dim a
						
						If (CInt(ReturnSet("ColumnID")) = runner) and (ReturnSet("StoreID") = StoreID) Then
							MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
							total = total + ReturnSet("Val")
							'Response.Write(total)
							Totals(runner) = Totals(runner) + ReturnSet("Val")
							Totals(end_For) = Totals(end_For) + ReturnSet("Val")
							ReturnSet.MoveNext
						Else
							MyString = MyString & "<Detail_Value>0</Detail_Value>"
						End IF
						if err.number <> 0 Then
							MyString = MyString & "<Detail_Value>0</Detail_Value>"
						end if
						MyString = MyString & "</Detail>"
					Next
					MyString = MyString & "<Detail><Special>yes</Special><Detail_Value>" & total & "</Detail_Value></Detail>"
				Else
					MyString = MyString & "<Detail>"
					MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
					MyString = MyString & "</Detail><Detail><Special>yes</Special>"
					MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
					Totals(1) = Totals(1) + ReturnSet("Val")
					Totals(2) = Totals(2) + ReturnSet("Val")
					'Response.Write(Totals(1) & " <br>")
					ReturnSet.MoveNext
					MyString = MyString & "</Detail>"
				End IF
				MyString = MyString & "</DetailRow>"
			WEnd
			
			MyString = MyString & "<FinalRow>"
			for count = 0 to end_For
				MyString = MyString & "<Final>"
				MyString = MyString & "<Final_Value>" & Totals(count) & "</Final_Value>"
				MyString = MyString & "</Final>"
			next
			MyString = MyString & "</FinalRow>"
		end if
		
		
		MyString = MyString & "</Main></spmessage>"
		MyString = MyString & "</rootnode>"
		
		'Response.Write (Mystring)
		
		DoFirstDrillDown = MyString
	End Function
	
	Function DoSecondDrillDown (DBConnection, SQL, Display)
		dim ReturnSet
		dim MyString
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		dim DC
		Dim disp
				
		MyString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
		MyString = MyString & "<rootnode>"
		MyString = MyString & "<spmessage>"
				
		' Execute the SQL
		''Response.Write(SQL)
		Set ReturnSet = ExecuteSql(SQL, DBConnection) 
		'Response.write("end")
		'Response.End 
		
		MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
		' Check if there are any errors
		if ReturnSet("returnvalue") <> 0 then
			' An error occured - Build the error message
			MyString = MyString & "<errormessage>" & ReturnSet("errormessage") & "</errormessage>"
		else
			MyString = MyString & "<drildown>ok</drildown>"
			MyString = MyString & "<Main><HeadingRow>"
			MyString = MyString & "<Header><Header_Value>Supplier</Header_Value></Header>"
			if ReturnSet("ReportOn") = "-1" Then
				MyString = MyString & "<Header><Header_Value>Orders</Header_Value></Header>"
				MyString = MyString & "<Header><Header_Value>Invoices</Header_Value></Header>"
				MyString = MyString & "<Header><Header_Value>Claims</Header_Value></Header>"
				MyString = MyString & "<Header><Header_Value>Credit Notes</Header_Value></Header>"
			Else
				MyString = MyString & "<Header>"
				SELECT CASE (ReturnSet("ColumnID"))
					CASE 1
						MyString = MyString & "<Header_Value>Orders</Header_Value>"
					CASE 2
						MyString = MyString & "<Header_Value>Invoices</Header_Value>"
					CASE 3
						MyString = MyString & "<Header_Value>Claims</Header_Value>"
					CASE 4
						MyString = MyString & "<Header_Value>Credit Notes</Header_Value>"
				END SELECT
				MyString = MyString & "</Header>"
			End IF
			MyString = MyString & "<Header><Header_Value>Supplier Total</Header_Value></Header>"
			MyString = MyString & "</HeadingRow>"	
			'Response.Write("While")
			'Response.End 
			Dim Totals(6)
			Totals(0) = "Message Total"
			Totals(1) = 0
			Totals(2) = 0
			Totals(3) = 0
			Totals(4) = 0
			Totals(5) = 0
			Dim ReportOn
			ReportOn = ReturnSet("ReportOn")
			Dim count
			
			Dim end_For
			If ReportOn = "-1" Then
				end_For = 5
			else
				end_For = 2
			end if
			
'			response.Write(ReportOn)
'			Response.End
			
			While not ReturnSet.EOF
				Dim SupplierID
				SupplierID = ReturnSet("SupplierID")
				MyString = MyString & "<DetailRow>"
				MyString = MyString & "<Detail><Detail_Value>" & ReturnSet("SupplierName") & "</Detail_Value></Detail>"
				If ReportOn = "-1" Then
					Dim runner
					Dim total
					total = 0
					
					For runner = 1 to end_For - 1
						on error resume next
						MyString = MyString & "<Detail>"
						Dim a
						Disp = Display & " for Supplier " & ReturnSet("SupplierName")
						If (CInt(ReturnSet("ColumnID")) = runner) and (ReturnSet("SupplierID") = SupplierID) Then
							MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
							If ReportOn = "-1" Then
								If ReturnSet("ColumnID") > 2 Then 'This is to assign credit notes and claims as its the 3rd and 4th column but in list its report on 8 an 9
									a = ReturnSet("ColumnID") + 5
								Else
									a = ReturnSet("ColumnID")
								End IF
							else
								a = ReturnSet("ReportOn")
							end If
							MyString = MyString & "<Detail_URL>" & ReturnSet("DC") & "??Supplier=" & ReturnSet("SupplierID") & "??ReportType=" & ReturnSet("ReportType") & "??ReportOn=" & a & "??Month=" & ReturnSet("MonthID") & "??Year=" & ReturnSet("YearValue") & "??Store=" & ReturnSet("StoreID") & "??FromDate=" & ReturnSet("FromDate") & "??ToDate=" & ReturnSet("ToDate") & "??FromMonth=" & ReturnSet("FromMonth") & "??Download=False??Display=" & disp & "</Detail_URL>"
							total = total + ReturnSet("Val")
							Totals(runner) = Totals(runner) + ReturnSet("Val")
							Totals(end_For) = Totals(end_For) + ReturnSet("Val")
							ReturnSet.MoveNext
						Else
							MyString = MyString & "<Detail_Value>0</Detail_Value>"
						End IF
						if err.number <> 0 Then
							MyString = MyString & "<Detail_Value>0</Detail_Value>"
						end if
						MyString = MyString & "</Detail>"
					Next
					MyString = MyString & "<Detail><Special>yes</Special><Detail_Value>" & total & "</Detail_Value></Detail>"
				Else
					MyString = MyString & "<Detail>"
					MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
					If CINT(ReturnSet("Val")) > 0 Then
						MyString = MyString & "<Detail_URL>" & ReturnSet("DC") & "??Supplier=" & ReturnSet("SupplierID") & "??ReportType=" & ReturnSet("ReportType") & "??ReportOn=" & ReturnSet("ReportOn") & "??Month=" & ReturnSet("MonthID") & "??Year=" & ReturnSet("YearValue") & "??Store=" & ReturnSet("StoreID") & "??FromDate=" & ReturnSet("FromDate") & "??ToDate=" & ReturnSet("ToDate") & "??FromMonth=" & ReturnSet("FromMonth") & "??Download=False??Display=" & disp & "</Detail_URL>"
					End IF
					MyString = MyString & "</Detail><Detail><Special>yes</Special>"
					MyString = MyString & "<Detail_Value>" & ReturnSet("Val") & "</Detail_Value>"
					Totals(1) = Totals(1) + ReturnSet("Val")
					Totals(2) = Totals(2) + ReturnSet("Val")
					ReturnSet.MoveNext
					MyString = MyString & "</Detail>"
				End IF
				MyString = MyString & "</DetailRow>"
'				ReturnSet.MoveNext
			WEnd
			
			MyString = MyString & "<FinalRow>"
			for count = 0 to end_For
				MyString = MyString & "<Final>"
				MyString = MyString & "<Final_Value>" & Totals(count) & "</Final_Value>"
				MyString = MyString & "</Final>"
			next
			MyString = MyString & "</FinalRow>"
		end if
		
		
		MyString = MyString & "</Main></spmessage>"
		MyString = MyString & "</rootnode>"
		
		'Response.Write (Mystring)
		'Response.End 
		
		DoSecondDrillDown = MyString
	End Function
	
	Function HeaderString (Value)
		Dim MyString
		MyString = ""
		
		MyString = MyString & "<Main><HeadingRow>"
		MyString = MyString & "<Header><Header_Value>DC Name</Header_Value></Header>"
		MyString = MyString & "<Header><Header_Value>Supplier Name</Header_Value></Header>"
		MyString = MyString & "<Header><Header_Value>Store Name</Header_Value></Header>"
		MyString = MyString & "<Header>"
		'SELECT CASE (ReturnSet("ReportON"))
		'	CASE 1
		'		MyString = MyString & "<Header_Value>Order Number</Header_Value>"
		'	CASE 2
		'		MyString = MyString & "<Header_Value>Invoice Number</Header_Value>"
		'	CASE 3
		'		MyString = MyString & "<Header_Value>Claim Number</Header_Value>"
		'	CASE 4
		'		MyString = MyString & "<Header_Value>Credit Note Number</Header_Value>"
		'END SELECT
		MyString = MyString & "<Header_Value>" & Value & "</Header_Value>"
					
		MyString = MyString & "</Header>"
		MyString = MyString & "<Header><Header_Value>Received</Header_Value></Header>"
		MyString = MyString & "</HeadingRow>"
		HeaderString = MyString
	End Function
	
	Function DoThirdDrillDown (DBConnection, SQL, Display)
		dim ReturnSet
		dim MyString
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		dim DC, Supplier, Store, header
		Dim disp
		
		DC = ""
		Supplier = ""
		Store = ""
		header = ""
				
		MyString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
		MyString = MyString & "<rootnode>"
		MyString = MyString & "<spmessage>"
				
		' Execute the SQL
		'Response.Write(SQL)
		'Response.End 
		Set ReturnSet = ExecuteSql(SQL, DBConnection) 
		'Response.write("end")
		'Response.End 
		
		MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
		' Check if there are any errors
		if CInt(ReturnSet("returnvalue")) <> 0 then
			' An error occured - Build the error message
			MyString = MyString & "<errormessage>" & ReturnSet("errormessage") & "</errormessage>"
		else
			'Response.Write("Cool")
			'Response.End 
			MyString = MyString & HeaderString(ReturnSet("Header"))	
			Header = ReturnSet("Header")
						
			While not ReturnSet.EOF
			
				If Header <> ReturnSet("Header") Then
					MyString = MyString & "</Main>" & HeaderString(ReturnSet("Header"))	
					Header = ReturnSet("Header")
					DC = ""
					Supplier = ""
					Store = ""
				End IF
			
				MyString = MyString & "<DetailRow>"
				If ReturnSet("DCcName") <> DC Then
					MyString = MyString & "<Detail><Detail_Value>" & ReturnSet("DCcName") & "</Detail_Value><Special>yes</Special></Detail>"
					DC = ReturnSet("DCcName")
				Else
					'MyString = MyString & "<Detail><Detail_Value>-</Detail_Value></Detail>"
					MyString = MyString & "<Detail><Detail_Value>" & ReturnSet("DCcName") & "</Detail_Value></Detail>"
				End IF
				
				If ReturnSet("SPcName") <> Supplier Then
					MyString = MyString & "<Detail><Detail_Value>" & ReturnSet("SPcName") & "</Detail_Value><Special>yes</Special></Detail>"
					Supplier = ReturnSet("SPcName")
				Else
					'MyString = MyString & "<Detail><Detail_Value>-</Detail_Value></Detail>"
					MyString = MyString & "<Detail><Detail_Value>" & ReturnSet("SPcName") & "</Detail_Value></Detail>"
				End IF
				
				If ReturnSet("STcName") <> Store Then
					MyString = MyString & "<Detail><Detail_Value>" & ReturnSet("STcName") & "</Detail_Value><Special>yes</Special></Detail>"
					Store = ReturnSet("STcName")
				Else
					'MyString = MyString & "<Detail><Detail_Value>-</Detail_Value></Detail>"
					MyString = MyString & "<Detail><Detail_Value>" & ReturnSet("STcName") & "</Detail_Value></Detail>"
				End IF
				
				MyString = MyString & "<Detail>"
				
				Dim tmpVal, pos
				pos = instr(ReturnSet("Val"),".")
				if pos = 0 then
					tmpVal = ReturnSet("Val")
				else
					tmpVal = mid(ReturnSet("Val"),pos + 1) & "/" & mid(ReturnSet("Val"),1,pos - 1)
				end if	
				MyString = MyString & "<Detail_Value>" & tmpVal & "</Detail_Value>"
				MyString = MyString & "</Detail>"
				MyString = MyString & "<Detail>"
				MyString = MyString & "<Detail_Value>" & ReturnSet("Dtm") & "</Detail_Value>"
				MyString = MyString & "</Detail>"
				MyString = MyString & "</DetailRow>"
				on error resume next
				ReturnSet.Movenext
			WEnd
			
		end if
		
		
		MyString = MyString & "</Main></spmessage>"
		MyString = MyString & "</rootnode>"
		
		'Response.Write (Mystring)
		'Response.End 
		
		DoThirdDrillDown = MyString
	End Function
	
	Function XML_Detail_Download (DBConnection, SQL)
		dim ReturnSet
		dim MyString
		Dim DC, Supplier, Store
		Dim DoSupplier, DoStore, DoDC
		
		DC = ""
		Supplier = ""
		Store = ""
		
		DoSupplier = False
		DoStore = False
		DoDC = false
		
		MyString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
		Server.ScriptTimeout = 0
		DBConnection.Close
		DBConnection.ConnectionTimeout = 0
		DBConnection.CommandTimeout = 0
		DBConnection.Open
		Set ReturnSet = ExecuteSql(SQL, DBConnection) 
		
		
		MyString = MyString & "<Report>"
		While Not ReturnSet.Eof
			If ReturnSet("DCcName") <> DC Then
				if DoStore Then
					MyString = MyString & "</Store>"
					DoStore = False
					Store = ""
				End IF
				if DoSupplier Then
					MyString = MyString & "</Supplier>"
					DoSupplier = False
					Supplier = ""
				End IF
				if DoDC Then
					MyString = MyString & "</DC>"
					DoDC = false
					DC = ""
				End IF
				MyString = MyString & "<DC Name=""" & ReturnSet("DCcName") & """ EAN=""" & ReturnSet("DCcEANNumber") &  """ >"
				DC = ReturnSet("DCcName")
				DoDC = true
			End If
			
			If ReturnSet("SPcName") <> Supplier Then
				if DoStore Then
					MyString = MyString & "</Store>"
					DoStore = False
					Store = ""
				End IF
				if DoSupplier Then
					MyString = MyString & "</Supplier>"
					DoSupplier = False
					Supplier = ""
				End IF
				MyString = MyString & "<Supplier Name=""" & ReturnSet("SPcName") & """ EAN=""" & ReturnSet("SPcEANNumber") &  """ >"
				Supplier = ReturnSet("SPcName")
				DoSupplier = true
			End If
			
			If ReturnSet("STcName") <> Store Then
				if DoStore Then
					MyString = MyString & "</Store>"
					DoStore = False
					Store = ""
				End IF
				MyString = MyString & "<Store Name=""" & ReturnSet("STcName") & """ EAN=""" & ReturnSet("STcEANNumber") &  """ >"
				Store = ReturnSet("STcName")
				DoStore = true
			End If
			
			MyString = MyString & "<" & ReturnSet("Type") & " Number=""" & ReturnSet("Val") & """ TotalAmountInclusive=""" & ReturnSet("TotalAmountInclusive") & """ Date=""" & ReturnSet("DTM") & """  />"
			
			Returnset.MoveNext
		WEnd
		MyString = MyString & "</Store>"
		MyString = MyString & "</Supplier>"
		MyString = MyString & "</DC>"
		MyString = MyString & "</Report>"
		
		'Response.Write(MyString)
		'Response.End 
		
		XML_Detail_Download = MyString
	End Function
	
	Function Flat_Download (DBConnection, SQL)
		dim ReturnSet
		dim MyString
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		DBConnection.Close
		MyString = "DC EAN, DC Name, Supplier EAN, Supplier Name, Store EAN, Store Name, Message Type, Document Nr, Total Amount Inclusive, Date" & VBCRLF
		Server.ScriptTimeout = 0
		DBConnection.ConnectionTimeout = 0
		DBConnection.CommandTimeout = 0
		DBConnection.Open
		Set ReturnSet = ExecuteSql(SQL, DBConnection) 
		
		While Not ReturnSet.Eof
			MyString = MyString & ReturnSet("DCcEANNumber") & "," & ReturnSet("DCcName") & "," & ReturnSet("SPcEANNumber") & "," & ReturnSet("SPcName") & "," & ReturnSet("STcEANNumber") & "," _
				& ReturnSet("STcName") & "," & ReturnSet("Header") & "," & ReturnSet("Val") & "," & ReturnSet("TotalAmountInclusive") & "," & ReturnSet("DTM") & VBCRLF
			Returnset.MoveNext
		WEnd
		'MyString = MyString & Returnset.GetString(2, , ",", VBCRLF)
		
		Flat_Download = MyString
	End Function
	
	Function XML_Download (DBConnection, SQL)
		dim ReturnSet
		dim MyString
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
						
		MyString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
				
		'Execute the SQL
		''Response.Write(SQL)
		Set ReturnSet = ExecuteSql(SQL, DBConnection) 
		'Response.write("end")
		'Response.End 
		
		MyString = MyString & "<Report>"
		
		' Check if there are any errors
		if (CInt(ReturnSet("returnvalue")) <> 0) and (CInt(ReturnSet("returnvalue")) <> 1) then
			' An error occured - Build the error message
			MyString = MyString & "<errormessage>An error occured when generating the xml</errormessage>"
		else
			MyString = MyString & "<Stats>"
			MyString = MyString & "<DateRange FromDate=""" & ReturnSet("FromDate") & """ ToDate=""" & ReturnSet("ToDate") & """ />"
			Dim Dc, Supplier, Store
			Dim Dc_Close, Supplier_Close, Store_Close
			Dim Val1, val2, val3, val4, val5,DoRecon
			Dc = ""
			Supplier = ""
			Store = ""
			Dc_Close = ""
			Supplier_Close = ""
			Store_Close = ""
			val1 = ""
			val2 = ""
			val3 = ""
			val4 = ""
			Val5 = ""
			DoRecon = False
			While Not ReturnSet.Eof
				IF CInt(ReturnSet("returnvalue")) = 1 Then
					DoRecon = True
				End if
				
				IF ReturnSet("DC") <> DC Then 'New DC
					DC = ReturnSet("DC") 'Assigns DC to be current
					Store = ""
					Supplier = ""
					IF DC_Close = "Close" Then	'Allready DC open
						
						If DoRecon Then
							MyString = MyString & "</Supplier></DC>" 'Close DC
						else
							IF val1 = "" Then
								MyString = MyString & "<Orders>0</Orders>"
								val1 = "fine"
							End IF
							IF val2 = "" Then
								MyString = MyString & "<Invoices>0</Invoices>"
								val2 = "fine"
							End IF
							IF val3 = "" Then
								MyString = MyString & "<Claims>0</Claims>"
								val3 = "fine"
							End IF
							IF val4 = "" Then
								MyString = MyString & "<Credit_Notes>0</Credit_Notes>"
								val4 = "fine"
							End IF
						
							MyString = MyString & "</Supplier></Store></DC>" 'Close DC
						End If					
						
						Supplier_Close = ""
						Store_Close = ""
						
						val1 = ""
						val2 = ""
						val3 = ""
						val4 = ""
					End IF
					DC_Close = "Close"
					MyString = MyString & "<DC ID=""" & ReturnSet("DC") & """ Name=""" & ReturnSet("DCName") & """ >" 'Opens a DC
				End If
				
				If Not DoRecon Then
					IF ReturnSet("Store") <> Store Then 'New Store
						Store = ReturnSet("Store") 'Assigns Store to be current
						Supplier = ""
						IF Store_Close = "Close" Then	'Allready Store open
						
							IF val1 = "" Then
								MyString = MyString & "<Orders>0</Orders>"
							End IF
							IF val2 = "" Then
								MyString = MyString & "<Invoices>0</Invoices>"
							End IF
							IF val3 = "" Then
								MyString = MyString & "<Claims>0</Claims>"
							End IF
							IF val4 = "" Then
								MyString = MyString & "<Credit_Notes>0</Credit_Notes>"
							End IF
						
							MyString = MyString & "</Supplier></Store>" 'Close Store
							Supplier_Close = ""
							val1 = ""
							val2 = ""
							val3 = ""
							val4 = ""
						End IF
						Store_Close = "Close"
						MyString = MyString & "<Store ID=""" & ReturnSet("Store") & """ Name=""" & ReturnSet("StoreName") & """ >" 'Opens a Store
					End If
				End IF
				
				IF ReturnSet("Supplier") <> Supplier Then 'New Supplier
					Supplier = ReturnSet("Supplier") 'Assigns Supplier to be current
					IF Supplier_Close = "Close" Then	'Allready supplier open
					
						If not DoRecon Then
							IF val1 = "" Then
								MyString = MyString & "<Orders>0</Orders>"
							End IF
							IF val2 = "" Then
								MyString = MyString & "<Invoices>0</Invoices>"
							End IF
							IF val3 = "" Then
								MyString = MyString & "<Claims>0</Claims>"
							End	IF
							IF val4 = "" Then
								MyString = MyString & "<Credit_Notes>0</Credit_Notes>"
							End IF
						End If
					
						MyString = MyString & "</Supplier>" 'Close Supplier
						val1 = ""
						val2 = ""
						val3 = ""
						val4 = ""
					End IF
					Supplier_Close = "Close"
					
					MyString = MyString & "<Supplier ID=""" & ReturnSet("Supplier") & """ Name=""" & ReturnSet("SupplierName") & """ >" 'Opens a Supplier
				End If
				
				
				IF ReturnSet("Type") = 1 Then
					MyString = MyString & "<Orders>" & ReturnSet("Val") & "</Orders>"
					val1 = "fine"
				End IF
				IF ReturnSet("Type") = 2 Then
				
					IF val1 = "" Then
						MyString = MyString & "<Orders>0</Orders>"
						val1 = "fine"
					End IF
								
					MyString = MyString & "<Invoices>" & ReturnSet("Val") & "</Invoices>"
					val2 = "fine"
				End IF
				IF ReturnSet("Type") = 3 Then
				
					IF val1 = "" Then
						MyString = MyString & "<Orders>0</Orders>"
						val1 = "fine"
					End IF
					IF val2 = "" Then
						MyString = MyString & "<Invoices>0</Invoices>"
						val2 = "fine"
					End IF
				
					MyString = MyString & "<Claims>" & ReturnSet("Val") & "</Claims>"
					val3 = "fine"
				End IF
				IF ReturnSet("Type") = 4 Then
				
					IF val1 = "" Then
						MyString = MyString & "<Orders>0</Orders>"
						val1 = "fine"
					End IF
					IF val2 = "" Then
						MyString = MyString & "<Invoices>0</Invoices>"
						val2 = "fine"
					End IF
					IF val3 = "" Then
						MyString = MyString & "<Claims>0</Claims>"
						val3 = "fine"
					End IF
									
					MyString = MyString & "<Credit_Notes>" & ReturnSet("Val") & "</Credit_Notes>"
					val4 = "fine"
				End IF
				
				IF ReturnSet("Type") = 5 Then
					MyString = MyString & "<Recon_Report>" & ReturnSet("Val") & "</Recon_Report>"
					val1 = "fine"
				End IF
				
				ReturnSet.MoveNext
			WEnd
			
			If DoRecon Then
				MyString = MyString & "</Supplier></DC>"	
			Else
				IF val1 = "" Then
					MyString = MyString & "<Orders>0</Orders>"
				End IF
				IF val2 = "" Then
					MyString = MyString & "<Invoices>0</Invoices>"
				End	IF
				IF val3 = "" Then
					MyString = MyString & "<Claims>0</Claims>"
				End IF
				IF val4 = "" Then
					MyString = MyString & "<Credit_Notes>0</Credit_Notes>"
				End IF
			
				MyString = MyString & "</Supplier></Store></DC>"	
			End IF		
			MyString = MyString & "</Stats>"
		End IF
		
		MyString = MyString & "</Report>"
			
		
		'Response.Write (Mystring)
		XML_Download = MyString
	End Function

%>
