
<%
			dim StrText
			dim NewCount
			dim Counter
			dim StrCount
			dim StrDisplay
			dim oFile
			dim File
			dim DayCount
			dim NoDisplay
										
			
			PageTitle = "Drop Shipment: Track and Trace"

			Select Case Session("UserType")
			Case 1
				' This is a Supplier
				Folder = "supplier"
			Case 2
				' This is a DC
				Folder = "dc"
			Case 3
				' This is a Store
				Folder = "store"
			End Select
			
			NewDate = Year(Now) & "/" & Month(Now) & "/" & Day(Now)
			Response.Write "<br /><br />"
			Response.Write "<a style='font-family: Verdana,Geneva,Arial,Helvetica,sans-serif;font-weight:bold; font-size:0.7em; color: #00006A; text-decoration:none' href='" & const_app_ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?id=" & FormatDate(CDate(NewDate) - DayCount,false) & "'>" & FormatDate(CDate(NewDate) - DayCount,false) & "</a>" & vbCrLf
			'Response.Write const_app_ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?id=" & FormatDate(CDate(NewDate) - DayCount,false)
			
			'Response.End 
			'StrText = "<pre>"
			'StrText = StrText & "<!--" & VbCrLf
			'StrText = StrText & "var tocTab = new Array();var ir=0;" & VbCrLf
			'StrText = StrText & "tocTab[ir++] = new Array ('0', 'Date Menu', '');" & VbCrLf
			'StrText = StrText & "tocTab[ir++] = new Array ('0', '', '');" & VbCrLf
			'StrText = StrText & "tocTab[ir++] = new Array ('1', '" & FormatDate(CDate(NewDate),false) & "', '" & const_app_ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?id=" & FormatDate(CDate(NewDate),false) & "');" & VbCrLf

			NewCount = 0
			DayCount = 0

			For Counter = 2 to 30
				DayCount = DayCount + 1
				StrCount = Counter
				StrDisplay = FormatDate(CDate(NewDate) - DayCount,false)
					
				if Counter >= 9 Then
					if Counter = 9 Then
						StrCount = 9 
					else
						NewCount = NewCount + 1
						StrCount = 9 & "." & NewCount
					end if
						
					if NewCount = 0 Then
						StrDisplay = "Before " & FormatDate(CDate(NewDate) - DayCount,false)
					else
						StrDisplay = FormatDate(CDate(NewDate) - DayCount,false)
					end if
				end if
				Response.Write "<a style='font-family: Verdana,Geneva,Arial,Helvetica,sans-serif;font-weight:bold; font-size:0.7em; color: #00006A; text-decoration:none' href='" & const_app_ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?id=" & FormatDate(CDate(NewDate) - DayCount,false) & "'>" & FormatDate(CDate(NewDate) - DayCount,false) & "</a><br />"  & vbCrLf
				'StrText = StrText & "tocTab[ir++] = new Array ('" & StrCount & "', '" & StrDisplay & "', '" & const_app_ApplicationRoot & "/track/" & Folder & "/frmcontent.asp?id=" & FormatDate(CDate(NewDate) - DayCount,false) & "');" & VbCrLf
			Next
			
			'StrText = StrText & "var nCols = 4;" & VbCrLf
			'StrText = StrText & "//-->" & VbCrLf
			'StrText = StrText & "</pre>"

			' Create the file system object
			'Set oFile = Server.CreateObject("Scripting.FileSystemObject")
			
			' Open the text file
			'Set File = oFile.OpenTextFile (const_app_IncludePath & Folder & "datemenu.js",2,True)
											' C:\InetPub\wwwroot\Spar\dropship\includes\dc 				
			' write the string to the text file
			'File.Write StrText
			'												
			' Close the file system object
			'Set File = Nothing
			'Set oFile = Nothing
			
			
			'Response.Write  StrText
			
%>