<%
	function SendCDOMail (ToAddress, FromAddress, Subject, BodyText, MailFormat)
		' Author & Date: Chris Kennedy, 25 June 2002
		' Purpose: This function will send any mail according to the parameters provided.
		Dim Command   

		Command = "sp_send_cdosysmail " _
					  & "@From='" & Replace(FromAddress,"'","''") _
					  & "',@To='" & Replace(ToAddress,"'","''") _
					  & "',@Cc='"  _
					  & "',@Subject='" & Replace(Subject,"'","''") _
					 & "',@Body='" & Replace(BodyText,"'","''") & "'"

		Dim MailConnection

		Set MailConnection= CreateObject ("ADODB.Connection")
		MailConnection.Open "Provider=SQLOLEDB.1;Password=ECsqlOnline!;Persist Security Info=True;User Id=sparuser;Initial Catalog=SparDS;Data Source=192.168.101.36,1433"

		MailConnection.Execute(Command)
		'ExecuteSql Command, MailConnection
		
		
		MailConnection.Close

		Set MailConnection = Nothing
	end function
%>