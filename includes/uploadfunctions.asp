<%
Function BuildUpload(RequestBin)
		dim PosBeg
		dim PosEnd
		dim boundary
		dim boundaryPos
		dim UploadControl 
		dim Pos
		dim PosFile
		dim Name
		dim PosBound
		dim ContentType
		dim Value

     'Get the boundary
     PosBeg = 1
     PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(13)))
     boundary = MidB(RequestBin,PosBeg,PosEnd-PosBeg)
     boundaryPos = InstrB(1,RequestBin,boundary)
     'Get all data inside the boundaries
     Do until (boundaryPos=InstrB(RequestBin,boundary & getByteString("--")))
          'Members variable of objects are put in a dictionary object
        
          Set UploadControl = CreateObject("Scripting.Dictionary")
          'Get an object name
          Pos = InstrB(BoundaryPos,RequestBin,getByteString("Content-Disposition"))
          Pos = InstrB(Pos,RequestBin,getByteString("name="))
          PosBeg = Pos+6
          PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(34)))
          Name = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
          PosFile = InstrB(BoundaryPos,RequestBin,getByteString("filename="))
          PosBound = InstrB(PosEnd,RequestBin,boundary)
          'Test if object is of file type
          If PosFile<>0 AND (PosFile<PosBound) Then
               'Get Filename, content-type and content of file
               PosBeg = PosFile + 10
               PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(34)))
               FileName = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
               'Add filename to dictionary object
               UploadControl.Add "FileName", FileName
               Pos = InstrB(PosEnd,RequestBin,getByteString("Content-Type:"))
               PosBeg = Pos+14
               PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(13)))
               'Add content-type to dictionary object
               ContentType = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
               UploadControl.Add "ContentType",ContentType
               'Get content of object
               PosBeg = PosEnd+4
               PosEnd = InstrB(PosBeg,RequestBin,boundary)-2
               Value = MidB(RequestBin,PosBeg,PosEnd-PosBeg)
            Else
               'Get content of object
               Pos = InstrB(Pos,RequestBin,getByteString(chr(13)))
               PosBeg = Pos+4
               PosEnd = InstrB(PosBeg,RequestBin,boundary)-2
               Value = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
          End If
          UploadControl.Add "Value" , Value     
          UploadRequest.Add name, UploadControl     
          BoundaryPos=InstrB(BoundaryPos+LenB(boundary),RequestBin,boundary)
     Loop
End Function

Function getByteString(StringStr)
		dim char
     For i = 1 to Len(StringStr)
          char = Mid(StringStr,i,1)
          getByteString = getByteString & chrB(AscB(char))
     Next
End Function

Function getString(StringBin)
		dim intCount

     getString =""
     For intCount = 1 to LenB(StringBin)
          getString = getString & chr(AscB(MidB(StringBin,intCount,1))) 
     Next
End Function
%>