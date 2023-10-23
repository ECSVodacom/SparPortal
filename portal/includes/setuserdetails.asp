<%
	function SetUserDetails (UserID, UserName, FirstName, UserType, Permission, PhysAddress, PostAddress, Email)
		' Author & Date: Chris Kennedy, 04 June 2002
		' Purpose: This function will set the session variable for the logged in user
		
		Session("IsLoggedIn") = 1
		
		if Permission = 1 or Permission = 2 then
			Session("UserID") = 0
		else
			Session("UserID") = UserID
		end if
		Session("UserName") = UserName
		Session("ClientName") = FirstName
		Session("UserType") = UserType
		Session("Permission") = Permission
		Session("PhysAddress") = PhysAddress
		Session("PostAddress") = PostAddress
		Session("ClientMail") = Email
	
	end function
%>
