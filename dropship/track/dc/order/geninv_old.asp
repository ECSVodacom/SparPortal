<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<%
										dim SQL
										dim curConnection
										dim ReturnSet
										dim Counter
										dim AddRow
										dim Selected

										AddRow = False
										
										' Determine if the user selected to generate new lines
										if Request.Form("hidAction") = "1" then
											' The user requested to add new rows
											AddRow = True
										end if
%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../../includes/calc.js"></script>
<script type="text/javascript" language="JavaScript" src="../../../includes/validation.js"></script>
<script language="javascript">
<!--

	function validate(obj) {
		if (obj.drpStore.value=='-1') {
			window.alert ('You have to select a store from the store dropdown box.');
			obj.drpStore.focus();
			return false;
		};
		
		if (chkdate(obj.txtInvoiceDate) == false) {
			obj.txtInvoiceDate.select();
			window.alert('Enter a valid date.');
			obj.txtInvoiceDate.focus();
			return false;
		};	

		// Loop through the fileds
		for (var i =1;i<=obj.hidTotalCount.value;i++) {
			if (obj.elements['txtBarCode' + i].value == '') {
				window.alert ('Enter a Consumer Barcode for line item ' + i);
				obj.elements['txtBarCode' + i].focus();
				return false;
			};
			
			if (obj.elements['txtDescr' + i].value == '') {
				window.alert ('Enter a Description for line item ' + i);
				obj.elements['txtDescr' + i].focus();
				return false;
			};
			
			if ((!isFinite(obj.elements['txtQty' + i].value)) || (obj.elements['txtQty' + i].value=='0')) {
				window.alert ('Enter a numeric Quantity greater than 0 for line item ' + i);
				obj.elements['txtQty' + i].focus();
				return false;
			};
			
			if ((!isFinite(obj.elements['txtListCost' + i].value)) || (obj.elements['txtListCost' + i].value=='')) {
				window.alert ('Enter a List Cost for line item ' + i);
				obj.elements['txtListCost' + i].focus();
				return false;
			};
			
			window.alert (obj.elements['txtDealR' + i].value);
			
			if ((obj.elements['txtDealR' + i].value==0) || (obj.elements['txtDealR' + i].value=='') && (obj.elements['txtDealperc' + i].value==0) || (obj.elements['txtDealperc' + i].value=='')) {
				window.alert ('At least one of the deals should be filled in.');
				obj.elements['txtDealR' + i].focus();
				return false;
			};
		};
		
		if ((obj.txtCRAdjR1.value=='') || (obj.txtCRAdjR1.value==0)) {
			window.alert ('Enter a Trade 1 value.');
			obj.txtCRAdjR1.focus();
			return false;
		};
		
		if ((obj.txtCRAdjR2.value=='') || (obj.txtCRAdjR2.value==0)) {
			window.alert ('Enter a Trade 2 value.');
			obj.txtCRAdjR2.focus();
			return false;
		};
	};
	
//-->
</script>
<!--#include file="../../../layout/headclose.asp"-->
<!--#include file="../../../layout/bodystart.asp"-->
<p align="left"><img src="<%=const_app_ApplicationRoot%>/layout/images/sparlogo.gif"></p>
<p class="pcontent" align="left"><b>Copy Invoice</b></p>
<form name="frmInvoice" id="frmInvoice" method="post" action="newinvoice.asp" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pcontent">Supplier:&nbsp;<b>Test Supplier</b></td>
		<td class="pcontent" align="right">VAT Reg No&nbsp;:<b>12345678</b></td>
		<td class="pcontent" align="right">Store Name:
			<select name="drpStore" id="drpStore" class="pcontent">
<%
										if AddRow = false Then
%>			
				<option value="-1">-- Select a Store --</option>
<%
										end if
										
										' Get the list of stores for the selected supplier
										SQL = "exec listStores @SupplierID=1"
										
										' Set the connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										
										' Ececute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)

										' Loop through the recordset
										While not ReturnSet.EOF
											' Display the stores
											' Check which one was selected
											if CInt(Request.Form("drpStore")) = ReturnSet("StoreID") Then
												Selected = "selected"
											else
												Selected = ""
											end if
%>
				<option <%=selected%> value="<%=ReturnSet("StoreID")%>"><%=ReturnSet("StoreName")%></option>
<%				
																
											ReturnSet.MoveNext
										Wend
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>		
			</select>
		</td>
	</tr>
