#include <File.au3>
#include <Debug.au3>
#include <Array.au3>

Opt("MustDeclareVars", 1)

_DebugSetup("", False, 2) ; Set up debugging to log to the console

Global $file_array[0] ; Declare a global array to store the file paths

Func SearchFilesByPattern($directory, $search_lastname, $search_firstname)
    ; Initialize the global array
    Global $file_array[0] ; Ensuring the array always exists

    ; Log the search parameters
    _DebugOut("Starting search: Directory = " & $directory & ", Lastname = " & $search_lastname & ", Firstname = " & $search_firstname)

    ; Ensure the search terms are lowercase to make the search case-insensitive
    $search_lastname = StringLower($search_lastname)
    $search_firstname = StringLower($search_firstname)

    ; Combine Lastname and Firstname into "Lastname, Firstname" format
    Local $search_pattern = $search_lastname & ", " & $search_firstname
    _DebugOut("Search pattern generated: " & $search_pattern)

    ; Open a search handle to find files in the directory
    Local $search_handle = FileFindFirstFile($directory & "\*")
    If $search_handle = -1 Then
        _DebugOut("No files found in directory: " & $directory)
        Return
    EndIf

    ; Loop through all files in the directory
    While 1
        Local $file = FileFindNextFile($search_handle)
        If @error Then ExitLoop

        ; Convert the file name to lowercase to compare it in a case-insensitive way
        Local $lower_file = StringLower($file)
        _DebugOut("Checking file: " & $lower_file)

        ; Check if the file starts with "Lastname, Firstname"
        If StringLeft($lower_file, StringLen($search_pattern)) = $search_pattern Then
            _DebugOut("Match found: " & $file)

            ; Resize the global array and store the file path
            ReDim $file_array[UBound($file_array) + 1]
            $file_array[UBound($file_array) - 1] = $directory & "\" & $file
        EndIf
    WEnd

    ; Close the search handle
    FileClose($search_handle)

    ; Ensure the array is still valid after the search
    If UBound($file_array) = 0 Then
        _DebugOut("No matching files were found.")
        MsgBox(64, "No Files Found", "No matching files were found.")
    Else
        _DebugOut("Files found: " & UBound($file_array))
    EndIf

    ; Update the ListView with the found files
    GUICtrlSetData($List1, "") ; Clear previous data
    For $i = 0 To UBound($file_array) - 1
        GUICtrlSetData($List1, $file_array[$i] & "|") ; Display the file paths in the ListView
    Next
EndFunc
