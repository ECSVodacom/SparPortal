<%
	function ClearUserDetails ()
		' This function will set all the session variables to blank
		
		Session("IsLoggedIn") = 0
		Session("UserID") = 0
		Session("UserName") = ""
		Session("FirstName") = ""
		Session("Surname") = ""
		Session("EMail") = ""
		Session("Permission") = 0
		
		Session.Abandon
	end function	
%>