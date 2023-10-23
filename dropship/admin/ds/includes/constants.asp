<!--#include file="../../../includes/ExecuteProcedure.asp"-->
<%
	' This include file will display the constants for the CMS
		
	'const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=SparDS;Data Source=SPARNEW1\SPAR"
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=ECsqlOnline!;Initial Catalog=SparDS;Data Source=192.168.101.36,1433"
	Const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/dropship/admin/ds"
	Const const_app_Moniker = "SPAR DROP SHIPMENT ADMINISTRATION SYSTEM"
	Const const_app_MailObject = "CDONTS.NewMail"
	
%>