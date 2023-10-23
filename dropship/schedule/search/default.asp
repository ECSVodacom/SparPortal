<%@Language=VBScript%>
<%OPTION EXPLICIT%>
<%Response.Buffer=False%> 
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
										dim StatusID
										Dim IsForceCredit, hidCurrentPageNumber, HiddenSupplier
										Dim IsRewards,IsStamps

										If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
											IsForceCredit = CBool(Request.Form("IsForceCredit"))
											IsRewards = CBool(Request.Form("IsRewards"))
											IsStamps = CBool(Request.Form("IsStamps"))
											
										Else
											If Request.QueryString("fc") <> "" Then
												IsForceCredit = CBool(Request.QueryString("fc"))
												IsRewards = False
												IsStamps = False
											ElseIf Request.QueryString("rw") <> "" Then
												IsRewards = CBool(Request.QueryString("rw"))
												IsForceCredit = False
												IsStamps = False
											ElseIf Request.QueryString("st") <> "" Then
												IsStamps = CBool(Request.QueryString("st"))
												IsRewards = False
												IsForceCredit = False	
											End If
										End If
										
										
										
										Dim IsForceCreditNumeric 
										If IsForceCredit Then
											IsForceCreditNumeric = 1
										Else
											IsForceCreditNumeric = 0
										End If
										
										'Rewards
										Dim IsRewardsNumeric
										If IsRewards then
											IsRewardsNumeric = 1
										Else
											IsRewardsNumeric = 0
										End IF
										
										'Stamps
										Dim IsStampsNumeric
										If IsStamps then
											IsStampsNumeric = 1
										Else
											IsStampsNumeric = 0
										End IF
									
									
									
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
										
										If Request.Form("drpDC") <> "" Then
											dcID = Request.Form("drpDC")
										End If
										
										StatusID = 0
										
								
										
										'Session("Date")= LZ(Month(now())) & "/" & LZ(Day(now())) & "/" & Year(now())
										Session("Date")= ""
									
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
		return true;
	};
	
	function partialSupSearch(){
		if (document.frmFilter.elements['txtPartialSup'].value==''){
			window.alert('You have to enter partial supplier name.');
			document.frmFilter.elements['txtPartialSup'].focus();
			return false;	
		}
		var parNameSearch = document.frmFilter.elements['txtPartialSup'].value;
		var dcId = document.frmFilter.elements['drpDC'].value;
		window.open('../../search/partial_search.asp?value=' + parNameSearch + '&type=ScheduleList&fc=<%=IsForceCredit%>&rw=<%=IsRewards%>&id='+dcId,'PartialSearch', 'width=600,height=400,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');
	}

	function setSupplierSelectedVal() {
		// Set the selected supplier index
		if (document.frmFilter.elements['txtPartialSup'] != null)
			document.frmFilter.elements['txtPartialSup'].value = '';
		
		if (document.frmFilter.elements['hidSupplier'] != null)
			document.frmFilter.elements['hidSupplier'].value = document.frmFilter.drpSupplier.options[document.frmFilter.elements['drpSupplier'].selectedIndex].value;
	}
	
	function SetPage(pagenumber)
	{
		document.frmFilter.elements['hidCurrentPageNumber'].value = pagenumber;
		window.document.frmFilter.submit();
	}
//-->
</script>
  <% If  Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE") Then%>
<script type="text/javascript" src="../../includes/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8">
$(function(){
	$("select#drpDC").change(function(){
		$.getJSON("../../includes/JQueryDataSetSuppliers.asp",{id: $(this).val(), IsStampsNumeric: <%=IsStampsNumeric%>,IsRewardsNumeric: <%=IsRewardsNumeric%>, IsForceCreditNumeric:<%=IsForceCreditNumeric%>}, function(j){
			var options = '';
			
			for (var i = 0; i < j.length; i++) {
				if ( j[i].optionValue == -1) {
					options += '<option value="-1,-- Select a Supplier --<,-1">-- Select a Supplier --</option>'
				}
				else {
					options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + ',' + j[i].optionVendorCode + '">' + j[i].optionDisplay + '</option>'
				}
			}
			$('#drpSupplier').html(options);
			$('#drpSupplier option:first').attr('selected', 'selected');
			$('#hidSupplier').val(j[0].optionValue);
			$("#txtPartialSup").val('');
		})

	})		

	
})
</script>
<% End If %>

