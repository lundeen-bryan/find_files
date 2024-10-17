#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\blundeen\AppData\Local\Apps\repos\find_files\Searchpt.kxf
$Form1 = GUICreate("Search For a Report", 555, 394, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
$search_group = GUICtrlCreateGroup("", 6, 6, 537, 81, BitOR($GUI_SS_DEFAULT_GROUP,$BS_FLAT,$WS_CLIPSIBLINGS))
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKHEIGHT)
$search_input = GUICtrlCreateInput("Type Patient's Name Here", 12, 22, 521, 27)
GUICtrlSetFont(-1, 12, 400, 0, "Consolas")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
$search_btn = GUICtrlCreateButton("Search", 16, 56, 75, 25)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$List1 = GUICtrlCreateList("", 8, 96, 537, 289, BitOR($LBS_NOTIFY,$LBS_SORT,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetFont(-1, 12, 400, 0, "Consolas")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
