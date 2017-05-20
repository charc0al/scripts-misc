formatTime, theDate, ,MM-dd-yyyy
lastDate := theDate

Loop, read, backup_scripts_last.log
{
	lastDate = %A_LoopReadLine%
}
fileAppend, `n%theDate%, backup_scripts_last.log
fileReadline, lastDate, "backup_scripts_last.log", 1

cmd = "xcopy `"C:\Documents and Settings\pj7960\Documents\scripts`" U:\Scripts /s /y /d:%lastDate%"
;msgbox %cmd%
run, %comspec% /c %cmd%