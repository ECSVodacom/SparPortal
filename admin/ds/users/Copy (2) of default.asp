<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/functions.asp"-->
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
										' Declare the variables
										dim SQL
										dim curConnection
										dim ReturnSet
										dim txtMaxRecords
										dim txtRecordFrom
										dim txtRecordTo
										dim txtBandSize
										dim txtRecordCount
										dim Page
										dim TotPages
										dim Counter
										
										PageTitle = "List Stores"
										Counter = 0
										
										' Determine the page number
										if Request.QueryString("page") = "" then
											Page = 1
										else	
											Page = CInt(Request.QueryString("page"))
										end if									
										
										' Build the SQL 
										'SQL = "exec listStores @Admin=1" & _
										'	", @RecordBand=" & Page & _
										'	", @DCID=" & Session("UserID")
											
										SQL = "exec listStores @Admin=0"

										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Execute the SQL
										Set ReturnSet = curConnection.Execute (SQL)
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="bheader">Store Section</td>
	</tr>
</table>
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") < 0 then
											' An error occured - Display the error message
%>
<p class="errortext">There are currently no Stores allocated to this Distribution Centre.</p>
<p class="errortext">Please try again later. Thank you.</p>

<%
										end if
%>

<form name="lstStore" id="lstStore" method="post" action="item.asp">
<p class="pcontent">Select the <b>store</b> from the list below.</p>

<select name="drpStore" id="drpStore" class="pcontent" onchange="document.lstStore.action='item.asp?id=' + document.lstStore.drpStore.value; document.lstStore.submit();">
				<option value="-1">-- Select a Store --</option>
				
		

<%
											' Loop through the recordset
											While not ReturnSet.EOF
												Counter = Counter + 1


%>
	
		<option value="<%=ReturnSet("StoreID")%>"><%=ReturnSet("StoreName") & " (" & ReturnSet("StoreEAN") & ") "%></option>
	
<%											
												ReturnSet.MoveNext
											Wend
%>		
			</select>
	</form>		

<!--#include file="../layout/end.asp"-->
<%
										' Close the recordset and connection
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing

							
%>