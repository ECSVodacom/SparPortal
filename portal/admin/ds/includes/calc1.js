<!--
	function addRows(id,count){
		var tdcount = (parseFloat(count) + 1);

		var tbody = document.getElementById
		(id).getElementsByTagName("TBODY")[6];
		var row = document.createElement("<tr></tr>")

		var td1 = document.createElement("<td class='tbldata' align='center'></td>")
		td1.appendChild(document.createTextNode(tdcount + "."))
		
		var td2 = document.createElement("<td class='tbldata' align='center'></td>")
		td2.appendChild(document.createElement("<input type='checkbox' name='chkDel" + tdcount + "' id='chkDel" + tdcount + "' class='pcontent'>"))
		td2.appendChild(document.createElement("<input type='hidden' name='txtMailID" + tdcount + "'  id='txtMailID" + tdcount + "' value='0'>"))
		
		var td3 = document.createElement("<td class='tbldata'></td>")
		td3.appendChild(document.createElement("<input type='text' name='txtStoreMail" + tdcount + "' id='txtStoreMail" + tdcount + "' size='40' maxlength='100' class='pcontent'>"))

		document.EditStore.hidTotalCount.value = parseFloat(document.EditStore.hidTotalCount.value) + 1
		
		row.appendChild(td1);
		row.appendChild(td2);
		row.appendChild(td3);
		tbody.appendChild(row);
	};
//-->