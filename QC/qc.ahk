#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

inactive = 1

#Up::
	ControlSend, , ^p, Manual Runner
	inactive = 1
return

#Down::
	ControlSend, , ^f, Manual Runner
	WinGetActiveTitle, active_title
	WinSet, AlwaysOnTop, On, %active_title%
	WinActivate, Manual Runner
	ControlFocus, _INNER_EDIT_CLASS_1, Manual Runner
	sleep 100
	send {down}
	WinSet, AlwaysOnTop, Off, %active_title%
	WinActivate, %active_title%
	inactive = 1
return

#Left::
	button = {Up}
	inactive := sendArrow(button, inactive)
return

#Right::
	button = {Down}
	inactive := sendArrow(button, inactive)
return

#NumpadIns::
#Numpad0::
	ControlSend, , ^n, Manual Runner
return

#End::
	WinActivate, Manual Runner
	;ControlSend, , ^q, Manual Runner
	sleep 100
	send ^q
return

#x::
	ControlGetFocus, theCon, Manual Runner
	sleep 100
	InputBox, UserInput, Active Control, %theCon%
return

~^c::
newline = `n
sleep 100
temp := RegExReplace(clipboard, "     ( *)", newline)
clipboard := temp
return

sendArrow(key, in)
{
	if(in)
	{
		WinGetActiveTitle, act_title
		WinSet, AlwaysOnTop, On, %act_title%
		WinActivate, Manual Runner
		;ControlFocus, TcxApiImageComboBox1, Manual Runner
		sleep 100
		send %key%
		WinSet, AlwaysOnTop, Off, %act_title%
		WinActivate, %act_title%
	}
	else
	{
		;ControlFocus, _INNER_EDIT_CLASS_1, Manual Runner
		ControlSend, TcxApiDateEdit1, %key%, Manual Runner
		ControlSend, TcxApiTextEdit1, %key%, Manual Runner
		ControlSend, TcxApiImageComboBox1, %key%, Manual Runner
	}
	return 0
}