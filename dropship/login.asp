<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="includes/constants.asp"-->
<%	
	' 1.	Orders
	' 2.	Invoices
	' 3.	Claims
	' 4.	Credit Notes
	' 5.	Recon Reports
	' 6.	Electronic Remittance
	' 7. 	Store Lists
	
	Dim Username 
	Username = Server.URLEncode(Request.QueryString("u"))

	If Request.Cookies("DSLogin") <> Username Then
		Response.Cookies("DSLogin") = Username
		Response.Cookies("DSLogin").Expires = DateAdd("m",1,Date)
	End If
	
	Session("Action") = Request.QueryString("a")
	
	Response.Redirect const_app_ApplicationRoot &  "/default.asp?i=true"	

		
	
	
	
%>