<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background=""  onload="setSupplierSelectedVal();"	>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/calendar2.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	

		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>
<script>
/*$(function() {
	$("#drpSupplier").combobox();
});*/
</script>
<br><br>

<form autocomplete = "off" name="frmFilter" id="frmFilter" method="post" action="default.asp" onsubmit="return validate(this);" >
    <table border="0" cellpadding="2" cellspacing="2" width="100%">
	    <tr>
			<% If IsForceCredit  Then %>
				<td class="bheader" align="left">List Force Credits &amp; Reversals</td>
			
			<% elseIf IsRewards then %>
				<td class="bheader" align="left" colspan="2">List Rewards Schedule<br /><br /></td>
			<%ElseIf IsStamps Then%>
				<td class="bheader" align="left" colspan="2">List SPAR Stamps<br /><br /></td>
			<% Else %>
				<td class="bheader" align="left">List Schedules</td>
			<% End If %>
	    </tr>
    </table>
	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent" colspan="4">Select from the filter below and click on the "Filter" button.<br/>
			<b>Note:</b> That the more filter options you select, the faster the page will load.<br/><br/>
			</td>
		</tr>
		<tr>
			<td class="pcontent"><b>DC:</b></td>
			<td>
				<select name="drpDC" id="drpDC" class="pcontent">
<%
										if Session("dcID") = 0 then
%>				
					<option selected value="0">-- Select a DC --</option>
<%
										end if

										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
													
										' Get a list of Stores
										Set ReturnSet = ExecuteSql("listDC @DC=" & Session("dcID"), curConnection) 

										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											'if Session("DCID") = ReturnSet("DCID") Then
											if CInt(Request.Form("drpDC")) = ReturnSet("DCID") Then
												Selected = "selected"
											else
												Selected = ""
											end if
%>
					<option <%=Selected%> value="<%=ReturnSet("DCID")%>"><%=ReturnSet("DCcName")%></option>
<%											
											ReturnSet.MoveNext
										Wend
													
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>									
				</select>
			</td>
			<td class="pcontent"><b>Supplier:</b></td>
			<td>
				<select name="drpSupplier" id="drpSupplier" class="pcontent" onchange="setSupplierSelectedVal();">
					<%
							' Set a connection
						Set curConnection = Server.CreateObject ("ADODB.Connection")
						curConnection.Open const_db_ConnectionString
												
						' Get a list of Stores
					If Request.Form("hidSupplier") <> "" Then
						HiddenSupplier = Request.Form("hidSupplier")
					Else
						HiddenSupplier = "-1"
					End If
						
					Set ReturnSet = ExecuteSql("listScheduleSupplier @SupplierID=" & UserId  & ", @DCId=" &  dcID & ", @HiddenIsForceCredit=" & IsForceCreditNumeric & ", @IsRewardsNumeric=" & IsRewardsNumeric & ", @IsStampsNumeric=" & IsStampsNumeric, curConnection) 

					If Not (ReturnSet.EOF And ReturnSet.BOF) Then
					
						If Session("UserType") <> 4 And ReturnSet("RecordCount") > 1 Then %>
							<option value="-1">-- Select a Supplier --</option>
						<%				
						End If
						Selected = ""
						Dim drpSupplierValue
						' Loop through the recordset
						While not ReturnSet.EOF
							drpSupplierValue = ReturnSet("SupplierId") & "," & ReturnSet("SupplierName")  & "," & ReturnSet("VendorCode")

							If drpSupplierValue = HiddenSupplier Then
								Selected = "selected"
							Else 
								Selected = ""
							End If

	%>
	<option <%=selected%> value="<%=drpSupplierValue%>"><%=ReturnSet("SupplierName")%></option>
	<%											
							ReturnSet.MoveNext
						Wend
									
						' Close the Connection and RecordSet
						Set ReturnSet = Nothing
					Else
