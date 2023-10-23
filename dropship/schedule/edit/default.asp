<%@Language="VBScript"%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/genmenuitems.asp"-->
<!--#include file="../../includes/schedulefunctions.asp"-->
<!--#include file="PostToBiz.asp"-->
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
										dim line
										dim errCnt
										dim ReturnVal
										dim isDCAllowedToChangeClaimNumber
										Dim WarningCount
										Dim ErrorCount
										Dim ScheduleId
										
										ScheduleId = Request.QueryString("id")
										
										WarningCount = 0
										
										if Session("UserType") = 1 or  Session("UserType") = 4 then
											UserID = Session("ProcID")
											UserType = 1
											dcID = Session("DCID")
										else
											UserID = Session("UserID")
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
										curConnection.ConnectionTimeout=90
										curConnection.Open const_db_ConnectionString

										' Check if the user clicked on any of the action buttons
										if request.Form("hidAction") <> "0" then
										    errCnt = 0

									    
									        select case request.Form("hidAction")
									            case "1"
									                ' Update the schedule + status
									                for line = 1 to request.Form("hidTotalLine")
									                    SQL = "editScheduleDetail @DetailID=" & request.Form("hidDetailID" & line) & _
									                        ", @StoreCode='" & request.Form("txtStoreCode" & line) & _
									                        "', @DCID=" & request.Form("drpDC") & _
									                        ", @AmtIncl=" & Replace(request.Form("txtAmtExcl" & line),",",".") & _
									                        ", @Vat=" & Replace(request.Form("txtVat" & line),",",".") &_
									                        ", @AmtExcl=" &  Replace(request.Form("txtAmtIncl" & line),",",".") &_
															", @ScheduleIsReward=" &  request.Form("hidIsReward" & line) &_
															", @ScheduleIsStamps=" &  request.Form("hidIsStamps" & line)
										               
									                     Set ReturnSet =  curConnection.Execute(SQL) 
										                 
									                     if ReturnSet("returnvalue") <> "0" then
									                        errCnt = errCnt + 1
									                     end if
										                 
									                     Set ReturnSet = Nothing
									                 next
									                 response.write SQL
									                 ' Update the header record
									                 Set ReturnSet = curConnection.Execute("editSchedule @ScheduleID=" & request.QueryString("id") & ", @DCID=" & request.Form("drpDC")) 
									                 
									                 Set ReturnSet = Nothing
									            case "2"
										            ' Update the reject status
										            Set ReturnSet = curConnection.Execute("editScheduleStatus @ScheduleID=" & request.QueryString("id") & ", @StatusID=6")
										            
										            if ReturnSet("returnvalue")  <> "0" then
										                errCnt = errCnt + 1
										            end if
										            
										            Set ReturnSet = Nothing
									            case "3"
													' Release to DC
													' Spar Schedules Go live	
													'If Session("DcId") = 8 And False Then 
													'response.write Session("DcId") = 8
													'or Session("DcId") = 5 
													If Session("DcId") = 8 or Session("DcId") = 1 or Session("DcId") = 2 or Session("DcId") = 3 or Session("DcId") = 4 or Session("DcId") = 5 or Session("DcId") = 9 then
														ReturnVal =  DoPost(request.QueryString("id"), Request.Form("ScheduleFileName"))
													Else
														ReturnVal = ProcessReleaseMessage(curConnection, request.QueryString("id"), const_app_schedOutDir)
													End If
                                                case "4"
                                                    ReturnVal = GenCSVSavedFile(curConenction, request.QueryString("id"), const_app_schedOutDir)
                                                
									        end select
										end if
										

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
	
    function confirmSubmit()
    {
        var agree=confirm("Are you sure you wish to release this schedule?");
        if (agree)
        {
            document.frmFilter.hidAction.value=3;
            document.frmFilter.submit();
	        return true;
	    }
        else
	        return false;
	    
    }

//-->
</script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/calendar2.js"></script>

<form name="frmFilter" id="frmFilter" method="post" action="default.asp?id=<%=request.querystring("id")%>&amp;statusid=<%=request.querystring("statusid")%>" onsubmit="return validate(this);">
    <table border="0" cellpadding="2" cellspacing="2" width="100%">
	    <tr>
		    <td class="bheader" align="left">Schedule Detail</td>
	    </tr>
    </table><br />
