<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="DownloadFunction.asp"-->
<%
    Dim rid
    Dim sqlCommand
    Dim recordSet
    Dim curConnection
    Dim cnObj
    Dim rsObj
    Dim i
    Dim ColumnHeaders
    Dim RowValues
    Dim FileContents
    Dim FileName
    Dim delimiter
    Dim FileLocation
    Dim FileNameOnly
    Dim FSO, NewFile
	
    rid = Request.Form("rid")
	If InStr(rid,"{") > 0 Then rid = Mid(rid,2,Len(rid)-2)
	FileName = rid 

    Set cnObj = CreateObject("ADODB.Connection")
    Set rsObj = CreateObject("ADODB.RecordSet")
	
    cnObj.Open const_db_ConnectionString
    If Request.Form("ReportType") = "FullReport" Then
		sqlCommand = "EXEC SparDS.dbo.GetRemittanceXML @Id = '" & rid & "'"
		'rESPONSE.wRITE sqlCommand
        rsObj.Open sqlCommand, cnObj
		If Not (rsObj.EOF And rsObj.BOF) Then
			FileContents = rsObj(0)
			Set FSO = Server.CreateObject("Scripting.FileSystemObject")
			FileName = FileName & ".xml"
			FileLocation = Const_ElectronicRemittance_TempSave & Replace(FileName,"-","")
			Set NewFile = FSO.CreateTextFile(FileLocation,True)
			NewFile.WriteLine(FileContents)
			NewFile.Close
		Else
			Response.Write "No download available"
			Response.End		
		End If
		rsObj.Close
        cnObj.Close
        Set rsObj = Nothing
        Set cnObj = Nothing
		DoDownload FileName, FileLocation
    Else
        sqlCommand = "EXEC SqlExportToFlatFile " & Request.Form("ReportSeperator") & ",'" & rid & "'"
		'rESPONSE.wRITE sqlCommand
        rsObj.Open sqlCommand, cnObj
        If Not (rsObj.EOF And rsObj.BOF) Then
			FileName = rsObj("FileName")
			'FileLocation = Const_ElectronicRemittance_TempSave 
			'Response.Write FileLocation
			'DoDownload FileName, FileLocation & FileName
			Response.Redirect(const_app_ApplicationRoot & "/documents/Spar/dropship/remittanceadvices/tempsave/" & FileName)
		Else
			Response.Write "No download available"
			Response.End		
        End If
        rsObj.Close
        cnObj.Close

        Set cnObj = Nothing
        Set rsObj = Nothing
    End If
	
%>