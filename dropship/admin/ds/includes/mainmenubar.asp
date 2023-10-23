<!--MAIN MENU-->
<hr>
<table>
	<tr>
		<td class="pcontent">
			<a class="menu" href="<%=const_app_ApplicationRoot%>/store/">Stores</a>&nbsp;|&nbsp;
			<a class="menu" href="<%=const_app_ApplicationRoot%>/supplier/">Suppliers</a>&nbsp;|&nbsp;
<%
										' Check if this is a super administrator
										if Session("Permission") = 1 then
%>
			<a class="menu" href="<%=const_app_ApplicationRoot%>/password/">Password Look-Up</a>&nbsp;|&nbsp;
			<a class="menu" href="<%=const_app_ApplicationRoot%>/mail/">Generate E-Mail</a>&nbsp;|&nbsp;		
<%										
										end if
%>			
			<a class="menu" href="<%=const_app_ApplicationRoot%>/profile/logout.asp">Log Out</a>
		</td>
	</tr>
</table>
<hr>
<!--/MAIN MENU/-->