<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes"/>
<xsl:decimal-format name="staff" digit="D" />
<xsl:template match="/" xml:space="preserve">
	<table border="1" cellPadding="4" cellSpacing="2" width="100%">
    		<table border="0" cellPadding="4" cellSpacing="0" width="100%">
			 <tr>
			       <td width="50%" align="left"><img src="@@ApplicationRoot/images/spar/sparlogo.gif"></img></td>
			       <td>
				       <table width="100%" align="right" valign="middle">
					       <tr>
						       <td class="pcontent"><xsl:value-of select="/DOCUMENT/UNB/Sender/SenderReg"/></td>
					       </tr>
					       <tr>
						       <td class="pcontent"><xsl:value-of select="DOCUMENT/UNB/Sender/SenderAddress"/></td>
					       </tr>
					       <tr>
						       <td class="pcontent"><xsl:value-of select="DOCUMENT/UNB/Sender/SenderTel"/></td>
					       </tr>
					       <tr>
						       <td class="pcontent"><b>VAT Reg.No.</b> <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/NARR2"/></td>
					       </tr>
				       </table>
				</td>
			</tr>
	    	</table>
		<table border="0" cellPadding="2" cellSpacing="0" width="100%">
			<tr>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/Receiver/ReceiverID"/></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><b>Delivery Instructions:</b></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/UNH/DIN/NARR1"/></td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/Receiver/ReceiverAddress"/></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><b>PO NR: </b><xsl:number value="DOCUMENT/UNB/UNH/ORD/CDNO/CNDN"/>&#160;/&#160;<xsl:value-of select="DOCUMENT/UNB/UNH/ORD/ORNO/ORNU"/>
					<input type="hidden" name="txtOrderNumber" id="txtOrderNumber" value="{DOCUMENT/UNB/UNH/ORD/ORNO/ORNU}"/>
				</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><b>Delivery Date:</b> <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/EDAT"/></td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><b>RAIL TO SIDING:</b> <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
				<xsl:choose>
					<xsl:when test="DOCUMENT/UNB/APRF!=''">
						<td width="33%" VALIGN = "TOP" class="pcontent"><b><xsl:value-of select="DOCUMENT/UNB/APRF"/>: </b><xsl:value-of select="DOCUMENT/UNB/SOURCEREFERNCENUMBER"/></td>
					</xsl:when>
					<xsl:otherwise>
						<td width="33%" VALIGN = "TOP">&#160;</td>					
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP"><a href="javascript:window.print();"><img src="@@ApplicationRoot/images/spar/print_old.gif" border="0"/></a></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/UNH/CLO/CDPN"/></td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
		</table>
	</table>
