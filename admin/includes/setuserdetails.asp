<%
	function SetUserDetails (UserID, UserName, FirstName, Surname, EMail,Permission, DCID, DCName)
		' Author & Date: Chris Kennedy, 04 June 2002
		' Purpose: This function will set the session variable for the logged in user
		
		Session("IsLoggedIn") = 1
		Session("UserID") = UserID
		Session("UserName") = UserName
		Session("FirstName") = FirstName
		Session("Surname") = Surname
		Session("EMail") = EMail
		Session("Permission") = Permission
		Session("DCID") = DCID
		Session("DCName") = DCName
	
	end function
%>
