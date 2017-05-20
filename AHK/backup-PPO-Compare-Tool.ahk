#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

inputBox, notes, PPO Tool Backup, Enter description of changes:

global workspace :=		regExReplace(A_MyDocuments, "[^\\]*$", "") . "workspace"
global srcDir :=		workspace . "\PPOCompareTool"
global googleDrive :=	A_MyDocuments . "\Google Drive"
global ppoDir :=		googleDrive . "\Assurant\PPO Comparison Tool"
global backupDir := 	ppoDir . "\" . A_YYYY . "-" . A_MM . "-" . A_DD . " (" . A_Hour . "." . A_Min . "." . A_Sec . ") - " . notes

fileCreateDir,	% backupDir

copyDir(".settings")
copyDir("src")
copyDir("test")
copyDir("test-classes")
copyDir("war")

fileRemoveDir, % backupDir . "\war\WEB-INF", 1
fileCopy, % srcDir . "\*.*", % backupDir

copyDir(str){
	FileCopyDir, % srcDir . "\" . str, % backupDir . "\" . str
}