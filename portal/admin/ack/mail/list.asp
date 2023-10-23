<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<%
										dim curConnection
										dim SQL
										dim ReturnSet
%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/clearuserdetails.asp"-->
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script language="JavaScript">
<!--
	function move(fbox, tbox) {
		var arrFbox = new Array();
		var arrTbox = new Array();
		var arrLookup = new Array();
		var i;

		for (i = 0; i < tbox.options.length; i++) {
			arrLookup[tbox.options[i].text] = tbox.options[i].value;
			arrTbox[i] = tbox.options[i].text;
		}
		
		var fLength = 0;
		var tLength = arrTbox.length;

		for(i = 0; i < fbox.options.length; i++) {
			arrLookup[fbox.options[i].text] = fbox.options[i].value;
		
			if (fbox.options[i].selected && fbox.options[i].value != "") {
				arrTbox[tLength] = fbox.options[i].text;
				tLength++;
			} else {
				arrFbox[fLength] = fbox.options[i].text;
				fLength++;
		   }
		}

		arrFbox.sort();
		arrTbox.sort();
		fbox.length = 0;
		tbox.length = 0;
		var c;

		for(c = 0; c < arrFbox.length; c++) {
			var no = new Option();
			no.value = arrLookup[arrFbox[c]];
			no.text = arrFbox[c];
			fbox[c] = no;
		}
		
		for(c = 0; c < arrTbox.length; c++) {
			var no = new Option();
			no.value = arrLookup[arrTbox[c]];
			no.text = arrTbox[c];
			tbox[c] = no;
	   }
	}
	
	function validate(obj) {
		var delim = '';
		var delimval = '';
		for (i = 0; i < obj.lstAssign.options.length; i++) {
			obj.lstAssign.options[i].selected = true;
			
			//delimval = delimval + delim + obj.lstAssign.options[i][obj.lstAssign.options[i].selectedIndex].value;
			delimval = delimval + delim + obj.lstAssign.options[i].value;
			delim = ';';
			
			//obj.hidList.value=delimval;
		};
		
		if (obj.hidAction.value=='2') {
			window.opener.document.email.txtTo.value = delimval;
		} else {
			window.opener.document.email.txtFrom.value = delimval;
		};
		window.close();
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<p class="pcontent">Please select to whom you want to send the mail.</p>
<form name="list" id="list" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<th class="pcontent">Not Selected Group</th>
		<th>&nbsp;</th>
		<th class="pcontent">Selected Group</th>
	</tr>
	<tr>
		<td>
			<select multiple size="10" name="lstUnassign" id="lstUnassign" style="width:290" class="pcontent">
<%
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											SQL = "exec listSupplier"
										
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Loop through the recordset
											While not ReturnSet.EOF
%>
				<option value="<%=ReturnSet("UserMail")%>"><%=ReturnSet("FirstName") & " (" & ReturnSet("UserMail") & ") "%></option>
<%											
												ReturnSet.MoveNext
											Wend
											
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
%>		
			</select>
		</td>
		<td align="center" valign="middle">
			<input type="button" onClick="move(this.form.lstAssign,this.form.lstUnassign)" value="<<" class="button" id=button1 name=button1><br><br>
			<input type="button" onClick="move(this.form.lstUnassign,this.form.lstAssign)" value=">>" class="button" id=button2 name=button2>
		</td>
		<td>
			<select multiple size="10" name="lstAssign" id="lstAssign" style="width:240" class="pcontent">
			</select>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="3">
			<input type="submit" name="btnSubmit" id="btnSubmit" value="Select" class="button">
			<input type="hidden" name="hidAction" id="hidAction" value="<%=Request.QueryString("action")%>">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->