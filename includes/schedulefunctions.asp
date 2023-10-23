<%
	function ProcessExcel (dboConn, SupplierID, UserID, DCID, FilePath, FileName, FileSize, IsForceCredit, IsRewardsNumeric)
		' Author & Date: Chris Kennedy, 02 September 2008
		' Purpose: This function will read the excel spreadsheet and upload into database
		'Response.Write Server.ScriptTimeout
		Server.ScriptTimeout=200
		'Response.Write Server.ScriptTimeout
		'on error resume next

	    'Dim rs,sql,i, myrs
	    Dim objConn, objRS, strSQL
	    Const ForReading = 1 
        Const ForWriting = 2 
        Const ForAppending = 8 
        Const TristateUseDefault = -2 
        Const TristateTrue = -1 
        Const TristateFalse = 0 

        dim ReturnSet
        dim scheduleID
        dim ReturnVal
        dim errorFlag
        dim strSplit
        dim StatusVal
        dim Total
        dim TotalDoc
        dim amtIncl
        dim vatAmt
        dim amtExcl
        dim storeCode
        dim SQL1
        dim invRef
        dim clmRef
		Dim ConnectionString
		
	    errorFlag = false
        StatusVal = "Validated - No Errors"
        Total = 0
        TotalDoc = 0
        storeCode = ""
							
		Const Before2003 = "xls"
		Const After2003 = "xlsx"
		Dim FileNameArray
		FileNameArray = Split(FileName,".")
		If FileNameArray(UBound(FileNameArray)) = After2003 Then
			ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("../upload/" & FileName) & ";Extended Properties='Excel 12.0 Xml;HDR=YES; IMEX=1'"
		ElseIf FileNameArray(UBound(FileNameArray)) = Before2003 Then
			ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & Server.MapPath("../upload/" & FileName) & ";Extended Properties='Excel 8.0; HDR=Yes; IMEX=1'"
		Else
			ProcessExcel = "Invalid file type"	
			Exit Function
		End If
	
		
        Set objConn = Server.CreateObject("ADODB.Connection")
		objConn.Open ConnectionString
        strSQL = "SELECT * FROM  [Sheet1$]"
        Set objRS=objConn.Execute(strSQL) ' This reads data from excel document
		
		Dim ExclusiveColumn
		Dim VatColumn
	   
		ExclusiveColumn = objRS.Fields.Item(4).Value
		VatColumn = objRS.Fields.Item(5).Value

		If (IsRewardsNumeric = 1 And objRS.Fields.count < 11) Then
			' Total fields for rewards is 11
			ReturnVal = ReturnVal & "ERROR: The rewards schedule you are tying to upload does not match the file type selected or the file content is not in the agreed format."			
		ElseIf (objRS.Fields.count < 8)  Then
			ReturnVal = ReturnVal & "ERROR: The file you are tying to upload does not match the file type selected or the file content is not in the agreed format."			
		
		else
	        if err then
		        ReturnVal = ReturnVal & "ERROR: An error occured while trying to read the Excel file: " & err.Description
	        else
                SQL = "addScheduleHeader @FileName=" & MakeSQLText(FileName) &_
                ", @Size=" & FileSize & _
                ", @DCID=" & DCID &_
                ", @supplierID=" & SupplierID & _
				", @UserID=" & UserID & _
				", @IsForceCredit=" & IsForceCredit & _
                ", @IsRewardsNumeric=" & IsRewardsNumeric 
		'Response.Write SQL
                Set ReturnSet = ExecuteSql(SQL, dboConn) 
                
                if ReturnSet("returnvalue") <> "0" then
                    ReturnVal = ReturnVal & "ERROR: An error occured while trying to create a Schedule header record in the database for file: " & FileName
                else
                    scheduleID = ReturnSet("newHeadID")
                    
                    Set ReturnSet = Nothing
                        
                    i = 0
                    Total = 0
                    Do While Not objRS.EOF 
                        i = i + 1
                        
                        amtIncl = 0
                        vatAmt = 0
                        amtExcl = 0
                        
                        if objRS.Fields.Item(4).Value <> "" then
                            amtIncl = objRS.Fields.Item(4).Value
                        end if
                        
                        if objRS.Fields.Item(5).Value <> "" then
                            vatAmt = objRS.Fields.Item(5).Value
                        end if
                        
                        if objRS.Fields.Item(6).Value <> "" then
                            amtExcl = objRS.Fields.Item(6).Value
                        end if
						
						StoreCode = objRS.Fields.Item(0).Value
                        If IsNumeric(Trim(StoreCode)) Then
							StoreCode = Replace(StoreCode, Chr(16), "")
							StoreCode = Replace(StoreCode, Chr(160), "")

							' Date could also be seperated by a . instead of a front-slash
							Dim DocDate
							DocDate = objRS.Fields.Item(3).Value
							DocDate = Replace(DocDate,".","/")
									
							If IsDate(DocDate) Then                       
								If DateDiff("d", DocDate, Now) < 0 Then
									DocDate = Date
								End If
							Else
								DocDate = Date
							End if
					
						' If StoreCode is not numeric then ignore
						
							SQL = "addScheduleDetail @HeaderID=" & scheduleID & _
							", @StoreCode=" & MakeSQLText(StoreCode) & _
							", @StoreName=" & MakeSQLText(objRS.Fields.Item(1).Value) & _
							", @DocNumber=" & MakeSQLText(objRS.Fields.Item(2).Value) & _
							", @DocDate=" & MakeSQLText(Year(DocDate) & "/" & LZ(Month(DocDate)) & "/" & LZ(Day(DocDate))) & _
							", @AmtExcl=" & Replace(amtIncl,",","") & _
							", @Vat=" & Replace(vatAmt,",","") & _
							", @AmtIncl=" & Replace(amtExcl,",","") & _
							", @InvRef=" & MakeSQLText(objRS.Fields.Item(7).Value) & _
							", @ClaimRef=" & MakeSQLText(objRS.Fields.Item(8).Value) 
							
							If IsRewardsNumeric = 1 Then
								SQL = SQL & _
								", @CampaignName=" & MakeSQLText(objRS.Fields.Item(9).Value) & _
								", @BasketNo=" & MakeSQLText(objRS.Fields.Item(10).Value)
							End If
							
							'Response.Write SQL 
							Set ReturnSet = ExecuteSql(SQL, dboConn) 
						
							if ReturnSet("returnvalue") <> "0" then
								errorFlag = true
								StatusVal = ReturnSet("StatusVal")
								ReturnVal = ReturnVal & "<br/>" & StatusVal & "<br/>"
							end if
						
							Set ReturnSet = Nothing
						
							Total = Total + amtExcl
						
							if amtIncl <> 0 and amtExcl <> 0 then
								TotalDoc = TotalDoc + 1
							end if
							
							
						'response.write SQL
						End If	
                    
				        objRS.MoveNext
                    Loop 
                    
                    Set objRS = Nothing
                    
                    ReturnVal = ReturnVal & "<br/>" & StatusVal & "<br/>"
                    
                    ' Update the header record
                    SQL = "exec editScheduleHeader @ScheduleID=" & scheduleID & _	
                        ", @Total=" & Total & _
                        ", @NumberOfDoc=" & TotalDoc & _
                        ", @Status=" & MakeSQLTExt(StatusVal)
                     
                    Set ReturnSet = ExecuteSql(SQL, dboConn)
                    
					If ReturnSet("returnvalue") <> 0 then
                        ReturnVal = ReturnVal & "<br/>" & ReturnSet("StatusVal") & "<br/>"
					end if

                    Set ReturnSet = Nothing
                end if
	        end if
	    end if
	    
	    ProcessExcel = ReturnVal
	end function
		
	function ProcessPipe (dboConn, SupplierID, UserID, DCID, FilePath, FileName, FileSize, IsForceCredit)
		' Author & Date: Chris Kennedy, 02 September 2008
		' Purpose: This function will read the delimited text file and upload into database
		
		'dim oFile, strRead, oTextStream, strSplit
		
		Const ForReading = 1 
        Const ForWriting = 2 
        Const ForAppending = 8 
        Const TristateUseDefault = -2 
        Const TristateTrue = -1 
        Const TristateFalse = 0 

		Dim oFS 
        Dim oFile 
        Dim oStream 
        dim sRecord
        dim i
        dim ReturnSet
        dim scheduleID
        dim ReturnVal
        dim errorFlag
        dim strSplit
        dim StatusVal
        dim Total
        dim TotalDoc

        errorFlag = false
        StatusVal = "Validated - No Errors"
        Total = 0
        TotalDoc = 0
        
        ' Validate the text file first
        if ValidateFile(FilePath, FileName, "|") <> 0 then
            ReturnVal = ReturnVal & "ERROR: The file you are tying to upload does not match the file type selected or the file content is not in the agreed format."
        else       
            SQL = "exec addScheduleHeader @FileName=" & MakeSQLText(FileName) &_
                ", @Size=" & FileSize & _
                ", @DCID=" & DCID &_
                ", @supplierID=" & SupplierID & _
				", @UserID=" & UserID & _
				", @IsForceCredit=" & IsForceCredit
                
                 'response.Write SQL & "<br/>"
        
            Set ReturnSet = ExecuteSql(SQL, dboConn) 
            
            if ReturnSet("returnvalue") <> "0" then
                ReturnVal = ReturnVal & "ERROR: The schedule already exist on the database for file: " & FileName
            else
                scheduleID = ReturnSet("newHeadID")
                
                Set ReturnSet = Nothing
                    
                Set oFS = Server.CreateObject("Scripting.FileSystemObject") 
                Set oFile = oFS.GetFile(FilePath & FileName) 
                Set oStream = oFile.OpenAsTextStream(ForReading, TristateUseDefault) 
                i = 0
	         sRecord=oStream.ReadLine 

                Do While Not oStream.AtEndOfStream 
                    i = i + 1
                    sRecord=oStream.ReadLine 


                    ' Split the file on the "|"
		            strSplit = split(sRecord,"|")
		            
		            
		     Dim DocDate
                     DocDate = strSplit(3)
