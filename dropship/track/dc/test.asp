<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
	<table border="1" class="pcontent" width="100%">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center"><b>Select</b></td>
					<td class="tdcontent" align="center"><b>DC</b></td>
					<td class="tdcontent" align="center"><b>Category</b></td>
					<td class="tdcontent" align="center"><b>Sub Category</b></td>
					<td class="tdcontent" align="center"><b>Reason</b></td>
					<td class="tdcontent" align="center"><b>Sub Reason</b></td>
					<td class="tdcontent" align="center"><b>Status</b></td>
					<td class="tdcontent" align="center"><b>Range</b></td>
					<td class="tdcontent" align="center"><b>Email Address</b></td>
				</tr><%
			
				%>	<tr>
						<td class="pcontent" rowspan=11 align="center"><input type="checkbox" name="chkConfigurationId" value="<%=Guid%>" />&nbsp;&nbsp;<a href="WarehouseClaimConfigAdd.asp?guid="" 
							target="_blank">0150</a></td>
							
						<td class="pcontent" rowspan=11 align="center">SOUTH RAND</td>
						<td class="pcontent" rowspan=11 align="center">Crates</td>
						<td class="pcontent" rowspan=11  align="center">ALL</td>
						<td class="pcontent" rowspan=11 align="center">ALL</td>
						<td class="pcontent" rowspan=11  align="center">ALL</td>
						
						<tr><td>Acknowledged by DC</td><td></td><td>email</td></tr>
						<tr><td>Rejection disputed by store</td><td></td><td>email</td></tr>
						<tr><td>Resolution disputed by store</td><td></td><td>email</td></tr>
						<tr><td>Reinstated by DC</td><td></td><td>email</td></tr>
						<tr><td>Verified by DC Buyer</td><td></td><td>email</td></tr>
						<tr><td>Authorised for Credit to Store</td><td></td><td>email</td></tr>
						
						<tr>
							<td rowspan=3>Management Authorisation Required
								<tr><td>100-1000</td><td>email1</td></tr>
								<tr><td>1000.2-2000</td><td>email2</td></tr>
							</td>
						</tr>
						
						<tr><td>Verified By Category Manager</td><td></td><td>email</td></tr>
					</tr>
	</table>