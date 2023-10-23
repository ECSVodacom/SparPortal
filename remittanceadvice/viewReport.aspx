<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="viewReport.aspx.cs" Inherits="RemittanceAdvice.viewReport" %>


<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=15.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Electronice Remittance Advice</title>
</head>
<body>
    <form id="form1" runat="server">
        <table>
            <tr id="RemittanceAdvice">
                <td class="style1" style="font-size: 16px; font-style: normal; font-family: Arial, Helvetica, sans-serif"><b>Remittance Advice</b>
                </td>
                <td>
                    <asp:ImageButton ID="ImageButton1" runat="server" title="Export To PDF" src="icons/images_acrobat_icon.gif" OnClick="PrintRemittanceAdvice" Style="height: 32px; width: 32px; border-width: 0px;" />
                </td>
            </tr>
            <tr runat="server" id="tableRowTaxInvoice">
                <td class="style1" style="font-size: 16px; font-style: normal; font-family: Arial, Helvetica, sans-serif"><b>Tax Invoice</b></td>
                <td>
                    <asp:ImageButton ID="ImageButton2" runat="server" title="Export To PDF" src="icons/images_acrobat_icon.gif" OnClick="PrintTaxInvoice" Style="height: 32px; width: 32px; border-width: 0px;" />
                </td>
            </tr>
            <tr runat="server" id="tableRowCreditNote">
                <td class="style1" style="font-size: 16px; font-style: normal; font-family: Arial"><b>Discount Advice</b></td>
                <td>
                    <asp:ImageButton ID="ImageButton3" runat="server" title="Export To PDF" src="icons/images_acrobat_icon.gif" OnClick="PrintCreditNote" Style="height: 32px; width: 32px; border-width: 0px;" />
                </td>
            </tr>
        </table>
        <div>
            <rsweb:reportviewer id="ReportViewer1" runat="server" processingmode="Local" font-names="Verdana"
                font-size="8pt" waitmessagefont-names="Verdana" waitmessagefont-size="14pt"
                Width="1920px" Height="1080px" asyncrendering="False" enabletelemetry="false" showprintbutton="false" showexportbutton="false" enableeventvalidation="False" showrefreshbutton="False">
            </rsweb:reportviewer>
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
        </div>
    </form>
</body>
</html>