If IsDate(DocDate) Then
					' If date is future dated, assign the current system date and time
                     If DateDiff("d", DocDate, Now) < 0 Then
						DocDate = Date
		End If
End If
        		    
	                SQL = "exec addScheduleDetail @HeaderID=" & scheduleID & _
	                    ", @StoreCode=" & MakeSQLText(strSplit(0)) &_
	                    ", @StoreName=" & MakeSQLText(strSplit(1)) &_
	                    ", @DocNumber=" & MakeSQLText(strSplit(2)) & _
	                    ", @DocDate=" & MakeSQLText(DocDate) & _
	                    ", @AmtExcl=" & strSplit(4) & _
	                    ", @Vat=" & strSplit(5) & _
	                    ", @AmtIncl=" & strSplit(6) & _
	                    ", @InvRef=" & MakeSQLText(strSplit(7)) & _
			    ", @ClaimRef=" & MakeSQLText(strSplit(8))
				        
	                    'response.Write SQL & "<br/>"
	                   ' response.End
    		    
                    Set ReturnSet = ExecuteSql(SQL, dboConn) 
                    
                    if ReturnSet("returnvalue") <> "0" then
                        errorFlag = true
                        StatusVal = ReturnSet("StatusVal")
                    end if
                    
                    Set ReturnSet = Nothing
                    
                    Total = Total + strSplit(6)
                    TotalDoc = TotalDoc + 1
                Loop 
                
                ReturnVal = ReturnVal & "<br/>" & StatusVal & "<br/>"

                oStream.Close 
                
                ' Update the header record
                SQL = "exec editScheduleHeader @ScheduleID=" & scheduleID & _	
                    ", @Total=" & Total & _
                    ", @NumberOfDoc=" & TotalDoc & _
                    ", @Status=" & MakeSQLTExt(StatusVal)
                    
                    'response.Write SQL & "<br/>"
                    'response.End
                Set ReturnSet = ExecuteSql(SQL, dboConn)
            end if
        end if
        
        ProcessPipe = ReturnVal
        
	end function
	
	function ProcessTab (dboConn, SupplierID, UserID, DCID, FilePath, FileName, FileSize, IsForceCredit)
		' Author & Date: Chris Kennedy, 02 September 2008
		' Purpose: This function will read the tab delimited text file and upload into database
		
		'dim oFile, strRead, oTextStream, strSplit
		
		Const ForReading = 1 
        Const ForWriting = 2 
        Const ForAppending = 8 
        Const TristateUseDefault = -2 
        Const TristateTrue = -1 
        Const TristateFalse = 0 

		Dim oFS 
        Dim oFile 
        Dim oStream 
        dim sRecord
        dim i
        dim ReturnSet
        dim scheduleID
        dim ReturnVal
        dim errorFlag
        dim strSplit
        dim StatusVal
        dim Total
        dim TotalDoc

        errorFlag = false
        StatusVal = "Validated - No Errors"
        Total = 0
        TotalDoc = 0
        
        ' Validate the text file first
        if ValidateFile(FilePath, FileName, chr(09)) <> 0 then
            ReturnVal = ReturnVal & "ERROR: The file you are tying to upload does not match the file type selected or the file content is not in the agreed format."
        else
            SQL = "exec addScheduleHeader @FileName=" & MakeSQLText(FileName) &_
                ", @Size=" & FileSize & _
                ", @DCID=" & DCID &_
                ", @supplierID=" & SupplierID & _
				", @UserID=" & UserID & _
				", @IsForceCredit=" & IsForceCredit
                
            'response.Write SQL & "<br/>"
        
            Set ReturnSet = ExecuteSql(SQL, dboConn) 
            
            if ReturnSet("returnvalue") <> "0" then
                ReturnVal = ReturnVal & "ERROR: The schedule already exist on the database for file: " & FileName
            else
                scheduleID = ReturnSet("newHeadID")
                
                Set ReturnSet = Nothing
                    
                Set oFS = Server.CreateObject("Scripting.FileSystemObject") 
                Set oFile = oFS.GetFile(FilePath & FileName) 
                Set oStream = oFile.OpenAsTextStream(ForReading, TristateUseDefault) 
                i = 0

                Do While Not oStream.AtEndOfStream 
                    i = i + 1
                    sRecord=oStream.ReadLine 
                  
                    if sRecord <> "" then
                        ' Split the file on the "chr(09)"
		                strSplit = split(sRecord,chr(09))
            		    
            			Dim DocDate
						DocDate = strSplit(3)
						If DateDiff("d", DocDate, Now) < 0 Then
							DocDate = Date
						End If
					 
	                    SQL = "exec addScheduleDetail @HeaderID=" & scheduleID & _
	                        ", @StoreCode=" & MakeSQLText(strSplit(0)) &_
	                        ", @StoreName=" & MakeSQLText(strSplit(1)) &_
	                        ", @DocNumber=" & MakeSQLText(strSplit(2)) & _
	                        ", @DocDate=" & MakeSQLText(DocDate) & _
	                        ", @AmtExcl=" & strSplit(4) & _
	                        ", @Vat=" & strSplit(5) & _
	                        ", @AmtIncl=" & strSplit(6) & _
							", @InvRef=" & strSplit(7) & _
							", @ClaimRef=" & strSplit(8)

        	                
	                        'response.Write SQL & "<br/>"
	                        'response.End
        		    
                        Set ReturnSet = ExecuteSql(SQL, dboConn) 
                        
                        if ReturnSet("returnvalue") <> "0" then
                            errorFlag = true
                            StatusVal = ReturnSet("StatusVal")
                        end if
                        
                        Set ReturnSet = Nothing
                        
                        Total = Total + strSplit(6)
                        TotalDoc = TotalDoc + 1
                    end if
                Loop 
                
                ReturnVal = ReturnVal & "<br/>" & StatusVal & "<br/>"

                oStream.Close 
                
                ' Update the header record
                SQL = "exec editScheduleHeader @ScheduleID=" & scheduleID & _	
                    ", @Total=" & Total & _
                    ", @NumberOfDoc=" & TotalDoc & _
                    ", @Status=" & MakeSQLTExt(StatusVal)
                    
                    'response.Write SQL & "<br/>"
                    'response.End
                Set ReturnSet = ExecuteSql(SQL, dboConn)
            end if
        end if
        
        ProcessTab = ReturnVal
        
	end function
	
	function ProcessCSV (dboConn, SupplierID, UserID, DCID, FilePath, FileName, FileSize, IsForceCredit)
		' Author & Date: Chris Kennedy, 02 September 2008
		' Purpose: This function will read the tab delimited text file and upload into database
		
		'dim oFile, strRead, oTextStream, strSplit
		
		Const ForReading = 1 
        Const ForWriting = 2 
        Const ForAppending = 8 
        Const TristateUseDefault = -2 
        Const TristateTrue = -1 
        Const TristateFalse = 0 

		Dim oFS 
        Dim oFile 
        Dim oStream 
        dim sRecord
        dim i
        dim ReturnSet
        dim scheduleID
        dim ReturnVal
        dim errorFlag
        dim strSplit
        dim StatusVal
        dim Total
        dim TotalDoc

        errorFlag = false
        StatusVal = "Validated - No Errors"
        Total = 0
        TotalDoc = 0
        
        ' Validate the text file first
        if ValidateFile(FilePath, FileName, ",") <> 0 then
            ReturnVal = ReturnVal & "ERROR: The file you are tying to upload does not match the file type selected or the file content is not in the agreed format."
        else
            SQL = "exec addScheduleHeader @FileName=" & MakeSQLText(FileName) &_
                ", @Size=" & FileSize & _
                ", @DCID=" & DCID &_
                ", @supplierID=" & SupplierID & _
                ", @UserID=" & UserID & _
				", @IsForceCredit=" & IsForceCredit
                
            'response.Write SQL & "<br/>"
        
            Set ReturnSet = ExecuteSql(SQL, dboConn) 
            
            if ReturnSet("returnvalue") <> "0" then
                ReturnVal = ReturnVal & "ERROR: The schedule already exist on the database for file: " & FileName
            else
                scheduleID = ReturnSet("newHeadID")
                
                Set ReturnSet = Nothing
                    
                Set oFS = Server.CreateObject("Scripting.FileSystemObject") 
                Set oFile = oFS.GetFile(FilePath & FileName) 
                Set oStream = oFile.OpenAsTextStream(ForReading, TristateUseDefault) 
                i = 0
                sRecord=oStream.ReadLine 

                Do While Not oStream.AtEndOfStream 
                    i = i + 1
                    sRecord=oStream.ReadLine 
                  
                    ' Split the file on the ","
		            strSplit = split(sRecord,",")
            		    
            		 if UBound(strSplit) = 8 then   
						Dim DocDate
						DocDate = strSplit(3)
						If IsDate(DocDate) Then
							' If date is future dated then, assign system current date
							If DateDiff("d", DocDate, Now) < 0 Then
								DocDate = Date
							End If
						End If

	                    SQL = "exec addScheduleDetail @HeaderID=" & scheduleID & _
	                        ", @StoreCode=" & MakeSQLText(strSplit(0)) &_
	                        ", @StoreName=" & MakeSQLText(strSplit(1)) &_
	                        ", @DocNumber=" & MakeSQLText(strSplit(2)) & _
	                        ", @DocDate=" & MakeSQLText(DocDate) & _
	                        ", @AmtExcl=" & strSplit(4) & _
	                        ", @Vat=" & strSplit(5) & _
	                        ", @AmtIncl=" & strSplit(6) & _
	                        ", @InvRef=" & MakeSQLText(Replace(strSplit(7),"'","")) & _
							", @ClaimRef=" & MakeSQLText(Replace(strSplit(8),"'",""))

        	                
	                        'response.Write SQL & "<br/>"
	                        'response.End
        		    
                        Set ReturnSet = ExecuteSql(SQL, dboConn) 
                        
                        if ReturnSet("returnvalue") <> "0" then
                            errorFlag = true
                            StatusVal = ReturnSet("StatusVal")
                        end if
                        
                        Set ReturnSet = Nothing
                        
                        Total = Total + strSplit(6)
                        TotalDoc = TotalDoc + 1
                    end if
                Loop 
                
                ReturnVal = ReturnVal & "<br/>" & StatusVal & "<br/>"

                oStream.Close 
                
                ' Update the header record
                SQL = "exec editScheduleHeader @ScheduleID=" & scheduleID & _	
                    ", @Total=" & Total & _
                    ", @NumberOfDoc=" & TotalDoc & _
                    ", @Status=" & MakeSQLTExt(StatusVal)
                    
                    'response.Write SQL & "<br/>"
                    'response.End
                Set ReturnSet = ExecuteSql(SQL, dboConn)
            end if
        end if
   
        ProcessCSV = ReturnVal
        
	end function
	
	function ValidateFile (FilePath, FileName, CharToLookFor)
	    
	    Const ForReading = 1 
        Const ForWriting = 2 
        Const ForAppending = 8 
        Const TristateUseDefault = -2 
        Const TristateTrue = -1 
        Const TristateFalse = 0 

		Dim oFS 
        Dim oTextStream 
        Dim sFileContents
        Dim returnVal
        Dim strArray
        
        returnVal = 0
        
	    Set oFS = Server.CreateObject("Scripting.FileSystemObject") 
        Set oTextStream = oFS.OpenTextFile(FilePath & FileName,1) 
        sFileContents = oTextStream.ReadLine
        oTextStream.Close 
        Set oTextStream = nothing 
        
        strArray = split(sFileContents,CharToLookFor)
        
        'response.write "<br/>" & sFileContents
        'response.write "<br/>" & CharToLookFor
        'response.write "<br/>" & UBound(strArray)
        
        if UBound(strArray) = 0 then
            returnVal = 1
        else
            ' Check if the correct amount of columns are uploaded
            if UBound(strArray) <> 8 then
                returnVal = 2
            end if
        end if

		'response.write "<br/>" & returnVal

        ValidateFile = returnVal
        
	end function
	
	function ProcessReleaseMessage(dboConn, HeaderID, OutPath)
	
	    Dim ReturnSet, InvVal, CredVal, interchangeNo, cntinv, cntcred, filename, VatPerc, StoreName, ForceCredit
		
		
	    ReturnVal = ""
	    cntinv = 0
	    cntcred = 0
	    VatPerc = 0
	    interchangeNo = Year(now()) & month(now()) & day(now()) & hour(now()) & minute(now()) & second(now())
	    StoreName = ""
		ForceCredit = "N"
	
		Dim SqlCommand 
		SqlCommand = "itemSchedule @ScheduleID=" & HeaderID & ", @Release=1"
		
	    Set ReturnSet = ExecuteSql(SqlCommand, dboConn) 
		
	    If ReturnSet("ReturnValue") <> "0" Then
	        ReturnVal = "ERROR: An error occured while trying to extract this schedule's detail from the database. Please try again."
	    Else
			ReturnSet.MoveFirst
	        While NOT (ReturnSet.EOF)
                ' Check if this is a inv or cred
                If CDbl(ReturnSet("AmtIncl")) > 0 Then
                    cntinv = cntinv + 1
                    
				    StoreName = ReturnSet("StoreName")
                    StoreName = Replace(StoreName,"'","?'")
                    StoreName = Replace(StoreName,":","?:")
                    StoreName = Replace(StoreName,"+","?+")


                    ' check if this is the first invoice record
                    if cntinv = 1 then
                        InvVal = InvVal & "UNB+UNOA:2+" & ReturnSet("SupplierEAN") & "+" & ReturnSet("DCEAN") & "+" & FormatEDIDate(now()) & ":" & LZ(hour(now())) & LZ(minute(now())) & "+" & interchangeNo & "++TAXINV'" & vbcrlf
                    end if
					
					
				    if ReturnSet("VatAmt") <> "0" then
						VatPerc = 14
				    end if
                
                    ' This is an invoice - create the SAANA invoice
                    InvVal = InvVal & "UNH+" & interchangeNo & "+TAXINV:6:0:S'" & vbcrlf
                    InvVal = InvVal & "SAP+" & ReturnSet("SupplierEAN") & "+" & ReturnSet("SupplierVatNumber") & "'" & vbcrlf
                    InvVal = InvVal & "SDP+" & ReturnSet("DespatchPoint") & "'" & vbcrlf
                    InvVal = InvVal & "CLO+" & Trim(ReturnSet("StoreEAN")) & "+" & ReturnSet("DCEAN") & "+" & StoreName & "'" & vbcrlf
                    InvVal = InvVal & "IRE+" & ReturnSet("DocNumber") & ":" & FormatEDIDate(ReturnSet("DocDate")) & "'" & vbcrlf
                    InvVal = InvVal & "NAR+1+E-SCHEDULE'" & vbcrlf
                    InvVal = InvVal & "ODD+1+N/A::++:" & FormatEDIDate(ReturnSet("DocDate")) & "'" & vbcrlf
                    InvVal = InvVal & "ILD+1++:::Purchases+1:1+" & ReturnSet("AmtExcl") & ":1++" & ReturnSet("AmtExcl") & "++" & VatPerc & "+S+" & ReturnSet("AmtExcl") & "'" & vbcrlf
                    InvVal = InvVal & "VRS+1+" & VatPerc & "+S+1+" & ReturnSet("AmtExcl") & "+" & ReturnSet("VatAmt") & "'" & vbcrlf
                    InvVal = InvVal & "IPD+" & ReturnSet("AmtExcl") & "+" & ReturnSet("VatAmt") & "+" & ReturnSet("AmtIncl") & "'" & vbcrlf
                    InvVal = InvVal & "UNT+11+" & interchangeNo & "'" & vbcrlf
                    
                    ' Check if this is the last invoice record
                    if cntinv = ReturnSet("InvTotal") then      
						'response.write "cntinv = " & cntinv & "<br>"
                        InvVal = InvVal & "UNZ+" & cntinv & "+" & interchangeNo & "'" & vbcrlf
                    end if
                Else
                    ' This is a credit note
                    cntcred = cntcred + 1
					
					If ReturnSet("IsForceCredit") Then
						ForceCredit = "Y"
					ElseIf ReturnSet("IsReward") then
						ForceCredit = "R"
					Else
						ForceCredit = "N"
					End If
						
                    
				    StoreName = ReturnSet("StoreName")
                    StoreName = Replace(StoreName,"'","?'")
                    StoreName = Replace(StoreName,":","?:")
                    StoreName = Replace(StoreName,"+","?+")

                    ' check if this is the first invoice record
                    if cntcred = 1 then
                        CredVal = CredVal & "UNB+UNOA:2+" & ReturnSet("SupplierEAN") & "+" & ReturnSet("DCEAN") & "+" & FormatEDIDate(now()) & ":" & LZ(hour(now())) & LZ(minute(now())) & "+" & interchangeNo & "++CREDIT'" & vbcrlf
                    end if
                
					Dim ProductLine
					If ReturnSet ("IsReward") then
						ProductLine = ReturnSet("CampaignName")
					Else
						ProductLine = "Credit Purchases"
					End If
				
                    ' This is an invoice - create the SAANA invoice
                    CredVal = CredVal & "UNH+" & interchangeNo & "+CREDIT:5:0:S'" & vbcrlf
                    CredVal = CredVal & "SAP+" & ReturnSet("SupplierEAN") & "+" & ReturnSet("SupplierVatNumber") & "'" & vbcrlf
                    CredVal = CredVal & "SDP+" & ReturnSet("DespatchPoint") & "'" & vbcrlf
                    CredVal = CredVal & "CLO+" & Trim(ReturnSet("StoreEAN")) & "+" & ReturnSet("DCEAN") & "+" & StoreName & "'" & vbcrlf
                    CredVal = CredVal & "REF+" & ReturnSet("DocNumber") & ":" & FormatEDIDate(ReturnSet("DocDate")) & "+" & ForceCredit & "'" & vbcrlf
                    CredVal = CredVal & "DCF+1+RFC:" & FormatEDIDate(ReturnSet("DocDate")) & "::" & ReturnSet("StoreCode") & " /" & ReturnSet("ClaimRef") & ":000000::" & ReturnSet("InvRef") & ":000000:'" & VbCrLf
                    CredVal = CredVal & "LDS+1++" & ReturnSet("AmtIncl") & "+14+s++++00000000000000:::"&ProductLine&"+0+" & ReturnSet("AmtExcl") & "'" & vbcrlf
                    CredVal = CredVal & "DOT+" & ReturnSet("AmtExcl") & "+" & ReturnSet("VatAmt") & "+" & ReturnSet("AmtIncl") & "'" & vbcrlf
                    CredVal = CredVal & "VRT+1+0+S+" & ReturnSet("AmtExcl") & "+" & ReturnSet("VatAmt") & "+" & ReturnSet("AmtIncl") & "'" & vbcrlf
                    CredVal = CredVal & "MSY+" & ReturnSet("AmtExcl") & "+" & ReturnSet("VatAmt") & "+" & ReturnSet("AmtIncl") & "'" & vbcrlf
                    CredVal = CredVal & "UNT+11+" & interchangeNo & "'" & vbcrlf
                    
                    ' Check if this is the last invoice record
                    if cntcred = ReturnSet("CredTotal") then                    
                        CredVal = CredVal & "UNZ+" & cntcred & "+" & interchangeNo & "'" & vbcrlf
                    end if
                end if
				
	            ReturnSet.MoveNext
	        Wend
	    end if

	    Set ReturnSet = Nothing

		

	    ' Write the InvVal and CredVal to output files
	    if InvVal <> "" then
	        filename = "INV" & interchangeNo & ".edi"
	        ReturnVal = WriteFile(const_app_schedDelayDir & filename, InvVal)
	    end if
	    
	    if CredVal <> "" then
	        filename = "CRED" & interchangeNo & ".edi"
	        ReturnVal = WriteFile(const_app_schedDelayDir & filename, CredVal)
	    end if



	   	' Update the status of this message to released
	   	Set ReturnSet = ExecuteSql("editScheduleStatus @ScheduleID=" & HeaderID & ", @StatusID=5", curConnection)    
	   	Set Returnset = Nothing
	   	
	   	dim oFile
	   	
	   	'response.write const_app_schedDelayDir & "*.edi"
	   	'response.end
	   	
	   	Set oFile = Server.CreateObject("Scripting.FileSystemObject")
	   	'Response.Write OutPath
		
		
	   	if InvVal <> "" then
	   		' Move the INV file to the outPath
			'Response.Write const_app_schedDelayDir
			
			
	   		oFile.MoveFile const_app_schedDelayDir & "INV" & interchangeNo & ".edi" ,OutPath & "INV" & interchangeNo & ".edi"
			
			
	   	end if
		
		
			   	
	   	if CredVal <> "" then
	   		' Move the CRED file to the outPath
			
	   		oFile.MoveFile const_app_schedDelayDir & "CRED" & interchangeNo & ".edi" ,OutPath & "CRED" & interchangeNo & ".edi"
	   	end if
	   	
	   	Set oFile = Nothing
	   	
	    ProcessReleaseMessage = ReturnVal
	
	end function
	
	function FormatEDIDate (DateToFormat)
	
	    dim strYear, strMonth, strDay, strSplit
	    
	    strYear = Year(DateToFormat)
	    strMonth = Month(DateToFormat)
	    strDay = Day(DateToFormat)
	    
	    if len(strYear) = 4 then
	        strYear = mid(strYear,3,2)
	    end if
	    
	    FormatEDIDate = strYear & LZ(strMonth) & LZ(strDay)
	
	end function
	
	function LZ(NumberToFormat)
		'Converts a single char int into a double digit with leading zero

		If len(NumberToFormat) < 2 Then
			NumberToFormat = "0" & NumberToFormat
		End if
		LZ = NumberToFormat
	End Function
	
	function WriteFile(sFilePathAndName,sFileContents)   

        on error resume next

        Const ForWriting =2 
        Dim oFS, oFSFile, msg

        msg = "success"

        Set oFS = Server.CreateObject("Scripting.FileSystemObject") 
        Set oFSFile = oFS.OpenTextFile(sFilePathAndName,ForWriting,True) 

        oFSFile.Write(sFileContents) 
        oFSFile.Close 

        Set oFSFile = Nothing 
        Set oFS = Nothing 

        if err <> 0 then
            msg = "ERROR: An error occured while trying to create the output file: " & sFilePathAndName
        end if
        
        WriteFile = msg

    End function 

    function GenCSVSavedFile (dboConn, HeaderID, OutPath)
        ' This function will generate a comma delimited CSV file to be downloaded by the user
        
        Const ForReading = 1 
        Const ForWriting = 2 
        Const ForAppending = 8 
        Const TristateUseDefault = -2 
        Const TristateTrue = -1 
        Const TristateFalse = 0 

		Dim oFS 
        Dim oTextStream 
        Dim sFileContents
        dim ReturnSet, ReturnVal
        
        ReturnVal = ""
        
        Set ReturnSet = ExecuteSql("itemSchedule @ScheduleID=" & HeaderID, dboConn)  
        
        if ReturnSet("returnvalue") <> "0" then
            ReturnVal = "ERROR: The selected schedule does not exist."
        else
                        
        end if
    
    end function

%>
