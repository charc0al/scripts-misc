#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
global odds := 20
global choice := 0
global flag := 0
global sound := "rickroll/sound.mp3"

return

~LButton::
random, num0, 0, odds
random, num1, 0, odds
random, choice, 0, 5
trayTip, Roll, % "(" . num0 . ", " . num1 . "), " . choice

if (num0 = num1)
	Drive, Eject
return

#if (choice = 1)
{
	#include leet.ahk
}

#if (choice = 2)
{

}

#if (choice = 3)
{
	#include backwards_typing.ahk
}

rickRoll()
{
	maxVolume()
	flag = 1
	sleep 1000
	run % sound
	winWait, ahk_class WMPlayerApp
	winHide, ahk_class WMPlayerApp
	send !^{Down}
	;sleep 100
	;send #l
}

maxVolume()
{
	soundSet 100
	soundGet, sound_mute, Master, mute 
	if sound_mute = On
		send {Volume_Mute}
}