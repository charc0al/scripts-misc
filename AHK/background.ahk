#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global blockFlag = 0
global system32 := regExReplace(ComSpec, "[^\\]*$", "")
global userProf	:= regExReplace(A_MyDocuments, "[^\\]*$", "")

muteVolume()

#include windows_functions.ahk
#include background\IntelliSense.ahk
#include background\shutdown.ahk
#include background\windows_hotkeys.ahk
#include background\qc_hotkeys.ahk
#include background\console.ahk

GuiClose:
gui, destroy
return