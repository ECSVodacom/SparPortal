<%

	
		Set httpRequest = Server.CreateObject("MSXML2.XMLHTTP")

		httpRequest.Open "POST", "http://192.168.202.31:9080/msgsrv/http?from=SPARSCHEDULES&to=dcean&filename=filename", False
		httpRequest.SetRequestHeader "Content-Type", "text/xml"
		
		
		httpRequest.Send "testnj"

		postResponse = httpRequest.ResponseText

		response.write postResponse
		reponse.end
%>