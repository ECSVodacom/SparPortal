<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
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
										
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/search/default.asp")
										
										' Set the page header
										PageTitle = "Search"
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/validation.js"></script>
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
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Search</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<%
										' Check if the user selected to search
										if Request.Form("hidAction") = "1" or Request.QueryString("page") <> "" Then
											' Create a connection
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
																					
											'	Set the session variables
											if Session("Check") = 1 Then
												Session("SearcType") = Session("SearcType")
												Session("SearchVal") = Session("SearchVal")
											end if
												
											if Request.Form("hidAction") = "1" Then
												Session("Check") = 1
												Session("SearcType") = Request.Form("drpType")
												Session("SearchVal") = Request.Form("txtSearchVal")
											end if
											
											' check the recordbands
											if CStr(Request.QueryString("page")) = "" or IsNull(CStr(Request.QueryString("page")))	Then
												Band = 1
											else
												Band = CInt(Request.QueryString("page"))
											end if
											
											' Build the SQL
											SQL = "exec procAdminSearch @SearchType=" & Session("SearcType") & _
												", @SearchVal=" & MakeSQLText(Trim(Session("SearchVal"))) & _
												", @RecordBand=" & Band 

													
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="pheader" align="left">Results</td>
				</tr>
				<tr>
					<td class="pcontent"><br>Below is the search results on the following criteria:
						<ul>
							<li class="pcontent">Search Type = <b>
<%
											Select Case Session("SearcType") 
											Case 1 
												Response.Write "Supplier Name" 
											Case 2 
												Response.Write "Supplier EAN Number" 
											Case 3 
												Response.Write "Supplier E-mail Address" 
											End Select
%></b></li>
							<li class="pcontent">Search Criteria = <b><%if Session("SearchVal") = "" then Response.Write "Not Supplied" else Response.Write Session("SearchVal") end if%></b></li>
						</ul>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<%
											' Check the returnvalue
											if ReturnSet("returnvalue") < 0 then
												' an error occured - display
%>
<table border="0" cellpadding="0" cellspacing="0" bordercolor="red">
	<tr>
		<td class="pcontent" valign="top"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilicry.gif"></td>
		<td class="pcontent" valign="middle"><font color="red"><b>No match found: Select an alternative search criteria.</b></font></td>
	</tr>
</table>
<%												
											else
												' no error occured
%>
<table border="0" cellpadding="2" cellspacing="2" bordercolor="red">
	<tr>
		<td class="pcontent" valign="top"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilihappy.gif"></td>
		<td class="pcontent" valign="middle"><b>Note:</b> Click on the Supplier Name link to view the Supplier details.</td>
	</tr>
</table>
<%
												' Set the variables
												RecordCount = ReturnSet("RecordCount")
												MaxRecords = ReturnSet("MaxRecords")
												RecordFrom = ReturnSet("RecordFrom")
												RecordTo = ReturnSet("RecordTo")
												BandSize = ReturnSet("BandSize")
												
												' Calculate the number of pages - Call function CalcNumPages
												TotPages = CalcNumPages(MaxRecords, BandSize)

												' Display the page head navigation
												Call PageHeadNav ("pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo)
												
												' Display the page navigation
												Call PageNav (const_app_ApplicationRoot & "/search/default.asp", "pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo, TotPages, Band, Request.QueryString("id"))

%>
<table border="1" cellpadding="2" cellspacing="0">
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>Supplier Name</b></td>
	</tr>
<%												
												' Loop through the recordset
												While not ReturnSet.EOF
%>
	<tr>
		<td class="pcontent" align="left"><a class="subsubmenu" href="<%=const_app_ApplicationRoot%>/admin/ack/supplier/item.asp?id=<%=ReturnSet("SupplierID")%>"><%=ReturnSet("SupplierName")%></a></td>
	</tr>
<%			
													ReturnSet.MoveNext
												Wend
%>	
</table>
<%
											' Display the page navigation
											Call PageNav (const_app_ApplicationRoot & "/search/default.asp", "pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo, TotPages, Band, Request.QueryString("id"))
												
											end if
											
											' Close the recordset
											Set ReturnSet = Nothing
%>
<p><hr></p>
<%											
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										end if
%>
<p class="pcontent">Enter search criteria below.</p>
<p class="pcontent"><b>Note:</b> Fields marked with <b>[*]</b> are mandatory.</p>
<form name="FrmSearch" id="FrmSearch" method="post" action="default.asp?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>Search Type:</b></td>
			<td>
				<select name="drpType" id="drpType" class="pcontent">
					<option value="-1">-- Select a Search Type --</option>
					<option value="1">Supplier Name</option>
					<option value="2">Supplier EAN Number</option>
					<option value="3">Supplier E-mail Address</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Search Criteria:</b></td>
			<td><input type="text" name="txtSearchVal" id="txtSearchVal" class="pcontent"></td>
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
