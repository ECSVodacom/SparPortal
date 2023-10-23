<%
	function ClearUserDetails ()
		' This function will set all the session variables to blank
		
		Session("IsLoggedIn") = 0
		Session("UserID") = ""
		Session("UserName") = ""
		Session("FirstName") = ""
		Session("Surname") = ""
		Session("EMail") = ""
		
		Session.Abandon
	end function	
%>