<form name="FormFilter" id="FormFilter" method="post" action="default.asp?id=@@XMLFile">
	<table border="1" align="center" cellPadding="4" cellSpacing="0" width="100%" bgColor="#ccccc2">
          <tr> 
            	@@ListBox
	        <input type="hidden" name="hidFilter" id="hidFilter" value=""/>
          </tr>
        </table>
 </form>
        <br/>
	<table  style="font:8pt Arial" border="1" cellPadding="2" cellSpacing="0" width="100%">
		<tr bgColor="#ccccc2">
			 <td title="Items present in Original Order and Confirmation" COLSPAN="14" class="pcontent">&#160;<STRONG>Confirmed Items (Present in original order and confirmation)</STRONG></td>
		 </tr>
		<tr bgColor="#ccccc2">
			<td class="pcontent"><i>Seq<br/>No</i></td>
			<td class="pcontent"><i>Consumer Barcode<br/>Order Barcode<br/>Supp Prod Code</i></td>
			<td class="pcontent"><i>Description</i></td>
			<td class="pcontent"><i>Order<br/>Quantity<br/></i></td>
			<td class="pcontent"><i>Confirm<br/>Quantity<br/></i></td>
			<td class="pcontent"><i>Store<br/>Pack<br/></i></td>
			<td class="pcontent"><i>Vendor<br/>Pack<br/></i></td>
			<td class="pcontent"><i>List<br/>Cost<br/></i></td>
			<td class="pcontent"><i>Confirm<br/>Cost<br/></i></td>
			<td class="pcontent"><i>Dea1 1<br/>Deal 3<br/>Deal 5</i></td>
			<td class="pcontent"><i>Deal 2<br/>Deal 4<br/>Deal 6</i></td>
			<td class="pcontent"><i>Discount<br/>Calculation<br/>Method</i></td>
			<td class="pcontent"><i>Order<br/>Value<br/></i></td>
			@@Confirm
		</tr>
		<xsl:for-each select="DOCUMENT/UNB/UNH/OLD">
			<xsl:if test="@status='Confirmed'">
				<xsl:if test="QNTO/NROUC!=QNTO/NROU">
					<xsl:if test="QNTO/NROU * QNTO/TMEA != QNTO/NROUC">
						<xsl:if test="QNTO/NROU * QNTO/CONU != QNTO/NROUC">
							<tr>
								<td valign="middle" class="pcontent"><xsl:value-of select="@id"/></td>
								<td align="left" valign="top" class="pcontent"><xsl:value-of select="PROC/EANC"/>
									<br/><xsl:value-of select="PROC/EANC2"/><br/>
									<xsl:value-of select="PROC/SUPC"/>
								</td>
								<td align="left" valign="middle" class="pcontent"><xsl:value-of select="PROC/PROD"/>
									<input type="hidden" name="txtDesc{@id}" id="txtDesc{@id}" size="5" value="{PROC/PROD}"/>
								</td>
								<td class="pcontent"><xsl:value-of select="QNTO/NROU"/></td>
								<td bgcolor="@@Qty{@id}Color" class="@@Qty{@id}Class"><xsl:value-of select="QNTO/NROUC"/></td>
								<td align="right" valign="middle" class="pcontent">
									<xsl:choose>
										<xsl:when test="QNTO/CONU[. != '']">
											<xsl:value-of select="QNTO/CONU"/></xsl:when>
										<xsl:otherwise>
											&#160;
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td align="right" valign="middle" class="pcontent">
									<xsl:choose>
										<xsl:when test="QNTO/TMEA[. !='']">
											<xsl:value-of select="QNTO/TMEA"/></xsl:when>
										<xsl:otherwise>
											1	
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="pcontent">R<xsl:value-of select="format-number(COST/COSP, 'DDD,DDD.00', 'staff')"/></td>
								<td bgcolor="@@Pr{@id}Color" class="@@Pr{@id}Class">R<xsl:value-of select="format-number(COST/COSPC, 'DDD,DDD.00', 'staff')"/></td>
								<td align="left" valign="top" class="pcontent">
									<xsl:choose>
										<xsl:when test="CRAD/ADJI1[. != '']">
											<xsl:value-of select="CRAD/ADJI1"/>
												<xsl:choose>
													<xsl:when test="CRAD/PERC1[. != '0000000' and  . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC1"/>% </xsl:when>
													<xsl:when test="CRAD/VALU1[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU1"/></xsl:when>
												</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
										</xsl:otherwise>
									</xsl:choose>
									<br>   
									<xsl:choose>
										<xsl:when test="CRAD/ADJI3[. !='']">
											<xsl:value-of select="CRAD/ADJI3"/>
												<xsl:choose>
													<xsl:when test="CRAD/PERC3[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC3"/>% </xsl:when>
													<xsl:when test="CRAD/VALU3[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU3"/> </xsl:when>
												</xsl:choose>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
									</br>
									<xsl:choose>
										<xsl:when test="CRAD/ADJI5[. != '']">
											<xsl:value-of select="CRAD/ADJI5"/>
											<xsl:choose>
												<xsl:when test="CRAD/PERC5[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC5"/>% </xsl:when>
												<xsl:when test="CRAD/VALU5[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU5"/> </xsl:when>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</td>
								<td align="left" valign="top" class="pcontent">
									<xsl:choose>
										<xsl:when test="CRAD/ADJI2[. != ' ']">
											<xsl:value-of select="CRAD/ADJI2"/>
												<xsl:choose>
													<xsl:when test="CRAD/PERC2[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC2"/>% </xsl:when>
													<xsl:when test="CRAD/VALU2[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU2"/> </xsl:when>
												</xsl:choose>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
									<br>   
									<xsl:choose>
										<xsl:when test="CRAD/ADJI4[. != ' ']">
											<xsl:value-of select="CRAD/ADJI4"/>
												<xsl:choose>
													<xsl:when test="CRAD/PERC4[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC4"/>% </xsl:when>
													<xsl:when test="CRAD/VALU4[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU4"/> </xsl:when>
												</xsl:choose>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
									</br>
									<xsl:choose>
										<xsl:when test="CRAD/ADJI6[. != ' ']">
											<xsl:value-of select="CRAD/ADJI6"/>
												<xsl:choose>
													<xsl:when test="CRAD/PERC6[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC6"/>% </xsl:when>
													<xsl:when test="CRAD/VALU6[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU6"/> </xsl:when>
												</xsl:choose>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</td>
								<td align="left" valign="middle" class="pcontent">
									<xsl:choose>
										<xsl:when test="DCMD[. = 'C']">Compound</xsl:when>
										<xsl:when test="DCMD[. = 'S']">Simple</xsl:when>
										<xsl:otherwise>Unknown</xsl:otherwise>
									</xsl:choose>
								</td>
								<td align="right" valign="middle" class="pcontent">R<xsl:value-of select="format-number(NELC, 'DDD,DDD.00', 'staff')"/></td>
								@@Net<xsl:value-of select="@id"/>Price
							</tr>
								<xsl:if test="NARR!='NONE'">
									<tr bgcolor="red">
										<td>&#160;</td>
										<td class="pcontent"><i>Comments: </i></td>
										<td colspan = "13" class="pcontent"><xsl:value-of select="NARR"/></td>
									</tr>
								</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</table>
	<br/>
	<table  style="font:8pt Arial" border="1" cellPadding="2" cellSpacing="0" width="100%">
		<tr bgColor="#ccccc2">
			 <td title="Items present in Original Order and not in Confirmation" COLSPAN="14" class="pcontent">&#160;<STRONG>Unconfirmed Items (Present in original order and not in confirmation)</STRONG></td>
		 </tr>
		<tr bgColor="#ccccc2">
			<td class="pcontent"><i>Seq<br/>No</i></td>
			<td class="pcontent"><i>Consumer Barcode<br/>Order Barcode<br/>Supp Prod Code</i></td>
			<td class="pcontent"><i>Description</i></td>
			<td class="pcontent"><i>Order<br/>Quantity<br/></i></td>
			<td class="pcontent"><i>Store<br/>Pack<br/></i></td>
			<td class="pcontent"><i>Vendor<br/>Pack<br/></i></td>
			<td class="pcontent"><i>List<br/>Cost<br/></i></td>
			<td class="pcontent"><i>Dea1 1<br/>Deal 3<br/>Deal 5</i></td>
			<td class="pcontent"><i>Deal 2<br/>Deal 4<br/>Deal 6</i></td>
			<td class="pcontent"><i>Discount<br/>Calculation<br/>Method</i></td>
			<td class="pcontent"><i>Order<br/>Value<br/></i></td>
		</tr>
		<xsl:for-each select="DOCUMENT/UNB/UNH/OLD">
			<xsl:if test="@status='Unconfirmed'">
				<tr>
					<td valign="middle" class="pcontent"><xsl:value-of select="@id"/></td>
					<td align="left" valign="top" class="pcontent"><xsl:value-of select="PROC/EANC"/>
						<br/><xsl:value-of select="PROC/EANC2"/><br/>
						<xsl:value-of select="PROC/SUPC"/>
					</td>
					<td align="left" valign="middle" class="pcontent"><xsl:value-of select="PROC/PROD"/>
						<input type="hidden" name="txtDesc{@id}" id="txtDesc{@id}" size="5" value="{PROC/PROD}"/>
					</td>
					<td class="pcontent"><xsl:value-of select="QNTO/NROU"/></td>
					<td align="right" valign="middle" class="pcontent">
						<xsl:choose>
							<xsl:when test="QNTO/CONU[. != '']">
								<xsl:value-of select="QNTO/CONU"/></xsl:when>
							<xsl:otherwise>
								&#160;
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td align="right" valign="middle" class="pcontent">
						<xsl:choose>
							<xsl:when test="QNTO/TMEA[. !='']">
								<xsl:value-of select="QNTO/TMEA"/></xsl:when>
							<xsl:otherwise>
								1	
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="pcontent">R<xsl:value-of select="format-number(COST/COSP, 'DDD,DDD.00', 'staff')"/></td>
					<td align="left" valign="top" class="pcontent">
						<xsl:choose>
							<xsl:when test="CRAD/ADJI1[. != '']">
								<xsl:value-of select="CRAD/ADJI1"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC1[. != '0000000' and  . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC1"/>% </xsl:when>
										<xsl:when test="CRAD/VALU1[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU1"/></xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
							</xsl:otherwise>
						</xsl:choose>
						<br>   
						<xsl:choose>
							<xsl:when test="CRAD/ADJI3[. !='']">
								<xsl:value-of select="CRAD/ADJI3"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC3[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC3"/>% </xsl:when>
										<xsl:when test="CRAD/VALU3[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU3"/> </xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						</br>
						<xsl:choose>
							<xsl:when test="CRAD/ADJI5[. != '']">
								<xsl:value-of select="CRAD/ADJI5"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC5[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC5"/>% </xsl:when>
									<xsl:when test="CRAD/VALU5[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU5"/> </xsl:when>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</td>
					<td align="left" valign="top" class="pcontent">
						<xsl:choose>
							<xsl:when test="CRAD/ADJI2[. != ' ']">
								<xsl:value-of select="CRAD/ADJI2"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC2[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC2"/>% </xsl:when>
										<xsl:when test="CRAD/VALU2[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU2"/> </xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						<br>   
						<xsl:choose>
							<xsl:when test="CRAD/ADJI4[. != ' ']">
								<xsl:value-of select="CRAD/ADJI4"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC4[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC4"/>% </xsl:when>
										<xsl:when test="CRAD/VALU4[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU4"/> </xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						</br>
						<xsl:choose>
							<xsl:when test="CRAD/ADJI6[. != ' ']">
								<xsl:value-of select="CRAD/ADJI6"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC6[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC6"/>% </xsl:when>
										<xsl:when test="CRAD/VALU6[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU6"/> </xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</td>
					<td align="left" valign="middle" class="pcontent">
						<xsl:choose>
							<xsl:when test="DCMD[. = 'C']">Compound</xsl:when>
							<xsl:when test="DCMD[. = 'S']">Simple</xsl:when>
							<xsl:otherwise>Unknown</xsl:otherwise>
						</xsl:choose>
					</td>
					<td align="right" valign="middle" class="pcontent">R<xsl:value-of select="format-number(NELC, 'DDD,DDD.00', 'staff')"/></td>
				</tr>
				<!--<xsl:if test="NARR!='' or NARR!=''">
					<tr bgcolor="red">
						<td>&#160;</td>
						<td class="pcontent"><i>Comments: </i></td>
						<td colspan = "13" class="pcontent"><xsl:value-of select="NARR"/></td>
					</tr>
				</xsl:if>-->
			</xsl:if>
		</xsl:for-each>
	</table>
	<br/>
		<br/>
	<table  style="font:8pt Arial" border="1" cellPadding="2" cellSpacing="0" width="100%">
		<tr bgColor="#ccccc2">
			 <td title="Items present in Original Order and not in Original" COLSPAN="14" class="pcontent">&#160;<STRONG>New Items (Present in original order and not in original)</STRONG></td>
		 </tr>
		<tr bgColor="#ccccc2">
			<td class="pcontent"><i>Seq<br/>No</i></td>
			<td class="pcontent"><i>Consumer Barcode<br/>Order Barcode<br/>Supp Prod Code</i></td>
			<td class="pcontent"><i>Description</i></td>
			<td class="pcontent"><i>Order<br/>Quantity<br/></i></td>
			<td class="pcontent"><i>Store<br/>Pack<br/></i></td>
			<td class="pcontent"><i>Vendor<br/>Pack<br/></i></td>
			<td class="pcontent"><i>List<br/>Cost<br/></i></td>
			<td class="pcontent"><i>Dea1 1<br/>Deal 3<br/>Deal 5</i></td>
			<td class="pcontent"><i>Deal 2<br/>Deal 4<br/>Deal 6</i></td>
			<td class="pcontent"><i>Discount<br/>Calculation<br/>Method</i></td>
			<td class="pcontent"><i>Order<br/>Value<br/></i></td>
		</tr>
		<xsl:for-each select="DOCUMENT/UNB/UNH/OLD">
			<xsl:if test="@status='New'">
				<tr>
					<td valign="middle" class="pcontent"><xsl:value-of select="@id"/></td>
					<td align="left" valign="top" class="pcontent"><xsl:value-of select="PROC/EANC"/>
						<br/><xsl:value-of select="PROC/EANC2"/><br/>
						<xsl:value-of select="PROC/SUPC"/>
					</td>
					<td align="left" valign="middle" class="pcontent"><xsl:value-of select="PROC/PROD"/>
						<input type="hidden" name="txtDesc{@id}" id="txtDesc{@id}" size="5" value="{PROC/PROD}"/>
					</td>
					<td class="pcontent"><xsl:value-of select="QNTO/NROU"/></td>
					<td align="right" valign="middle" class="pcontent">
						<xsl:choose>
							<xsl:when test="QNTO/CONU[. != '']">
								<xsl:value-of select="QNTO/CONU"/></xsl:when>
							<xsl:otherwise>
								&#160;
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td align="right" valign="middle" class="pcontent">
						<xsl:choose>
							<xsl:when test="QNTO/TMEA[. !='']">
								<xsl:value-of select="QNTO/TMEA"/></xsl:when>
							<xsl:otherwise>
								1	
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="pcontent">R<xsl:value-of select="format-number(COST/COSP, 'DDD,DDD.00', 'staff')"/></td>
					<td align="left" valign="top" class="pcontent">
						<xsl:choose>
							<xsl:when test="CRAD/ADJI1[. != '']">
								<xsl:value-of select="CRAD/ADJI1"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC1[. != '0000000' and  . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC1"/>% </xsl:when>
										<xsl:when test="CRAD/VALU1[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU1"/></xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
							</xsl:otherwise>
						</xsl:choose>
						<br>   
						<xsl:choose>
							<xsl:when test="CRAD/ADJI3[. !='']">
								<xsl:value-of select="CRAD/ADJI3"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC3[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC3"/>% </xsl:when>
										<xsl:when test="CRAD/VALU3[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU3"/> </xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						</br>
						<xsl:choose>
							<xsl:when test="CRAD/ADJI5[. != '']">
								<xsl:value-of select="CRAD/ADJI5"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC5[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC5"/>% </xsl:when>
									<xsl:when test="CRAD/VALU5[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU5"/> </xsl:when>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</td>
					<td align="left" valign="top" class="pcontent">
						<xsl:choose>
							<xsl:when test="CRAD/ADJI2[. != ' ']">
								<xsl:value-of select="CRAD/ADJI2"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC2[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC2"/>% </xsl:when>
										<xsl:when test="CRAD/VALU2[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU2"/> </xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						<br>   
						<xsl:choose>
							<xsl:when test="CRAD/ADJI4[. != ' ']">
								<xsl:value-of select="CRAD/ADJI4"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC4[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC4"/>% </xsl:when>
										<xsl:when test="CRAD/VALU4[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU4"/> </xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
						</br>
						<xsl:choose>
							<xsl:when test="CRAD/ADJI6[. != ' ']">
								<xsl:value-of select="CRAD/ADJI6"/>
									<xsl:choose>
										<xsl:when test="CRAD/PERC6[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC6"/>% </xsl:when>
										<xsl:when test="CRAD/VALU6[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU6"/> </xsl:when>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</td>
					<td align="left" valign="middle" class="pcontent">
						<xsl:choose>
							<xsl:when test="DCMD[. = 'C']">Compound</xsl:when>
							<xsl:when test="DCMD[. = 'S']">Simple</xsl:when>
							<xsl:otherwise>Unknown</xsl:otherwise>
						</xsl:choose>
					</td>
					<td align="right" valign="middle" class="pcontent">R<xsl:value-of select="format-number(NELC, 'DDD,DDD.00', 'staff')"/></td>
				</tr>
				<!--<xsl:if test="NARR!='' or NARR!=''">
					<tr bgcolor="red">
						<td>&#160;</td>
						<td class="pcontent"><i>Comments: </i></td>
						<td colspan = "13" class="pcontent"><xsl:value-of select="NARR"/></td>
					</tr>
				</xsl:if>-->
			</xsl:if>
		</xsl:for-each>
	</table>
	<br/><br/>
 </xsl:template>
</xsl:stylesheet>

