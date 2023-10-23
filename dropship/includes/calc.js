<!--
	function addRows(id,count){
		var tdcount = (parseFloat(count) + 1);
		var perc = "%"
		var rand = "R"
	
		var tbody = document.getElementById
		(id).getElementsByTagName("TBODY")[11];
		var row = document.createElement("<tr></tr>")

		var td1 = document.createElement("<td class='tblcontent' align='center'></td>")
		td1.appendChild(document.createTextNode(tdcount))
		td1.appendChild(document.createElement("<br>"))
		td1.appendChild(document.createElement("<input type='checkbox' name='chkDelete" + tdcount + "' id='chkDelete" + tdcount + "' onclick='document.frmInvoice.hidChkDelete" + tdcount + ".value=1;'>"))
		td1.appendChild(document.createElement("<br>"))
		td1.appendChild(document.createTextNode("Delete?"))
		td1.appendChild(document.createElement("<input type='hidden' name='hidChkDelete" + tdcount + "' id='hidChkDelete" + tdcount + "' value='0'>"))

		var td2 = document.createElement("<td class='tblcontent' align='left'></td>")
		td2.appendChild(document.createElement("<input type='text' name='txtBarCode" + tdcount + "' id='txtBarCode" + tdcount + "' size='15' class='tblcontent'>"))
		td2.appendChild(document.createElement("<br>"))
		td2.appendChild(document.createElement("<input type='text' name='txtOrdCode" + tdcount + "' id='txtOrdCode" + tdcount + "' size='15' class='tblcontent'>"))
		td2.appendChild(document.createElement("<br>"))
		td2.appendChild(document.createElement("<input type='text' name='txtProdCode" + tdcount + "' id='txtProdCode" + tdcount + "' size='10' class='tblcontent'>"))

		var td3 = document.createElement("<td class='tblcontent' align='center'></td>")
		td3.appendChild(document.createElement("<input type='text' name='txtDescr" + tdcount + "' id='txtDescr" + tdcount + "' size='25' class='tblcontent'>"))

		var td4 = document.createElement("<td class='tblcontent' align='center'></td>")
		td4.appendChild(document.createElement("<input type='text' name='txtQty" + tdcount + "' id='txtQty" + tdcount + "' size='2' value='0' class='tblcontent' onchange='calcTotalExcl(" + tdcount + ");'>"))

		var td5 = document.createElement("<td class='tblcontent' align='center'></td>")
		td5.appendChild(document.createElement("<input type='text' name='txtMeasure" + tdcount + "' id='txtMeasure" + tdcount + "' size='2' class='tblcontent'>"))

		var td6 = document.createElement("<td class='tblcontent' align='center'></td>")
		td6.appendChild(document.createElement("<input type='text' name='txtSupPack" + tdcount + "' id='txtSupPack" + tdcount + "' size='2' class='tblcontent'>"))

		var td7 = document.createElement("<td class='tblcontent' align='center'></td>")
		td7.appendChild(document.createElement("<input type='text' name='txtListCost" + tdcount + "' id='txtListCost" + tdcount + "' size='3' value='0.00' class='tblcontent' onchange='calcTotalExcl(" + tdcount + ");'>"))

		var td8 = document.createElement("<td class='tblcontent' align='center' valign='top'><table><tr><td class='pcontent' align='center' valign='top'></td></tr></table></td>")
		td8.appendChild(document.createElement("<input type='radio' name='rdTradeOne" + tdcount + "' id='rdTradeOne" + tdcount + "' value='1' checked='true' onclick='document.frmInvoice.txtDealpercOne" + tdcount + ".value=document.frmInvoice.hidDealpercOne" + tdcount + ".value;'>"))
		td8.appendChild(document.createTextNode("%"))
		td8.appendChild(document.createElement("<input type='radio' name='rdTradeOne" + tdcount + "' id='rdTradeOne" + tdcount + "' value='3' onclick='document.frmInvoice.txtDealpercOne" + tdcount + ".value=document.frmInvoice.hidDealpercOne" + tdcount + ".value;'>"))
		td8.appendChild(document.createTextNode("R"))
		td8.appendChild(document.createElement("<br>"))
		td8.appendChild(document.createElement("<input type='text' name='txtDealpercOne" + tdcount + "' id='txtDealpercOne" + tdcount + "' size='3' value='0.00' class='tblcontent' onchange='calcTotalExcl(" + tdcount + ");calcTotalExcl(" + tdcount + ")'>"))
		td8.appendChild(document.createElement("<input type='hidden' name='hidDealpercOne" + tdcount + "' id='hidDealpercOne" + tdcount + "' size='3' value='0.00' class='tblcontent'>"))
		
		var td9 = document.createElement("<td class='tblcontent' align='center' valign='top'><table><tr><td class='pcontent' align='center' valign='top'></td></tr></table></td>")
		td9.appendChild(document.createElement("<input type='radio' name='rdTradeTwo" + tdcount + "' id='rdTradeTwo" + tdcount + "' value='1' checked='true' onclick='document.frmInvoice.txtDealpercTwo" + tdcount + ".value=document.frmInvoice.hidDealpercTwo" + tdcount + ".value;'>"))
		td9.appendChild(document.createTextNode("%"))
		td9.appendChild(document.createElement("<input type='radio' name='rdTradeTwo" + tdcount + "' id='rdTradeTwo" + tdcount + "' value='2' onclick='document.frmInvoice.txtDealpercTwo" + tdcount + ".value=document.frmInvoice.hidDealpercTwo" + tdcount + ".value;'>"))
		td9.appendChild(document.createTextNode("R"))
		td9.appendChild(document.createElement("<br>"))
		td9.appendChild(document.createElement("<input type='text' name='txtDealpercTwo" + tdcount + "' id='txtDealpercTwo" + tdcount + "' size='3' value='0.00' class='tblcontent' onchange='calcTotalExcl(" + tdcount + ");calcTotalExcl(" + tdcount + ")'>"))
		td9.appendChild(document.createElement("<input type='hidden' name='hidDealpercTwo" + tdcount + "' id='hidDealpercTwo" + tdcount + "' size='3' value='0.00' class='tblcontent'>"))

		var td10 = document.createElement("<td class='tblcontent' align='center'></td>")
		td10.appendChild(document.createElement("<input type='text' name='txtTotalExcl" + tdcount + "' id='txtTotalExcl" + tdcount + "' size='3' value='0.00' class='tblcontent' onfocus='calcTotalExcl(" + tdcount + ");' disabled='true'>"))
		td10.appendChild(document.createElement("<input type='hidden' name='hidTotalExcl" + tdcount + "' id='hidTotalExcl" + tdcount + "' value='0.00'>"))

		var td11 = document.createElement("<td class='tblcontent' align='center'></td>")
		var guiSel = td11.appendChild(document.createElement("<select name='txtVatperc" + tdcount + "' id='txtVatperc" + tdcount + "' onchange='calcVat(" + tdcount + ");' class='tblcontent'>"));
		var a=[0,10,14];
		for(i=0;i<a.length;i++) {
			guiSel.options[guiSel.options.length]=new Option(a[i],a[i]);
		};

		var td12 = document.createElement("<td class='tblcontent' align='center'></td>")
		td12.appendChild(document.createElement("<input type='text' name='txtVatr" + tdcount + "' id='txtVatr" + tdcount + "' size='3' value='0.00' class='tblcontent' disabled='true'>"))
		td12.appendChild(document.createElement("<input type='hidden' name='hidVatr" + tdcount + "' id='hidVatr" + tdcount + "' value='0.00'>"))

		var td13 = document.createElement("<td class='tblcontent' align='center'></td>")
		td13.appendChild(document.createElement("<input type='text' name='txtTotalIncl" + tdcount + "' id='txtTotalIncl" + tdcount + "' size='3' value='0.00' class='tblcontent' disabled='true'>"))
		td13.appendChild(document.createElement("<input type='hidden' name='hidTotalIncl" + tdcount + "' id='hidTotalIncl" + tdcount + "' value='0.00'>"))

		var td14 = document.createElement("<td class='tblcontent' align='center'></td>")
		td14.appendChild(document.createElement("<input type='text' name='txtFreeQty" + tdcount + "' id='txtFreeQty" + tdcount + "' size='2' value='0' class='tblcontent'>"))

		document.frmInvoice.hidTotalCount.value = parseFloat(document.frmInvoice.hidTotalCount.value) + 1
		
		row.appendChild(td1);
		row.appendChild(td2);
		row.appendChild(td3);
		row.appendChild(td4);
		row.appendChild(td5);
		row.appendChild(td6);
		row.appendChild(td7);
		row.appendChild(td8);
		row.appendChild(td9);
		row.appendChild(td10);
		row.appendChild(td11);
		row.appendChild(td12);
		row.appendChild(td13);
		row.appendChild(td14);
		tbody.appendChild(row);
	};
	
	function validate(obj) {
		if (obj.hidSupAction.value=='1') {
			// Check if the User selected a supplier
			if (obj.drpSupplier.value=='-1') {
				window.alert ('Select a Supplier from the Supplier drop down box.');
				obj.drpSupplier.focus();
				return false;
			};
		};
		
		if (obj.hidNew.value=='1') {
			// Check if the user selected a Store
			if (obj.drpStore.value=='-1') {
				window.alert ('Select a Store from the Store drop down box.');
				obj.drpStore.focus();
				return false;
			};
			
			// Check if the user entered a delivery date
			if (chkdate(obj.txtDelivDate) == false) {
				obj.txtDelivDate.select();
				window.alert('Enter a valid Delivery Date.');
				obj.txtDelivDate.focus();
				return false;
			};	
		};
	
		/* Invoice number and date longer mandatory - Order Enhancments
			Petrus Daffue, 2014-09-02
		if (obj.txtInvoiceNo.value=='') {
			window.alert ('You have to supply an Invoice Number.');
			obj.txtInvoiceNo.focus();
			return false;
		};
		
		if (chkdate(obj.txtInvoiceDate) == false) {
			obj.txtInvoiceDate.select();
			window.alert('Enter a valid Invoice Date.');
			obj.txtInvoiceDate.focus();
			return false;
		};	
		*/
		
		// Loop through the fileds
		for (var i=1;i<=obj.hidTotalCount.value;i++) {
			if (obj.elements['txtProdCode' + i].value=='') {
				window.alert ('You have to supply a Supplier Product Code for Line item ' + i);
				obj.elements['txtProdCode' + i].focus();
				return false;
			};
			
			if (obj.elements['txtDescr' + i].value=='') {
				window.alert ('You have to supply a Product Description for Line item ' + i);
				obj.elements['txtDescr' + i].focus();
				return false;
			};
			
			if ((!isFinite(obj.elements['txtQty' + i].value)) || (obj.elements['txtQty' + i].value=='')) {
				window.alert ('Enter a numeric Quantity greater than 0 for line item ' + i);
				obj.elements['txtQty' + i].focus();
				return false;
			};
			
			if ((!isFinite(obj.elements['txtSupPack' + i].value)) || (obj.elements['txtSupPack' + i].value=='')) {
				window.alert ('Enter a numeric Supplier Pack for line item ' + i);
				obj.elements['txtSupPack' + i].focus();
				return false;
			};
			
			if ((!isFinite(obj.elements['txtListCost' + i].value)) || (obj.elements['txtListCost' + i].value=='')) {
				window.alert ('Enter a List Cost for line item ' + i);
				obj.elements['txtListCost' + i].focus();
				return false;
			};
			
			if ((!isFinite(obj.elements['txtDealpercOne' + i].value)) || (obj.elements['txtDealpercOne' + i].value=='')) {
				window.alert ('Enter a valid numeric Deal value into the Deal 1 field on line item ' + i);
				obj.elements['txtDealpercOne' + i].focus();
				return false;
			};
			
			if ((!isFinite(obj.elements['txtDealpercTwo' + i].value)) || (obj.elements['txtDealpercTwo' + i].value=='')) {
				window.alert ('Enter a valid numeric Deal value into the Deal 2 field on line item ' + i);
				obj.elements['txtDealpercTwo' + i].focus();
				return false;
			};
		};
		
		if ((!isFinite(obj.elements['txtDealOne'].value)) || (obj.elements['txtDealOne'].value=='')) {
			window.alert ('Enter a valid numeric Trade value into the Trade 1 field');
			obj.elements['txtDealOne'].focus();
			return false;
		};
		
		if ((!isFinite(obj.elements['txtDealTwo'].value)) || (obj.elements['txtDealTwo'].value=='')) {
			window.alert ('Enter a valid numeric Trade value into the Trade 2 field');
			obj.elements['txtDealTwo'].focus();
			return false;
		};
		
		if ((!isFinite(obj.elements['txtDealThree'].value)) || (obj.elements['txtDealThree'].value=='')) {
			window.alert ('Enter a valid numeric Additional Discount value into the Addtional Discount field');
			obj.elements['txtDealThree'].focus();
			return false;
		};
		
		if ((!isFinite(obj.elements['txtDealFour'].value)) || (obj.elements['txtDealFour'].value=='')) {
			window.alert ('Enter a valid numeric Transport Cost value into the Transport Costs field');
			obj.elements['txtDealFour'].focus();
			return false;
		};
		
		if ((!isFinite(obj.elements['txtDealFive'].value)) || (obj.elements['txtDealFive'].value=='')) {
			window.alert ('Enter a valid numeric Duty/Levy Cost into the Duty/Levy Cost field');
			obj.elements['txtDealFive'].focus();
			return false;
		};
		
		if ((!isFinite(obj.elements['txtSettle'].value)) || (obj.elements['txtSettle'].value=='')) {
			window.alert ('Enter a valid numeric Settlement Discount value into the Settlement Discount field');
			obj.elements['txtSettle'].focus();
			return false;
		};
		
		
		return true;
	};
	
	function DisableBut (id) {
		document.frmInvoice.elements['btnNew' + id].disabled = true;
		document.frmInvoice.elements['chkRemove' + id].disabled = false;
	};
	
	function loadDefault () {
		for (var i=1;i<=document.frmInvoice.hidTotalCount.value;i++) {
			calcTotalExcl (i);
		};
		
		calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1);
		calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo,2);
		calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree,3);
		
		calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1);
		calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2);
		calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1);
		
		
	};
	
	function calcTotalExcl(id) {
		var Total
		var DealPerc1
		var DealPerc2
		var found_it //initial value is null because we gave it no other value
	
		
		var InvQty = document.frmInvoice.elements['txtQty' + id].value;
		var Deal1 = document.frmInvoice.elements['txtDealpercOne' + id].value;
		var Deal2 = document.frmInvoice.elements['txtDealpercTwo' + id].value;
		var InvListCost = document.frmInvoice.elements['txtListCost' + id].value;
		
		var rdTradeOne = 0;
		if (document.frmInvoice.elements['rdTradeOne' + id][0].checked)
			rdTradeOne = document.frmInvoice.elements['rdTradeOne' + id][0].value;
		else
			rdTradeOne = document.frmInvoice.elements['rdTradeOne' + id][1].value;
		
		var rdTradeTwo = 0;
		if (document.frmInvoice.elements['rdTradeTwo' + id][0].checked)
			rdTradeTwo = document.frmInvoice.elements['rdTradeTwo' + id][0].value;
		else
			rdTradeTwo = document.frmInvoice.elements['rdTradeTwo' + id][1].value;
		 
		
		/* Percentage selected 1, amount 2 */
		if (rdTradeOne == 1) 
			Deal1 = Deal1 * InvListCost / 100
		
		if (rdTradeTwo == 1) 
			Deal2 = Deal2 * (InvListCost-Deal1) / 100
		
		var NewPrice = InvListCost - Deal1 - Deal2
		
		var Total = InvQty * NewPrice
		
		document.frmInvoice.elements['txtTotalExcl' + id].value = FormatToNumber(Total,2);
		document.frmInvoice.elements['hidTotalExcl' + id].value = FormatToNumber(Total,2);
		/*
	// Calc the totalExcl val	
	
		Total = (document.frmInvoice.elements['txtListCost' + id].value * document.frmInvoice.elements['txtQty' + id].value);
		
		
		
		// Check if the value entered is not 0 or 0.00
		if ((Math.round(document.frmInvoice.elements['txtDealpercOne' + id].value!=0))) {
			for (var i=0; i<document.frmInvoice.elements['rdTradeOne'+id].length; i++)  { 
				if (document.frmInvoice.elements['rdTradeOne'+id][i].checked)  {
					found_it = document.frmInvoice.elements['rdTradeOne'+id][i].value; //set found_it equal to checked button's value
				}; 
			};
		
			// Check if the user selected to add a percentage or rand value
			if (found_it=='1') {
				// Calc the perc val
				DealPerc1 = (Total * document.frmInvoice.elements['txtDealpercOne' + id].value / 100);
				Total = (Total - DealPerc1);
			} else {
				// Calc the rand val
				Total = (Total - document.frmInvoice.elements['txtDealpercOne' + id].value);
			};
		};
		
		// Check if the value entered is not 0 or 0.00
		if (Math.round(document.frmInvoice.elements['txtDealpercTwo' + id].value!=0)) {
			for (var i=0; i<document.frmInvoice.elements['rdTradeTwo'+id].length; i++)  { 
				if (document.frmInvoice.elements['rdTradeTwo'+id][i].checked)  {
					found_it = document.frmInvoice.elements['rdTradeTwo'+id][i].value; //set found_it equal to checked button's value
				}; 
			};
		
			// Check if the user selected to add a percentage or rand value
			if (found_it=='1') {
				// Calc the perc val
				DealPerc2 = (Total * document.frmInvoice.elements['txtDealpercTwo' + id].value / 100);
			Total = (Total - DealPerc2);
			} else {
				// Calc the rand val
				Total = (Total - document.frmInvoice.elements['txtDealpercTwo' + id].value);
			};
		};
		
		document.frmInvoice.elements['txtTotalExcl' + id].value = FormatToNumber(Total,2);
		document.frmInvoice.elements['hidTotalExcl' + id].value = FormatToNumber(Total,2);
		
		*/
		calcVat (id);
		calcTots ();
	
		return true;
	};
	
	function calcVat (id) {
		var TotalVat
		var GrandTotal
		var SubTotsExcl
		var SubTotsVat

		TotalVat = (document.frmInvoice.elements['txtTotalExcl' + id].value * document.frmInvoice.elements['txtVatperc' + id].value / 100);
		
		document.frmInvoice.elements['txtVatr' + id].value = FormatToNumber(TotalVat,2);
		document.frmInvoice.elements['hidVatr' + id].value = FormatToNumber(TotalVat,2);
		GrandTotal = (parseFloat(document.frmInvoice.elements['txtTotalExcl' + id].value) + parseFloat(TotalVat));
		document.frmInvoice.elements['txtTotalIncl' + id].value = FormatToNumber(GrandTotal,2);
		document.frmInvoice.elements['hidTotalIncl' + id].value = FormatToNumber(GrandTotal,2);
		
		calcTots ();
		
		return true;
	};
	
	function calcTots () {
		if (document.frmInvoice.txtFilter.value != -1)
			if (document.frmInvoice.txtFilter.value.split(',')[0] != 1)
				return true;
	
		var TotsExcl = 0;
		var TotsVat = 0;
		var TotsIncl = 0;

		// Loop through the fields to calc the Total(excl), VatR and Total(incl) sub totals
		for (var i=1;i<=document.frmInvoice.hidTotalCount.value;i++) {
			// Calc the sub total excl vat
			TotsExcl = (parseFloat(TotsExcl) + parseFloat(document.frmInvoice.elements['txtTotalExcl' + i].value));
			TotsVat = (parseFloat(TotsVat) + parseFloat(document.frmInvoice.elements['txtVatr' + i].value));
			TotsIncl = (parseFloat(TotsIncl) + parseFloat(document.frmInvoice.elements['txtTotalIncl' + i].value));
		};

		document.frmInvoice.txtTots1.value = FormatToNumber(TotsExcl,2);
		document.frmInvoice.txtTots2.value = FormatToNumber(TotsVat,2);
		document.frmInvoice.txtTots3.value = FormatToNumber(TotsIncl,2);
		document.frmInvoice.hidTots1.value = FormatToNumber(TotsExcl,2);
		document.frmInvoice.hidTots2.value = FormatToNumber(TotsVat,2);
		document.frmInvoice.hidTots3.value = FormatToNumber(TotsIncl,2);
		
		
		calcSubTots ();
		calcInvTots ();
		calcDueTots ();
		
		return true;
	};
	
	function calcDealDisc (txtObj, rdObj,id) {
		if (document.frmInvoice.txtFilter.value != -1)
			if (document.frmInvoice.txtFilter.value.split(',')[0] != 1)
				return true;
		
		var VatPercentage = 14/100;
		var found_it;
		var Discount;
		var Total1 = document.frmInvoice.txtTots1.value;
		var Total2 = document.frmInvoice.txtTots2.value;
		var Total3 = document.frmInvoice.txtTots3.value;

		// Check if trade1 value is not 0
		if (Math.round(txtObj.value)!=0){
			// check if the user selected percentage or rand
			for (var i=0; i<rdObj.length; i++)  { 
				if (rdObj[i].checked)  {
					found_it = rdObj[i].value; //set found_it equal to checked button's value
				}; 
			};
			
			if (id==1) {
				// Check if the user selected to add a percentage or rand value
				if (found_it=='1') {
					// Calc the perc val
					Total1 = (Total1 * txtObj.value / 100);
					Total2 = (Total2 * txtObj.value / 100);
					Total3 = (Total3 * txtObj.value / 100);
				} else {
					// Calc the rand val
					Total1 = (txtObj.value);
					Total2 = (txtObj.value * VatPercentage);
					Total3 = (txtObj.value * (1+VatPercentage));
				};
			};
			
			if (id==2) {
				// Check if the user selected to add a percentage or rand value
				if (found_it=='1') {
					// Calc the perc val
					Total1 = ((Total1 - document.frmInvoice.elements['txtCRAdjR'+1].value) * txtObj.value / 100);
					Total2 = ((Total2 - document.frmInvoice.elements['txtCRAdjRVat'+1].value) * txtObj.value / 100);
					Total3 = ((Total3 - document.frmInvoice.elements['txtCRAdjTotIncl'+1].value) * txtObj.value / 100);
				} else {
					// Calc the rand val
					Total1 = (txtObj.value);
					Total2 = (txtObj.value * VatPercentage);
					Total3 = (txtObj.value * (1+VatPercentage));
				};
			};
			
			if (id==3) {
				// Check if the user selected to add a percentage or rand value
				if (found_it=='1') {
					// Calc the perc val
					Total1 = ((Total1 - document.frmInvoice.elements['txtCRAdjR'+1].value - document.frmInvoice.elements['txtCRAdjR'+2].value) * txtObj.value / 100);
					Total2 = ((Total2 - document.frmInvoice.elements['txtCRAdjRVat'+1].value - document.frmInvoice.elements['txtCRAdjRVat'+2].value) * txtObj.value / 100);
					Total3 = ((Total3 - document.frmInvoice.elements['txtCRAdjTotIncl'+1].value - document.frmInvoice.elements['txtCRAdjTotIncl'+2].value) * txtObj.value / 100);
				} else {
					// Calc the rand val
					Total1 = (txtObj.value);
					Total2 = (txtObj.value * VatPercentage);
					Total3 = (txtObj.value * (1+VatPercentage));
				};
			};
			
			document.frmInvoice.elements['txtCRAdjR'+id].value = FormatToNumber(Total1,2);
			document.frmInvoice.elements['txtCRAdjRVat'+id].value = FormatToNumber(Total2,2);
			document.frmInvoice.elements['txtCRAdjTotIncl'+id].value = FormatToNumber(Total3,2);
			document.frmInvoice.elements['hidCRAdjR'+id].value = FormatToNumber(Total1,2);
			document.frmInvoice.elements['hidCRAdjRVat'+id].value = FormatToNumber(Total2,2);
			document.frmInvoice.elements['hidCRAdjTotIncl'+id].value = FormatToNumber(Total3,2);

		} else {
		
			document.frmInvoice.elements['txtCRAdjR'+id].value = '0.00';
			document.frmInvoice.elements['txtCRAdjRVat'+id].value = '0.00';
			document.frmInvoice.elements['txtCRAdjTotIncl'+id].value = '0.00';
			document.frmInvoice.elements['hidCRAdjR'+id].value = '0.00';
			document.frmInvoice.elements['hidCRAdjRVat'+id].value = '0.00';
			document.frmInvoice.elements['hidCRAdjTotIncl'+id].value = '0.00';
		};
		
		calcSubTots ()
		
		return true;
	};
	
	function calcTransLev (txtObj, rdObj,id) {
		if (document.frmInvoice.txtFilter.value != -1)
			if (document.frmInvoice.txtFilter.value.split(',')[0] != 1)
				return true;
	
		var VatPercentage = 14/100;
		var found_it;
		var Discount;
		var Total1 = parseFloat(document.frmInvoice.txtSubTots1.value);
		var Total2 = parseFloat(document.frmInvoice.txtSubTots2.value);
		var Total3 = parseFloat(document.frmInvoice.txtSubTots3.value);
		
		if (Math.round(txtObj.value)!=0){
			// check if the user selected percentage or rand
			for (var i=0; i<rdObj.length; i++)  { 
				if (rdObj[i].checked)  {
					found_it = rdObj[i].value; //set found_it equal to checked button's value
				}; 
			};
			
			if (id==1) {
				// Check if the user selected to add a percentage or rand value
				if (found_it=='1') {
					// Calc the perc val
					Total1 = (Total1 * txtObj.value / 100);
					Total2 = (Total2 * txtObj.value / 100);
					Total3 = (Total3 * txtObj.value / 100);
				} else {
					// Calc the rand val
					Total1 = (txtObj.value);
					Total2 = (txtObj.value * VatPercentage);
					Total3 = (txtObj.value * (1+VatPercentage));
				};
			};
			
			if (id==2) {
				// Check if the user selected to add a percentage or rand value
				if (found_it=='1') {
					// Calc the perc val
					Total1 = ((Total1 + parseFloat(document.frmInvoice.elements['txtDBAdjR1'].value)) * txtObj.value / 100);
					Total2 = ((Total2 + parseFloat(document.frmInvoice.elements['txtDBAdjRVat1'].value)) * txtObj.value / 100);
					Total3 = ((Total3 + parseFloat(document.frmInvoice.elements['txtDBAdjTotIncl1'].value)) * txtObj.value / 100);
				} else {
					// Calc the rand val
					Total1 = (txtObj.value);
					Total2 = (txtObj.value * VatPercentage);
					Total3 = (txtObj.value * (1+VatPercentage));
				};
			};
			
			document.frmInvoice.elements['txtDBAdjR'+id].value = FormatToNumber(Total1,2);
			document.frmInvoice.elements['txtDBAdjRVat'+id].value = FormatToNumber(Total2,2);
			document.frmInvoice.elements['txtDBAdjTotIncl'+id].value = FormatToNumber(Total3,2);
			document.frmInvoice.elements['hidDBAdjR'+id].value = FormatToNumber(Total1,2);
			document.frmInvoice.elements['hidDBAdjRVat'+id].value = FormatToNumber(Total2,2);
			document.frmInvoice.elements['hidDBAdjTotIncl'+id].value = FormatToNumber(Total3,2);

		} else {
		
			document.frmInvoice.elements['txtDBAdjR'+id].value = '0.00';
			document.frmInvoice.elements['txtDBAdjRVat'+id].value = '0.00';
			document.frmInvoice.elements['txtDBAdjTotIncl'+id].value = '0.00';
			document.frmInvoice.elements['hidDBAdjR'+id].value = '0.00';
			document.frmInvoice.elements['hidDBAdjRVat'+id].value = '0.00';
			document.frmInvoice.elements['hidDBAdjTotIncl'+id].value = '0.00';
		};
		
		calcInvTots ();
		
		return true;
	};
	
	function calcSettle (txtObj, rdObj,id) {
		if (document.frmInvoice.txtFilter.value != -1)
			if (document.frmInvoice.txtFilter.value.split(',')[0] != 1)
				return true;
		
	
	var VatPercentage = 14/100;
		var found_it;
		var Discount;
		var Total1 = document.frmInvoice.txtInvTots1.value;
		var Total2 = document.frmInvoice.txtInvTots2.value;
		var Total3 = document.frmInvoice.txtInvTots3.value;
		
		if (Math.round(txtObj.value)!=0){
			// check if the user selected percentage or rand
			for (var i=0; i<rdObj.length; i++)  { 
				if (rdObj[i].checked)  {
					found_it = rdObj[i].value; //set found_it equal to checked button's value
				}; 
			};
			
			if (id==1) {
				// Check if the user selected to add a percentage or rand value
				if (found_it=='1') {
					// Calc the perc val
					Total1 = (Total1 * txtObj.value / 100);
					Total2 = (Total2 * txtObj.value / 100);
					Total3 = (Total3 * txtObj.value / 100);
				} else {
					// Calc the rand val
					Total1 = (txtObj.value);
					Total2 = (txtObj.value * VatPercentage);
					Total3 = (txtObj.value * (1+VatPercentage));
				};
			};
			
			document.frmInvoice.elements['txtSetTotExl'].value = FormatToNumber(Total1,2);
			document.frmInvoice.elements['txtSetTotVat'].value = FormatToNumber(Total2,2);
			document.frmInvoice.elements['txtSetTotIncl'].value = FormatToNumber(Total3,2);
			document.frmInvoice.elements['hidSetTotExl'].value = FormatToNumber(Total1,2);
			document.frmInvoice.elements['hidSetTotVat'].value = FormatToNumber(Total2,2);
			document.frmInvoice.elements['hidSetTotIncl'].value = FormatToNumber(Total3,2);

		} else {
		
			document.frmInvoice.elements['txtSetTotExl'].value = '0.00';
			document.frmInvoice.elements['txtSetTotVat'].value = '0.00';
			document.frmInvoice.elements['txtSetTotIncl'].value = '0.00';
			document.frmInvoice.elements['hidSetTotExl'].value = '0.00';
			document.frmInvoice.elements['hidSetTotVat'].value = '0.00';
			document.frmInvoice.elements['hidSetTotIncl'].value = '0.00';
		};
		
		calcDueTots ();
		
		
		return true;
	};
	
	function calcSubTots () {
		var SubTotsExcl = 0;
		var SubTotsVat = 0;
		var SubTotsIncl = 0;
		
	
		// Subtract the first discount
		SubTotsExcl = (parseFloat(document.frmInvoice.elements['txtTots1'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjR1'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjR2'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjR3'].value));

		// Subtract the second discount
		SubTotsVat = (parseFloat(document.frmInvoice.elements['txtTots2'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjRVat1'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjRVat2'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjRVat3'].value));

		// Subtract the third discount
		SubTotsIncl = (parseFloat(document.frmInvoice.elements['txtTots3'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjTotIncl1'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjTotIncl2'].value) - parseFloat(document.frmInvoice.elements['txtCRAdjTotIncl3'].value));

		document.frmInvoice.txtSubTots1.value = FormatToNumber(SubTotsExcl,2);
		document.frmInvoice.txtSubTots2.value = FormatToNumber(SubTotsVat,2);
		document.frmInvoice.txtSubTots3.value = FormatToNumber(SubTotsIncl,2);
		document.frmInvoice.hidSubTots1.value = FormatToNumber(SubTotsExcl,2);
		document.frmInvoice.hidSubTots2.value = FormatToNumber(SubTotsVat,2);
		document.frmInvoice.hidSubTots3.value = FormatToNumber(SubTotsIncl,2);
		
		return true;
	};
	
	function calcInvTots () {
		var InvTotsExcl = 0;
		var InvTotsVat = 0;
		var InvTotsIncl = 0;
		
	
		// Add the first discount
		InvTotsExcl = (parseFloat(document.frmInvoice.elements['txtSubTots1'].value) + parseFloat(document.frmInvoice.elements['txtDBAdjR1'].value) + parseFloat(document.frmInvoice.elements['txtDBAdjR2'].value));

		// Add the second discount
		InvTotsVat = (parseFloat(document.frmInvoice.elements['txtSubTots2'].value) + parseFloat(document.frmInvoice.elements['txtDBAdjRVat1'].value) + parseFloat(document.frmInvoice.elements['txtDBAdjRVat2'].value));

		// Add the third discount
		InvTotsIncl = (parseFloat(document.frmInvoice.elements['txtSubTots3'].value) + parseFloat(document.frmInvoice.elements['txtDBAdjTotIncl1'].value) + parseFloat(document.frmInvoice.elements['txtDBAdjTotIncl2'].value));

		document.frmInvoice.txtInvTots1.value = FormatToNumber(InvTotsExcl,2);
		document.frmInvoice.txtInvTots2.value = FormatToNumber(InvTotsVat,2);
		document.frmInvoice.txtInvTots3.value = FormatToNumber(InvTotsIncl,2);
		document.frmInvoice.hidInvTots1.value = FormatToNumber(InvTotsExcl,2);
		document.frmInvoice.hidInvTots2.value = FormatToNumber(InvTotsVat,2);
		document.frmInvoice.hidInvTots3.value = FormatToNumber(InvTotsIncl,2);
		
		return true;
	};
	
	function calcDueTots () {
		var NettTotsExcl = 0;
		var NettTotsVat = 0;
		var NettTotsIncl = 0;
		
	
		// Add the first discount
		NettTotsExcl = (parseFloat(document.frmInvoice.elements['txtInvTots1'].value) - parseFloat(document.frmInvoice.elements['txtSetTotExl'].value));

		// Add the second discount
		NettTotsVat = (parseFloat(document.frmInvoice.elements['txtInvTots2'].value) - parseFloat(document.frmInvoice.elements['txtSetTotVat'].value));

		// Add the third discount
		NettTotsIncl = (parseFloat(document.frmInvoice.elements['txtInvTots3'].value) - parseFloat(document.frmInvoice.elements['txtSetTotIncl'].value));

		document.frmInvoice.txtNettTotExcl.value = FormatToNumber(NettTotsExcl,2);
		document.frmInvoice.txtNettTotVat.value = FormatToNumber(NettTotsVat,2);
		document.frmInvoice.txtNettTotIncl.value = FormatToNumber(NettTotsIncl,2);
		document.frmInvoice.hidNettTotExcl.value = FormatToNumber(NettTotsExcl,2);
		document.frmInvoice.hidNettTotVat.value = FormatToNumber(NettTotsVat,2);
		document.frmInvoice.hidNettTotIncl.value = FormatToNumber(NettTotsIncl,2);
		
		return true;
	};

	function calcGrandTots() {
		var TotExcl = document.frmInvoice.txtTots1.value;
		var TotVat = document.frmInvoice.txtTots2.value;
		var TotIncl = document.frmInvoice.txtTots3.value;
		
		// Calculate the total Excl vat grand total
		TotExcl = (parseFloat(TotExcl) - parseFloat(document.frmInvoice.txtCRAdjR1.value));
		
		if (document.frmInvoice.txtCRAdjR2.value > 0) {
			TotExcl = (parseFloat(TotExcl) - parseFloat(TotExcl) * parseFloat(document.frmInvoice.txtCRAdjR2.value / 100));
		};
		
		/*TotExcl = (parseFloat(TotExcl) + parseFloat(document.frmInvoice.txtDBAdjR1.value));
		TotExcl = (parseFloat(TotExcl) + parseFloat(TotExcl) * parseFloat(document.frmInvoice.txtDBAdjR2.value / 100));*/
		
		// Calculate the total vat
		TotVat = (parseFloat(TotVat) - parseFloat(document.frmInvoice.txtCRAdjRVat1.value) - parseFloat(document.frmInvoice.txtCRAdjRVat2.value));
		/*TotVat = (parseFloat(TotVat) + parseFloat(document.frmInvoice.txtDBAdjVat1.value) + parseFloat(document.frmInvoice.txtDBAdjVat2.value));*/
		
		/*document.frmInvoice.txtGrandTotsExcl.value = FormatToNumber(TotExcl,2);
		document.frmInvoice.txtGrandTotsPerc.value = FormatToNumber(TotVat,2);
		
		// Calculate the Total incl vat
		TotIncl = (parseFloat(TotIncl) - parseFloat(document.frmInvoice.txtCRAdjTotIncl1.value) - parseFloat(document.frmInvoice.txtCRAdjTotIncl2.value));
		TotIncl = (parseFloat(TotIncl) + parseFloat(document.frmInvoice.txtDBAdjTotIncl1.value) + parseFloat(document.frmInvoice.txtDBAdjTotIncl2.value));
		
		document.frmInvoice.txtGrandTotsIncl.value = FormatToNumber(TotIncl,2);*/
		
		return true;
	};
	
	function calcDealVat (Val, Vat, VatR, TotIncl) {
		var TotVat = 0;
		var TotalIncl = 0;

		TotVat = parseFloat(Val * Vat / 100); 
		TotalIncl = parseFloat(Val) + parseFloat(TotVat); 

		TotIncl.value = FormatToNumber(TotalIncl,2);
		VatR.value = FormatToNumber(TotVat,2);
		
		calcGrandTots();
		
		return true;
	};
	
	/*function FormatToNumber(numToChange) {
		var tmpNum
		var formatNum
		var strChangeToString
		var strBegin
		var strLast
		var itemCount
		var MyArray

		// Multiply the numToChange with 100
		tmpNum = numToChange * 100;

		// Convert the number to a string
		strChangeToString = "" + tmpNum;
	
		MyArray = strChangeToString.split(".");
			
		// get the first few caracters axecpt the last two
		strBegin = MyArray[0].substring(0, MyArray[0].length-2);
		//get the last two characters from the string
		strLast = MyArray[0].substr(MyArray[0].length-4, (MyArray[0].length));
		
		window.alert (strLast);

		// Concatenate the string
		formatNum = strBegin + '.' + strLast;
			
		// return the concatenated sting
		return formatNum;
	};*/
	
	function FormatToNumber(expr, decplaces) {
		var str = "" + Math.round(eval(expr) * Math.pow(10,decplaces));
		
		while (str.length <= decplaces) {
			str = "0" + str;
		}
		
		var decpoint = str.length - decplaces;
		return str.substring(0,decpoint) + "." + str.substring(decpoint, str.length);
	};
	
	function fNumericOnly(textBox) {
		textBox.value = textBox.value.replace(/[^\0-9]/ig,"");

	}	
	
	
//-->