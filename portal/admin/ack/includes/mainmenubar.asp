<!--MAIN MENU-->
<hr>
<table>
	<tr>
		<td class="pcontent">
<%
										if (Session("Permission") AND 1) = 1 then
%>		
			<a class="menu" href="<%=const_app_ApplicationRoot%>/users/">Admin Users</a>&nbsp;|&nbsp;
<%
										end if
										
										if (Session("Permission") AND 2) = 2 then
%>		
			<a class="menu" href="<%=const_app_ApplicationRoot%>/supplier/">Suppliers</a>&nbsp;|&nbsp;
<%
										end if
										
										if (Session("Permission") AND 4) = 4 then
%>		
			<a class="menu" href="<%=const_app_ApplicationRoot%>/search/">Search</a>&nbsp;|&nbsp;
<%
										end if
										
										if (Session("Permission") AND 8) = 8 then
%>			
			<a class="menu" href="<%=const_app_ApplicationRoot%>/mail/">Generate E-Mail</a>&nbsp;|&nbsp;		
<%
										end if
										
										if (Session("Permission") AND 16) = 16 then
%>			
			<a class="menu" href="<%=const_app_ApplicationRoot%>/password/">Password Look-up</a>&nbsp;|&nbsp;		
<%
										end if
%>													
			<a class="menu" href="<%=const_app_ApplicationRoot%>/profile/">Log Off</a>
		</td>
	</tr>
</table>
<hr>
<!--/MAIN MENU/-->