<%@ page language="C#" autoeventwireup="true" inherits="_Default, App_Web_764phjys" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<script language="javascript" type="text/javascript">
function OpenNewWindow(url)
{
    window.open(url);
}
</script>
<head runat="server">
    <title>Electronic Remittance Advice</title>
    <style type="text/css">
        .style1
        {
            font-family: Arial;
            font-size: medium;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <table>
            <tr>
            <td class="style1">Remittance Advice</td>
                <td><asp:ImageButton runat="server" OnClick="exportToPDF_Click" 
                        ToolTip="Export To PDF" ImageUrl="~/icons/images_acrobat_icon.gif" 
                        Width="32" Height="32" ImageAlign="Middle"></asp:ImageButton></td>
                <td><asp:ImageButton ID="exportToTIFF" runat="server" OnClick="exportToTIFF_Click" ToolTip="Export To TIFF" ImageUrl="~/icons/TIF.ico" Width="32" Height="32" ImageAlign="Middle"></asp:ImageButton></td>
                <td><asp:ImageButton ID="exportToWebArchive" runat="server" OnClick="exportToWebArchive_Click" ToolTip="Export To Web Archive" ImageUrl="~/icons/HTML.ico" Width="32" Height="32" ImageAlign="Middle"></asp:ImageButton></td>
            </tr>
            <asp:TableRow ID="TaxInvoice" runat="server" 
                    style="font-size: medium; font-family: Arial; font-weight: 700">
                <asp:TableCell>Tax Invoice</asp:TableCell>
                <asp:TableCell><asp:ImageButton ID="exportTaxInvoiceToPDF" runat="server" 
                        ToolTip="Export To PDF" ImageUrl="~/icons/PDF.ico" Width="32" Height="32"
                        ImageAlign="Middle" onclick="exportTaxInvoiceToPDF_Click"></asp:ImageButton></asp:TableCell>
                <asp:TableCell><asp:ImageButton ID="exportTaxInvoiceToTIFF" runat="server" 
                        ToolTip="Export To TIFF" ImageUrl="~/icons/TIF.ico" Width="32" Height="32"
                        ImageAlign="Middle" onclick="exportTaxInvoiceToTIFF_Click"></asp:ImageButton></asp:TableCell>
                <asp:TableCell><asp:ImageButton ID="exportTaxInvoiceToWebArchive" runat="server" 
                        ToolTip="Export To Web Archive" ImageUrl="~/icons/HTML.ico" Width="32"
                        Height="32" ImageAlign="Middle" onclick="exportTaxInvoiceToWebArchive_Click"></asp:ImageButton></asp:TableCell>
            </asp:TableRow>
        </table>
    <table cellpadding="0" cellspacing="1">
        <tr>
            <td style="height:1000px; width:1600px" rowspan="10">
                <rsweb:ReportViewer ID="ReportViewer1" runat="server" ProcessingMode="Remote" 
                                Height="900px" Width="100%" ZoomMode="Percent" 
                    ShowCredentialPrompts="False" ShowParameterPrompts="False" 
                    ShowExportControls="False" ShowPrintButton="False">
                    <ServerReport ReportServerUrl="http://196.38.104.211/Reports$EC_DATA_SERVER" />
                </rsweb:ReportViewer>
                <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
    </form>
</body>
</html>
