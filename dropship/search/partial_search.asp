<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<% 
										' Declare the variables
										dim SQL
										dim curConnection
										dim ReturnSet
										dim DoAdd
										dim TxtError
										dim txtProdID
										dim txtCode
										dim txtAmt
										dim txtImgRef
										dim txtCatID
										dim txtCatName
										dim txtIsPublic
										dim txtIsSpecial
										dim txtSubCatID
										dim FormAction
										dim Counter
										dim NewCount
										dim txtAddInfo
										dim searchVal
										
										txtError = false
										searchVal = ""
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/globalfunctions.js"></script>
<script language="javascript">
  <!--
  	function validate(obj) {
  	    var i,selectedVal;
  	    
 	    selectedVal = '';
 	    
  	    for (i = 0; i < obj.txtSupplierName.options.length; i++) {
  	        if (obj.txtSupplierName.options[i].selected==true){
			    selectedVal = obj.txtSupplierName.options[i].value;
				splitVal = selectedVal.split(",");
				displayVal = splitVal[1];
			}
		};
		
		if (selectedVal == '') {
		    window.alert('You have to select at least one address from the list above!!');
		    return false;
		};
  	
	    
		
		switch ("<%=request.querystring("type")%>")
		{
			case "Store":
				window.opener.document.FrmSearch.txtPartialSup.value = displayVal;
				window.opener.document.FrmSearch.hidSupplier.value = splitVal[0];
				break;
			case "Search":
				window.opener.document.FrmSearch.txtPartialSup.value = displayVal;
				window.opener.document.FrmSearch.hidSupplier.value = selectedVal;
				break;
			case "Stats":
				window.opener.document.FrmSearch.txtPartialSup.value = displayVal;
				window.opener.document.FrmSearch.hidSupplier.value = splitVal[0];
				break;
			case "Schedule":
				window.opener.document.frmLoad.txtPartialSup.value = displayVal;
				window.opener.document.frmLoad.hidSupplier.value = splitVal[0];
				break;
			case "ScheduleList":
				window.opener.document.frmFilter.txtPartialSup.value = displayVal;
				window.opener.document.frmFilter.hidSupplier.value = selectedVal;
				break;
			case "Claims":
				window.opener.document.Index.txtPartialSup.value = displayVal;
				window.opener.document.Index.hidSupplier.value = selectedVal;
				
				break;
		}
		
		window.close();
	};

	function closeWin() {
		window.close();
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Partial Supplier Name Lookup</td>
	</tr>
</table>
<hr>
<p class="pcontent" align="right"><a href="javascript:closeWin();">Close Window</a></p>
<form name="nameLookup" id="nameLookup" method="post" action="partial_search.asp?value=<%=request.querystring("value")%>&type=<%=request.querystring("type")%>" onsubmit="return validate(this);">

<%
                                             ' Create a connection
											 Dim SelectedDCId 
											 
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											Dim IsRewardsNumeric
											If Request.QueryString("rw") then
												IsRewardsNumeric = 1
											Else
												IsRewardsNumeric = 0
											End IF
											
											Dim IsStampsNumeric
											If Request.QueryString("st") then
												IsStampsNumeric = 1
											Else
												IsStampsNumeric = 0
											End IF
											
											If Request.QueryString("id") = "" Or Request.QueryString("id") = "-1" Then
												SelectedDCId = 0
											Else
												SelectedDCId = Request.QueryString("id")
												SelectedDCId = Split(SelectedDCId,",")(0)
											End If
											
											If SelectedDCId = 0 Then
												
												If Request.QueryString("dcid") = "" Or Request.QueryString("dcid") = "-1" Then
													SelectedDCId = 0
												Else
													SelectedDCId = Request.QueryString("dcid")
													SelectedDCId = Split(SelectedDCId,",")(0)
												End If
											End If
											
											
											
											If request.QueryString("type") = "Claims" Or request.QueryString("type") = "Stats" Or Request.QueryString("type") = "Search" Then
												Dim ClaimTypeId
												ClaimTypeId = request.QueryString("ClaimTypeId")
												'Removed claimTypeId - xander 05/10/2017
												'SQL = "exec searchSupplierPartialName @LookupVal=" & MakeSQLText(request.QueryString("value")) & ", @DCId=" & SelectedDCId & ", @Type=" & MakeSQLText(request.QueryString("type")) & ",@ClaimTypeId=" & ClaimTypeId 
												SQL = "exec searchSupplierPartialName @LookupVal=" & MakeSQLText(request.QueryString("value")) & ", @DCId=" & SelectedDCId & ", @Type=" & MakeSQLText(request.QueryString("type"))  
												If (Session("UserType") = 1 Or Session("UserType") = 4) Then SQL = SQL & ",@SupplierId=" & Session("ProcId")
												'Response.write "A"
												'response.write 
											ElseIf (request.QueryString("type") = "ScheduleList" OR request.QueryString("type") = "Schedule" ) and IsRewardsNumeric = 1 then
												SQL = "exec searchSupplierPartialName @IsReward = 1, @IsStamps = 0,@LookupVal=" & MakeSQLText(request.QueryString("value")) & ", @DCId=" & SelectedDCId & ", @Type=" & MakeSQLText(request.QueryString("type"))
												'Response.write "B"
											ElseIf (request.QueryString("type") = "ScheduleList" OR request.QueryString("type") = "Schedule" ) and IsStampsNumeric = 1 then
												SQL = "exec searchSupplierPartialName @IsReward = 0 ,@IsStamps = 1,@LookupVal=" & MakeSQLText(request.QueryString("value")) & ", @DCId=" & SelectedDCId & ", @Type=" & MakeSQLText(request.QueryString("type"))
												'Response.write "C"
											Else
												'Response.Write "NJAR"
												SQL = "exec searchSupplierPartialName @IsReward = 0,@IsStamps = 0,@LookupVal=" & MakeSQLText(request.QueryString("value")) & ", @DCId=" & SelectedDCId & ", @Type=" & MakeSQLText(request.QueryString("type"))
												
												
						
											End If
											'response.Write SQL
											'response.End
															
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											'if ReturnSet("returnvalue") <> "0" then
											if ReturnSet.EOF then
%>												
		<p class="pcontent">There are no matching records found. Please close the window and try again?</p>
<%											
											
											else
%>
<table border="0" cellpadding="2" cellspacing="2">
    <tr>
        <td class="pcontent">&nbsp;</td>
        <td class="pcontent">Select the correct name and click on the "Submit" button.<br /><br /></td>        												
    </tr>
    <tr>
		<td class="pcontent"><b>Supplier Name:</b></td>
		<td><select size="10" name="txtSupplierName" id="txtSupplierName" style="width:450" class="pcontent">
<%											
											    ' Loop through the recordset
											    While not ReturnSet.EOF
													Select Case CStr(request.querystring("type"))
														Case "Search", "Stats", "Schedule", "ScheduleList", "Claims"
%>
				<option value="<%=ReturnSet("SupplierID")%>,<%=ReturnSet("SupplierName")%>,<%=ReturnSet("VendorCode")%>"><%=ReturnSet("SupplierName")%></option>
<%											
														Case "Store"
%>
				<option value="<%=ReturnSet("SupplierEAN")%>,<%=ReturnSet("SupplierName")%>,<%=ReturnSet("VendorCode")%>"><%=ReturnSet("SupplierName")%></option>
<%
													End Select
												    ReturnSet.MoveNext
											    Wend
%>		
			</select>
		</td>
	</tr>
	<tr>
	    <td class="pcontent">&nbsp;</td>
		<td>
			<input type="submit" name="btnSubmit" id="btnSubmit" value="Select" class="pcontent">&nbsp;
			<input type="hidden" name="hidAction" id="hidAction" value="1">
		</td>
	</tr>
</table>
<% 
                                            end if
                                            
                                            Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
%>

</form>
<!--#include file="../layout/end.asp"-->
