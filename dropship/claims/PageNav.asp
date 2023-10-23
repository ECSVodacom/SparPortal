
	<%
	'rsObj("RowNumber"), rsObj("TotalRecords"), rsObj("PageSize"), hidCurrentPageNumber
	
	Sub DrawPagination ( RowNumber, TotalRecords, PageSize, HiddenPageNumber )
	%>
	<tr>
			<td class="pcontent" align="center" colspan="2">Displaying <%If rsObj("PageSize") > rsObj("TotalRecords") Then Response.Write rsObj("TotalRecords") Else Response.Write rsObj("PageSize")%> records out of a total of <%=rsObj("TotalRecords")%> records.</td>
			<td class="pcontent" align="center">Records <%=rsObj("RowNumber")%> to 
			<%
				If CLng(rsObj("RowNumber")) + CLng(rsObj("PageSize")) > rsObj("TotalRecords") Then
					Response.Write rsObj("TotalRecords")
				Else
					Response.Write CLng(rsObj("RowNumber")) - 1 + CLng(rsObj("PageSize"))
				End If
			%> are currently displayed.</td>
			<td class="pcontent" align="left" colspan="15">
			<%
				If Not IsNumeric(Request.Form("hidCurrentPageNumber")) Or Request.Form("hidCurrentPageNumber") = "" Then
					hidCurrentPageNumber = 1
				Else
					hidCurrentPageNumber = CInt(Request.Form("hidCurrentPageNumber"))
				End If
			
				If hidCurrentPageNumber > 1 Then
					Response.Write "<a href='javascript: SetPage(" & hidCurrentPageNumber - 1 & ")'>Previous Page</a>" & " | " 
				End If
			
				If hidCurrentPageNumber < Int(rsObj("TotalRecords") / rsObj("PageSize") + 1) Then
					Response.Write "<a href='javascript: SetPage(" & hidCurrentPageNumber + 1 & ")'>Next Page</a>" & " | " 
				End If

				Dim TotalPages 
				TotalPages = Int(rsObj("TotalRecords") / rsObj("PageSize") + 1)
				FromPage = hidCurrentPageNumber - 4
				ToPage = hidCurrentPageNumber + 4
				If FromPage < 1 Then
					FromPage = 1
				End If
				If ToPage > TotalPages Then
					ToPage = TotalPages
				End If

				If hidCurrentPageNumber <> 1 Then
					Response.Write "<a href='javascript: SetPage(1)'>First Page</a>" & " | "
				End If
			
				If hidCurrentPageNumber = 0 Then
					Response.Write "<b>Page 1 |</b> "
				End If
				For i = FromPage To ToPage 
					If Cint(hidCurrentPageNumber) = i Then
						Response.Write "<b>Page " & i & " |</b> "
					Else
						Response.Write "<a href='javascript: SetPage(" & i & ")'>Page " & i & "</a>" & " | "
					End If
				Next
				If  hidCurrentPageNumber <> ToPage  Then
					Response.Write "<a href='javascript: SetPage(" &  TotalPages & ")'>Last Page</a>" & " | "
				End If
			%>
			</td>
	</tr>
<%
	End Sub


%>