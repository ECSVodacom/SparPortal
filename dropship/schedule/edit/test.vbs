
	
		Set httpRequest = CreateObject("WinHttp.WinHttpRequest.5.1")
		httpRequest.Option(9) = 2560
		httpRequest.Open "POST", "http://192.168.202.31:9080/msgsrv/http?from=SPARSCHEDULES&to=dcean&filename=filename", False
		httpRequest.SetRequestHeader "Content-Type", "text/xml"
		
		
		httpRequest.Send "testnj"

		postResponse = httpRequest.ResponseText

	 