%>
			<option value="0">-- No a Supplier --</option>
<%
					End If
					
%>					
		
				</select>
			&nbsp;<b class="pcontent">OR&nbsp;Supplier Partial Name</b>
			<input type="text" name="txtPartialSup" id="txtPartialSup" value="<%=Request.Form("txtPartialSup")%> " class="pcontent" size="60">
			<button type="button" name="btnFilter" id="btnFilter" value="Find" class="button" OnClick="javascript:partialSupSearch();">Find</button></td>
		</tr>
		<tr>
			<td class="pcontent"><b>Status:</b></td>
			<td>
				<select name="drpStatus" id="drpStatus" class="pcontent">
					<% 	
						Dim SelectedStatusId
						SelectedStatusId = CInt(Request.Form("drpStatus"))
					%>
					<option <% If SelectedStatusId = 0 Then Response.Write "selected" %> value="0">-- Select a Status --</option>
					<option <% If SelectedStatusId = 2 Then Response.Write "selected" %> value="2">Validated - Errors</option>
					<option <% If SelectedStatusId = 3 Then Response.Write "selected" %> value="3">Validated - Incorrect DC</option>
					<option <% If SelectedStatusId = 4 Then Response.Write "selected" %> value="4">Validated - No Errors</option>
					<option <% If SelectedStatusId = 5 Then Response.Write "selected" %> value="5">Downloaded to DC</option>
					<option <% If SelectedStatusId = 6 Then Response.Write "selected" %> value="6">Rejected</option>
				</select>
			</td>
			<td class="pcontent"><b>Date:</b></td>
            <td>								
				<input type="text" name="txtFromDate" id="txtFromDate" value="<%=Request.Form("txtFromDate")%>" class="pcontent" size="15">
				<a href="javascript:cal5.popup();"><img align="top" border="0" height="21" id="FromDateImg" src="../../Calendar/calendar.gif" style="POSITION: relative" width=34></a>
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Filter" class="button">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
				<input type="hidden" name="hidSupplier" id="hidSupplier" value="<%=HiddenSupplier%>">
				<input type="hidden" name="HiddenIsForceCredit" id="HiddenIsForceCredit" value="<%=IsForceCredit%>">
				<input type="hidden" name="HiddenIsRewards" id="HiddenIsRewards" value="<%=IsRewards%>">
				<input type="hidden" name="HiddenIsStamps" id="HiddenIsStamps" value="<%=IsStamps%>">
				<input type="hidden" name="hidCurrentPageNumber" id="hidCurrentPageNumber" >
				<input type="hidden" name="IsForceCredit" id="IsForceCredit" value="<%=IsForceCredit%>">
				<input type="hidden" name="IsRewards" id="IsRewards" value="<%=IsRewards%>">
				<input type="hidden" name="IsStamps" id="IsStamps" value="<%=IsStamps%>">
				
			</td>
			<td class="pcontent" colspan="2">&nbsp;</td>
		</tr>
		<tr>
		    <td class="pcontent" colspan="13"><hr /></td>
		</tr>
	</table>