</table>
<table id="myTable" border="1" cellpadding="2" cellspacing="0" bordercolor="gray" width="100%" class="table">
	<tr bgcolor="#ccccc2">
		<td class="pcontent" colspan="15"><b><i>Invoice Details</i></b></td>
	</tr>
	<tr>
		<td class="pcontent" width="50%" colspan="7">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="pcontent" align="right"><b><i>Invoice Number</i></b></td>
					<td><input type="text" name="txtInvoiceNo" id="txtInvoiceNo" value="<%=Request.Form("txtInvoiceNo")%>" class="pcontent"></td>
				</tr>
			</table>
		</td>
		<td class="pcontent" width="50%" colspan="8">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="pcontent" align="right"><b><i>Invoice Date</i></b></td>
					<td class="pcontent"><input type="text" name="txtInvoiceDate" id="txtInvoiceDate" value="<%=Request.Form("txtInvoiceDate")%>" class="pcontent">&nbsp;[dd/mm/ccyy]</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr bgcolor="#ccccc2">
		<td class="pcontent" align="center"><i>Consumer Barcode<br>Supp Prod<br>Code</i></td>
		<td class="pcontent" align="center"><i>Description</i></td>
		<td class="pcontent" align="center"><i>Order Quantity</i></td>
		<td class="pcontent" align="center"><i>Total Measure</i></td>
		<td class="pcontent" align="center"><i>Unit of Measure</i></td>
		<td class="pcontent" align="center"><i>Supplier Pack</i></td>
		<td class="pcontent" align="center"><i>List Cost</i></td>
		<td class="pcontent" align="center"><i>Deal 1 Rand</i></td>
		<td class="pcontent" align="center"><i>Deal 2 %</i></td>
		<td class="pcontent" align="center"><i>Total (excl VAT)</i></td>
		<td class="pcontent" align="center"><i>VAT %</i></td>
		<td class="pcontent" align="center"><i>VAT R</i></td>
		<td class="pcontent" align="center"><i>Total<br>(incl VAT)</i></td>
		<td class="pcontent" align="center"><i>Qty of<br>Free Goods</i></td>
		<td class="pcontent" align="center"><i>Action<br>Add/Remove</i></td>
	</tr>
	
	<tr>
		<td class="tblcontent" align="center">
			<input type="text" name="txtBarCode1" id="txtBarCode1" size="10" class="tblcontent"><br>
			<input type="text" name="txtProdCode1" id="txtProdCode1" size="10" class="tblcontent">
		</td>
		<td class="tblcontent" align="center"><input type="text" name="txtDescr1" id="txtDescr1" size="20" class="tblcontent"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtQty1" id="txtQty1" value="0" size="2" class="tblcontent" onchange="calcTotalExcl(1);"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtMeasure1" id="txtMeasure1" size="2" class="tblcontent"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtUnit1" id="txtUnit1" size="2" class="tblcontent"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtSupPack1" id="txtSupPack1" size="2" class="tblcontent"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtListCost1" id="txtListCost1" value="0" size="5" class="tblcontent" onchange="calcTotalExcl(1);"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtDealR1" id="txtDealR1" size="5" value="0" class="tblcontent" onchange="calcTotalExcl(1);"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtDealperc1" id="txtDealperc1" value="0" size="5" class="tblcontent" onchange="calcTotalExcl(1);"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtTotalExcl1" id="txtTotalExcl1" value="0" size="5" class="tblcontent" onchange="calcTotalExcl(1);" disabled="true"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtVatperc1" id="txtVatperc1" value="0" size="2" class="tblcontent" onchange="calcVat(1);"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtVatr1" id="txtVatr1" value="0" size="5" class="tblcontent" disabled="true"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtTotalIncl1" id="txtTotalIncl1" value="0" size="5" class="tblcontent" disabled="true"></td>
		<td class="tblcontent" align="center"><input type="text" name="txtFreeQty1" id="txtFreeQty1" size="2" value="0" class="tblcontent"></td>
		<td class="tblcontent" align="center"><input type="button" name="btnNew1" id="btnNew1" value="Add" class="button" onclick="addRows('myTable',1);"><input type="checkbox" name="chkRemove1" id="chkRemove1" disabled></td>
	</tr>
	<TBODY></TBODY>
	<tr>
		<td colspan="9" class="pcontent">SUB TOTALS:</td>
		<td class="pcontent" align="center"><input type="text" name="txtSubTots1" id="txtSubTots1" size="5" class="pcontent" disabled="true"></td>
		<td>&nbsp;</td>
		<td class="pcontent" align="center"><input type="text" name="txtSubTots2" id="txtSubTots2" size="5" class="pcontent" disabled="true"></td>
		<td class="pcontent" align="center"><input type="text" name="txtSubTots3" id="txtSubTots3" size="5" class="pcontent" disabled="true"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="9" class="pcontent">CREDIT ADJUSTMENT (TRADE 1 - Rand/VAT):</td>
		<td class="pcontent" align="center"><input type="text" name="txtCRAdjR1" id="txtCRAdjR1" value="0" size="5" class="pcontent"></td>
		<td class="pcontent" align="center"><input type="text" name="txtCRAdjPerc1" id="txtCRAdjPerc1" value="0" size="5" class="pcontent" onchange="calcDealVat (document.frmInvoice.txtCRAdjR1.value, document.frmInvoice.txtCRAdjPerc1.value, document.frmInvoice.txtCRAdjRVat1, document.frmInvoice.txtCRAdjTotIncl1);"></td>
		<td class="pcontent" align="center"><input type="text" name="txtCRAdjRVat1" id="txtCRAdjRVat1" value="0" size="5" class="pcontent" disabled="true"></td>
		<td class="pcontent" align="center"><input type="text" name="txtCRAdjTotIncl1" id="txtCRAdjTotIncl1" value="0" size="5" class="pcontent" disabled="true"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="9" class="pcontent">CREDIT ADJUSTMENT (TRADE 2 - %/VAT):</td>
		<td class="pcontent" align="center"><input type="text" name="txtCRAdjR2" id="txtCRAdjR2" value="0" size="5" class="pcontent"></td>
		<td class="pcontent" align="center"><input type="text" name="txtCRAdjPerc2" id="txtCRAdjPerc2" value="0" size="5" class="pcontent" onchange="calcDealVat (document.frmInvoice.txtCRAdjR2.value, document.frmInvoice.txtCRAdjPerc2.value, document.frmInvoice.txtCRAdjRVat2, document.frmInvoice.txtCRAdjTotIncl2);"></td>
		<td class="pcontent" align="center"><input type="text" name="txtCRAdjRVat2" id="txtCRAdjRVat2" value="0" size="5" class="pcontent" disabled="true"></td>
		<td class="pcontent" align="center"><input type="text" name="txtCRAdjTotIncl2" id="txtCRAdjTotIncl2" value="0" size="5" class="pcontent" disabled="true"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="9" class="pcontent">DEBIT ADJUSTMENT - Rand/VAT:</td>
		<td class="pcontent" align="center"><input type="text" name="txtDBAdjR1" id="txtDBAdjR1" value="0" size="5" class="pcontent"></td>
		<td class="pcontent" align="center"><input type="text" name="txtDBAdjPerc1" id="txtDBAdjPerc1" value="0" size="5" class="pcontent" onchange="calcDealVat (document.frmInvoice.txtDBAdjR1.value, document.frmInvoice.txtDBAdjPerc1.value, document.frmInvoice.txtDBAdjVat1, document.frmInvoice.txtDBAdjTotIncl1);"></td>
		<td class="pcontent" align="center"><input type="text" name="txtDBAdjVat1" id="txtDBAdjVat1" value="0" size="5" class="pcontent" disabled="true"></td>
		<td class="pcontent" align="center"><input type="text" name="txtDBAdjTotIncl1" id="txtDBAdjTotIncl1" value="0" size="5" class="pcontent" disabled="true"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="9" class="pcontent">DEBIT ADJUSTMENT - %/VAT:</td>
		<td class="pcontent" align="center"><input type="text" name="txtDBAdjR2" id="txtDBAdjR2" value="0" size="5" class="pcontent"></td>
		<td class="pcontent" align="center"><input type="text" name="txtDBAdjPerc2" id="txtDBAdjPerc2" value="0" size="5" class="pcontent" onchange="calcDealVat (document.frmInvoice.txtDBAdjR2.value, document.frmInvoice.txtDBAdjPerc2.value, document.frmInvoice.txtDBAdjVat2, document.frmInvoice.txtDBAdjTotIncl2);"></td>
		<td class="pcontent" align="center"><input type="text" name="txtDBAdjVat2" id="txtDBAdjVat2" value="0" size="5" class="pcontent" disabled="true"></td>
		<td class="pcontent" align="center"><input type="text" name="txtDBAdjTotIncl2" id="txtDBAdjTotIncl2" value="0" size="5" class="pcontent" disabled="true"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="9" class="pcontent"><b>Grand Totals:</b></td>
		<td class="pcontent" align="center"><input type="text" name="txtGrandTotsExcl" id="txtGrandTotsExcl" value="0" size="5" class="pcontent" disabled="true"></td>
		<td>&nbsp;</td>
		<td class="pcontent" align="center"><input type="text" name="txtGrandTotsPerc" id="txtGrandTotsPerc" value="0" size="5" class="pcontent" disabled="true"></td>
		<td class="pcontent" align="center"><input type="text" name="txtGrandTotsIncl" id="txtGrandTotsIncl" value="0" size="5" class="pcontent" disabled="true"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="9" class="pcontent">SETTLEMENT DISCOUNT:</td>
		<td class="pcontent" align="center"><input type="text" name="txtSetDiscR" id="txtSetDiscR" size="5" class="pcontent"></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="14" class="pcontent">
			<input type="submit" name="btnSubmit" id="btnSubmit" value="Save/Send Invoice" class="button">&nbsp;
			<b><i>This will send the invoice to the selected store.</i></b>
			<input type="hidden" name="hidTotalCount" id="hidTotalCount" value="1">
		</td>
	</tr>
	<tr>
		<td colspan="14" class="pcontent"><input type="button" name="btnPrint" id="btnPrint" value="Print" class="button" onclick="window.print();">
			&nbsp;
			<b><i>This will print the Copy Invoice to your printer.</i></b>
		</td>
	</tr>
</table>
</form>
<!--#include file="../../../layout/end.asp"-->
