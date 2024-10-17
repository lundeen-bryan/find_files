#include "search_reports_ui.au3"
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $search_input
	EndSwitch
WEnd