<%										
                                        
										select case CInt(request.Form("hidAction"))
                                            case 1
                                                if errCnt > 0 then
%>
    <p class="pcontent">Some errors occured during the update of the schedule. See the line status below.</p>
<%                                        
                                                else
%>
    <p class="pcontent">The schedule was successfully updated.</p>
<%                                                                                           
                                                end if
                                            case 2
                                                if errCnt > 0 then
%>
    <p class="pcontent">An error occured while trying to reject this schedule. Please try again.</p>
<%                                                                                        
                                                else
%>
    <p class="pcontent">This schedule was successfully rejected.</p>
<%                                                                                                                                        
                                                end if
                                            case 3
                                        end select

										SQL = "exec itemSchedule @ScheduleID=" & request.QueryString("id")
										
										'response.Write SQL
									    'response.End
										
										Set ReturnSet = curConnection.Execute(SQL)
										
										if ReturnSet("returnvalue") <> "0" then
%>
   <p class="pcontent">The selected schedule does not exist. Please try again by selecting another one.</p>
<%										
										else
											ScheduleName = ReturnSet("FileName")
										
										'response.Write ReturnSet("DetailStatusID")
%>
    <table border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr>
			<td class="pcontent"><b>FileName:</b></td>
			<td class="pcontent"><%=ReturnSet("FileName")%></td>
        </tr>
        <tr>
			<td class="pcontent"><b>Supplier:</b></td>
			<td class="pcontent"><%=ReturnSet("SupplierName")%></td>
        </tr>
		<tr>
			<td class="pcontent"><b>DC Vendor:</b></td>
			<td class="pcontent"><%=ReturnSet("VendorCode")%></td>
        </tr>
        <tr>
			<td class="pcontent"><b>Date Created:</b></td>
			<td class="pcontent"><%=ReturnSet("CreateDate")%></td>
        </tr>
        <tr>
			<td class="pcontent"><b>Total Amount:</b></td>
			<td class="pcontent"><%=ReturnSet("TotalAmt")%></td>
        </tr>
        <tr>
			<td class="pcontent"><b>Number of docs:</b></td>
			<td class="pcontent"><%=ReturnSet("NumberOfDoc")%></td>
        </tr>
			<td class="pcontent"><b>Schedule Type:</b></td>
			<td class="pcontent">
			<%
				If ReturnSet("IsReward") Then 
					Response.Write "Reward"
				ElseIf ReturnSet("IsStamps") Then 
					Response.Write "Stamps"
				ElseIf ReturnSet("IsAdmin") Then 
					Response.Write "Admin"
				ElseIf ReturnSet("IsForceCredit") Then 
					Response.Write "Force Credit"
				Else 
					Response.Write "Normal"
				End If
			%>
			</td>
        </tr>			 
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
										    Set DCSet = curConnection.Execute("exec listDC @DC=" & dcID)  
    													
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
	 	<% If ReturnSet("SHiStatusID") = "5" Or ReturnSet("SHiStatusID") = "34" Then %>
					<td>	<input type="image" src="recycle.png" alt="Resend Schedule" onclick="javascript:confirmSubmit();" height="21" width="21"></td>
						<% End If %>
		    		    <td class="pcontent"><input type="button" id="btnPrint" value="Print Schedule" class="button" onclick="javascript:window.open('<%=const_app_ApplicationRoot%>/schedule/edit/print.asp?id=<%=request.querystring("id")%>','Print','width=900,height=700,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"/></td>
						 <!--<td class="pcontent"><input type="button" id="btnPrint" value="Print by Store" class="button" onclick="javascript:window.open('<%=const_app_ApplicationRoot%>/schedule/reports/default.aspx?id=<%=request.querystring("id")%>','Print','');"/></td>-->

		               <!-- <td class="pcontent"><input type="button" id="btnPrint" value="Print" class="button" onclick="javascript:window.open('<%=const_app_ApplicationRoot%>/schedule/edit/print.asp?id=<%=request.querystring("id")%>','Print','width=900,height=700,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"/></td>-->
<%
                                            if ReturnSet("DetailStatusID") <> "5" and ReturnSet("DetailStatusID") <> "6" and (request.QueryString("statusid") <> "3" or request.QueryString("statusid") <> "5" or request.QueryString("statusid") <> "6") then
