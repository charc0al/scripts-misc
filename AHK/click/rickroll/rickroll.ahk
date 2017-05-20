#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
#NoTrayIcon
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
global flag = 0
global sound := "sound.mp3"

~LButton::
random, num, 0, 20
if(num < 10)
{
	if (flag)
		maxVolume()
	if(num = 1)
		rickRoll()
}
return

^!+Esc::
process, close, wmplayer.exe
msgBox, ,Script, Exited, 3
exitApp
return

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