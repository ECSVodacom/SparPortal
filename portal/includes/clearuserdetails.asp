<%
	function ClearUserDetails ()
		' This function will set all the session variables to blank
		
		Session("IsLoggedIn") = 0
		Session("UserID") = 0
		Session("UserName") = ""
		Session("ClientName") = ""
		Session("UserType") = ""
		Session("Permission") = 0
		Session("PhysAddress") = ""
		Session("PostAddress") = ""
		Session("ClientMail") = ""
		
		Session.Abandon
	end function	
%>