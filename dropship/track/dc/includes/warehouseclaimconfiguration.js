	$(document).ready(function() {
		fClaimCategoryClick();
		fLoadClaimLevels($("#token").val());
	});
	
	function fValidateEmail(email) 
	{  
		if (email == "")
			return true;
			
		var regEx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/  
		return email.match(regEx) 
	}
	
	function fClaimSubCategoryClick(checkbox)
	{
	
		if (checkbox.value == -1 && !checkbox.checked)
		{
			checkbox.checked = true;
			return false;
		}
	
		var checkboxes = document.getElementsByName("chkClaimSubCategory");
		if (checkbox.value == -1)
			for (var i=0; i<checkboxes.length; i++)
				checkboxes[i].checked = false;
		else
			dcClaimOptions.chkAllClaimSubCategories.checked = false;
	}
	
	function fClaimSubReasonClick(checkbox)
	{
	
		if (dcClaimOptions.chkAllClaimReasons.checked && checkbox.value != -1)
		{
			checkbox.checked = false;
			return false;
		}
		
		if (dcClaimOptions.chkAllClaimReasons.checked  && checkbox.value == -1 && !checkbox.checked)
		{
			checkbox.checked = true;
			return false;
		}

		
		var checkboxes = document.getElementsByName("chkClaimSubReason");
		if (checkbox.value == -1)
			for (var i=0; i<checkboxes.length; i++)
				checkboxes[i].checked = false;
		else
			dcClaimOptions.chkAllClaimSubReasons.checked = false;
	}
	
	function fClaimReasonClick(checkbox)
	{
		var countChecked = 0;
		var pricingCountChecked = 0;
		if (checkbox.value == -1 && !checkbox.checked)
		{
			checkbox.checked = true;
			return false;
		}
	
	
		var checkboxes = document.getElementsByName("chkClaimReason");
		if (checkbox.value == -1) {
			for (var i=0; i<checkboxes.length; i++)
				checkboxes[i].checked = false;
		}
		else
			dcClaimOptions.chkAllClaimReasons.checked = false;
		
		var doesHavePricingReasons = false;
		
		for (var i=0; i<checkboxes.length; i++) {
			if (checkboxes[i].nextSibling.data.toLowerCase().indexOf("pricing") > -1)
				doesHavePricingReasons = true;
		
			if (checkboxes[i].checked) {
				countChecked += 1;

				if (checkboxes[i].nextSibling.data.toLowerCase().indexOf("pricing") > -1)
					pricingCountChecked += 1;
			}
		}
				
		if (countChecked == 0)
			dcClaimOptions.chkAllClaimReasons.checked = true;
			
			
		var dcId = dcClaimOptions.cboDC[dcClaimOptions.cboDC.selectedIndex].value.split(",")[0];
		var token = $("#token").val();
		var categoryIds = getCategoryIds(null);
		var crids = getClaimReasonIds(null);
		var isPricing = false;
		
		if (pricingCountChecked > 0 || (doesHavePricingReasons && dcClaimOptions.chkAllClaimReasons.checked))
			isPricing = true;
			
		getAcknowledgedByDcEmail(dcId,categoryIds, isPricing);
		/* Load SubReasons*/
		fLoadClaimSubReasons(categoryIds, dcId,  token, crids);
		//alert('here');
		
		
	}
	
	function getAcknowledgedByDcEmail(dcId, categoryId, isPricing)
	{
		var statusApplicable15 = document.getElementById("txtStatusApplicableEmail_15");
		if (statusApplicable15 != null)
			$.getJSON("../../claims/GetDcClaimCategoryDetail.asp",{ DcId: dcId, ClaimCategoryId: categoryId},function(email) {
				if (isPricing) 
					statusApplicable15.value = email.PricingEmail;
				else
					statusApplicable15.value = email.ForceCreditDisputed;
			})
	}
	
	function getClaimReasonIds(checkbox)
	{
		var checkboxes = document.getElementsByName("chkClaimReason");
		var claimReasonIds = '';
		
		for (var i=0; i< checkboxes.length; i++) {
			if (checkbox != null) {
				if (checkbox.value != checkboxes[i].value) 
					checkboxes[i].checked = false
					
				if (checkbox.value == -1 || checkboxes[i].checked ) {
					claimReasonIds += checkboxes[i].value + '|';
				}
			}
			else if (checkboxes[i].checked) {
				claimReasonIds += checkboxes[i].value + '|';
			}
		}
		
		return claimReasonIds;
	}
	
	function getCategoryIds(checkbox)
	{
		var checkboxes = document.getElementsByName("ClaimCategory");
		var categoryIds = '';
		
		for (var i=0; i< checkboxes.length; i++) {
			if (checkbox != null) {
				if (checkbox.value != checkboxes[i].value) 
					checkboxes[i].checked = false
					
				if (checkbox.value == -1 || checkboxes[i].checked ) {
					categoryIds += checkboxes[i].value + '|';
				}
			}
			else if (checkboxes[i].checked) {
				categoryIds += checkboxes[i].value + '|';
			}
		}
		
		return categoryIds;
	}
	
	
	function fClaimCategoryClick(checkbox)
	{
		if (typeof(checkbox) != "undefined" && !checkbox.checked)
		{
			checkbox.checked = true;
			return false;
		}
	
		categoryIds = getCategoryIds(checkbox);
		
		if (categoryIds.length > 0)
			categoryIds = categoryIds.substring(0,categoryIds.length-1)
		else
			categoryIds = 0;
			
		var dcId = dcClaimOptions.cboDC[dcClaimOptions.cboDC.selectedIndex].value.split(",")[0];
		var token = $("#token").val();
		
		$.getJSON("../../includes/json_wclaimsubcategories.asp",{categoryIds: categoryIds, dcId: dcId, guid: token}, function(j){
			var chkSubCategories = '';
			var checkedCount = 0;
			var isChecked = "";
			
			for (var i = 0; i < j.length; i++) {
				if (j[i].isChecked)
					checkedCount =+ 1;
					
				if (checkedCount == 0) 
					isChecked = "checked";
				else	
					isChecked = "";
			
			
				
				if (j[i].subCategoryId == -1) 
					chkSubCategories += '<input ' + j[i].isChecked + ' type="checkbox" onclick="fClaimSubCategoryClick(this);" name="chkAllClaimSubCategories" id="chkAllClaimSubCategories" value="-1" type="checkbox" ' + isChecked + '/>All Sub Categories</div>'
				else
					chkSubCategories += '<input ' + j[i].isChecked + ' type="checkbox" onclick="fClaimSubCategoryClick(this);" name="chkClaimSubCategory" id="chkClaimSubCategory" value="' + j[i].subCategoryId + '" />' + j[i].subCategoryDisplay + '<br />'
			}
			
			$('#divClaimSubCategories').html(chkSubCategories);
			
			$.getJSON("../../includes/json_getemail.asp",{dcId: dcId, categoryIds: categoryIds}, function(e) {
				if (e != null)
					$('#txtStatusApplicableEmail_4').val(e[0].mail);
			})
		})
		
	
		
		$.getJSON("../../includes/json_wclaimreasons.asp",{categoryIds: categoryIds, dcId: dcId, guid: token}, function(l){
			var chkClaimReasons = '';
			var checkedCount = 0;
			var isChecked = "";
			var crids = "";
			
			for (var i = 0; i < l.length; i++) {
				if (l[i].isChecked)
				{
					checkedCount =+ 1;
					crids = crids + l[i].claimReasonId + "|"
				}
					
				if (checkedCount == 0) 
					isChecked = "checked";
				else	
					isChecked = "";
			
				if (l[i].claimReasonId == -1)
					chkClaimReasons += '<input ' + l[i].isChecked + ' onclick="fClaimReasonClick(this);" name="chkAllClaimReasons" id="chkAllClaimReasons" value="-1" type="checkbox" ' + isChecked + ' />All Claim Reasons</div>'
				else
					chkClaimReasons += '<input ' + l[i].isChecked + ' type="checkbox" onclick="fClaimReasonClick(this);" name="chkClaimReason" id="chkClaimReason" value="' + l[i].claimReasonId + '" />' + l[i].description + '<br />';
			}
			
			$('#divClaimReasons').html(chkClaimReasons);
			
			//alert("spar.gatewayec.co.za/dropship/includes/json_wclaimsubreasons.asp?categoryIds=" + categoryIds + "&dcId=" + dcId + "&guid=" + token );
			//var crids = getClaimReasonIds(null);	
			//lert(crids);
			fLoadClaimSubReasons(categoryIds, dcId,  token, crids);
		})
		
		
		
		
		
		
	}
	
	function fLoadClaimSubReasons(categoryIds, dcId,  token, crids)
	{
	
		$.getJSON("../../includes/json_wclaimsubreasons.asp",{categoryIds: categoryIds, dcId: dcId, guid: token, crids: crids}, function(l){
			var chkClaimSubReasons = '';
			var checkedCount = 0;
			var isChecked = "";
			
			for (var i = 0; i < l.length; i++) {
				if (l[i].isChecked)
					checkedCount =+ 1;
					
				if (checkedCount == 0) 
					isChecked = "checked";
				else	
					isChecked = "";
			
				if (l[i].claimSubReasonId == -1)
					chkClaimSubReasons += '<input ' + l[i].isChecked + ' name="chkAllClaimSubReasons" onclick="fClaimSubReasonClick(this);" id="chkAllClaimSubReasons" value="-1" type="checkbox" '+ isChecked + '/>' + l[i].description + '<br />';
				else
					chkClaimSubReasons += '<input ' + l[i].isChecked + ' type="checkbox" onclick="fClaimSubReasonClick(this);" name="chkClaimSubReason" id="chkClaimSubReason" value="' + l[i].claimSubReasonId + '" />' + l[i].description + '<br />';
			}
			$('#divClaimSubReasons').html(chkClaimSubReasons);
		})
	}
	
	
	function fUpdateRangeCount(rangeCount)
	{
		$('#rangeCount').val(rangeCount);
	}
	
	function fStatusApplicableOnClick(checkbox)
	{
		var emailBox = "#txtStatusApplicableEmail_" + checkbox.value;
		var lblEmailBox = "#lblStatusApplicableEmail_" + checkbox.value;
		if (checkbox.checked)
		{		
			if (checkbox.value != 24) 
			{
				$(emailBox).show();
				$(lblEmailBox).show();
			}
				
			if (checkbox.value == 24) // Management Authorisation Required 
			{
				 $("#showManagementAuthorisations").val("True");
				fLoadClaimLevels();
			}
		}
		else
		{
			if (checkbox.value != 4) {
				$(emailBox).val("");
			};
			
			$(emailBox).hide();
			$(lblEmailBox).hide();
			if (checkbox.value == 24)
			{
				$("#showManagementAuthorisations").val("False");
				// Destroy claim levels
				var rangeCount = parseInt($('#rangeCount').val());
				fUpdateRangeCount(0);

				$('#rc_ma').remove();
				$('#rc_cl').remove();
				for (var i = 0; i <  rangeCount; i++) {
					$('#rc_' + i).remove();
				}
			}
			
		}
	}
	
	
	function fDeleteRow(obj)
	{
		var rangeCount = parseInt($('#rangeCount').val());
		var row = obj.parentNode.parentNode;
		var removingId = row.id.split('_')[1];
		var newFromForNext = parseInt($('#to_' + (parseInt(removingId)-1)).val()) + 1;
		$('#from_' + (parseInt(removingId)+1)).val(newFromForNext);
		
		for (var i = removingId; i < rangeCount; i++) {
			$('#from_' + (parseInt(i)+1)).attr('id', 'from_' + i);
			$('#to_' + (parseInt(i)+1)).attr('id', 'to_' + i);
			$('#email_' + (parseInt(i)+1)).attr('id', 'email_' + i);
			$('#rc_' + (parseInt(i)+1)).attr('id', 'rc_' + i);
			$('#validation_result_' + (parseInt(i)+1)).attr('id', 'validation_result_' + i);
		}
		
		row.parentNode.removeChild(row);
		
		rangeCount -= 1;
		fUpdateRangeCount(rangeCount);
	}
	
	function ValidateMoney(obj) 
	{ 
		if (obj == null) return true;
		if (typeof(obj) == "object")
			var id = obj.id.split('_')[1];
		else
			var id = obj;
			
		var amountFrom = $('#from_'+id).val();
		var amountTo = $('#to_'+id).val();
		var previousAmountTo = $('#to_'+(parseInt(id)-1)).val();
		var regEx = /^[0-9\.]+$/; 
		
		if (regEx.test(amountFrom)) 
		{ 
			$('#validation_result_' + id).text('');
		}
		else if (!regEx.test(amountFrom))
		{
			$('#validation_result_' + id).html('Invalid amount, must be greater or equal to 0, numeric');
				
			return false;
		}
		
		if (regEx.test(amountTo)) 
		{ 
			$('#validation_result_' + id).text('');
		}
		else if (!regEx.test(amountTo))
		{
			$('#validation_result_' + id).html('Invalid amount, must be greater or equal to 0, numeric');
				
			return false;
		}

		
		if (parseFloat(amountFrom) > parseFloat(amountTo))
		{
			$('#validation_result_' + id).html('The "from" amount cannot be greater than the "to" amount');
				
			return false;
		}
		else if (id != 0 && (amountFrom != parseFloat(previousAmountTo) + 0.01)) {
			$('#validation_result_' + id).html('The "from" amount must be equal to previous "to" amount + 1 cent');
				
			return false;
		}
		else if (amountTo > 99999999) {
			$('#validation_result_' + id).html('The amount cannot be greated than 99999999');
			return false;
		}
		else
		{
			$('#validation_result_' + id).html('');
		}
		return true;
	}
	
	
	function fLoadClaimLevels(token)
	{
		if (token == null)
			token = $("#token").val();
			
		var allowClaimEmails = $("#allowClaimEmails").val() == "True";
		var showManagementAuthorisations = $("#showManagementAuthorisations").val() == "True";

		if (showManagementAuthorisations) 
		{
			$.getJSON("../../includes/json_wclaimlevels.asp",{guid: token}, function(l){
					var claimLevels = '';
					
					fUpdateRangeCount(l.length)
					
					
					for (var i = 0; i <  l.length; i++) {
						if (i==0) {
							claimLevels += 	'<tr id="rc_ma"><td colspan="2" ><br /><br /><b>Management Authorisations:</b></td></tr>'
							claimLevels += 	'<tr id="rc_cl"><td><br /><b>Claim levels</b><br /><br /><input type="button" class="button" onclick="fAddClaimLevel(0);" value="Add level"/></td></tr>'
							claimLevels += 	'<tr id="rc_' + i + '">'
							claimLevels += 	'	<td>&nbsp;</td>'
							claimLevels += 	'	<td >From:&nbsp;<input class="pcontent" type="text" onkeyup="ValidateMoney(this);" id="from_' + i + '" value="' + l[i].from + '" size="10" />&nbsp;&nbsp;to&nbsp;&nbsp;<input class="pcontent"  type="text" id="to_' + i + '" onkeyup="ValidateMoney(this);" value="' + l[i].to + '" size="10"/><br/><span colspan="5" id="validation_result_' + i + '" class="warning"></span></td>'
							claimLevels += 	'	<td colspan="3">'
							if (allowClaimEmails )
								claimLevels +=  '<input class="pcontent" type="text"  id="email_' + i + '" size="60" title="Authoriser\'s E-mail address" value="' + l[i].email + '" class="pcontent" />&nbsp;&nbsp;Authoriser\'s E-mail address'
							claimLevels += 	'</td></tr>'
						}
						else 
						{
							claimLevels += 	'<tr id="rc_' + i + '">'
							claimLevels += 	'	<td>&nbsp;</td>'
							claimLevels += 	'	<td>From:&nbsp;<input class="pcontent" type="text" onkeyup="ValidateMoney(this);" id="from_' + i + '" value="' + l[i].from + '" size="10" />&nbsp;&nbsp;to&nbsp;&nbsp;<input class="pcontent"  type="text" id="to_' + i + '" onkeyup="ValidateMoney(this);" value="' + l[i].to + '" size="10"/><br/><span colspan="5" id="validation_result_' + i + '" class="warning"></span></td>'
							claimLevels += 	'	<td colspan="3">'
							if (allowClaimEmails )
								claimLevels += '<input class="pcontent" type="text"  id="email_' + i + '" size="60" title="Authoriser\'s E-mail address" value="' + l[i].email + '" class="pcontent" />&nbsp;&nbsp;<input type="button" class="button" onclick="fDeleteRow(this);" value="Remove"/>'
							claimLevels += '</td>'
							claimLevels += 	'</tr>'
						}
						
					}
					
					$('#WarehouseClaimConfigurationsGrid').append(claimLevels);
				})
		}
	}
	
	
	
	function fAddClaimLevel(toAmount)
	{
		var rangeCount = parseInt($('#rangeCount').val());
		var lastTo = document.getElementById("to_" + (rangeCount-1))
		var allowClaimEmails = $("#allowClaimEmails").val() == "True";
		
		if (toAmount == 0)
			toAmount = '';
		
		if (parseFloat(lastTo.value) == 99999999) {
			alert('Unable to add a new level if the last to amount is 99999999');
			return false;
		}
		
		if (ValidateMoney(rangeCount-1))
		{
			var previousFromPlusOne = parseFloat($('#to_' +  (parseInt(rangeCount) - 1)).val()) + 0.01;
			
			if (rangeCount < 10) {
				var levels = '<tr id="rc_' + rangeCount + '">'
				levels += '<td>&nbsp;</td>'
				levels += '<td>From:&nbsp;<input class="pcontent" type="text" onkeyup="ValidateMoney(this);" id="from_' + rangeCount + '" value="' + previousFromPlusOne + '" size="10" />&nbsp;&nbsp;to&nbsp;&nbsp;<input class="pcontent"  type="text" id="to_' + rangeCount + '" onkeyup="ValidateMoney(this);" value="' + toAmount + '" size="10"/><br/><span colspan="5" id="validation_result_' + rangeCount+ '" class="warning"></span></td>'
				levels += '<td colspan="3">'
				if (allowClaimEmails)
					levels += '<input class="pcontent" type="text" id="email_' + rangeCount + '" size="60" value="" class="pcontent" />&nbsp;&nbsp;<input type="button" class="button" onclick="fDeleteRow(this);" value="Remove"/>'
				levels += '</td></tr>'
				
				$('#WarehouseClaimConfigurationsGrid').append(levels);
				rangeCount += 1;
				fUpdateRangeCount(rangeCount);
			}
			else
				alert("You have reached your maximum of 10 levels");
		}
	}


