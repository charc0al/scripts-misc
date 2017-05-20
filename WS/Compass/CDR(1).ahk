#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

winGet, compass_id, ID, ahk_class SunAwtFrame
winActivate ahk_id %compass_id%
;winMenuSelectItem, ahk_id %compass_id%, , Financials, Premiums, Scheme, Premium Calculation
sleep 100
send, {LAlt}npsp
;controlSend, , {LAlt}, ahk_id %compass_id%
;controlSend, , npsp, ahk_id %compass_id%