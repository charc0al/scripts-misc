#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
#NoTrayIcon
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global day :=	"20120921"
global hour :=	16
global min :=	01
global sec :=	12
global today :=	A_YYYY . A_MM . A_DD

if(day = today){
	while(A_Hour < (hour - 1))
		sleep 3600000 ;sleep for an hour
	while(((A_Hour < hour) and (A_Min < 59)) or ((A_Hour >= hour) and (A_Min < (min - 1))))
		sleep 60000
	while((A_Min < min) or ((A_Min >= min) and (A_Sec < (sec - 1))) or (A_Hour < hour))
		sleep 1000
	while not ((A_Min >= min) and (A_Sec >= sec))
		sleep 100
	msgbox time is up! %A_Now%
}
