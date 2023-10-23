<%@ Register TagPrefix="CR" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Print Schedule</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <CR:CrystalReportViewer ID="ReportViewer" runat="server" AutoDataBind="true" HasCrystalLogo="False" ShowAllPageIds="True" GroupTreeStyle-BorderStyle="Dashed" GroupTreeStyle-BorderWidth="1px" Height="50px" Width="350px" GroupTreeStyle-Font-Bold="True" GroupTreeStyle-Font-Names="Arial Narrow" GroupTreeStyle-Font-Size="Smaller" />
        <CR:CrystalReportSource ID="CrystalReportSource1" runat="server">
            <Report FileName="CrystalReport1.rpt">
            </Report>
        </CR:CrystalReportSource>
    
    </div>
    </form>
</body>
</html>