%>		                		                
		                <td class="pcontent"><input type="button" id="btnEdit" value="Update / Validate" class="button" onclick="javascript:document.frmFilter.hidAction.value=1; document.frmFilter.submit();"/></td>
<%
                                            end if
                                            
                                            if ReturnSet("DetailStatusID") <> "5" and ReturnSet("DetailStatusID") <> "6" and (request.QueryString("statusid") <> "5" or request.QueryString("statusid") <> "6") then
%>		                    		                
		                <td class="pcontent"><input type="button" id="btnReject" value="Reject" class="button" onclick="javascript:document.frmFilter.hidAction.value=2; document.frmFilter.submit();"/></td>
<%
                                            end if
%>		                
		                <td class="pcontent">
<%
                                            If UserType = 2 Then
                                                ' If the schedule contains error, no schedule should be able to be "Released to DC"
												' If ReturnSet("DetailStatusID") = "4" Then
												If ReturnSet("SHiStatusID") = "4"  Then
												
													If  ReturnSet("IsAdmin") Then
												
%>

								<input type="button"  id="btnRelease" value="Release for Matching" onclick="javascript:confirmSubmit();"  class="button"  />
						

								
<%
													Else
													%>

								<input type="button"  id="btnRelease" value="Release to DC" onclick="javascript:confirmSubmit();"  class="button"  />
						

								
<%
													End If

												 ElseIf  ReturnSet("SHiStatusID") = "777"   Then
												%>
												<div id="release"></div>
												
												
												<%
                                                End If
												
												
											
												' The schedule can now be released if the DetailStatusID IN (30,31,32,18)
												
												
                                            End If
%>		                  
		                    <input type="hidden" name="hidAction" id="hidAction" value="0" />
		                </td>
		                <td class="pcontent"><input type="button" id="btnSave" value="Save" class="button" onclick="javascript:window.open('<%=const_app_ApplicationRoot%>/schedule/edit/exporttoexcel.asp?id=<%=request.querystring("id")%>','ExportRpt','');"/></td>
						<td class="pcontent"><input type="button" id="btnClose" value="Close" class="button" onclick="try { window.opener.document.getElementById(name='btnSubmit').click(); } finally { window.open('close.html', '_self');}"/></td>
		                <!--<td class="pcontent"><input type="button" id="btnClose" value="Close" class="button" onclick="javascript:opener.location.reload();window.close();"/></td>-->
		            </tr>
		        </table>
		    </td>
        </tr>
    </table><br />
    <table border="1" cellpadding="0" cellspacing="2" width="100%">
    <tr bgcolor="#4C8ED7">
	    <td class="tdcontent" align="center"><b>Store Code</b></td>
	    <td class="tdcontent" align="center"><b>Store Name</b></td>
	    <%
			If ReturnSet("IsReward") Then
		%>
			<td class="tdcontent" align="center"><b>Credit Note Number</b></td>
		<%
			ElseIf ReturnSet("IsStamps") Then
			
		%>
			<td class="tdcontent" align="center"><b>Transaction ID</b></td>
		<%
			Else
		%>
		<td class="tdcontent" align="center"><b>Doc Number</b></td>
	    <%
			End If
		%>
		
		  <%
			If ReturnSet("IsReward") Then
		%>
			<td class="tdcontent" align="center"><b>Campaign End Date</b></td>
		<%
			ElseIF ReturnSet("IsReward") Then
		%>
			<td class="tdcontent" align="center"><b>End Date</b></td>
		<%
		
			Else
		%>
		<td class="tdcontent" align="center"><b>Doc Date</b></td>
	    <%
			End If
		%>
		
	    <td class="tdcontent" align="center"><b>Amount Exclusive</b></td>
	    <td class="tdcontent" align="center"><b>VAT</b></td>
	    <td class="tdcontent" align="center"><b>Amount Inclusive</b></td>
	    <td class="tdcontent" align="center"><b>Invoice Reference</b></td>
	    <td class="tdcontent" align="center"><b>Claim Reference</b></td>

		<%
			If ReturnSet("IsReward") Then
		%>
		<td class="tdcontent" align="center"><b>Campaign Name</b></td>
		<td class="tdcontent" align="center"><b>Basket Name</b></td>
		<%
			ElseIf ReturnSet("IsStamps") Then	
		%>
		<td class="tdcontent" align="center"><b>TransactionType</b></td>
		<%
		
			End If
		%>
		<td class="tdcontent" align="center"><b>Status</b></td>
    </tr>
