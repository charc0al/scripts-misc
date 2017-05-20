#include ..\..\AHK\browser_controls.ahk
#include ..\..\AHK\Listview_G.ahk
global theTitle
global buttonLabel
global outputDir
global caseListFile
global saveDataFile
global userNamePreset
global passWordPreset
global envPreset
global winXpos
global winYpos
global noOutput
return

BuildGui(titleStr, btnLabel)
{
	theTitle := titleStr
	buttonLabel := btnLabel
	saveDataName := regExReplace(theTitle, "[\s]+", "_") . ".cfg"
	stringLower, saveDataName, saveDataName
	saveDataDir := A_AppData . "\Charlie's Scripts"
	ifNotExist %A_AppData%\Charlie's Scripts
		fileCreateDir, %A_AppData%\Charlie's Scripts
	saveDataFile := saveDataDir . "\" . saveDataName
	userNamePreset := userNameSaved
	passWordPreset := passWordSaved
	envPreset := env
	getSaveData()
	goSub BuildGui	
}

getSaveData()
{
	caseListFile := A_ScriptDir . "\cases.txt"
	outputDir := A_WorkingDir
	userNameSaved := userNamePreset
	passWordSaved := passWordPreset
	env := envPreset
	ifExist %saveDataFile%
	{
		Loop, read, %saveDataFile%
		{
			stringSplit, curLine, A_LoopReadLine, "|"
			varName := curLine1
			val := curLine2
			%varName% := curLine2
		}
	}
}

setSaveData()
{
	winGetPos, winXpos, winYpos, , , %theTitle%
	Gui, submit, NoHide
	ifNotExist %saveDataDir%
		fileCreateDir, %saveDataDir%
	fileDelete, %saveDataFile%
	fileAppend, caseListFile|%caseListFile%`n,		%saveDataFile%
	fileAppend, outputDir|%outputDir%`n,			%saveDataFile%
	fileAppend, userNameSaved|%userNameSaved%`n,	%saveDataFile%
	fileAppend, passWordSaved|%passWordSaved%`n,	%saveDataFile%
	fileAppend, env|%env%`n,						%saveDataFile%
	fileAppend, winXpos|%winXpos%`n,				%saveDataFile%
	fileAppend, winYpos|%winYpos%`n,				%saveDataFile%
	fileAppend, effDate|%effDate%`n,				%saveDataFile%
}

MyListView:
return

AllCases:
Gui, Submit, NoHide
if(AllCases)
	LV_Modify(0,"Select")
else
	LV_Modify(0,"-Select")
Gui, Show
return

FileOpenCase:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedFileName, 3,%A_ScriptDir%, %theTitle% - Open Case List, Text Documents (*.txt)
if SelectedFileName =  ; No file selected.
    return
winGetPos, winXpos, winYpos, , , %theTitle%
Gui, destroy
Menu, FileMenu, delete
Menu, HelpMenu, delete
caseListFile := SelectedFileName
goSub BuildGui
return

FileSetOutputDir:
FileSelectFolder, SelectedFolderName, , 3, %theTitle% - Set Output Directory
outputDir := SelectedFolderName
setSaveData()
return

FileOpenOutputDir:
Run explorer.exe %outputDir%
return

GuiClose:
FileExit:
setSaveData()
exitApp
return

FileExitWithoutSave:
exitApp
return

HelpAbout:
winGetPos, winXpos, winYpos, , , %theTitle%
aboutX := winXpos - 50
aboutY := winYpos + 100
Gui, 2:Show, w300 h100 x%AboutX% y%AboutY%, About
return

ClearSaveData:
fileDelete, %saveDataFile%
winXpos := ""
winYpos := ""
alert(theTitle,"Saved data cleared.",3)
Gui, destroy
getSaveData()
goTo BuildGui
return

SelectEnv:
env := A_GuiControl
return

SelectBrowser:
browserName := A_GuiControl
return

MainButton:
Gui, Submit, NoHide
initChrome()
setBrowser(browserName)
setEnv(env)
doLogin(envString, userNameSaved, passWordSaved)
AltMainButton:
selected_list := LVG_Get(1,"Selected","List","all")
comma := ","
stringSplit, selected_items, selected_list, %comma%
loop %selected_items0%
{
	if(dual_cases)
	{
		LV_GetText(stageCase,	selected_items%A_Index%,	1)
		LV_GetText(devCase,		selected_items%A_Index%,	2)
		if(Stage)
			caseID := stageCase
		if(Dev)
			caseID := devCase
		folderName := stageCase . " " . devCase
	}
	else
	{
		LV_GetText(folderName,selected_items%A_Index%)
		caseID := folderName
	}
	goSub Main
	trayTip, %theTitle%, %caseID% completed., 2, 1
}
return

