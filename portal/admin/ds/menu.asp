<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="includes/constants.asp"-->
<!--#include file="includes/logincheck.asp"-->
<!--#include file="includes/formatfunctions.asp"-->
<!--#include file="includes/setuserdetails.asp"-->
<%
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/menu.asp")
										
										' Set the page header
										PageTitle = "Main Menu"
%>
<!--#include file="layout/start.asp"-->
<!--#include file="layout/title.asp"-->
<!--#include file="layout/headstart.asp"-->
<!--#include file="layout/globaljavascript.asp"-->
<!--#include file="layout/headclose.asp"-->
<!--#include file="layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Main Menu</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("DCName")%></b></td>
	</tr>
</table>
<!--#include file="includes/mainmenubar.asp"-->
<p class="pcontent">Welcome to the SPAR Drop Shipment Administration System. <br><br>Click on one of the menu bar links above to take you to the section you wish to edit.</p>
<!--#include file="layout/end.asp"-->