<%
                                            cnt = 0
                                            While Not ReturnSet.EOF
                                                cnt = cnt + 1
%>
    <tr>
        <td class="pcontent" align="center"><input type="text" name="txtStoreCode<%=cnt%>" id="txtStoreCode<%=cnt%>" value="<%=ReturnSet("StoreCode")%>" class="pcontent" size="8" /></td>
        <td class="pcontent" align="center"><%=ReturnSet("StoreName")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("DocNumber")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("DocDate")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("AmtExcl")%><input type="hidden" name="txtAmtIncl<%=cnt%>" id="txtAmtIncl<%=cnt%>" value="<%=ReturnSet("AmtExcl")%>" class="pcontent" size="8" /></td>
        <td class="pcontent" align="center"><%=ReturnSet("Vat")%><input type="hidden" name="txtVat<%=cnt%>" id="txtVat<%=cnt%>" value="<%=ReturnSet("Vat")%>" class="pcontent" size="8" /></td>
        <td class="pcontent" align="center"><%=ReturnSet("AmtIncl")%><input type="hidden" name="txtAmtExcl<%=cnt%>" id="txtAmtExcl<%=cnt%>" value="<%=ReturnSet("AmtIncl")%>" class="pcontent" size="8" />
            <input type="hidden" name="hidDetailID<%=cnt%>" id="hidDetailID<%=cnt%>" value="<%=ReturnSet("DetailID")%>" />
			<input type="hidden" name="hidIsReward<%=cnt%>" id="hidIsReward<%=cnt%>" value="<%=ReturnSet("IsReward")%>" />
			<input type="hidden" name="hidIsStamps<%=cnt%>" id="hidIsStamps<%=cnt%>" value="<%=ReturnSet("IsStamps")%>" />
        </td>
        
        <td class="pcontent" align="center"><%If ReturnSet("InvRef") <> "" Then Response.Write(ReturnSet("InvRef")) Else Response.Write("&nbsp;") End If %></td>
        <td class="pcontent" align="center"><%If ReturnSet("ClaimRef") <> "" Then Response.Write(ReturnSet("ClaimRef")) Else Response.Write("&nbsp;") End If %></td>
		
		<%
			If ReturnSet("IsReward") Then
		%>
		<td class="pcontent" align="center"><%If ReturnSet("SDcCampainName") <> "" Then Response.Write(ReturnSet("SDcCampainName")) Else Response.Write("&nbsp;") End If %></td>
		<td class="pcontent" align="center"><%If ReturnSet("SdcBasketNo") <> "" Then Response.Write(ReturnSet("SdcBasketNo")) Else Response.Write("&nbsp;") End If %></td>
		
		<%
			ElseIf  ReturnSet("IsStamps") Then
		%>
		<td class="pcontent" align="center"><%If ReturnSet("SDcTransactionType") <> "" Then Response.Write(ReturnSet("SDcTransactionType")) Else Response.Write("&nbsp;") End If %></td>
		<%
		
			End If
		%>
       <td class="pcontent" align="center">
<%
                                                if ReturnSet("DetailStatusID") = 4 or ReturnSet("DetailStatusID") = 5 or ReturnSet("DetailStatusID") = 34  then
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/right.gif" alt="" height="10" width="10"/>
<%
                                                elseif (ReturnSet("DetailStatusID") = 30 or ReturnSet("DetailStatusID") = 31 or ReturnSet("DetailStatusID") = 18) And Not (IsForceCredit Or IsReward Or IsStamps )  Then
													WarningCount = WarningCount + 1
												
												%>
            
			<img src="<%=const_app_ApplicationRoot%>/layout/images/warning.gif" alt="" height="10" width="10"/>
			
<%          									else
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/wrong.gif" alt="" height="10" width="10"/>
			
<%   
													ErrorCount = ErrorCount + 1

                                      
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
	<input type="hidden" name="hidTotalLine" id="hidTotalLine" value="<%=cnt%>" />
	<input type="hidden" name="ScheduleFileName" id="ScheduleFileName" value="<%=ScheduleName%>" />

<%										
										
										end if
										
										Set ReturnSet = Nothing
                                
                                        curConnection.Close
										Set curConnection = Nothing       
										
										ErrorCount = 0
%>
</form>

<!--#include file="../../layout/end.asp"-->