BuildGui:
setEnv(env)
Menu, FileMenu,		Add,	&Select Case List,			FileOpenCase
Menu, FileMenu,		Add,	Set Output &Directory,		FileSetOutputDir
Menu, FileMenu,		Add,	&Open Output Directory,		FileOpenOutputDir
Menu, FileMenu,		Add		; Separator line.
Menu, FileMenu,		Add,	E&xit,						FileExit
Menu, FileMenu,		Add,	E&xit Without Saving,		FileExitWithoutSave

Menu, HelpMenu, Add, &About, HelpAbout
Menu, HelpMenu, Add, &Clear Saved Data && Reset, ClearSaveData

; Create the menu bar by attaching the sub-menus to it:
Menu, MyMenuBar,	Add,	&File,					:FileMenu
Menu, MyMenuBar,	Add,	&Help,					:HelpMenu
Gui, Menu, MyMenuBar

Gui, 2:+owner1  ; Make the main window (Gui #1) the owner of the "about box" (Gui #2).
Gui, 2:Font,	w700
Gui, 2:Add,		Text,	,			Case Select GUI - %theTitle%
Gui, 2:Font,	norm
Gui, 2:Add,		Text,	, 			Designed and coded by Charlie Mehrer
Gui, 2:Add,		Text,	yp+15,		charles.mehrer@assurant.com
Gui, 2:Add,		Text,	yp+15,		816.881.8439 (office)
Gui, 2:Add,		Text,	yp+15,		785.524.2368 (mobile)

Gui, Add, 		Tab2,		vTabsMain h350 w180,			Cases|Settings
Gui, Tab, 1
Gui, Add,		Checkbox,	vAllCases gAllCases Checked,	All Cases
Loop, read, %caseListFile%
{
	stringSplit caseIDs, A_LoopReadLine, %A_Space%
	if(caseIDs0 > 1)
		dual_cases = 1
	else
		dual_cases = 0
	break
}
if(dual_cases)
	Gui, Add, ListView, r20 w155 h250 vListViewMain gMyListView, Stage|Dev
else
	Gui, Add, ListView, r20 w155 h250 vListViewMain gMyListView, Case ID
Loop, read, %caseListFile%
{
	formattedLine := regExReplace(A_LoopReadLine, "[\s]+", "|")
	stringSplit caseIDs, formattedLine, |
	if(caseIDs0 = 1)
		LV_Add("check gMyListView v" . A_LoopReadLine, A_LoopReadLine)
	else if(regExMatch(A_LoopReadLine, "[0-9]+[\s]+[0-9]+[\s]+[a-zA-Z]+"))
	{
		LV_Add("check gMyListView v" . A_LoopReadLine, caseIDs1 . "  " . caseIDs2 . "  " . caseIDs3)
		noOutput := 1
	}
	else
	{
		dual_cases = 1
		LV_Add("check gMyListView v" . A_LoopReadLine, caseIDs1, caseIDs2)
	}
}
LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(1, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.
if(dual_cases)
{
	LV_ModifyCol(1,73)
	LV_ModifyCol(1,"Center")
	LV_ModifyCol(2,73)
	LV_ModifyCol(2,"Center")
}
else
{
	LV_ModifyCol(1,130)
	LV_ModifyCol(1,"Center")
}
LV_Modify(0,"Select")

Gui,	Add,	Text,, `n
Gui,	Add,	Button, 	vMainButton gMainButton x25 y320 w150 default,	%buttonLabel%
Gui,	Tab,	2
Gui,	Add,	Text,		,												Username/Pass:
Gui,	Add,	Edit, 		vUserNameSaved w100,							%userNameSaved%
Gui,	Add,	Edit, 		vPassWordSaved w100 +Password,					%passwordSaved%
Gui,	Add,	Text, 		x20 yp+30,										Test Env:
Gui,	Add,	Radio, 		vDev 	gSelectEnv Checked%DevSel%,				Dev
Gui,	Add,	Radio, 		vStage	gSelectEnv Checked%StageSel%,			Stage
Gui,	Add,	Text, 		x20 yp+30,										Browser:
Gui,	Add,	Radio, 		vChrome	gSelectBrowser Checked,					Chrome
Gui,	Add,	Radio, 		vIE8	gSelectBrowser,							IE8 (don't use)
if((winXpos <> "") && (winYpos <> ""))
	Gui, Show, x%winXpos% y%winYpos%, %theTitle%
else
	Gui, Show, w200, %theTitle%
ifNotExist %caseListFile%
	goTo FileOpenCase
ifNotExist %saveDataFile%
	if not noOutput
		goSub FileSetOutputDir