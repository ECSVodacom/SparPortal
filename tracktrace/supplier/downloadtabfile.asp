<%@ Language=VBScript %>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="DownloadFunction.asp"-->
<%
	'Response.AddHeader "content-disposition","attachment; filename='" & Request.QueryString("id") & "'"
	'Response.Redirect const_app_XMLDownloadOutPath & Request.QueryString("id")
	
	FileName = Request.QueryString("id")
	DoDownload FileName, const_app_XMLDownloadTabPath & FileName
%>