function fOnSave()
{ 
	if ($("#cboDC").val().split(',')[0] == 0)
	{
		alert("You have not selected a DC");
		$("#cboDC").focus();
		return false;
	}
	if ($("#cboClaimType").val().split(',')[0] == 0)
	{
		alert("You have not selected a Claim Type");
		$("#cboClaimType").focus();
		return false;
	}


	var statusesApplicableIds = '';
	var emailsApplicable = "";
	var currentEmail = "";
	var stopExecution = false;
	var rangeCount = parseInt($('#rangeCount').val());
	var allowClaimEmails = $("#allowClaimEmails").val() == "True";
	
	for (i = 0; i < rangeCount ; i++)
	{
		if (ValidateMoney(i) == false)
			stopExecution = true;
	}	
	if (stopExecution) return false;
	
	var userSelected = 0;
	$("input:checkbox[name=chkStatusApplicable]").each(function () {
		if ($(this).is(":checked"))
		{
			if ($(this).val() != 14 && $(this).val() != 23) 
				userSelected += 1;
				
			statusesApplicableIds += $(this).val() + "|";
		}
			
		currentEmail = $("#txtStatusApplicableEmail_" + $(this).val()).val();
		if (typeof(currentEmail) != "undefined") {
			var emailArray = currentEmail.split(';');
			for (emailIdx = 0; emailIdx < emailArray.length; emailIdx++)
			{
				if (!fValidateEmail(currentEmail.split(';')[emailIdx])) {
					alert('Please enter valid email');	
					$("#txtStatusApplicableEmail_" + $(this).val()).focus();
					stopExecution = true;
					return false;
				}
			}
			
			if (currentEmail != "")
				emailsApplicable += $(this).val() + "|" + $("#txtStatusApplicableEmail_" + $(this).val()).val() + "||";
		}
	});
	
	if (userSelected == 0)
		{
			alert('You need to select at least one status applicable');
			
			return false;
		}
		
		
	if (stopExecution) return false;
	
	
	 
	
	var dcId = dcClaimOptions.cboDC[dcClaimOptions.cboDC.selectedIndex].value.split(",")[0];
		
	var claimCategoryIds = '';
	$("input:checkbox[name=ClaimCategory]:checked").each(function () {
		claimCategoryIds += $(this).val() + '|';
	});
	if (claimCategoryIds.length == 0) {
		alert("Claim category is mandatory");
		//claimCategoryIds = '-1';
	}
	
	var claimSubCategoryIds = '';
	$("input:checkbox[name=chkClaimSubCategory]:checked").each(function () {
		claimSubCategoryIds += $(this).val() + '|';
	});
	if (claimSubCategoryIds.length == 0) claimSubCategoryIds = '-1';

	var claimReasonIds = '';
	$("input:checkbox[name=chkClaimReason]:checked").each(function () {
		claimReasonIds += $(this).val() + '|';
	});
	if (claimReasonIds.length == 0) claimReasonIds = '-1';
	
	var claimSubReasonIds = '';
	$("input:checkbox[name=chkClaimSubReason]:checked").each(function () {
		claimSubReasonIds += $(this).val() + '|';
	});
	if (claimSubReasonIds.length == 0) 
		claimSubReasonIds = '-1';
		
	var ClaimType = '';
	 ClaimType =  $("#cboClaimType").val().split(',')[0];
		
	
	var claimLevelRanges = '';
	if (rangeCount != 0)
	{
		var lastTo = document.getElementById("to_" + (rangeCount-1))
		
		if (parseFloat(lastTo.value) != 99999999 && rangeCount < 10)
		{
			fAddClaimLevel(99999999);
			rangeCount += 1;
		}
		else if (parseFloat(lastTo.value) != 99999999)
		{			
			alert("The last 'to' value for claim levels will be updated to 99999999");
			lastTo.value = 99999999;
		}
	
	
		for (idx=0; idx<rangeCount;idx++)
		{	
			var claimLevelEmail = '';
			if (typeof($("#email_"+idx).val()) != "undefined")
				claimLevelEmail = $("#email_"+idx).val();
				
			claimLevelRanges += document.getElementById("from_"+idx).value + "|" + document.getElementById("to_"+idx).value + "|-" + claimLevelEmail + "||";
		}
		
		
	}
		

		

	var token = $("#token").val();

	var debugString = "json_wclaimcategoriesmaintain.asp?categoryIds=" + claimCategoryIds 
		debugString +=	"&subCategoryIds=" + claimSubCategoryIds
		debugString +=	"&reasonIds=" + claimReasonIds
		debugString +=	"&subReasonIds=" + claimSubReasonIds
		debugString +=	"&statusApplicableIds=" + statusesApplicableIds
		debugString +=	"&dcId=" + dcId
		debugString +=	"&guid=" + token
		debugString +=	"&emailAddresses=" + emailsApplicable
		debugString +=	"&ranges=" + claimLevelRanges
		debugString +=	"&ClaimTypeId=" + ClaimType
	
	//console.debug("https://spar.gatewayec.co.za/dropship/includes/"+debugString);
	//return false;
	//return;
	
	$.getJSON("../../includes/json_wclaimcategoriesmaintain.asp",
		{	
			categoryIds: claimCategoryIds, 
			subCategoryIds: claimSubCategoryIds,
			reasonIds: claimReasonIds,
			subReasonIds: claimSubReasonIds,
			statusApplicableIds: statusesApplicableIds,
			dcId: dcId,
			guid: token,
			emailAddresses: emailsApplicable,
			ranges: claimLevelRanges,
			ClaimTypeId: ClaimType
		}, function(l) { 
		
		
		if (l[0].guid != 0)
		{	
			if (window.opener != null)
				try { window.opener.document.getElementById(name='btnRefresh').click(); } finally {  };

			document.location = "WarehouseClaimConfigAdd.asp?guid=" + l[0].guid + "&s=true";
		}
		else
		{
			$("#savedResult").html("<b>" + l[0].message + "</b>");
		}
	})
	
	
	
	return false;
}