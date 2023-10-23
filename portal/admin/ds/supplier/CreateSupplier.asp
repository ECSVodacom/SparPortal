<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="includes/subsuppliermenu.asp"-->
<!--#include file="../includes/freeASPUpload.asp"-->
<%
Function CleanUp(strString)
	If IsNull(strString) Then 
		CleanUp = ""
	Else
		Dim myRegExp, myMatch, myMatches

		Set myRegExp = New RegExp
		myRegExp.IgnoreCase = True
		myRegExp.Global = True
		myRegExp.Pattern = "[0-9a-zA-Z ']"
		
		If myRegExp.Test(strString) Then
			Set myMatches = myRegExp.Execute(strString)
			
			For Each myMatch in myMatches
				CleanUp = CleanUp & myMatch.Value
			Next
		End If
		
		CleanUp = Trim(CleanUp)	
	End If
End Function
										
										
										
	If Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	End If
	
										

	Dim Upload, FileName, FileKey, ShowGrid
	Dim ConnectionString, cnObjDoc, rsObjDoc, SqlCommand
	Dim cnObj, rsObj
	Dim VendorCode, VendorName, VatNumber, EanCode
	Dim SupplierId, ErrorMessage
	
	ShowGrid = False

	If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
		ShowGrid = True
	End If
	
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
	};
//-->
</script>
<script>
		function validate(obj) {
			var fileInput = obj.elements.txtFile.value;
			
			if (fileInput != "") {
				
				return true;
			}
			else {
				alert("Please select a file");
					return false;
			}
			
		
		
		}
		
		function isValidExtention(fileInput){
			var ext = fileInput.value.match(/\.([^\.]+)$/)[1];
			switch (ext) {
				case 'xls':
				case 'xlsx':
					return true;
					
					break;
				default:
					alert('Only excel is supported');
					document.getElementById("ScheduleSupplier").reset();
					return false
			}
		}
		
		function onFileChange(fileInput)
		{
			return isValidExtention(fileInput);
		}
</script>

<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="PreLoadDefaultImages; <%=Preloader%>">
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>

		<td class="bheader">Create new schedule suppliers</td>

		

	</tr>
</table>
<p class="pcontent">Please complete the form below to add a new supplier.</p>
<div class="pcontent">
	<form name="ScheduleSupplier" id="ScheduleSupplier" enctype="multipart/form-data" method="post" onsubmit="return validate(this);">
		<table>
			<tr>
				<td class="pcontent">
					File Type:
				</td>
				<td class="pcontent">
					<select name="cboFileType" id="cboFileType" class="pcontent">
						<option value="Excel">Excel</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="pcontent">File:</td>
				<td><input type="file" name="txtFile" id="txtFile" size="60" onchange="onFileChange(this);" accept=".xls,.xlsx"></td>
			</tr>
			
		</table>
		<p>
					<input type="submit" name="btnSubmit" id="btnSubmit" class="button" value="Upload / Validate">&nbsp;
				
			</p>
	</form>
	
	<% If ShowGrid Then %>
	<table border="1" cellpadding="0" cellspacing="0" width="60%">
		<tr>
			<td class="bheader" align="left" colspan="5">Results</td>
		</tr>
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center"><b>Vendor Code</b></td>
			<td class="tdcontent" align="center"><b>Vendor Name</b></td>
			<td class="tdcontent" align="center"><b>Vat Number</b></td>
			<td class="tdcontent" align="center"><b>Location Code</b></td>
			<td class="tdcontent" align="center"><b>Result</b></td>
		</tr>
	<%
	
		
		Set Upload = New FreeASPUpload
		Upload.Save(const_app_ScheduleFileLocation)
		
		For Each fileKey In Upload.UploadedFiles.Keys
			FileName = Upload.UploadedFiles(fileKey).FileName
		Next
		
		ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & const_app_ScheduleFileLocation & FileName & ";Extended Properties='Excel 12.0 Xml;HDR=YES; IMEX=1'"
		Set cnObjDoc = Server.CreateObject("ADODB.Connection")
		cnObjDoc.Open ConnectionString
		
		
		
		Set rsObjDoc =cnObjDoc.Execute("SELECT * FROM [Sheet1$]")
		If Not (rsObjDoc.BOF And rsObjDoc.EOF) Then
			If (rsObjDoc.Fields.Count < 1) Then %>
				<div class="warning">ERROR: The file you are tying to upload does not match the file type selected or the file content is not in the agreed format.</div>
			<%			
			Else
				Set cnObj = Server.CreateObject("ADODB.Connection")
				cnObj.Open const_db_ConnectionString
			
				While Not rsObjDoc.EOF
					VendorCode = CleanUp(rsObjDoc(0))
					VendorName = CleanUp(rsObjDoc(1))
					VatNumber = CleanUp(rsObjDoc(2))
					EanCode = CleanUp(rsObjDoc(3))
					ErrorMessage = "-"
				
					VendorName = "SCHEDULE - " & VendorName
					
					SqlCommand = "addSupplier @UserName='" & EanCode & "', @Password='password'"  _
						& ", @SupplierName='" & VendorName & "', @SupplierEAN='" & EanCode & "', @SupplierVatNo='" & VatNumber _
						& "', @SupplierAddress='', @UserType=4, @Disable=0"
						
					'response.write SqlCommand
					
					
					Set rsObj = ExecuteSql(SqlCommand, cnObj)  
					
					If rsObj("ReturnValue") <> 0 Then
						ErrorMessage = rsObj("ErrorMessage")
						EanCode = rsObj("EanCode")
					Else
						SupplierId = rsObj("NewSupplierID")
						EanCode = rsObj("EanCode")
						
						ExecuteSql "addVendorDetail @SupplierId=" & SupplierId & ",@VendorCode='" & VendorCode & "',@VendorName='" & VendorName & "'", cnObj
						
						ErrorMessage = "Loaded"
					End If
					
					rsObj.Close
					Set rsObj = Nothing
				
					%>
						<tr>
							<td class="pcontent" align="center"><%=VendorCode%></td>
							<td class="pcontent" align="center"><%=VendorName%></td>
							<td class="pcontent" align="center"><%=VatNumber%></td>
							<td class="pcontent" align="center"><%=EanCode%></td>
							<td class="pcontent" align="center"><%=ErrorMessage%></td>
						</tr>
					<%
				
				
				
					rsObjDoc.MoveNext
				Wend
				
				cnObj.Close
				Set cnObj = Nothing
				
			End If
		Else %>
			<div class="warning">Document empty</div>
		<%
		End If
		
		rsObjDoc.Close
		Set rsObjDoc = Nothing
		
		
		cnObjDoc.Close
		Set cnObjDoc = Nothing
	%>
		

		
		
		
	</table>
	<% End If %>
	
	
</div>
</body>
</html>