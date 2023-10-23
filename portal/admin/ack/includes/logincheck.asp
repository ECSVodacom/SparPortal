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
%>
