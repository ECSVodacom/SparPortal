<%
		
		' Set the FolderName
		FolderName = "E:\Inetpub\wwwroot\Spar\misc\"
	
		' Creat the FileSystem Object
		Set oFile = CreateObject("Scripting.FileSystemObject")

		Set fileOpen = oFile.OpenTextFile(FolderName & "award_Jan.txt",1,false)
											
		strRead = fileOpen.ReadAll
											
		Set fileOpen = Nothing	
		
		'Response.Write strRead
		'Response.End
		
		' Send the email
		Set oMail = Server.CreateObject("CDONTS.NewMail")
											
		oMail.From = "awards@gatewaycomms.com"
		oMail.To = "all@gatewaycomms.com"
		'oMail.To = "patrick.stevens@gatewaycomms.com"
		'oMail.To = "ckennedy@gatewaycomms.co.za"
		oMail.Subject = "Contributor of the Month - eAward #3 January 2006"
		oMail.AttachURL "E:\Inetpub\wwwroot\Spar\portal\admin\ack\layout\images\topbanner1.gif", "topbanner1.gif"
		oMail.AttachURL "E:\Inetpub\wwwroot\Spar\portal\admin\ack\layout\images\gototop.bmp", "gototop.bmp"
		oMail.MailFormat = 0
		oMail.BodyFormat = 0
		oMail.Body = strRead
		oMail.Send
											
		' Close the mail object
		Set oMail = Nothing		
		
		Response.Write strRead
%>