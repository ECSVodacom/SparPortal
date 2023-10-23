<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/genmenuitems.asp"-->
<!--#include file="../../includes/freeASPUpload.asp"-->
<!--#include file="../../includes/schedulefunctions.asp"-->

<%

										Server.ScriptTimeout=60000
		
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
										Dim Upload, fileName, fileSize, ks, i, fileKey, SaveFiles, errorFlag, ReturnVal, SupplierID, SelectedSupplierId
										Dim IsForceCredit 
										Dim IsRewards
										Dim IsForceCreditNumeric 
										Dim IsAdmin
										
										errorFlag = true								
										'Response.Write "SupplierId : " & SupplierId		
										if Session("UserType") = 1 or  Session("UserType") = 4 then
											UserID = Session("ProcID")
											SupplierID = Session("ProcID")
											UserType = 1
											dcID = Session("DCID")
										else
											UserID = Session("UserID")
											SupplierID = 0
											UserType = 2
											
											if Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE")then
												dcID = 0
											else
												dcID = Session("DCID")
											end if
                                        end if
										
										
										If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
											Set Upload = New FreeASPUpload
                                            Upload.Save(const_app_uploaddir)
											
											IsForceCredit = CBool(Upload.Form("IsForceCredit"))
											IsRewards = CBool(Upload.Form("IsRewards"))
											IsAdmin = CBool(Upload.Form("IsAdmin"))
											
											If Upload.Form("hidSupplier") <> "" Then SelectedSupplierId = Split(Upload.Form("hidSupplier") ,",")(0)
											If Upload.Form("drpDC") <> "" Then dcID = Upload.Form("drpDC") 
											
										Else
											If Request.QueryString("fc") <> "" Then
												IsForceCredit = CBool(Request.QueryString("fc"))
												IsRewards = False
												IsAdmin = False
											ElseIf Request.QueryString("rw") <> "" Then
												IsRewards = CBool(Request.QueryString("rw"))
												IsForceCredit = False
												IsAdmin = False
											ElseIf Request.QueryString("as") <> "" Then
												IsRewards = False
												IsForceCredit = False
												IsAdmin = True
											End If
										End If

									
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
		
		if (obj.drpDC.value == '-1' || obj.drpDC.value == '0' ) {
			window.alert('You have to select a DC.');
			obj.drpDC.focus();
			return false;
		};
		
		if (obj.drpSupplier.value == '-1' && obj.txtPartialSup.value == '') {
			window.alert('You have to select a Supplier.');
			obj.drpSupplier.focus();
			return false;
		};
		
		if (obj.drpSupplier.value != -1)
		{
			document.frmLoad.elements['hidSupplier'].value = obj.drpSupplier.value;
		}
		
		if (obj.drpType.value == '-1') {
			window.alert('You have to select a file type.');
			obj.drpType.focus();
			return false;
		};
		
		if (obj.txtFile.value == '') {
			window.alert('You have to select a file to upload.');
			obj.txtFile.focus();
			return false;
		};
	};
	function partialSupSearch(){
		if (document.frmLoad.elements['txtPartialSup'].value==''){
			window.alert('You have to enter partial supplier name.');
			document.frmLoad.elements['txtPartialSup'].focus();
			return false;	
		}
		var parNameSearch = document.frmLoad.elements['txtPartialSup'].value;
		var dcId = document.frmLoad.elements['drpDC'].value;
		window.open('../../search/partial_search.asp?value=' + parNameSearch + '&type=Schedule&fc=<%=IsForceCredit%>&rw=<%=IsRewards%>&id='+dcId,'PartialSearch', 'width=600,height=400,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');
	}

	function setSupplierSelectedVal() {
		// Set the selected supplier index
		document.frmLoad.elements['hidSupplier'].value = document.frmLoad.drpSupplier.options[document.frmLoad.elements['drpSupplier'].selectedIndex].value;
	}
