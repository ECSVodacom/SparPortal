<!--#include file="ExecuteProcedure.asp"-->
<%
	' This include file will display the constants for the CMS
	' Constants live site
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SparPortal;Data Source=192.168.101.36,1433"
	const const_db_ReportConnection = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=Spar;Data Source=192.168.101.36,1433"
	const const_db_CommunityConnection = ""
	const const_db_SPARDS = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SparDS;Data Source=192.168.101.36,1433"
	Const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/portal"
	Const const_app_SparArcPath = "\\Vodacom-sql2vm\SparOrders\"
	Const const_app_Moniker = "SPAR Portal"
	Const const_app_MailObject = "CDONTS.NewMail"
	Const const_app_XMLObject = "MSXML2.DomDocument"
	Const const_app_DCRoot = "https://spar.gatewayec.co.za/"
	Const const_app_PortalPath = "C:\inetpub\wwwroot\SPARv2\portal\"
%>