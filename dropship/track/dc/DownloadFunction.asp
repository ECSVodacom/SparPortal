<%


    Function DoDownload(FileNameOnly, FileNameAndPath)    
		Dim objShell
		Dim sMIME
		Dim objStream
		
		Set FSO = Server.CreateObject("Scripting.FileSystemObject")
        If FSO.FileExists(FileNameAndPath) Then
            Dim FileExtension
            FileExtension = FSO.GetExtensionName(FileNameOnly)

            
		    ' Now we have the extension, the file's MIME type is held in the registry at
		    ' HKEY_CLASSES_ROOT\.<ext>\Content Type
		    ' Create an instance of Wscript.Shell to let us read the registry
		    Set objShell = Server.CreateObject("Wscript.Shell")
		    On Error Resume Next
		    ' Get the MIME type
		    sMIME = objShell.RegRead("HKEY_CLASSES_ROOT\." & sExt & "\Content Type")

		    On Error GoTo 0
		    If Len(sMIME) = 0 Then
			    ' If there is no registered type then return octetstream.  This will prompt
			    ' the user with the "Open or Save to disk" dialogue.
			    sMIME = "application/octetstream"
		    End If
		    Set objShell = Nothing


            Response.AddHeader "content-disposition","attachment; filename=" & FileNameOnly

		    ' Tell the browse the content type
		    ' Now we need to pipe the file to the browser, to do this we
		    ' will use the ADODB.Stream
		    Set objStream = Server.CreateObject("ADODB.Stream")
		    objStream.Open
		    ' Set the type as Binary
		    objStream.Type = 1
		    ' Load our file
			
		    objStream.LoadFromFile FileNameAndPath
		    ' And send it to the browser
		    Response.BinaryWrite objStream.Read
            
		    objStream.Close
		    Set objStream = Nothing	
        Else
            %>
            <!--#include file="../../layout/start.asp"-->
            <!--#include file="../../layout/title.asp"-->
            <!--#include file="../../layout/headstart.asp"-->
            <!--#include file="../../layout/globaljavascript.asp"-->
            <!--#include file="../../layout/headclose.asp"-->
            <!--#include file="../../layout/bodystart.asp"-->
            <p class="pheader">File Download</p>
            <p class="errortext">The file does not exist on our server. Please contact the Systems Administrator.</p>
            <!--#include file="../../layout/end.asp"-->        
            <%
        End If
    End Function
	
    Function TwoDecimals(value)
        Dim Rands
        Dim Cents
        Dim Sp
        Dim Temp

        Sp = Split(value, ".")

        If UBound(Sp) > 0 Then
          Rands = Sp(0)
          Cents = Sp(1)
		
	    If Len(Cents) = 1 Then
             Cents = Cents & "0"
	    End If
		

	    Temp =  Rands & "." & Cents
	  Else
	    Temp = Value & ".00"	
	  End If

	  TwoDecimals = Temp 
    End Function
%>