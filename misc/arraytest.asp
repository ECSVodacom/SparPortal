<%@ Language=VBScript %>
<%
										Session("Basket") = Array(1,2,3,4)
										dim MyArray
										
										Redim MyArray(10)
										
										for count = 0 to Ubound(MyArray)
											MyArray(count) = count
											Response.Write MyArray(count) & "<br>"
										next
										
										MyArray = 5
										
										Response.Write Ubound(MyArray)
																			
										
%>