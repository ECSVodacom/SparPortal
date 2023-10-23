<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
	};
//-->
</script>
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
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/validation.js"></script>
<script language="javascript">
<!--
	function validate(obj) {
		if (obj.drpStore.value=='-1') {
			window.alert('You have to select a Store.');
			obj.drpStore.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="bheader" align="left">Search</td>
				</tr>
				<tr>
					<td class="pcontent" align="left"><br>Select a Store Name from the dropdown box below.</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<form name="FrmSearch" id="FrmSearch" method="post" action="item.asp" onsubmit="return validate(this);">
	<table border="0" cellpadding="2" cellspacing="2">
		<!--<tr>
			<td class="pcontent"><b>Order Number:</b></td>
			<td><input type="text" name="txtOrdNo" id="txtOrdNo" class="pcontent"></td>
		</tr>-->
		<tr>
			<td class="pcontent"><b>Store:</b></td>
			<td>
				<select name="drpStore" id="drpStore" class="pcontent">
					<option value="-1"> -- From Store --</option>
<%
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										SQL = "exec listStores @SupplierID=0" & _
											", @UserType=1" & _
											", @Admin=0" & _
											",@DCID=0"

										' Get a list of Stores
										Set ReturnSet = ExecuteSql(SQL, curConnection)

										' Loop through the recordset
										While not ReturnSet.EOF
%>
					<option value="<%=ReturnSet("StoreID")%>"><%=ReturnSet("StoreName")%></option>
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
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td colspan="2">
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Search" class="button">&nbsp;
				<input type="reset" name="btnReset" id="btnReset" value="Reset " class="button">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
			</td>
		</tr>
	</table>
</form>
<!--#include file="../layout/end.asp"-->
