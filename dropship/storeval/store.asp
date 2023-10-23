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
										dim FormAction
										dim txtStoreID
										dim txtUserName
										dim txtPassword
										dim txtStoreName
										dim txtStoreMail
										dim txtAddress
										dim txtDisable
										dim txtStoreEAN
										dim txtStorePhone
										dim txtStoreFax
										dim txtStoreCode
										dim txtIsLive
										dim txtDCID
										dim Counter
										dim ErrorCount
										
										' Check if the id was supplied in the querystring
										if Request.QueryString("id") = "" or isNull(Request.QueryString("id")) then
											DoAdd = True
											FormAction = "doadditem.asp"
											txtStoreID = 0
											PageTitle = "Add a New Store"
											txtUserName = ""
											txtPassword = ""
											txtStoreName = ""
											txtStoreMail = ""
											txtAddress = ""
											txtDisable = 0
											txtStoreEAN = ""
											txtStorePhone = ""
											txtStoreFax = ""
											txtStoreCode = ""
											txtIsLive = 0
											txtDCID = 0
										else
											DoAdd = False
											FormAction = "doedititem.asp"
											PageTitle = "Edit Store"
											txtStoreID = Request.QueryString("id")
										
											' Build the SQL 
											SQL = "exec itemStore @StoreID=" & txtStoreID
										
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_SPARDS
										
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												' An error occured - Display the error message
												ErrorCount = 1
											else
												' No error occured - Continue
												txtUserName = ReturnSet("StoreUserName")
												txtPassword = ReturnSet("StorePassword")
												txtStoreName = ReturnSet("StoreName")
												txtAddress = ReturnSet("StoreAddress")
												txtDisable = ReturnSet("Disabled")
												txtStoreEAN = ReturnSet("StoreEAN")
												txtStorePhone = ReturnSet("StorePhone")
												txtStoreFax = ReturnSet("StoreFax")
												txtStoreCode = ReturnSet("StoreCode")
												txtIsLive = ReturnSet("IsLive")
												txtDCID = ReturnSet("DCID")
											end if
											
											' Close the recordset and connection
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/calc1.js"></script>
<script language="javascript">
<!--
	function validate(obj) {
		// Check if the store name is supplied
		if	(obj.txtName.value=='') {
			window.alert ('Enter a Store Name.');
			obj.txtName.focus();
			return false;
		};
		// Check if the store ean is supplied
		if	(obj.txtEAN.value=='') {
			window.alert ('Enter a Store EAN Number.');
			obj.txtEAN.focus();
			return false;
		};
		// Check if the store code is supplied
		if	(obj.txtCode.value=='') {
			window.alert ('Enter a Store Code.');
			obj.txtCode.focus();
			return false;
		};
		// Check if the Telephone Number is supplied
		if	(obj.txtTel.value=='') {
			window.alert ('Enter a Store Telephone Number.');
			obj.txtTel.focus();
			return false;
		};
		// Check if the Fax Number is supplied
		if	(obj.txtFax.value=='') {
			window.alert ('Enter a Store Fax Number.');
			obj.txtFax.focus();
			return false;
		};
		// Check if the storeraddress is supplied
		if	(obj.txtAddress.value=='') {
			window.alert ('Enter a Store Address.');
			obj.txtAddress.focus();
			return false;
		};
		// Check if the dc is selected
		if	(obj.drpDC.value=='') {
			window.alert ('Select a Distribution Centre.');
			obj.drpDC.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10">
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
<%
										if DoAdd Then
%>
		<td class="bheader">Add a New Store</td>
<%
										else
%>
		<td class="bheader">Update Store Detail</td>
<%
										end if
%>
	</tr>
</table>
<%
										if ErrorCount > 0 then
%>
<p class="pcontent">There is no detail for the selected store. Please try again later.</p>
<%										
										else
											if DoAdd Then
%>
<p class="pcontent">Please complete the form below to add a new store.</p>
<%
											else
%>
<p class="pcontent">Below is the detail for store <b><%=txtStoreName%></b>.</p>
<%
											end if
%>
<form name="EditStore" id="EditStore" method="post" action="<%=FormAction%>?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="70%">
	<tr>
		<td>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td class="sheader">Personal Detail</td>
				</tr>
				<tr>
					<td>
						<table border="0" cellspacing="2" cellpadding="2" width="100%">
							<tr>
								<td class="pcontent"><b>Store Name:</b></td>
								<td><input type="text" name="txtName" id="txtName" value="<%=txtStoreName%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store EAN Number:</b></td>
								<td><input type="text" name="txtEAN" id="txtEAN" value="<%=txtStoreEAN%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Code:</b></td>
								<td><input type="text" name="txtCode" id="txtCode" value="<%=txtStoreCode%>" size="10" maxlength="10" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Telephone Number:</b></td>
								<td><input type="text" name="txtTel" id="txtTel" value="<%=txtStorePhone%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Fax Number:</b></td>
								<td><input type="text" name="txtFax" id="txtFax" value="<%=txtStoreFax%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Address:</b></td>
								<td class="pcontent"><textarea rows="5" cols="33" id="txtAddress" name="txtAddress" class="pcontent"><%=txtAddress%></textarea></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Status</b></td>
								<td>
									<select name="drpStatus" id="drpStatus" class="pcontent">
										<option value="-1">-- Select Status --</option>
										<option <%if txtIsLive = "0" then Response.Write "selected" end if%> value="0">InActive</option>
										<option <%if txtIsLive = "1" then Response.Write "selected" end if%> value="1">Live</option>
										<option <%if txtIsLive = "2" then Response.Write "selected" end if%> value="2">Test</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<br>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td class="sheader">Link Store to a Distribution Centre</td>
				</tr>
				<tr>
					<td><br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="pcontent"><b>Select a Distribution Centre</b></td>
								<td class="pcontent">
									<select name="drpDC" id="drpDC" class="pcontent">
										<option id="0"> -- Select -- </option>
<%
											if Session("UserName") = "SPARHEADOFFICE" OR Session("UserName") = "GATEWAYCALLCEN" then
%>									
										<option <%if txtDCID = 1 then Response.Write "selected" end if%> value="1">SPAR SOUTH RAND</option>
										<option <%if txtDCID = 2 then Response.Write "selected" end if%> value="2">SPAR NORTH RAND</option>
										<option <%if txtDCID = 3 then Response.Write "selected" end if%> value="3">SPAR KZN</option>
										<option <%if txtDCID = 4 then Response.Write "selected" end if%> value="4">SPAR EASTERN CAPE</option>
										<option <%if txtDCID = 5 then Response.Write "selected" end if%> value="5">SPAR WESTERN CAPE</option>
<%
											else
												Select Case txtDCID
												Case 1
%>
										<option selected value="1">SPAR SOUTH RAND</option>
<%											
												Case 2
%>
										<option selected value="2">SPAR NOTH RAND</option>
<%											
												Case 3
%>
										<option selected value="3">SPAR KZN</option>
<%											
												Case 4
%>
										<option selected value="4">SPAR EASTERN CAPE</option>
<%											
												Case 5
%>
										<option selected value="5">SPAR WESTERN CAPE</option>
<%											
												Case Else
%>
										<option value="1">SPAR SOUTH RAND</option>
										<option value="2">SPAR NORTH RAND</option>
										<option value="3">SPAR KZN</option>
										<option value="4">SPAR EASTERN CAPE</option>
										<option value="5">SPAR WESTERN CAPE</option>											
<%										
												End Select
											end if
%>										
									</select>
								</td>
							</tr>
						</table><br>
					</td>
				</tr>
			</table><br>
		</td>
	</tr>
	<tr>
		<td>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td>
						<table border="0" cellpadding="2" cellspacing="2" align="center">
							<tr>
								<td colspan="3">
									<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
									<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
									<input type="hidden" name="hidStoreID" id="hidStoreID" value="<%=txtStoreID%>">
									<input type="hidden" name="hidAction" id="hidAction" value="1">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<%
										end if
%>
<!--#include file="../layout/end.asp"-->
