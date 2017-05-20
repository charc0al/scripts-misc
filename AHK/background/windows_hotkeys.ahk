#b::
keyWait, LWin, D, T1
keyWait, LWin
send {LWin up}
TrayTip, Input Block, Keyboard & Mouse Locked, 5
blockInput, On
sleep, 2000
TrayTip
block:
blockInput, On
blockFlag = 0
codeString := "thecakeisalie"
loop % strLen(codeString)
	codeKey(subStr(codeString, A_Index, 1))

if (blockFlag = 1)
	goTo block
blockInput, Off
TrayTip, Input Block, Keyboard & Mouse unlocked
sleep 2000
TrayTip
return

codeKey(key){
	if(blockFlag = 0){
		keyWait, %key%, D T1
		if errorLevel{
			blockFlag = 1
			return
		}
		keyWait, %key%, T1
		if errorLevel{
			blockFlag = 1
			return
		}
	}
	return
}


;Toggle hidden files & folders
#h:: 
RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden 
If HiddenFiles_Status = 2  
RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1 
Else  
RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2 
WinGetClass, eh_Class,A 
If (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA") 
send, {F5} 
Else PostMessage, 0x111, 28931,,, A 
Return

#g::
{
	tempClip := clipboard
	Send, ^c
	Sleep 50
	runAs
	Run, http://www.google.com/search?q=%clipboard%
	clipboard := tempClip
	Return
}

#w::
runAs
run, `"%userProf%\workspace`"
return

#t::
elevateAdmin()
run, `"%system32%\taskmgr.exe`"
runAs
return

#c::
runAs
run, `"%system32%\control.exe`"
return

#a::
runAs
run, `"%userProf%\Local Settings\Application Data`"
return

#u::
runAs
run, `"%userProf%`"
return

#PrintScreen::
runAs
sleep 100
send !{PrintScreen}
run, mspaint.exe
winWait, ahk_class MSPaintApp
controlSend, , ^v, ahk_class MSPaintApp
winMenuSelectItem, ahk_class MSPaintApp, , File, Save As
winWait, Save As
timeStamp := A_YYYY . "-" . A_MM . "-" . A_DD . "-" . A_Hour . "-" . A_Min . "-" . A_Sec
controlSetText, Edit1, %A_Desktop%\%timeStamp%, Save As
;SendMessage, 0x14E, 07, 0, ComboBox3, Save As
controlSend, , {Enter}, Save As
winWaitClose, Save As
winClose, ahk_class MSPaintApp
return


;Grab & drag windows with click and mouse button 4
~LButton & XButton1::
^!M::
Send {LButton up}
CoordMode, Mouse
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
WinActivate, ahk_id %EWD_MouseWin%
if EWD_WinState = 0
	SetTimer, EWD_WatchMouse, 10
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U
{
	SetTimer, EWD_WatchMouse, off
	return
}

CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX
EWD_MouseStartY := EWD_MouseY
return

LWin & ~Lbutton::
	sleep 100
	WinGetActiveTitle, active_title
	WinSet, AlwaysOnTop, Toggle, %active_title%
return

LWin & XButton1::
	CoordMode, Mouse
	MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
	WinActivate, ahk_id %EWD_MouseWin%
	WinGetActiveTitle, active_title
	WinGet, t, Transparent, %active_title%
	if(t > 50)
	{
		Transparent := t - 16
		WinSet, Transparent, %Transparent%, %active_title%
	}
	else
		WinSet, Transparent, 175, %active_title%
return

LWin & XButton2::
	CoordMode, Mouse
	MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
	WinActivate, ahk_id %EWD_MouseWin%
	WinGetActiveTitle, active_title
	WinSet, Transparent, 255, %active_title%
return

#F::
	send {Alt}
	send F
	send W
	send F
return

#m::
	muteVolume()
return