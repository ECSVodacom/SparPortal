<!--
	function addRows(id,count){
		var tdcount = (parseFloat(count) + 1);
		var perc = "%"
		var rand = "R"
	
		var tbody = document.getElementById
		(id).getElementsByTagName("TBODY")[6];
		var row = document.createElement("<tr></tr>")

		var td1 = document.createElement("<td class='pcontent' align='center'></td>")
		td1.appendChild(document.createTextNode(tdcount + "."))
		
		var td2 = document.createElement("<td class='pcontent' align='center'></td>")
		td2.appendChild(document.createElement("<input type='checkbox' name='chkDel" + tdcount + "' id='chkDel" + tdcount + "' class='pcontent'>"))

		var td3 = document.createElement("<td class='pcontent'></td>")
		td3.appendChild(document.createElement("<input type='text' name='txtVendorCode" + tdcount + "' id='txtVendorCode" + tdcount + "' size='5' maxlength='10' class='pcontent'>"))

		var td4 = document.createElement("<td class='pcontent'></td>")
		td4.appendChild(document.createElement("<input type='text' name='txtVendorName" + tdcount + "' id='txtVendorName" + tdcount + "' size='40' maxlength='50' class='pcontent'>"))

		var td5 = document.createElement("<td class='pcontent'></td>")
		td5.appendChild(document.createElement("<input type='text' name='txtVendorMail" + tdcount + "' id='txtVendorMail" + tdcount + "' size='40' maxlength='100' class='pcontent'>"))

		document.EditSupplier.hidTotalCount.value = parseFloat(document.EditSupplier.hidTotalCount.value) + 1
		
		row.appendChild(td1);
		row.appendChild(td2);
		row.appendChild(td3);
		row.appendChild(td4);
		row.appendChild(td5);
		tbody.appendChild(row);
	};
//-->