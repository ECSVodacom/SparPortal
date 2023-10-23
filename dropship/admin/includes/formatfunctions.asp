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
	
		If IsDate(DateToFormat) then
			MonthArray = Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
		
			ReturnDate = DatePart("d", DateToFormat) & " " & MonthArray(DatePart("m", DateToFormat)-1) & " " & DatePart("yyyy", DateToFormat)
		
			If ShowTime then
				DtHour = LZ(DatePart("h", DateToFormat))
				DtMin = LZ(DatePart("n", DateToFormat))
		
				ReturnTime = DtHour & ":" & DtMin
		
				FormatLongDate = ReturnDate & " (" & ReturnTime & ")"
			Else
				FormatLongDate = ReturnDate
			end if
		Else
			FormatLongDate = DateToFormat
		End If
	
	end function
%>
