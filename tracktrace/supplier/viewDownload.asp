<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%

    Dim rid
    rid = Request.QueryString("rid")

				
										
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		window.parent.opener.top.location.href = "<%=const_app_ApplicationRoot%>";
		close();
	};

    function onDropdownChange()
    {
    
        if (document.getElementById("ReportType").value == 'FullReport')
        {
            document.getElementById("ReportSeperator").style.visibility = 'hidden';
            document.getElementById("lblDownloadTo").style.visibility = 'hidden';
        }
        else
        {
            document.getElementById("ReportSeperator").style.visibility = 'visible';
            document.getElementById("lblDownloadTo").style.visibility = 'visible';
        }
    };

    
-->
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SPAR</title>
</head>
<body onload="javascript:onDropdownChange()"></body>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="FrmTmp" id="FrmTmp" method="post" action="<%=const_app_ApplicationRoot%>/tracktrace/supplier/doDownload.asp">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">DOWNLOAD OPTIONS</td>
        </tr>
    </table>
    
    
    
    <table class="pcontent" border="0">
        <tr>&nbsp;</tr>
        <tr>
            <td style="width: 100px; height: 21px" class="pcontent">Report Type</td>
            <td style="width: 102px; height: 21px">
                <select onchange="javascript:onDropdownChange()" class="pcontent" name="ReportType" id="ReportType" style="width: 200px; height: 22px">
                    <option value="DetailLines">Detail lines</option>
					<option value="FullReport">XML Document</option>
                </select>
            </td>
        </tr>
        <tr>
            <td style="width: 100px" id="lblDownloadTo">
                Download to</td>
            <td style="width: 102px">
                <select class="pcontent" name="ReportSeperator" style="width: 200px" id="ReportSeperator" >
                    <option class="pcontent" id="CSV" value="CSV">Comma seperated values</option>
                    <option class="pcontent" id="PIPE" value="PIPE">Pipe delimited</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>&nbsp</td>
        </tr>
        <tr>
            <td>&nbsp</td>
            <td style="width: 102px">
        
            <input class="button" type="submit" style="width: 98px" value="Download"/></td>
        </tr>
    </table>
    
    <input type="hidden" name="rid" id="rid" value="<%=rid%>">
</form>

