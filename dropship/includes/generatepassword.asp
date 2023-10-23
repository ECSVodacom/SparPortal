
<%

	Function GeneratePassword()
		Const PasswordLength = 8
		Dim ChooseTypeId 
		Dim NewPassword  
		Dim LowerCase 
		Dim UpperCase
		Dim Numeric
		Dim Special
		Const SPECIAL_CHARACTERS = "!#*@"
		Dim i, RemainingCharacters, CharacterSetIndex
		
		For i = 1 To PasswordLength
			Randomize
			
			ChooseTypeId = Int((4 * Rnd) + 1)
			
			RemainingCharacters = PasswordLength - i
			
			If RemainingCharacters = 4 And Not LowerCase Then
				ChooseTypeId = 1
			End If
			
			If RemainingCharacters = 4 And Not UpperCase Then
				ChooseTypeId = 2
			End If


			If RemainingCharacters = 4 And Not Numeric Then
				ChooseTypeId = 3
			End If


			If RemainingCharacters = 1 And Not Special Then
				ChooseTypeId = 4
			End If



			Select Case ChooseTypeId
				Case 1 'a-z
					LowerCase = True
					NewPassword = NewPassword & CHR(Int((25 * Rnd) + 97))
				Case 2 ' A-Z
					UpperCase = True
					NewPassword = NewPassword & CHR(Int((25 * Rnd) + 65))
				Case 3 ' 0-9
					Numeric = True
					NewPassword = NewPassword & CHR(Int((9 * Rnd) + 48))
				Case 4 ' Special
					Special = True
					CharacterSetIndex = Int(4*Rnd+1)

					NewPassword = NewPassword &  Mid(SPECIAL_CHARACTERS,CharacterSetIndex,1)
			End Select
		Next 
	
		GeneratePassword = NewPassword
	End Function
	
	Function ValidatePassword(password)
		Set RegEx = New RegExp 
        RegEx.IgnoreCase = True
        RegEx.Pattern = "(?=^.{8,}$)(?=.*\d)(?=.*[!@#$%^&*]+)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$" 
        ValidatePassword = RegEx.Test(password)
	End Function
	
	
%>