</form>
<%
				if request.Form("hidAction") = "1"  or Request.QueryString("page") <> "" then
                                        if request.Form("hidAction") = "1" then
                                            ' Rem Petrus Session("DCID")= request.Form("drpDC")
                                            Session("SupplierID")= request.Form("hidSupplier")
                                            Session("StatusID")= request.Form("drpStatus")
                                            Session("Date")= request.Form("txtFromDate")
                                            
                                            if request.Form("txtFromDate") = "" then
                                                Session("SqlDate") = ""
                                            else
                                                Session("SqlDate")=  Year(request.Form("txtFromDate")) & "/" & LZ(Month(request.Form("txtFromDate"))) & "/" & LZ(Day(request.Form("txtFromDate")))
                                            end if
                                        else
                                            ' Rem - Useless Session("DCID")= Session("DCID")
                                            Session("SupplierID")= UserID
                                            Session("StatusID")= StatusID
                                            'Session("Date")= LZ(Month(now())) & "/" & LZ(Day(now())) & "/" & Year(now())
                                            'Session("SqlDate")=  Year(now()) & "/" & LZ(Month(now())) & "/" & LZ(Day(now()))
                                            Session("Date")= Session("Date")
                                            Session("SqlDate")=  Session("SqlDate")
                                        end if
										
										' check the recordbands
										if CStr(Request.QueryString("page")) = "" or IsNull(CStr(Request.QueryString("page")))	Then
											If Request.Form("hidCurrentPageNumber") <> "" Then
												
												Band = Request.Form("hidCurrentPageNumber") 
											Else
												Band = 1
											End If
										else
											Band = CInt(Request.QueryString("page"))
										end if
                                        
										Dim SearchOnDCId
										If Request.Form("drpDC") <> "" Then
											SearchOnDCId = Request.Form("drpDC")
										Else 
											SearchOnDCId = Session("DCID")
										End If
										
										
										Dim SupplierId 
										If Request.Form("drpSupplier") <> "" Then
											SupplierId = Split( HiddenSupplier ,",")(0)
										Else
											SupplierId = -1
										End If
										
										
										SQL = "exec listSchedules_New @SupplierID=" & SupplierId & _
											", @DCID=" & SearchOnDCId & _
											", @StatusID=" & Session("StatusID") & _
											", @Date=" & MakeSQLText(Session("SqlDate")) & _
											", @RecordBand=" & Band & _
											", @IsForceCredit=" & IsForceCreditNumeric &_
											", @IsRewardsNumeric=" & IsRewardsNumeric &_
											", @IsStampsNumeric=" & IsStampsNumeric
											
										'Response.write SQL		
										
                                        ' SQL = "exec listSchedules_New @SupplierID=" & Session("SupplierID") & _
                                            ' ", @DCID=" & Session("DCID") & _
                                            ' ", @StatusID=" & Session("StatusID") & _
                                            ' ", @Date=" & MakeSQLText(Session("SqlDate")) & _
											' ", @RecordBand=" & Band & _
											' ", @IsForceCredit=" & IsForceCredit
											
                                            
                                      
									  'response.Write "<br/>"&SQL
                                      '  response.End
                                        
                                        Set ReturnSet = ExecuteSql(SQL, curConnection)
                                        
                                        if ReturnSet("returnvalue") < "0" then
%>
			
	<table width="100%" cellspacing="2" cellpadding="2" border="0">
	    <tbody>
			<tr>
			<% If IsForceCredit  Then %>
				<td class="bheader" align="left">List Force Credits &amp; Reversals</td>
			<% ElseIf IsRewards Then %>
				<td class="bheader" align="left">List Reward Schedules</td>
			<%ElseIf IsStamps then%>
				<td class="bheader" align="left">List SPAR Stamps</td>
			<% Else  %>
				<td class="bheader" align="left">List Schedules</td>
			<% End If %>
			</tr>
		</tbody>
	</table>
