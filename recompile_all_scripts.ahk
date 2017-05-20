#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global USERPROFILE	:= regExReplace(A_MyDocuments, "[^\\]*$", "")
global AHK2EXE_DIR	:= "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
global SRC_DIR		:= A_MyDocuments . "\Google Drive\scripts"
global OUT_DIR		:= "T:\Test Services\Charlie's Scripts"
global ICON_DIR 	:= A_MyDocuments . "\Pictures\icons"

process, close, background.exe

;reCompile("WS\VDR Helper\vdr_helper.ahk", 						"WS\VDR Helper\VDR-Helper.exe", 							"ddxfer.ico")
;reCompile("WS\Proposals\proposals.ahk", 						"WS\proposals\Proposals.exe", 								"assurant.ico")
;reCompile("WS\Proposals\combined_proposals.ahk",				"WS\proposals\combined-proposals.exe", 						"assurant.ico")
;reCompile("WS\Plan details\plan_details.ahk", 					"WS\Plan Details\sas-plan-details.exe", 					"assurant.ico")
;reCompile("WS\Part. summaries\participation_summaries.ahk", 	"WS\Participation Summaries\participation-summaries.exe", 	"assurant.ico")
;reCompile("WS\AWE\savecases.ahk", 								"WS\AWE Save Cases\awe-savecases.exe", 						"assurant.ico")
;reCompile("WS\B&W\b&w.ahk",									"WS\WS B&W\WS-B&W.exe",										"assurant.ico")
;reCompile("WS\Solar\Solar B&W.ahk", 							"WS\Solar\Solar B&W.exe", 									"ddxfer.ico")
;reCompile("CDC\CF\claimfacts.ahk",								"Claimfacts.exe",											"spl2file.ico")
;reCompile("CDC\CF\cfpd.ahk",									"CFPD.exe",													"spl2file.ico")
;reCompile("WS\Compass\CompassMain.ahk",						"Compass.exe",												"compass.ico")

runWait %AHK2EXE_DIR% /in "%SRC_DIR%\AHK\background.ahk" /out "C:\Documents and Settings\pj7960\AHK\background.exe" /icon "%ICON_DIR%\agrsmdel.ico"

trayTip Recompile Scripts, All Scripts Re-compiled!, 10
run, `"%USERPROFILE%\AHK\background.exe`"
sleep 3000

reCompile(scriptPath, outPath, iconFile)
{
	runWait %AHK2EXE_DIR% /in "%SRC_DIR%\%scriptPath%" /out "%OUT_DIR%\%outPath%" /icon "%ICON_DIR%\%iconFile%"
	trayTip Recompile Scripts, %scriptPath% Re-compiled!, 10
}