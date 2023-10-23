<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/genmenuitems.asp"-->
<!--#include file="../../includes/freeASPUpload.asp"-->
<!--#include file="../../includes/schedulefunctions.asp"-->
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim FolderName
										dim TotPages
										dim Band
										dim RecordCount
										dim MaxRecords
										dim RecordFrom
										dim RecordTo
										dim BandSize
										dim UserID
										dim Selected
										dim UserType
										dim OrdNum
										dim txtSupplier
										dim txtStore
										dim NewDate
										dim IsXML
										dim Folder
										dim txtDC
										dim dcID
										Dim Upload, fileName, fileSize, ks, i, fileKey, SaveFiles, errorFlag, cnt, ReturnVal
										
										errorFlag = true								
										
										if Session("UserType") = 1 or  Session("UserType") = 4 then
											UserID = Session("ProcID")
											UserType = 1
											dcID = Session("DCID")
										else
											UserID = 0
											UserType = 2
											
											if Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE")then
												dcID = 0
											else
												dcID = Session("DCID")
											end if
                                        end if
									
										' Call the menu items generation function
										Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate, IsXML)
										
										' Set the connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	

		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>
<br /><br />
<%
  
                                       if request.Form("hidAction") = "1" then
                                            ' Loop throught the form lines
                                            for i = 1 to request.Form("hidTotal")
                                                ' Check which line was selected
                                                 
                                                 'response.Write "chkProcess = " & request.Form("chkProcess" & i)
                                                
                                                if request.Form("chkProcess" & i) = "checked" or request.Form("chkProcess" & i) = "on" then
                                                    ' Determine what file type needs to be procesed                                                                                              
                                                    Select Case request.Form("hidType" & i)
                                                        Case "Excel"
                                                            ' Call the ProcessExcel Function    
                                                        Case "Pipe Delimited"
                                                            ' Call the ProcessDelimited Function - Delimiter = "|"
                                                            ReturnVal = ProcessPipe(curConnection, UserID, Request.Form("hidDCID" & i), Request.Form("hidUploadID" & i), const_app_uploaddir, Request.Form("hidFileName" & i))
                                                        Case "Tab Delimited"
                                                            ' Call the ProcessDelimited Function - Delimiter = "tab"
                                                        Case "CSV"
                                                            ' Call the ProcessDelimited Function - Delimiter = ","
                                                    End Select
                                                end if
                                                
                                            next
                                       end if
%>
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="bheader" align="left">Process &amp; Validate</td>
				</tr>
            </table>
		</td>
	</tr>
</table>
<%
                                        ' Get a list of files that still needs to be processed
                                        Set ReturnSet = ExecuteSql("listScheduleUploads @UserID=" & UserID, curConnection) 
										
                                        if ReturnSet("returnvalue") <> "0" then
%>
<p class="pcontent">There are no upload files to be processed and validated.</p>
<%                                        
                                        else
%>
<p class="pcontent">Below is a list of uploaded schedules that has not been processed and validated yet.</p>
<form name="frmProcess" id="frmProcess" method="post" action="default.asp">
	<table border="1" cellpadding="0" cellspacing="0" width="100%">
	    <tr bgcolor="#4C8ED7">
	        <td class="tdcontent" align="center"><b>Process</b></td>
		    <td class="tdcontent" align="center"><b>File Name</b></td>
		    <td class="tdcontent" align="center"><b>File Size</b></td>
		    <td class="tdcontent" align="center"><b>Date Uploaded</b></td>
		    <td class="tdcontent" align="center"><b>File Type</b></td>
		    <td class="tdcontent" align="center"><b>DC Name</b></td>
		    <td class="tdcontent" align="center"><b>Status</b></td>
	    </tr>
<%
                                            cnt = 0
                                            While not ReturnSet.EOF
                                                cnt = cnt + 1
%>
        <tr>
            <td class="pcontent" align="center">
<%
                                                if ReturnSet("StatusDescrip") = "Not Processed" then
%>                
                <input type="checkbox" name="chkProcess<%=cnt%>" id="chkProcess<%=cnt%>" class="pcontent" />
<%
                                                end if
%>                
                <input type="hidden" name="hidUploadID<%=cnt%>" id="hidUploadID<%=cnt%>" value="<%=ReturnSet("UploadID")%>" class="pcontent" />
                <input type="hidden" name="hidType<%=cnt%>" id="hidType<%=cnt%>" value="<%=ReturnSet("Type")%>" class="pcontent" />
                <input type="hidden" name="hidDCID<%=cnt%>" id="hidDCID<%=cnt%>" value="<%=ReturnSet("DCID")%>" class="pcontent" />
                <input type="hidden" name="hidFileName<%=cnt%>" id="hidFileName<%=cnt%>" value="<%=ReturnSet("FileName")%>" class="pcontent" />
            </td>
            <td class="pcontent" align="center"><%=ReturnSet("FileName")%></td>
            <td class="pcontent" align="center"><%=ReturnSet("Size")%></td>
            <td class="pcontent" align="center"><%=ReturnSet("UploadDate")%></td>
            <td class="pcontent" align="center"><%=ReturnSet("Type")%></td>
            <td class="pcontent" align="center"><%=ReturnSet("DCName")%></td>
            <td class="pcontent" align="center"><%=ReturnSet("StatusDescrip")%></td>
        </tr>
<%                                            
                                            
                                                ReturnSet.MoveNext
                                            Wend
                                            
                                            Set ReturnSet = Nothing
%>
    </table>
    <p>
        <input type="submit" name="btnProcess" id="btnProcess" value="Process" class="button" />
        <input type="hidden" name="hidAction" id="hidAction" value="1" />
        <input type="hidden" name="hidTotal" id="hidTotal" value="<%=cnt%>" />
    </p>
</form>
<%                                            
                                        end if
                                            
                                        curConnection.Close
									    Set curConnection = Nothing
%>
<!--#include file="../../layout/end.asp"-->
