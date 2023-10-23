<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
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
                
    rid = Request.Form("rid")
    
    Set cnObj = CreateObject("ADODB.Connection")
    Set rsObj = CreateObject("ADODB.RecordSet")



    cnObj.Open const_db_ConnectionString

            
    If Request.Form("ReportType") = "FullReport" Then
        ' Download the original XML file submitted by SPAR
        
		Set rsObj =  ExecuteSql("GetRALog @Id="&rid, cnObj)
        
        FileLocation = rsObj("ArchivedLocation") &  rsObj("XML_FileName")
        FileNameOnly = rsObj("XML_FileName")
        ' Close connections
        rsObj.Close
        cnObj.Close
        
        ' Release systems resources
        Set rsObj = Nothing
        Set cnObj = Nothing
        

        ' Redirect to download page and start the download
        DoDownload FileNameOnly, FileLocation
    Else


        ' Generate CSV or PIPE delimited text and save to file, and download
        Select Case Request.Form("ReportSeperator")
            Case "PIPE"
                delimiter = "|"
            Case "CSV"
                delimiter = ","
        End Select
    
        'sqlCommand = "SELECT * FROM RADetail WHERE XML_UID = " & rid
        ' Get list by using a store procedure, this will return a select columns and values
        sqlCommand = "EXEC SparDS.dbo.getRALineItems @XML_UID=" & rid

        Set rsObj =  ExecuteSql(sqlCommand, cnObj)
        If Not (rsObj.EOF And rsObj.BOF) Then
            FileName = rsObj("XML_FileName")
            ' Get column headers
            For i = 0 To rsObj.Fields.Count - 1
                If rsObj.Fields(i).Name <> "XML_FileName" Then
                    ColumnHeaders = ColumnHeaders & rsObj.Fields(i).Name & delimiter
                End If
            Next 
            ColumnHeaders = Left(ColumnHeaders, Len(ColumnHeaders) - 1)
            
            ' Get detail items
            While Not rsObj.EOF
                For i = 0 To rsObj.Fields.Count - 1
                    If rsObj.Fields(i).Name <> "XML_FileName" Then
				If (i > 9 AND i < 16) Then
                        	RowValues = RowValues & TwoDecimals(rsObj.Fields(i).Value) & delimiter
				Else
					RowValues = RowValues & rsObj.Fields(i).Value & delimiter
				End If
				
                    End If
                Next 
                RowValues = Left(RowValues, Len(RowValues) - 1)
                RowValues = RowValues & vbCrLf
                
                rsObj.MoveNext
            Wend
		Else
			Response.Write "No download available"
			Response.End		
		End If
        rsObj.Close
        cnObj.Close

        Set cnObj = Nothing
        Set rsObj = Nothing

			

        Dim NewFileName
        Dim NewFile, FSO        
        ' Dump FileContents to a text file
        Set FSO = Server.CreateObject("Scripting.FileSystemObject")
        
        ' Remove old file name extension
        FileName = Left(FileName,Len(FileName) - 4)
        Select Case delimiter
            Case "|"
                NewFileName = FileName & ".txt"
            Case ","
                NewFileName = FileName & ".csv"
        End Select
        ' Finalize file contents
        FileContents = ColumnHeaders & vbCrLf & RowValues
	
		
        ' Dump file contents
        FileLocation = Const_ElectronicRemittance_TempSave & NewFileName

        Set NewFile = FSO.CreateTextFile(FileLocation,True)
        NewFile.WriteLine(FileContents)
        NewFile.Close

        DoDownload NewFileName, FileLocation
    End If
%>