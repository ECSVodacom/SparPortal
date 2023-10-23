<%
	function MakeSQLText (StringToFormat)
		' Author & date: Chris Kennedy, 04 June 2002
		' Purpose: This function will convert a string to a valid SQL string
		
		' Check if the StringToFormat is blank
		if StringToFormat = "" or isnull(StringToformat) Then
			' Return a blank string
			MakeSQLText = "''"
		else
			' Return the string for the SQl
			MakeSQLText = "'" & Replace(StringToformat, "'", "''") & "'"
		end if
	end function

	function MakeSQLDate(DateToChange)
	
	dim DateArray
	dim TempDate
	
	If IsNull(DateToChange) then
		MakeSQLDate = "null"
	else
		If IsDate(DateToChange) then
			TempDate = CDate(DateToChange)
			DateArray = Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
			MakeSQLDate = "'" & DatePart("d", TempDate) & _
				DateArray(Clng(DatePart("m", TempDate))-1) & _
				DatePart("yyyy", TempDate) & "'"
		else
			MakeSQLDate = "null"
		end if
	end if
	
	end function
	
	function FormatDate(DateToFormat,ShowTime)
	'Written by Chris Kennedy
	
		dim MonthArray
		dim ReturnString
		dim ReturnDate
		dim ReturnTime
		dim DtHour
		dim DtMin
	
		If IsDate(DateToFormat) then
			MonthArray = Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
		
			ReturnDate = DatePart("d", DateToFormat) & " " & MonthArray(DatePart("m", DateToFormat)-1) & " " & DatePart("yyyy", DateToFormat)
		
			If ShowTime then
				DtHour = LZ(DatePart("h", DateToFormat))
				DtMin = LZ(DatePart("n", DateToFormat))
		
				ReturnTime = DtHour & ":" & DtMin
		
				FormatDate = ReturnDate & " (" & ReturnTime & ")"
			Else
				FormatDate = ReturnDate
			end if
		Else
			FormatDate = DateToFormat
		End If
	
	end function
	
	function FormatLongDate(DateToFormat,ShowTime)
	'Written by Chris Kennedy
	
		dim MonthArray
		dim ReturnString
		dim ReturnDate
		dim ReturnTime
		dim DtHour
		dim DtMin
		dim DtSec
	
		If IsDate(DateToFormat) then
			MonthArray = Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
		
			ReturnDate = DatePart("d", DateToFormat) & " " & MonthArray(DatePart("m", DateToFormat)-1) & " " & DatePart("yyyy", DateToFormat)
		
			If ShowTime then
				DtHour = LZ(DatePart("h", DateToFormat))
				DtMin = LZ(DatePart("n", DateToFormat))
				DTSec = LZ(DatePart("s", DateToFormat))
		
				ReturnTime = DtHour & ":" & DtMin & ":" & DtSec
		
				FormatLongDate = ReturnDate & "<br> (" & ReturnTime & ")"
			Else
				FormatLongDate = ReturnDate
			end if
		Else
			FormatLongDate = DateToFormat
		End If
	
	end function
	
	Function GetMonth (MonthVal,ShowYear)
		dim MonthArray
		dim ReturnDate
		
		MonthVal = MonthVal - 1
		
		' Set the Months
		MonthArray = Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
		
		' Check if the month exist in the Array
		if MonthArray(MonthVal) <> "" Then
			ReturnDate = MonthArray(MonthVal)
		else
			ReturnDate = ""
		end if
		
		' Check if the user requested to show the year
		if ShowYear Then
			ReturnDate = ReturnDate & " " & Year(Now)
		end if
		
		' Return the ReturnDate
		GetMonth = ReturnDate
		
	End Function
	
	Function GetDay (DateVal, Abr)
	
		dim DayVal
		dim DayArray
		dim ReturnDay
		
		' Get the Day Val
		DayVal = WeekDay(DateVal,2)
		
		DayVal = DayVal - 1
		
		if Abr Then
			DayArray = Array("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
		else
			DayArray = Array("Mon","Tues","Wed","Thurs","Fri","Sat","Sun")
		end if
		
		ReturnDay = DayArray(DayVal)
		
		GetDay = ReturnDay
	
	End Function
	
Function GetDC (DCID)
		
	dim ReturnDC
		
	' Check what suffix should be used
	Select Case CStr(DCID)
	Case "nth"
		ReturnDC = "Spar North Rand"
	Case "erd"
		ReturnDC = "Spar South Rand"
	Case "plz"
		ReturnDC = "Spar Eastern Cape"
	Case "cpt"
		ReturnDC = "Spar Western Cape"
	Case "ntl"
		ReturnDC = "Spar Kwazulu Natal"
	End Select
	
	GetDC = ReturnDC
	
End Function
	
	Function LZ(NumberToFormat)
		'Converts a single char int into a double digit with leading zero

		If len(NumberToFormat) < 2 Then
			NumberToFormat = "0" & NumberToFormat
		End if
		LZ = NumberToFormat
	End Function
	
	function CalcNumPages (RecordCount, BandSize)
		' This function will calculate the number of pages 
		
		dim NumPages
		dim CheckRes
	
		' Divide the Total Number of Records into the records per page		
		NumPages = RecordCount / BandSize

		' Get the res value 		
		CheckRes = RecordCount MOD BandSize
		
		' Check if the res value is greater than 0
		if CheckRes > 0 Then
			' Add 0ne to the number of pages
			NumPages = Fix(NumPages + 1)
		else
			NumPages = Fix(NumPages)
		end if
		
		' Return the number of pages
		CalcNumPages = NumPages
	
	end function
	
	Function PageHeadNav (ClassName, RecCount, BandSize, RecFrom, RecTo)
		' This function will display the heading for the page navigation 
		dim Counter
%>
<p class="<%=ClassName%>">Displaying <b><%=RecCount%></b> records out of a total of <b><%=BandSize%></b> records.<br>
	Records <b><%=RecFrom%></b> to <b><%=RecTo%></b> is currently displayed.
</p>
<%
	End Function
	
	Function PageNav (URL, ClassName, RecCount, BandSize, RecFrom, RecTo, NumPages, RecBand, ID)
		' This function will display the number of pages 
		dim Counter
%>
<p class="<%=ClassName%>">
<%
		' Check if there are previous pages
		if RecBand > 1 Then
%>
<a class="stextnav" href="<%=URL%>?page=<%=RecBand - 1%>&id=<%=ID%>">Previous&nbsp;Page&nbsp;|</a>
<%		
		end if
		
		' Check if there are next records
		if RecTo < BandSize Then
%>
<a class="stextnav" href="<%=URL%>?page=<%=RecBand + 1%>&id=<%=ID%>">Next&nbsp;Page&nbsp;|</a>
<%			
		end if
		
		' Loop through the total Number of pages to display the page numbers
		for Counter = 1 to NumPages
										
			if RecBand = Counter Then
%>
<b>Page&nbsp;<%=Counter%>&nbsp;|</b>
<%											
			else
%>
<a class="stextnav" href="<%=URL%>?page=<%=Counter%>&id=<%=ID%>">Page&nbsp;<%=Counter%></a>&nbsp;|
<%										
			end if
		next	
%>
</p>
<%		
	End Function
%>
