<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/genmenuitems.asp"-->
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim DCSet
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
										dim cnt
										
										
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
                                        
                                        Session("Date")= LZ(Month(now())) & "/" & LZ(Day(now())) & "/" & Year(now())
									
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
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};

	function validate(obj) {
		// Check if the user selected a search type
		if (obj.drpType.value == '-1') {
			window.alert('You have to select a search type.');
			obj.drpType.focus();
			return false;
		};
		
		// Check if this is a valid date
		if (obj.txtDate.value!='') {
			if (chkdate(obj.txtDate) == false) {
				obj.txtDate.select();
				window.alert('Please enter a valid date.');
				obj.txtDate.focus();
				return false;
			};
		};
	};
//-->
</script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/calendar2.js"></script>

<form name="frmFilter" id="frmFilter" method="post" action="default.asp" onsubmit="return validate(this);">
    <table border="0" cellpadding="2" cellspacing="2" width="100%">
	    <tr>
		    <td class="bheader" align="left">Schedule Detail</td>
	    </tr>
    </table><br />
<%
										SQL = "exec itemSchedule @ScheduleID=" & request.QueryString("id")
										
										'response.Write SQL
										'response.End
										
										Set ReturnSet = ExecuteSql(SQL, curConnection)
										
										if ReturnSet("returnvalue") <> "0" then
%>
   <p class="pcontent">The selected schedule does not exist. Please try again by selecting another one.</p>
<%										
										else
%>
    <table border="0" cellpadding="2" cellspacing="2" width="100%">
        <tr>
		    <td class="pcontent"><b>DC:</b></td>
		    <td>
			    <select name="drpDC" id="drpDC" class="pcontent">
<%
										    if dcID = 0 then
%>				
					    <option value="0">-- Select a DC --</option>
<%
										    end if

										    ' Get a list of Stores
										    Set DCSet = ExecuteSql("listDC @DC=" & ReturnSet("DCID"), curConnection)   
    													
										    Selected = ""
    													
										    ' Loop through the recordset
										    While not DCSet.EOF
											    if DCSet("DCID") = ReturnSet("DCID") Then
												    Selected = "selected"
											    else
												    Selected = ""
											    end if
%>
					    <option <%=selected%> value="<%=DCSet("DCID")%>"><%=DCSet("DCcName")%></option>
<%											
											    DCSet.MoveNext
										    Wend
    													
										    ' Close the Connection and RecordSet
										    Set DCSet = Nothing
%>									
			    </select>
		    </td>
		    <td>&nbsp;</td>
		    <td class="pcontent" align="right">
		        <table border="0" cellpadding="2" cellspacing="2">
		            <tr>
		                <td class="pcontent"><input type="button" id="btnPrint" value="Print" class="button" onclick="javascript:window.print();"/></td>
		                <td class="pcontent"><input type="button" id="btnValidate" value="Validate" class="button" /></td>
		                <td class="pcontent"><input type="button" id="btnReject" value="Reject" class="button" /></td>
		                <td class="pcontent"><input type="button" id="btnRelease" value="Release" class="button" /></td>
		            </tr>
		        </table>
		    </td>
        </tr>
    </table><br />
    <table border="1" cellpadding="0" cellspacing="0" width="100%">
    <tr bgcolor="#4C8ED7">
	    <td class="tdcontent" align="center"><b>Store Code</b></td>
	    <td class="tdcontent" align="center"><b>Store Name</b></td>
	    <td class="tdcontent" align="center"><b>Doc Number</b></td>
	    <td class="tdcontent" align="center"><b>Doc Date</b></td>
	    <td class="tdcontent" align="center"><b>Amount Exclusive</b></td>
	    <td class="tdcontent" align="center"><b>VAT</b></td>
	    <td class="tdcontent" align="center"><b>Amount Inclusive</b></td>
	    <td class="tdcontent" align="center"><b>Status</b></td>
    </tr>
<%
                                            cnt = 0
                                            While Not ReturnSet.EOF
                                                cnt = cnt + 1
%>
    <tr>
        <td class="pcontent" align="center"><input type="text" id="txtStoreCode<%=cnt%>" value="<%=ReturnSet("StoreCode")%>" class="pcontent" size="20"/></td>
        <td class="pcontent" align="center"><input type="text" id="txtStoreName<%=cnt%>" value="<%=ReturnSet("StoreName")%>" class="pcontent" size="60"/></td>
        <td class="pcontent" align="center"><input type="text" id="txtDocNumber<%=cnt%>" value="<%=ReturnSet("DocNumber")%>" class="pcontent" /></td>
        <td class="pcontent" align="center"><input type="text" id="txtDocDate<%=cnt%>" value="<%=ReturnSet("DocDate")%>" class="pcontent" /></td>
        <td class="pcontent" align="center"><input type="text" id="txtAmtExcl<%=cnt%>" value="<%=ReturnSet("AmtExcl")%>" class="pcontent" /></td>
        <td class="pcontent" align="center"><input type="text" id="txtVat<%=cnt%>" value="<%=ReturnSet("Vat")%>" class="pcontent" /></td>
        <td class="pcontent" align="center"><input type="text" id="txtAmtIncl<%=cnt%>" value="<%=ReturnSet("AmtIncl")%>" class="pcontent" /></td>
        <td class="pcontent" align="center"><%=ReturnSet("StatusDescrip")%></td>
    </tr>

<%                                            
                                                ReturnSet.MoveNext
                                            Wend
%>        
    </table>
<%										
										
										end if
										
										Set ReturnSet = Nothing
                                
                                        curConnection.Close
										Set curConnection = Nothing       
%>
</form>
<!--#include file="../../layout/end.asp"-->
