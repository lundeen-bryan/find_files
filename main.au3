#Region ;~ Include section
    #include <ButtonConstants.au3>       ; For button-related constants
    #include <EditConstants.au3>         ; For edit (input) field constants
    #include <GUIConstantsEx.au3>        ; For GUI control-related constants (e.g., GUIGetMsg constants)
    #include <GUIListBox.au3>            ; For ListBox control constants
    #include <StaticConstants.au3>       ; For static text controls
    #include <WindowsConstants.au3>      ; For window-related constants
    #include <MsgBoxConstants.au3>       ; (Optional) For MsgBox constants if using message boxes
    #include <Debug.au3>
    #include <GuiListView.au3>
    #include "search_reports_ui.au3"
    #include "search.au3" ; Assuming the SearchFilesByPattern function is in this module
#EndRegion

#Region ;~ Opt Settings
    Opt("GUIResizeMode", $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)  ; Set resize mode only once
    Opt("GUICloseOnESC", 1)        ; Allow closing the window by pressing ESC
    Opt("TrayAutoPause", 0)        ; Disable script pausing when clicking the tray icon
    Opt("WinTitleMatchMode", 2)    ; Allow partial matches in window titles (if working with windows)
    Opt("MouseCoordMode", 2)       ; Use client-relative mouse coordinates (if working with mouse events)
#EndRegion

;~ _DebugSetup("", False, 2)

Dim $nMsg ; Declare $nMsg using Dim, it will be initialized later

; Main loop
While 1
    $nMsg = GUIGetMsg() ; Assign value inside the loop
    Switch $nMsg
        ; Handle closing the window
        Case $GUI_EVENT_CLOSE
            Exit

        ; Handle the search button click
        Case $search_btn
            CallSearchFunction()

        ; Handle the location button click (for selecting directory)
        Case $path_btn
            CallLocationFunction()

        Case $copy_btn
                CallCopyFunction()

        Case $clear_btn
            ClearForm()

    EndSwitch
WEnd

; Function to handle location button click
Func CallLocationFunction()
    ; Open a folder selection dialog
    Local $selected_path = FileSelectFolder("Select folder to search", "", 1)

    ; If the user selected a path, update the path input field
    If $selected_path <> "" Then
        GUICtrlSetData($path_input, $selected_path)
    EndIf
EndFunc

; Function to handle search button click
Func CallSearchFunction()
    Local $lastname = StringStripWS(GUICtrlRead($lastname_input), 3) ; Strip leading and trailing whitespace
    Local $firstname = StringStripWS(GUICtrlRead($firstname_input), 3)
    Local $directory = GUICtrlRead($path_input)

    ; Log the inputs received from the user
    _DebugOut("User Input - Lastname: " & $lastname & ", Firstname: " & $firstname & ", Directory: " & $directory)

    If StringLen($lastname) = 0 Or StringLen($firstname) = 0 Or StringLen($directory) = 0 Then
        _DebugOut("Error: One or more input fields are empty.")
        MsgBox(16, "Error", "Please fill out all fields before searching.")
        Return
    EndIf

    ; Call the search function and get the array of results
    Local $file_array = SearchFilesByPattern($directory, $lastname, $firstname)

    ; Check if the result is an array
    If IsArray($file_array) Then
        _DebugOut("SearchFilesByPattern returned an array with " & UBound($file_array) & " elements.")
    Else
        _DebugOut("SearchFilesByPattern did not return an array.")
        ;~ MsgBox(16, "Error", "The search function did not return an array.")
        Return
    EndIf

    ; Clear the ListBox before loading new results
    GUICtrlSetData($List1, "")

    ; Check if any files were found
    If UBound($file_array) > 0 Then
        ; Populate the ListBox with the search results
        For $i = 0 To UBound($file_array) - 1
            _DebugOut("Adding to ListBox: " & $file_array[$i])
            GUICtrlSetData($List1, $file_array[$i] & "|")
        Next
    Else
        _DebugOut("No matching files were found.")
        MsgBox(64, "No Files Found", "No matching files were found.")
    EndIf
EndFunc

Func CallCopyFunction()
    ; Open a folder selection dialog
    Local $dest_folder = FileSelectFolder("Select a folder to copy files to", "", 1)

    ; Check if the user selected a folder
    If $dest_folder = "" Then
        MsgBox(16, "Error", "No destination folder selected.")
        Return
    EndIf

    ; Ensure there are files to copy
    If UBound($file_array) = 0 Then
        MsgBox(16, "Error", "No files to copy.")
        Return
    EndIf

    ; Loop through the files in the global array and copy them to the selected folder
    For $i = 0 To UBound($file_array) - 1
        Local $file_path = $file_array[$i]

        ; Extract the filename from the full file path
        Local $file_name = StringTrimLeft($file_path, StringInStr($file_path, "\", 0, -1))

        ; Define the destination path (selected folder + file name)
        Local $dest_file_path = $dest_folder & "\" & $file_name

        ; Copy the file to the selected folder
        Local $copy_result = FileCopy($file_path, $dest_file_path, 8) ; Use flag 8 to overwrite files if necessary

        ; Check if the copy was successful
        If $copy_result = 0 Then
            MsgBox(16, "Error", "Failed to copy file: " & $file_path)
            Return
        EndIf
    Next

    ; Notify the user that the files were copied successfully
    MsgBox(64, "Success", "Files copied successfully to " & $dest_folder)
EndFunc

Func ClearForm()
    ; Clear the ListBox
    GUICtrlSetData($List1, "")

    ; Clear the Last Name textbox
    GUICtrlSetData($lastname_input, "")

    ; Clear the First Name textbox
    GUICtrlSetData($firstname_input, "")
EndFunc
