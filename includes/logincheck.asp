<%
	function LoginCheck (URLafter)
		' Author & Date: Chris Kennedy, 04 June 2002
		' Purpose: This function will determine if the current user is logged into the site.
		
		' Check if the Session("IsLoggedIn") <> 1
		if Session("IsLoggedIn") <> 1 Then
			' The user is not currently logged into the system - redirect him to the login page
			' Check if there was an URLafter link provided
			if URLafter <> "" Then
				' Redurect the user to the login page with the urlafter as parameter
				response.redirect const_app_ApplicationRoot & "/default.asp?response=1&urlafter=" & URLafter
			else
				' Redurect the user to the login page 
				response.redirect const_app_ApplicationRoot & "/default.asp?response=1"
			end if
		end if
	end function
	
	function CookieLoginTrackCheck(URLAfter)
		
		dim txtType
		dim SQL
		dim curConnection
		dim ReturnSet
		dim CreateCookie
		
		if Session("IsLoggedIn") <> 1 Then
			' The users session expired
			' Check if the user has a cookie
			if Request.Cookies("TrackTrace") = "" Then
				' The user has no cookie - redirect the user to the default login page with the url after
				Response.Redirect const_app_ApplicationRoot & "/tracktrace/default.asp?urlafter=" & URLAfter
			else
				' There are a cookie for the user - log him into the site
				SQL = "exec procCookieLogin @LoginName=" & MakeSQLText(Request.Cookies("TrackTrace"))	
			
				' Create the connection
				Set curConnection = Server.CreateObject("ADODB.Connection")
				curConnection.Open const_db_ConnectionString
			
				' Execute the SQL
				Set ReturnSet = ExecuteSql(SQL, curConnection)
			
				' Check if there is a an error
				if ReturnSet("returnvalue") <> 0 Then
					' A login error occured - redirect to the logon page with errorcode
					Response.Redirect const_app_ApplicationRoot & "/default.asp?errorcode=1&urlafter=" & URLAfter
					
					' Close the recordset and connections
					Set ReturnSet = Nothing
					curConnection.Close
					Set curConnection = Nothing
				else
					' No error occured - Set the Session variables
					Session("IsLoggedIn") = 1
					Session("UserID") = ReturnSet("UserID")
					Session("UserName") = ReturnSet("UserName")
					Session("FirstName") = ReturnSet("FirstName")
					Session("Surname") = ReturnSet("Surname")
					Session("SupplierEMail") = ReturnSet("SupplierEMail")
					Session("BuyerEMail") = ReturnSet("BuyerEMail")
					Session("BuyerCode") = ReturnSet("BuyerCode")
					Session("UserType") = ReturnSet("UserType")
					Session("ProcID") = ReturnSet("ProcID")
					
					' create the cookie for the user
					Response.Cookies("TrackTrace") = ReturnSet("UserName")
					Response.Cookies("TrackTrace").Expires = DateAdd("m",1,Date)
					
					' Close the recordset and connections
					Set ReturnSet = Nothing
					curConnection.Close
					Set curConnection = Nothing
				end if
			end if
		end if
	end function
	
	function CookieLoginCheck(URLAfter)
		
		dim txtType
		dim SQL
		dim curConnection
		dim ReturnSet
		dim CreateCookie
		
		'response.write "A:" & Session("IsLoggedIn")
		'response.end
		' If not logged in
		'if Session("IsLoggedIn") <> 1 Then
			' Check what user is trying to access the application
			if Request.QueryString("type") = "1" Then
				' This is a buyer
				txtType = "buyer"
			else
				' This is a supplier
				txtType = "supplier"
			end if

		
			' Check if the user has a cookie
			if Request.Cookies("WebLogon") = "" or IsNull(Session("WebLogon")) Then
				'Response.Write const_app_ApplicationRoot & "/default.asp?urlafter=" & const_app_ApplicationRoot & "/orders/" & txtType & "/default.asp?id=" & Request.QueryString("id")
				'Response.End

				' The user has no cookie - redirect the user to the default login page with the url after
				Response.Redirect const_app_ApplicationRoot & "/default.asp?urlafter=" & const_app_ApplicationRoot & "/orders/" & txtType & "/default.asp?id=" & Request.QueryString("id")
			else
			
			
				' There are a cookie for the user - log him into the site
				'SQL = "SELECT * FROM Users WHERE UScUserName=" & MakeSQLText(Request.Cookies("WebLogon"))
				SQL = "exec procCookieLogin @LoginName=" & MakeSQLText(Request.Cookies("WebLogon"))	
				
				'response.write SQL
				'response.end
				
				' Create the connection
				Set curConnection = Server.CreateObject("ADODB.Connection")
				curConnection.Open const_db_ConnectionString
				
				' Execute the SQL
				Set ReturnSet = ExecuteSql(SQL, curConnection)
				
				'response.write SQL
				' Check if there is a an error
				if ReturnSet("returnvalue") <> 0 Then
					' A login error occured - redirect to the logon page with errorcode
					Response.Redirect const_app_ApplicationRoot & "/default.asp?errorcode=1&urlafter=" & const_app_ApplicationRoot & "/orders/" & txtType & "/default.asp?id=" & Request.QueryString("id")
					
					' Close the recordset and connections
					Set ReturnSet = Nothing
					curConnection.Close
					Set curConnection = Nothing
				else
					' No error occured - Set the Session variables
					Session("IsLoggedIn") = 1
					Session("UserID") = ReturnSet("UserID")
					Session("UserName") = ReturnSet("UserName")
					Session("FirstName") = ReturnSet("FirstName")
					Session("Surname") = ReturnSet("Surname")
					Session("SupplierEMail") = ReturnSet("SupplierEMail")
					Session("BuyerEMail") = ReturnSet("BuyerEMail")
					'Session("BuyerCode") = ReturnSet("Code")
					Session("UserType") = ReturnSet("UserType")
					Session("Permission") = ReturnSet("Permission")
					
					
					If txtType = "supplier" Then
						Session("ProcID") = ReturnSet("ProcID")
					End If
					
					' create the cookie for the user
					Response.Cookies("WebLogon") = ReturnSet("UserName")
					Response.Cookies("WebLogon").Expires = DateAdd("m",1,Date)
					
					
					' Close the recordset and connections
					Set ReturnSet = Nothing
					curConnection.Close
					Set curConnection = Nothing
				end if
			end if
		'end if
	end function
%>
