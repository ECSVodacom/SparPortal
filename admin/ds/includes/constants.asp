<!--#include file="../../../includes/ExecuteProcedure.asp"-->
<%
	' This include file will display the constants for the CMS
		
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Password=ECsqlOnline!;Persist Security Info=True;User Id=SparUser;Initial Catalog=SparDS;Data Source=192.168.101.36,1433"
	Const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/portal/admin/ds"
	Const const_app_Moniker = "SPAR DROP SHIPMENT ADMINISTRATION SYSTEM"
	Const const_app_MailObject = "CDONTS.NewMail"
	Const const_app_ScheduleFileLocation = "C:\spar\portal\"
	
%>