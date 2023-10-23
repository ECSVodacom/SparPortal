<!--TITLE-->
<%
										Dim PageTitle	
										Dim Preloader			
%>
<title>
<%
										' Check if the user supplied a page title
										if PageTitle <> "" Then
											' Display the page title
											Response.Write const_app_Moniker & " : " & PageTitle
										else
											Response.Write const_app_Moniker
										end if
%>
</title>
<!--/TITLE/-->