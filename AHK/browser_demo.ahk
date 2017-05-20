#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include C:\Documents and Settings\pj7960\Documents\scripts\AHK\browser_controls.ahk
global Chrome
global IE8
global Firefox

Gui, Add, Radio, x10 y5 gSetChrome Checked vChrome, Chrome
Gui, Add, Radio, x75 y5 gSetFirefox vFirefox, Firefox
Gui, Add, Radio, x130 y5 gSetIE8 vIE8, IE8
Gui, Add, Button, x10 y30 w100 default, Load URL
Gui, Add, Edit, x130 y30 w450 vNavURL, http://www.google.com/
Gui, Add, Button, x10 y55 w100, Javascript
Gui, Add, Edit, x130 y55 w450 vJscript,
Gui, Add, Button, x350 y3 w100, << Back
Gui, Add, Button, x450 y3 w100, Forward >>
Gui, Add, Button, x250 y3 w100, + Tab
Gui, Show, w600, Browser Controller
setBrowser("Chrome")
return

setChrome:
	setBrowser("Chrome")
return

setIE8:
	setBrowser("IE8")
return

setFirefox:
	msgbox firefox set
return

ButtonLoadURL:
Gui, Submit, noHide
;Gui, Show, w600, Browser Controller
navigate(NavURL,0)
return

Button+Tab:
;controlGetFocus, focusControl, ahk_id %browser%
;msgBox % focusControl
;sleep 1000
;controlFocus, ahk_parent, ahk_id %browser%
;sleep 250
sendBrowser("{Ctrl down}t{Ctrl up}")
return

ButtonJavascript:
Gui, Submit
Gui, Show, w600, Browser Controller
js(Jscript,0)
return

ButtonForward>>:
Gui, Submit
Gui, Show, w600, Browser Controller
js("history.go(1);",0)
return

Button<<Back:
Gui, Submit
Gui, Show, w600, Browser Controller
js("history.go(-1);",0)
return

GuiClose:
ExitApp