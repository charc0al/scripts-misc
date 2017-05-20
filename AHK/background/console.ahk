global monitorX := 0
global monitorY := 0
global monitorWidth

getMonitor()
{
	SysGet, numScreens, monitorCount
	sysGet, mon, monitor, %numScreens%
	monitorX := monLeft+2
	monitorY := monTop
	monitorWidth := monRight - monLeft
}

ShowConsole()
{
  getMonitor()
  OutputDebug, => ShowConsole called
  WinWait, ahk_class Console_2_Main
  WinActivate, ahk_class Console_2_Main
  WinGetPos,,, consoleWidth, consoleHeight,	  
  newy := monitorY - consoleHeight
  SetWinDelay,10
  WinMove, ahk_class Console_2_Main,,monitorY, newy, monitorWidth, consoleHeight
  WinSet, Transparent, 210, ahk_class Console_2_Main
  WinShow ahk_class Console_2_Main
  
  OutputDebug, Console Height: %consoleHeight% newy: %newy%
  While newy < monitorY
  {
    newy := newy + 25
    if(newy > monitorY)
      newy := monitorY
      
    WinMove, monitorX, newy
  }
  
  return
}

HideConsole()
{
  OutputDebug, => HideConsole called
  SetWinDelay,10  
  WinGetPos,,, consoleWidth, consoleHeight,	  

  newy := monitorY
  targety := monitorY - consoleHeight
  OutputDebug, Console Height: %consoleHeight% newy: %newy%
  
  While newy > targety
  {
    newy := newy - 30
    WinMove, monitorX, newy
  }

  WinHide ahk_class Console_2_Main
  return
}

IsConsoleVisible()
{
  OutputDebug, => IsConsoleVisible called
  WinGetPos,xpos,ypos,,,
  
  isVisible = 0
  
  if(ypos >=monitorY)
    isVisible = 1
    
  OutputDebug, => ypos: %ypos%, isVisible: %isVisible%
  return isVisible
}
; Launch Console if necessary; hide/show on Win+`
#`::
DetectHiddenWindows, on
IfWinExist ahk_class Console_2_Main
{
	;IfWinActive ahk_class Console_2_Main
	if WinActive("ahk_class Console_2_Main") and IsConsoleVisible() = 1
	{
	    HideConsole()
	    ; need to move the focus somewhere else.
	    WinActivate ahk_class Shell_TrayWnd
	}
	else
	{
	    ;if (IsConsoleVisible() = 0)
	      ShowConsole()

	    WinActivate ahk_class Console_2_Main
	 }
}
else
{
	elevateAdmin()
	setWorkingDir, C:\cygwin\bin
	args := "-p -4,-500"
	Run C:\Program Files\Console2\Console.exe ;%args%
        ShowConsole()
	runAs
}
; the above assumes a shortcut in the c:\windows folder to Console.exe.
; also assumes Console is using the default Console.xml file, or
; that the desired config file is set in the shortcut.

DetectHiddenWindows, off
return

; hide Console on "esc".
#IfWinExist ahk_class Console_2_Main
esc::
 {
   HideConsole()
   ;WinActivate ahk_class Shell_TrayWnd
 }
return
