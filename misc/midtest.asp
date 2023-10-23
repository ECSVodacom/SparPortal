<%

Response.Write Year(Date) & Right(FormatDateTime(Date,0),6) & " " & FormatDateTime(Now,3) & "<br>"
'Response.Write Year(Date) & Now
	Response.end

OrderNumber = "123456sNTH"

Response.Write Mid(OrderNumber,1,Len(OrderNumber)-4)
'Response.Write Mid(OrderNumber,1,6)

%>
