#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

InputBox, UserInput, QC Rename, Enter a string to precede file names. Then use CTRL+R on selected items in QC to append this string to the front of a selected file. , 100, 350
dash := " - "

^r::
	send {F2}
	sleep 100
	send {Home}
	sleep 100
	send %UserInput%%dash%
	sleep 100
	send {Enter}
return