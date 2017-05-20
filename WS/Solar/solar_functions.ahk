global group_list := "SysListView321"
global plan_list := "SysListView322"
global doc_list := "SysListView321"
global solar_id
global group_crit_id

winGet, solar_id, ID, Data Capture Implementation

groupLookup(groupID)
{
	tryGroup:
	controlSend, ahk_parent, ^g, ahk_id %solar_id%
	winWait, Group Criteria, , 1
	if(errorLevel) ;if the group criteria window hasn't shown up after 1 second, try again
		goTo tryGroup
	winGet, group_crit_id, ID, Group Criteria ;get the new window's ID
	checkButton(group_crit_id, "Button1")
	controlSetText, Edit1, %groupID%, ahk_id %group_crit_id%
	controlClick, Button26, ahk_id %group_crit_id% ;click OK button
}

archiveSearch(caseID)
{
	trySearchArchive:
	winMenuSelectItem, ahk_id %solar_id%, , Solar, Search Output Archive...
	waitArchiveWin:
	winWait Solar Data Capture, Your default printer, 2 ;get rid of this annoying message
	ifWinExist, Solar Data Capture, Your default printer
		winClose, Solar Data Capture, Your default printer
	winWait, Solar Output Archive
	winGet, arc_search_id, ID, Solar Output Archive ;get the new window's ID
	searchFailCount := 0
	tryGetList:
	checkButton(arc_search_id, "Button8")
	controlSetText, Edit4, %caseID%, ahk_id %arc_search_id%
	sleep 100
	;checkButton(arc_search_id, "Button9")
	controlClick, Button14, ahk_id %arc_search_id%
	sleep 1000
	listLength := 0
	controlGet, docList, List, , %doc_list%, ahk_id %arc_search_id%
	listDeselectAll(arc_search_id, doc_list)
	closeWordWindows()
	Loop, Parse, docList, `n  ; Rows are delimited by linefeeds (`n).
	{
		listLength := listLength + 1
		stringSplit, planAttributes, A_LoopField, %A_Tab%
		docName := regExReplace(planAttributes1, "^[0-9]*\/", "")
		docName := regExReplace(docName, "/", "-") . " (" . regExReplace(planAttributes4, "/", "-") . ")"
		ifNotExist %outputDir%\%caseID%\%docName%.doc	;if there wasn't already a more recent copy of the document saved		
			if(planAttributes4 = EffDate)				;if the effective date matches the one specified by the user
			{
				tryView:
				listDeselectAll(arc_search_id, doc_list)
				listSelect(arc_search_id, doc_list, A_Index-1)
				controlClick, Button15, ahk_id %arc_search_id% ;click View
				winWait, ahk_class OpusApp, ,4 	;wait for MSWord to open up
				if(errorLevel)
					goTo tryView ;try clicking View again if it's not open after a few seconds
				saveWordDoc(outputDir . "\" . caseID, docName) ;save the word document
			}
	}
	if(listLength < 1) ;if nothing was returned in the search results, try again a few times just to make sure
	{
		ifWinExist, No Data
		{
			winKill, No Data
			searchFailCount := searchFailCount + 1
		}
		if(searchFailCount < 3)
			goTo tryGetList
	}
	winClose, ahk_id %arc_search_id%
}

;select an item in a 0-index based listview, where index of -1 is all items
listSelect(win_id, classNN, index){	
	listModify(win_id, classNN, index, 0x00000002)
}
;deselect all items in a listview
listDeselectAll(win_id, classNN){
	listModify(win_id, classNN,	-1,	0x00000001)
}

listModify(win_id, classNN, index, state) ;had to do come crazy stuff with virtual memory, don't mess with this unless you ABSOLUTELY know what you're doing
{
	RemoteBuf_Open(LVITEM_buf, win_id, 4*13) ;create LVITEM in Solar's virtual memory
	VarSetCapacity(LVITEM, 4*13, 0) ;Do *15 if you're on Vista or Win 7 (see MSDN)
	NumPut(0x00000008, LVITEM, 4*0) ;mask = LVIF_STATE
	NumPut(state, LVITEM, 4*3) ;state = <second LSB must be 1>
	NumPut(0x0002,     LVITEM, 4*4) ;stateMask = LVIS_SELECTED
	RemoteBuf_Write(LVITEM_buf, LVITEM, 4*13) ;write the LVITEM into solar's VM
	lv_addr := RemoteBuf_Get(LVITEM_buf) ;get address of LVITEM object
	sendMessage, 0x1000+43, %index%, %lv_addr%, %classNN%, ahk_id %win_id% ;send LVM_SETITEMSTATE (0x1000+43) message to the window to set the list select item(s)
	RemoteBuf_Close(LVITEM_buf) ;close remote buffer
	VarSetCapacity(LVITEM, 0) ;free up memory used by LVITEM
}

listSelectByAttribute(win_id, classNN, col, val)
{
	listDeselectAll(win_id, classNN)
	controlGet, theList, List, , %classNN%, ahk_id %win_id%
	Loop, Parse, theList, `n  ; Rows are delimited by linefeeds (`n).
	{
		RowNumber := A_Index
		stringSplit, planAttributes, A_LoopField, %A_Tab%
		if(planAttributes%col% = val)
			listSelect(win_id, classNN, RowNumber-1)
	}
}

checkButton(win_id, btnClass)
{
	controlGet, btnChecked, Checked, ,%btnClass%, ahk_id %win_id% ;check if the group ID checkbox is already checked
	if(not btnChecked) ;if not, click it
		controlClick, %btnClass%, ahk_id %win_id%
	btnChecked := 0
	sleep 100
}

closeWordWindows() ;does exactly what it sounds like
{
	killWord:
	ifWinExist ahk_class OpusApp
	{
		winKill ahk_class OpusApp
		goto killWord
	}
}

saveWordDoc(filePath, fileName)
{
	trySaveWord:
	winGet, word_id, ID, ahk_class OpusApp
	winActivate, ahk_id %word_id%		
	controlSend, MsoCommandBar1, fa, ahk_id %word_id% ;open "Save As" dialog
	winWait, Save As, , 1
	if(errorLevel)
		goTo trySaveWord
	ifNotExist %filePath% ;if the file path doesn't exist, then create it
		fileCreateDir, %filePath%
	ifExist %filePath%\%fileName%.doc ;if the file already exists, delete it so you can save without having to answer a prompt about overwriting the file
		fileDelete %filePath%\%fileName%.doc
	controlSetText, RichEdit20W2, %filePath%\%fileName%.doc, Save As
	controlSend, RichEdit20W2, {Enter}, Save As
	sleep 250
	winClose ahk_id %word_id%
	sleep 1000
}

#include RemoteBuf.ahk