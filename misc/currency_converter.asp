<%Option Explicit%>
<!-- Author: Mark Castle (http://www.markcastle.com)-->
<!-- Comments: Use this at your own risk. I knocked it up quickly so it probably has bugs plus there is not any error checking-->
<!-- Secura Hosting Ltd (http://www.securahosting.com)-->
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Currency Converter</title>
</head>

<body>

<%
Dim strAction 			' As String
Dim strExchangeRate  		' As String
Dim strFrom 			' As String
Dim strTo 			' As String
Dim strAmount 			' AS String
strAction = Request("ACTION")
Select Case UCase(strAction)
	Case "CONVERT"
		strFrom 	= Request("strFrom")
		strTo 		= Request("strTo")
		strAmount 	= Request("strAmount")
		strExchangeRate = GetXchangeRate(strFrom, _
                               			 strTo)
		Response.Write("Exchange Rate: (From:" & strFrom & " To:" & strTo & ") = " & strExchangeRate & "<br>" & vbCrLf)
		Response.Write(strAmount & " " & strFrom & " = " & CDbl(strAmount)*CDbl(strExchangeRate) & " " & strTo & "<br>" & vbcrlf)
		ShowForm
	Case Else
		ShowForm
End Select


Public Sub ShowForm()%>
<b>Currency Converter </b>
<form method="POST" action="<%=Request.ServerVariables("SCRIPT_NAME")%>">
  <table border="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1" cellpadding="4">
    <tr>
      <td width="33%">Amount:</td>
      <td width="33%">From:</td>
      <td width="34%">To:</td>
    </tr>
    <tr>
      <td width="33%">
      <input type="text" name="strAmount" size="20" value="1.00"></td>
      <td width="33%"><select size="1" name="strFrom">
  <option>afghanistan</option>
<option>albania</option>
<option>algeria</option>
<option>andorra</option>
<option>andorra</option>
<option>angola</option>
<option>argentina</option>
<option>aruba</option>
<option>australia</option>
<option>austria</option>
<option>bahrain</option>
<option>bangladesh</option>
<option>barbados</option>
<option>belgium</option>
<option>belize</option>
<option>bermuda</option>
<option>bhutan</option>
<option>bolivian</option>
<option>botswana</option>
<option>brazil</option>
<option>england</option>
<option>united kingdom</option>
<option>uk</option>
<option>great britain</option>
<option>brunei</option>
<option>burundi</option>
<option>cambodia</option>
<option>canada</option>
<option>cape verde</option>
<option>cayman islands</option>
<option>chile</option>
<option>china</option>
<option>colombia</option>
<option>comoros</option>
<option>costa rica</option>
<option>croatia</option>
<option>cuba</option>
<option>cyprus</option>
<option>czech republic</option>
<option>denmark</option>
<option>dijibouti</option>
<option>dominican republic</option>
<option>netherlands</option>
<option>east caribbean</option>
<option>ecuador</option>
<option>egypt</option>
<option>el salvador</option>
<option>estonia</option>
<option>ethiopia</option>
<option>euro</option>
<option>falkland islands</option>
<option>fiji</option>
<option>finland</option>
<option>france</option>
<option>gambia</option>
<option>germany</option>
<option>ghana</option>
<option>gibraltar</option>
<option>greece</option>
<option>guatemala</option>
<option>guinea</option>
<option>guyana</option>
<option>haiti</option>
<option>honduras</option>
<option>hong kong</option>
<option>hungary</option>
<option>iceland</option>
<option>india</option>
<option>indonesia</option>
<option>iraq</option>
<option>ireland</option>
<option>israel</option>
<option>italy</option>
<option>jamaica</option>
<option>japan</option>
<option>jordan</option>
<option>kazakhstan</option>
<option>kenya</option>
<option>korea</option>
<option>kuwait</option>
<option>laos</option>
<option>latvia</option>
<option>lebanon</option>
<option>lesotho</option>
<option>liberia</option>
<option>libya</option>
<option>lithuania</option>
<option>luxembourg</option>
<option>macau</option>
<option>macedonia</option>
<option>malaga</option>
<option>malawi kwacha</option>
<option>malaysia</option>
<option>maldives</option>
<option>malta</option>
<option>mauritania</option>
<option>mauritius</option>
<option>mexico</option>
<option>moldova</option>
<option>mongolia</option>
<option>morocco</option>
<option>mozambique</option>
<option>myanmar</option>
<option>namibia</option>
<option>nepal</option>
<option>new Zealand</option>
<option>nicaragua</option>
<option>nigeria</option>
<option>north korea</option>
<option>norway</option>
<option>oman</option>
<option>pakistan</option>
<option>panama</option>
<option>papua new guinea</option>
<option>paraguay</option>
<option>peru</option>
<option>philippines</option>
<option>poland</option>
<option>portugal</option>
<option>qatar</option>
<option>romania</option>
<option>russia</option>
<option>samoa</option>
<option>sao tome</option>
<option>saudi arabia</option>
<option>seychelles</option>
<option>sierra leone</option>
<option>singapore</option>
<option>slovakia</option>
<option>slovenia</option>
<option>solomon islands</option>
<option>somalia</option>
<option>south africa</option>
<option>spain</option>
<option>sri lanka</option>
<option>st helena</option>
<option>sudan</option>
<option>suriname</option>
<option>swaziland</option>
<option>sweden</option>
<option>switzerland</option>
<option>syria</option>
<option>taiwan</option>
<option>tanzania</option>
<option>thailand</option>
<option>tonga</option>
<option>trinidad</option>
<option>tunisia</option>
<option>turkey</option>
<option>united states</option>
<option>us</option>
<option>usa</option>
<option>uae</option>
<option>united arib emirates</option>
<option>uganda</option>
<option>ukraine</option>
<option>uzbekistan</option>
<option>vanuatu</option>
<option>venezuela</option>
<option>vietnam</option>
<option>yemen</option>
<option>yugoslavua</option>
<option>zambia</option>
<option>zimbabwe</option>
  </select></td>
      <td width="34%"><select size="1" name="strTo">
  <option>afghanistan</option>
<option>albania</option>
<option>algeria</option>
<option>andorra</option>
<option>andorra</option>
<option>angola</option>
<option>argentina</option>
<option>aruba</option>
<option>australia</option>
<option>austria</option>
<option>bahrain</option>
<option>bangladesh</option>
<option>barbados</option>
<option>belgium</option>
<option>belize</option>
<option>bermuda</option>
<option>bhutan</option>
<option>bolivian</option>
<option>botswana</option>
<option>brazil</option>
<option>england</option>
<option>united kingdom</option>
<option>uk</option>
<option>great britain</option>
<option>brunei</option>
<option>burundi</option>
<option>cambodia</option>
<option>canada</option>
<option>cape verde</option>
<option>cayman islands</option>
<option>chile</option>
<option>china</option>
<option>colombia</option>
<option>comoros</option>
<option>costa rica</option>
<option>croatia</option>
<option>cuba</option>
<option>cyprus</option>
<option>czech republic</option>
<option>denmark</option>
<option>dijibouti</option>
<option>dominican republic</option>
<option>netherlands</option>
<option>east caribbean</option>
<option>ecuador</option>
<option>egypt</option>
<option>el salvador</option>
<option>estonia</option>
<option>ethiopia</option>
<option>euro</option>
<option>falkland islands</option>
<option>fiji</option>
<option>finland</option>
<option>france</option>
<option>gambia</option>
<option>germany</option>
<option>ghana</option>
<option>gibraltar</option>
<option>greece</option>
<option>guatemala</option>
<option>guinea</option>
<option>guyana</option>
<option>haiti</option>
<option>honduras</option>
<option>hong kong</option>
<option>hungary</option>
<option>iceland</option>
<option>india</option>
<option>indonesia</option>
<option>iraq</option>
<option>ireland</option>
<option>israel</option>
<option>italy</option>
<option>jamaica</option>
<option>japan</option>
<option>jordan</option>
<option>kazakhstan</option>
<option>kenya</option>
<option>korea</option>
<option>kuwait</option>
<option>laos</option>
<option>latvia</option>
<option>lebanon</option>
<option>lesotho</option>
<option>liberia</option>
<option>libya</option>
<option>lithuania</option>
<option>luxembourg</option>
<option>macau</option>
<option>macedonia</option>
<option>malaga</option>
<option>malawi kwacha</option>
<option>malaysia</option>
<option>maldives</option>
<option>malta</option>
<option>mauritania</option>
<option>mauritius</option>
<option>mexico</option>
<option>moldova</option>
<option>mongolia</option>
<option>morocco</option>
<option>mozambique</option>
<option>myanmar</option>
<option>namibia</option>
<option>nepal</option>
<option>new Zealand</option>
<option>nicaragua</option>
<option>nigeria</option>
<option>north korea</option>
<option>norway</option>
<option>oman</option>
<option>pakistan</option>
<option>panama</option>
<option>papua new guinea</option>
<option>paraguay</option>
<option>peru</option>
<option>philippines</option>
<option>poland</option>
<option>portugal</option>
<option>qatar</option>
<option>romania</option>
<option>russia</option>
<option>samoa</option>
<option>sao tome</option>
<option>saudi arabia</option>
<option>seychelles</option>
<option>sierra leone</option>
<option>singapore</option>
<option>slovakia</option>
<option>slovenia</option>
<option>solomon islands</option>
<option>somalia</option>
<option>south africa</option>
<option>spain</option>
<option>sri lanka</option>
<option>st helena</option>
<option>sudan</option>
<option>suriname</option>
<option>swaziland</option>
<option>sweden</option>
<option>switzerland</option>
<option>syria</option>
<option>taiwan</option>
<option>tanzania</option>
<option>thailand</option>
<option>tonga</option>
<option>trinidad</option>
<option>tunisia</option>
<option>turkey</option>
<option>united states</option>
<option>us</option>
<option>usa</option>
<option>uae</option>
<option>united arib emirates</option>
<option>uganda</option>
<option>ukraine</option>
<option>uzbekistan</option>
<option>vanuatu</option>
<option>venezuela</option>
<option>vietnam</option>
<option>yemen</option>
<option>yugoslavua</option>
<option>zambia</option>
<option>zimbabwe</option>
  </select></td>
    </tr>
    <tr>
      <td width="33%">&nbsp;</td>
      <td width="33%">&nbsp;</td>
      <td width="34%">
      <input type="submit" value=" Convert &gt;&gt; " name="btnConvert"></td>
    </tr>
  </table>
  <p>&nbsp;</p>
  <input type="hidden" name="ACTION" value="CONVERT">
</form>
<%End Sub%>
</body>

</html>


<%
' GetXchangeRate using xmethods.net
' http://www.xmethods.com/ve2/ViewListing.po;jsessionid=zTogJhNW6cz0CB4jZywy_KTF(QhxieSRM)?serviceid=5
Public Function GetXchangeRate(ByVal strCountry1, _
                               ByVal strCountry2) ' As String
    On Error Resume Next
    ' SOAP Function 
    Dim WSDL_URL 'As String
    WSDL_URL = "http://www.xmethods.net/sd/2001/CurrencyExchangeService.wsdl"
    Dim objSOAPClient
    Dim strResult 'As String
    Set objSOAPClient = Server.CreateObject("MSSOAP.SoapClient")
    objSOAPClient.ClientProperty("ServerHTTPRequest") = True
    
    objSOAPClient.mssoapinit WSDL_URL
    
'   message name="getRateRequest">
'  <part name="country1" type="xsd:string" />
'  <part name="country2" type="xsd:string" />
'  </message>
    
    strResult = objSOAPClient.GetRate(CStr(strCountry1), _
                                             CStr(strCountry2)) ' As String

    If Err <> 0 Then
        ' GetXchangeRate = "ERROR: Could Not Get Exchange Rate (Error # " & CStr(Err.Number) & " " & Err.Description & " in " & Err.Source & ")"
        GetXchangeRate = "ERROR"
        Set objSOAPClient = Nothing
        Err.Clear
        Exit Function
    End If
    
    Set objSOAPClient = Nothing
    GetXchangeRate = strResult
End Function

%>