//-->
</script>
<% If  Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE") Then%>
<script type="text/javascript" src="../../includes/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8">
$(function(){
	$("select#drpDC").change(function(){
		$.getJSON("../../includes/JQueryDataSetSuppliers.asp",{id: $(this).val(), IsRewardsNumeric: <%=IsRewardsNumeric%>, IsForceCreditNumeric:<%=IsForceCreditNumeric%>}, function(j){
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
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	

		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>
<br /><br />
<form name="frmLoad" id="frmLoad" method="post" enctype="multipart/form-data" action="default.asp?id=<%=Request.QueryString("id")%>&fc=<%=IsForceCredit%>&rw=<%=IsRewards%>" onsubmit="return validate(this);" autocomplete = "off">
    <table border="0" cellpadding="2" cellspacing="2" width="100%">
	    <tr>
			<% If IsForceCredit Then %>
				<td class="bheader" align="left" colspan="2">Upload Force Credits &amp; Reversals<br /><br /></td>
			<% elseIf IsRewards then %>
				<td class="bheader" align="left" colspan="2">Upload Rewards Schedule<br /><br /></td>

			<% elseIf IsAdmin then %>
				<td class="bheader" align="left" colspan="2">Upload Admin Schedule<br /><br /></td>
			<% Else %>
				<td class="bheader" align="left" colspan="2">Load new Schedule<br /><br /></td>
			<% End If %>
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
										' Get a list of Stores
										Set ReturnSet = ExecuteSql("listDC @DC=" & Session("DCID"), curConnection) 	
										
										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											if CInt(dcId) = CInt(ReturnSet("DCID")) Then
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
%>									
				</select>
			</td>
		</tr>
		<tr>
		
		    <td class="pcontent"><b>Supplier:</b></td>
			<td>
				<select name="drpSupplier" id="drpSupplier" class="pcontent" onchange="setSupplierSelectedVal();">
					<%
							' Set a connection
						Set curConnection = Server.CreateObject ("ADODB.Connection")
						curConnection.Open const_db_ConnectionString
												
						' Get a list of Stores
						
						
					Set ReturnSet = ExecuteSql("listScheduleSupplier @SupplierID=" & SupplierId & ", @DCId=" & dcId & ", @HiddenIsForceCredit=" & IsForceCreditNumeric & ", @IsRewardsNumeric=" & IsRewardsNumeric, curConnection) 
					
					
					If Not (ReturnSet.EOF And ReturnSet.BOF) Then
						If Session("UserType") <> 4 And ReturnSet("RecordCount") > 1 Then %>
							<option value="-1">-- Select a Supplier --</option> <%					
						End If
							
										
											Selected = ""
											Dim SupplierCount 
											SupplierCount = 0 
											
											If Not IsNumeric(SelectedSupplierId) Then SelectedSupplierId = 0
														
											' Loop through the recordset
											While not ReturnSet.EOF
												if CInt(SelectedSupplierId) = ReturnSet("SupplierID") Then
													Selected = "selected"
												else
													Selected = ""
												end if
	%>
						<option <%=selected%> value="<%=ReturnSet("SupplierID")%>"><%=ReturnSet("SupplierName")%></option>
	<%											
												ReturnSet.MoveNext
											Wend
														
											' Close the Connection and RecordSet
											Set ReturnSet = Nothing
					Else
%>
			<option value="0">-- No  Supplier --</option>
<%
					End If
%>									
				</select>
			<% If Session("UserType") <> 4 Then %>
			&nbsp;<b class="pcontent">OR&nbsp;Supplier Partial Name</b>	
		
			<input type="text" name="txtPartialSup" id="txtPartialSup" class="pcontent" size="60">&nbsp;<button name="btnFilter" id="btnFilter" value="Find" class="button" type="button" OnClick="javascript:partialSupSearch();">Find</button></td>
			<% End If %>
		</tr>		
		<tr>
			<td class="pcontent"><b>File Type:</b></td>
			<td>
				<%
				if Request.ServerVariables("REQUEST_METHOD") = "POST" then
					Dim Excel,Pipe ,Tab,CSV
					Select Case Upload.Form("drpType")
						Case "Excel"
							Excel = "selected"
						Case "Pipe Delimited"
							Pipe = "selected"
						Case "Tab Delimited"
							Tab = "selected"
						Case "CSV"
							CSV = "selected"
					End Select
				
				End If
				%>
				
				
				<select name="drpType" id="drpType" class="pcontent">
					<option value="-1">-- Select a File Type --</option>
                    <option <%=Excel%> value="Excel">Excel</option>
                    <option <%=Pipe%> value="Pipe Delimited">Pipe Delimited</option>
                    <option <%=Tab %> value="Tab Delimited">Tab Delimited</option>
                    <option <%=CSV%> value="CSV">CSV</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent"><b>File:</b></td>
			<td class="pcontent"><input type="file" name="txtFile" id="txtFile" size="60" class="pcontent"></td>
		</tr>
		<tr>
			<td class="pcontent"  colspan="2">
					<input type="submit" name="btnSubmit" id="btnSubmit" value="Upload / Validate" class="button">&nbsp;
				<input type="checkbox" id="chkIsAdmin" name="chkIsAdmin" 
					value="<%=IsAdmin%>" disabled <% If IsAdmin = True Then Response.Write "checked"%>>
				

				
				<input type="hidden" name="hidAction" id="hidAction" value="1">
				<input type="hidden" name="hidSupplier" id="hidSupplier" value="-1">
				<input type="hidden" name="IsAdmin" id="IsAdmin" value="<%=IsAdmin%>">
				<input type="hidden" name="IsForceCredit" id="IsForceCredit" value="<%=IsForceCredit%>">
				<input type="hidden" name="IsRewards" id="IsRewards" value="<%=IsRewards%>">
			</td>
		</tr>
	</table>
	
<%
                                        ' Check if the user submitted the form
                                        if Request.ServerVariables("REQUEST_METHOD") = "POST" then
%>	
    <br /><hr />
    <table border="0" cellpadding="2" cellspacing="2" width="100%">
	    <tr>
		    <td class="bheader" align="left">Result</td>
        </tr>
<%
											
											
                                            ' If something fails inside the script, but the exception is handled
                                            If Err.Number<>0 then   
                                                errorFlag = true                                         
%>                                            
            <tr>
                <td class="pcontent" align="left"><br />The following error occured while trying to upload the selected file: <br /><%=Err.Description%><br />Please try again?</td>
            </tr>    
<%    
                                            else
                                                SaveFiles = ""
                                                ks = Upload.UploadedFiles.keys
                                                
												
												
                                                if (UBound(ks) <> -1) then
                                                    errorFlag = false
                                                
                                                    for each fileKey in Upload.UploadedFiles.keys
                                                        SaveFiles = SaveFiles & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
                                                        
                                                        ' Wrtie the file to database and validate
                                                        Select Case Upload.Form("drpType")
                                                            Case "Excel"
                                                                ' Call the ProcessExcel Function
                                                                ReturnVal = ProcessExcel(curConnection, SelectedSupplierId, UserID, dcId, const_app_uploaddir, Upload.UploadedFiles(fileKey).FileName, Upload.UploadedFiles(fileKey).Length, IsForceCreditNumeric, IsRewardsNumeric, IsAdmin)
                                                            Case "Pipe Delimited"
                                                                ' Call the ProcessDelimited Function - Delimiter = "|"
                                                                ReturnVal = ProcessPipe(curConnection, SelectedSupplierId, UserID, dcId, const_app_uploaddir, Upload.UploadedFiles(fileKey).FileName, Upload.UploadedFiles(fileKey).Length, IsForceCreditNumeric, IsRewardsNumeric)
                                                            Case "Tab Delimited"
                                                                ' Call the ProcessDelimited Function - Delimiter = "tab"
                                                                ReturnVal = ProcessTab(curConnection, SelectedSupplierId, UserID, dcId, const_app_uploaddir, Upload.UploadedFiles(fileKey).FileName, Upload.UploadedFiles(fileKey).Length, IsForceCreditNumeric, IsRewardsNumeric)
                                                            Case "CSV"
                                                                ' Call the ProcessDelimited Function - Delimiter = ","
                                                                ReturnVal = ProcessCSV(curConnection, SelectedSupplierId, UserID, dcId, const_app_uploaddir, Upload.UploadedFiles(fileKey).FileName, Upload.UploadedFiles(fileKey).Length, IsForceCreditNumeric, IsRewardsNumeric)
                                                        End Select
%>
            <tr>
                <td class="pcontent" align="left">
                    <br />The file <b><%=SaveFiles%></b> was validated with the following status:<br /><br /><b><%=ReturnVal%></b>
<%
                                                        if mid(ReturnVal,1,5) <> "ERROR" then
%>                    
<% If Session("HiddenIsForceCredit") = 1 Then %>
				<br /><br />To view and/or amend this schedule, go the the menu option and select the "List Force Credits and Reversals" option.
			<% Else %>
				<br /><br />To view and/or amend this schedule, go the the menu option and select the "List schedules" option.
			<% End If %>    

	
<%
                                                        end if
%>                    
                </td>
            </tr>
<%
                                                    next
                                                else
                                                    errorFlag = true
%>                                                
            <tr>
                <td class="pcontent" align="left"><br />An error occured while trying to upload the file <b><%=SaveFiles%></b> to the server. Please try again?</td>
            </tr>                                                
<%    
                                                end if    
                                        end if
%>
</table>
<%                                        
                                    end if

                                    curConnection.Close
									Set curConnection = Nothing
%>
</form>
<!--#include file="../../layout/end.asp"-->
