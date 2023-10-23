<!--#include file="ExecuteProcedure.asp"-->
<%
	' This include file will display the constants for the CMS
	' Constants live site

	' ========================================================================================================

	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=Spar;Data Source=192.168.101.36,1433"
	Const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/"
	Const const_app_Moniker = "Spar"
	Const const_app_UploadPath = "C:\InetPub\wwwroot\images"
	Const const_app_DownloadPath = "https://spar.gatewayec.co.za/images"
	Const const_app_SupplierPath = "https://spar.gatewayec.co.za/In/Supplier/"
	Const const_app_BuyerPath = "https://spar.gatewayec.co.za/In/Buyer/"
	Const const_app_XMLDownloadPath = "https://spar.gatewayec.co.za/"
	Const const_app_XMLDownloadOutPath = "https://spar.gatewayec.co.za/tracktrace/supplier/tab/"
	'Const const_app_VirtualPath = "C:\InetPub\wwwroot\SparIn"
	Const const_app_TabFile = "C:\spar\tabfile\"
	Const const_app_TrackPath = "C:\InetPub\wwwroot\sparv2\tracktrace\"
	Const const_app_XMLDownloadTabPath = "C:\spar\tracktrace\supplier\tab\"
	'Const const_app_LocalDrive = "C:\Saved Files\"
	Const const_app_OverwriteMode1 = 0
	Const const_app_OverwriteMode2 = 1
	Const const_app_OverwriteMode3 = 2
	Const const_app_ValidExtentions = "zip,txt,jpg,gif"
	Const const_appMaxUploadSize = 0		' Set to default 0 or else set the value im MB e.g 2048 = 2MB
	Const const_app_MailObject = "CDONTS.NewMail"
	Const const_app_XMLObject = "Microsoft.XMLDom"
	Const const_app_SparInPath = "\\ecintprd\ec-clients\spar\SparIn\"
	Const const_app_SparOutPath = "\\ecintprd\ec-clients\spar\SparOut\"
	Const const_app_SparArcPath = "\\ecintprd\ec-clients\spar\SparOrders\"
	Const const_app_IncludePath = "C:\Inetpub\wwwroot\sparv2\includes\"
	Const const_app_SqlReportsPath = "C:\Inetpub\wwwroot\sparv2\sqlreports\"
	Const Const_ElectronicRemittance_TempSave = "C:\spar\dropship\remittanceadvices\tempsave\"

	
%>