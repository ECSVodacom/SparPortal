<%
	function SetUserDetails (UserID, UserName, FirstName, UserType, Permission, PhysAddress, ProcID, ProcEAN, ProcName, IsXML, DCID, DCcX40Ean, DCcEANNumber, IsSuperUser, IsWarehouseUser, StoreCode, StoreFormat,ClaimCaptureOverrideIndicator)
		' Author & Date: Chris Kennedy, 04 June 2002
		' Purpose: This function will set the session variable for the logged in user
		
		Session("IsLoggedIn") = 1
		Session("UserID") = UserID
		Session("UserName") = UserName
		Session("FirstName") = FirstName
		Session("UserType") = UserType
		Session("Permission") = Permission
		Session("PhysAddress") = PhysAddress
		Session("ProcID") = ProcID
		Session("ProcEAN") = ProcEAN
		Session("ProcName") = ProcName
		Session("IsXML") = IsXML
		Session("DCID") = DCID
		Session("DCcX40Ean") = DCcX40Ean
		Session("DCcEANNumber")  = DCcEANNumber
		Session("IsSuperUser") = IsSuperUser
		Session("IsWarehouseUser") =  IsWarehouseUser
		Session("StoreCode") =  StoreCode
		Session("StoreFormat") = StoreFormat
		Session("ClaimCaptureOverrideIndicator") =  Trim(ClaimCaptureOverrideIndicator)
		
	
	end function
%>