<%
'response.Write "<br/>"&SQL
'                                        response.End
%>
<p class="pcontent">There are no schedules available for the filter criteria above.</p>
<%                                        
                                        else
										
											' Set the variables

											RecordCount = ReturnSet("RecordCount")
											MaxRecords = ReturnSet("MaxRecords")
											RecordFrom = ReturnSet("RecordFrom")
											RecordTo = ReturnSet("RecordTo")
											BandSize = ReturnSet("BandSize")
											
											' Calculate the number of pages - Call function CalcNumPages
											'TotPages = CalcNumPages(MaxRecords, BandSize)

											' Display the page head navigation
											'Call PageHeadNav ("pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo)
											
											' Display the page navigation
											'Call PageNav (const_app_ApplicationRoot & "/schedule/search/default.asp", "pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo, TotPages, Band, Request.QueryString("id"))
											
											
											If Not IsNumeric(Request.Form("hidCurrentPageNumber")) Or Request.Form("hidCurrentPageNumber") = "" Then
												hidCurrentPageNumber = 1
											Else
												hidCurrentPageNumber = CInt(Request.Form("hidCurrentPageNumber"))
											End If
											
											Dim TotalPages, FromPage, ToPage, i
											TotalPages = MaxRecords / BandSize + 1
											FromPage = hidCurrentPageNumber - 3
											ToPage = hidCurrentPageNumber + 3

											If FromPage < 1 Then
												FromPage = 1
											End If
											If ToPage > TotalPages Then
												ToPage = TotalPages - 3
											End If
			
											
										%>
										<p class="pcontent" >Displaying <%If BandSize > RecordCount Then Response.Write RecordCount Else Response.Write BandSize%> 
										records out of a total of <%=MaxRecords%> records.
										<br/>Records <%=RecordFrom%> to <%=RecordTo%> are currently displayed.<br/><br/><%
										
										
											If hidCurrentPageNumber > 1 Then
												Response.Write "<a href='javascript: SetPage(" & hidCurrentPageNumber - 1 & ")'>Previous Page</a>" & " | " 
											End If
											If hidCurrentPageNumber < Int(RecordCount / BandSize  + 1) Then
												Response.Write "<a href='javascript: SetPage(" & hidCurrentPageNumber + 1 & ")'>Next Page</a>" & " | " 
											End If

											Response.Write "<a href='javascript: SetPage(1)'>First Page</a>" & " | "
											If hidCurrentPageNumber = 0 Then
												Response.Write "<b>Page 1 |</b> "
											End If
											
											For i = FromPage To ToPage + 3
												If Cint(hidCurrentPageNumber) = i Then
													Response.Write "<b>Page " & i & " |</b> "
												Else
													Response.Write "<a href='javascript: SetPage(" & i & ")'>Page " & i & "</a>" & " | "
												End If
											Next
											If TotalPages > FormatNumber(TotalPages,0) Then
												TotalPages = FormatNumber(TotalPages,0) + 1
											End If
											Response.Write "<a href='javascript: SetPage(" &  TotalPages & ")'>Last Page</a>" & " | "
%></p>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
    <tr>
	    <td class="bheader" align="left" colspan="12">Results</td>
    </tr>
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
<%       
                                            while not ReturnSet.EOF
%>
    <tr>
        <td class="pcontent"><a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/schedule/edit/default.asp?id=<%=ReturnSet("ScheduleID")%>&amp;statusid=<%=ReturnSet("StatusID")%>', 'ScheduleDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><%=ReturnSet("FileName")%></a></td>
        <td class="pcontent" align="center"><%=ReturnSet("FileSize")%></td>
        <td class="pcontent" align="center"><%Response.Write Replace(ReturnSet("DCName"),"SPAR ","")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("SupplierName")%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("CreateDate")) then response.Write "-" else response.Write ReturnSet("CreateDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("ValidateDate")) then response.Write "-" else response.Write ReturnSet("ValidateDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("ReleaseDate")) then response.Write "-" else response.Write ReturnSet("ReleaseDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("EditDate")) then response.Write "-" else response.Write ReturnSet("EditDate") end if%></td>
        <td class="pcontent" align="center"><%=ReturnSet("TotalAmt")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("NumberOfDoc")%></td>
       <td class="pcontent" align="left">
<%
                                                if ReturnSet("StatusID") = 4 or ReturnSet("StatusID") = 5 or ReturnSet("StatusID") = 34  then
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/right.gif" alt="" height="10" width="10"/>
<%
                                                elseif ReturnSet("StatusID") = 33 And Not (IsForceCredit Or IsRewards Or IsStamps ) Then
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/warning.gif" alt="" height="10" width="10"/>
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
<%                                            
                                                ReturnSet.MoveNext  
                                            wend
%>
</table>
<%                             
				end if
                                        end if
                                        
                                        curConnection.Close
										Set curConnection = Nothing       
%>
<script language="JavaScript">
<!--		
		var cal5 = new calendar2(document.forms['frmFilter'].elements['txtFromDate']);
		cal5.year_scroll = true;
		cal5.time_comp = false;
//-->
</script>
<!--#include file="../../layout/end.asp"-->
