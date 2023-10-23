<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/genmenuitems.asp"-->
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim FolderName
										dim TotPages
										dim Band
										dim RecordCount
										dim MaxRecords
										dim RecordFrom
										dim RecordTo
										dim BandSize
										dim UserID
										dim Selected
										dim UserType
										dim OrdNum
										dim txtSupplier
										dim txtStore
										dim NewDate
										dim IsXML
										dim Folder
										dim txtDC
										dim dcID
										
										if Session("UserType") = 1 or  Session("UserType") = 4 then
											UserID = Session("ProcID")
											UserType = 1
											dcID = Session("DCID")
										else
											UserID = 0
											UserType = 2
											
											if Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE")then
												dcID = 0
											else
												dcID = Session("DCID")
											end if
                                        end if
									
										' Call the menu items generation function
										Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate, IsXML)
										
										' Set the connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="javascript:window.print();">
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/calendar2.js"></script>
<br><br>

<table border="0" cellpadding="2" cellspacing="2" width="100%">
    <tr>
	    <td class="bheader" align="left">Print Schedule</td>
    </tr>
</table>
<%
                                        SQL = "exec procPrintSchedule @ScheduleID=" & request.QueryString("id")
                                            
                                        'response.Write "<br/>"&SQL
                                        'response.End
                                        
                                        Set ReturnSet = ExecuteSql(SQL, curConnection)
                                        
                                        if ReturnSet("returnvalue") <> "0" then
%>
<p class="pcontent">There are no schedules available for the filter criteria above.</p>
<%                                        
                                        else
%>
<br />
<table border="1" cellpadding="0" cellspacing="0" width="100%">
    <tr bgcolor="#4C8ED7">
	    <td class="tdcontent" align="center"><b>File Name</b></td>
	    <td class="tdcontent" align="center"><b>File Size</b></td>
	    <td class="tdcontent" align="center"><b>DC</b></td>
	    <td class="tdcontent" align="center"><b>Supplier</b></td>
	    <td class="tdcontent" align="center"><b>Date Created</b></td>
	    <td class="tdcontent" align="center"><b>Date Validated</b></td>
	    <td class="tdcontent" align="center"><b>Date Released</b></td>
	    <td class="tdcontent" align="center"><b>Date Updated</b></td>
	    <td class="tdcontent" align="center"><b>Total Amount</b></td>
	    <td class="tdcontent" align="center"><b>Number Of Documents</b></td>
	    <td class="tdcontent" align="center"><b>Status</b></td>
	    <td class="tdcontent" align="center"><b>User</b></td>
    </tr>
    <tr>
        <td class="pcontent"><%=ReturnSet("FileName")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("FileSize")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("DCName")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("SupplierName")%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("CreateDate")) then response.Write "-" else response.Write ReturnSet("CreateDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("ValidateDate")) then response.Write "-" else response.Write ReturnSet("ValidateDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("ReleaseDate")) then response.Write "-" else response.Write ReturnSet("ReleaseDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("EditDate")) then response.Write "-" else response.Write ReturnSet("EditDate") end if%></td>
        <td class="pcontent" align="center"><%=ReturnSet("TotalAmt")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("NumberOfDoc")%></td>
        <td class="pcontent" align="left">
<%
                                                if ReturnSet("StatusID") = 4 or ReturnSet("StatusID") = 5 then
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/right.gif" alt="" height="10" width="10"/>
<%
                                                else
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/wrong.gif" alt="" height="10" width="10"/>
<%                                                
                                                end if
%>                                                     
            &nbsp;<%=ReturnSet("StatusDescrip")%>
        </td>
        <td class="pcontent" align="center"><%=ReturnSet("UserName")%></td>
    </tr>
</table>
<%           
                                            Set ReturnSet = Nothing
                                            
                                            SQL = "exec itemSchedule @ScheduleID=" & request.QueryString("id")

                                            Set ReturnSet = ExecuteSql(SQL, curConnection)
%>  
<br/>                                          
<table border="1" cellpadding="0" cellspacing="0" width="100%">
    <tr bgcolor="#4C8ED7">
	    <td class="tdcontent" align="center"><b>Store Code</b></td>
	    <td class="tdcontent" align="center"><b>Store Name</b></td>
	    <td class="tdcontent" align="center"><b>Doc Number</b></td>
	    <td class="tdcontent" align="center"><b>Doc Date</b></td>
	    <td class="tdcontent" align="center"><b>Amount Exclusive</b></td>
	    <td class="tdcontent" align="center"><b>VAT</b></td>
	    <td class="tdcontent" align="center"><b>Amount Inclusive</b></td>
	    <td class="tdcontent" align="center"><b>Invoice Reference</b></td>
	    <td class="tdcontent" align="center"><b>Claim Reference</b></td>
		<td class="tdcontent" align="center"><b>Status</b></td>
    </tr>
<%
                                            While Not ReturnSet.EOF
%>
    <tr>
        <td class="pcontent" align="center"><%=ReturnSet("StoreCode")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("StoreName")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("DocNumber")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("DocDate")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("AmtExcl")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("Vat")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("AmtIncl")%></td>
        <td class="pcontent" align="center"><%If ReturnSet("InvRef") <> "" Then Response.Write(ReturnSet("InvRef")) Else Response.Write("&nbsp;") End If %></td>
        <td class="pcontent" align="center"><%If ReturnSet("ClaimRef") <> "" Then Response.Write(ReturnSet("ClaimRef")) Else Response.Write("&nbsp;") End If %></td>
        <td class="pcontent" align="center">
<%
                                                if ReturnSet("DetailStatusID") = 4 or ReturnSet("DetailStatusID") = 5 then
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/right.gif" alt="" height="10" width="10"/>
<%
                                                else
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/wrong.gif" alt="" height="10" width="10"/>
<%                                                
                                                end if
%>                                                
            &nbsp;<%=ReturnSet("DetailStatusDescrip")%>
        </td>
    </tr>

<%                                            
                                                ReturnSet.MoveNext
                                            Wend
%>        
    </table>                                            
<%                      
                                        end if
                                        
                                        curConnection.Close
										Set curConnection = Nothing       
%>
<!--#include file="../../layout/end.asp"-->
