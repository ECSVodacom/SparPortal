<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										' Check if the User is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/supplier/default.asp")

										DIM DoAdd
										Dim txtSupplierName
										Dim FormAction	
										Dim curConnection	
										Dim ReturnSet		
										Dim txtSupplierID			

%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<!--#include file="includes/subsuppliermenu.asp"-->
<%
											
											DIM SQL
											DIM txtVendorCode, SupplierId, Counter, ErrorCount, SqlCommandText
											SupplierId = Request.QueryString("id")
											

											SqlCommandText = "listSupplierCode @SupplierID=" & SupplierId & ",@DoLinkCheck=1"
											
											
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SqlCommandText, curConnection) 
											'response.write SqlCommandText
											'response.end
%>										
<p class="pcontent">Below is the detail for supplier <b><%=ReturnSet("VbSupplierName")%></b>.</p>
<table border="1" cellpadding="2" cellspacing="0" bordercolor="#333366" width="80%">
<%
										'response.write SqlCommandText
											If ReturnSet("ReturnValue") = 0 Then
												Counter = 0 %>
												<tr>
													<td class="sheader" colspan="9">Supplier DC Link Details</td>
												</tr>
												<tr>
													<th class="tblheader" align="left">Line No</th>
													<th class="tblheader" align="left">Distribution Centre</th>
													<th class="tblheader" align="left">Vendor Code</th>
													<th class="tblheader" align="left">Vendor Name</th>
													<th class="tblheader" align="left">Location Code</th>
													<th class="tblheader" align="left">Despatch Point</th>
													<th class="tblheader" align="left">Vendor Status</th>
													<th class="tblheader" align="left">EDI Group Code</th>
													<th class="tblheader" align="left">EDI Group EAN</th>
													
												</tr>
				<%
												While Not ReturnSet.EOF 
													Counter = Counter + 1
												%>
													<tr>
														<td class="tbldata" align="center"><%=Counter%>.</td>
														<td class="tbldata"><label id="txtDC<%=Counter%>" size="40" maxlength="100"><%=ReturnSet("DC")%></label></td>
														<td class="tbldata"><label id="txtVendorCode<%=Counter%>" size="5" maxlength="10"><%=ReturnSet("VendorCode")%> </label></td>
														<td class="tbldata"><label id="txtVendorName<%=Counter%>"  size="50" maxlength="50"><%=ReturnSet("SupplierName")%></label></td>
														<td class="tbldata"><label id="txtEdiGroupCode<%=Counter%>"  size="50" maxlength="50"><%=ReturnSet("LocationCode")%></label></td>
														<td class="tbldata"><label id="txtEdiGroupCode<%=Counter%>"  size="50" maxlength="50"><%=ReturnSet("DespatchPoint")%></label></td>
														<td class="tbldata"><label id="txtEdiGroupCode<%=Counter%>"  size="50" maxlength="50"><%=ReturnSet("VendorStatus")%></label></td>
														<td class="tbldata"><label id="txtEdiGroupCode<%=Counter%>"  size="50" maxlength="50"><%=ReturnSet("EdiGroupCode")%></label></td>
														<td class="tbldata"><label id="txtEdiGroupCode<%=Counter%>"  size="50" maxlength="50"><%=ReturnSet("EdiGroupCodeEan")%></label></td>

													</tr> <%
																		
													ReturnSet.MoveNext
												Wend
												
												'response.write SqlCommandText
												'If ReturnSet("ReturnValue") <> 0 Then 
												'	ErrorCount = 1
												'Else 
												'	txtVendorCode = ReturnSet("VendorCode")
											'		txtSupplierName = ReturnSet("SupplierName")
												'End If
											Else %>
												<p class="errortext"><%=ReturnSet("ErrorMessage")%></p>
											<%
											End If
%>
</table>
<form name="EditSupplier" id="EditSupplier" method="post" action="<%=FormAction%>?id=<%=Request.QueryString("id")%>" >
	<tr>
		<td>
		</td>
	</tr>
</form>
<!--#include file="../layout/end.asp"-->
