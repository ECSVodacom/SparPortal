<%
	function SetUserDetails (UserID, UserName, FirstName, Surname, SupplierEMail, BuyerEMail, BuyerCode, ProcID, UserType, Permission)
		' Author & Date: Chris Kennedy, 04 June 2002
		' Purpose: This function will set the session variable for the logged in user
		
		Session("IsLoggedIn") = 1
		Session("UserID") = UserID
		Session("UserName") = UserName
		Session("FirstName") = FirstName
		Session("Surname") = Surname
		Session("SupplierEMail") = SupplierEMail
		Session("BuyerEMail") = BuyerEMail
		Session("BuyerCode") = BuyerCode
		Session("UserType") = UserType
		Session("ProcID") = ProcID
		Session("Permission") = Permission
	
	end function
%>
