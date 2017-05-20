;#NoTrayIcon
detectHiddenWindows, on
global winXpos := 600, winYpos := 250
global subDomain, dbName, saveLogin, userNamePreset, passWordPreset, userNameSaved, passWordSaved, envPreset, saveDataFile
global buildSel := 0, stageSel := 0, compassSel := 0, trainSel := 0, testSel := 0
BuildGui("Compass Login","Login")
return

BuildGui:
Gui,	Add,	Tab2,						w180,									Login|Settings|
Gui,	Add,	Text,						x20	y50,								User ID:
Gui,	Add,	Edit,		vUserNameSaved	xp+60 yp-5 w100,						%userNameSaved%
Gui,	Add,	Text,						x20 yp+30,								Password:
Gui,	Add,	Edit,		vPasswordSaved	xp+60 yp-5 w100		+Password,			%passWordSaved%
Gui,	Add,	Checkbox,	vSaveLogin 		x20	yp+30			Checked,			Remember Login
Gui,	Add,	Button,						x45 yp+30 w100,							Login
Gui,	Tab,	2
Gui,	Add,	Radio,		vcompass	gSetEnv Checked%compassSel%,				Production
Gui,	Add,	Radio,		vstage		gSetEnv Checked%stageSel%,					Staging
Gui,	Add,	Radio,		vtrain		gSetEnv Checked%trainSel%,					Training
Gui,	Add,	Radio,		vtest		gSetEnv Checked%testSel%,					Test
Gui,	Add,	Radio,		vbuild		gSetEnv Checked%buildSel%,					Build
Gui,	Add,	Text,						x20 yp+30,								Database:
Gui,	Add,	Edit,		vDbName 		xp+60 yp-5 w100,						%dbName%
Gui,	Show,	x%winXpos% y%winYpos% w200,											Compass Login
return

ButtonLogin:
Gui, Submit
setSaveData()
runAs, 			administrator, winxpsupport
run, 			`"C:\Program Files\Internet Explorer\IEXPLORE.EXE`" http://%dbName%.compass.assurantemployeebenefits.com/forms/frmservlet?config=compass_jini, , hide, ie_pid
winWait,						Windows Internet Explorer
winGet,			ie_ahk_id,	ID,	Windows Internet Explorer
winWait,						Oracle Developer Forms ahk_class SunAwtFrame
winGet,			java_id,	ID,	Oracle Developer Forms ahk_class SunAwtFrame
while not (A_Cursor = "Arrow")
	sleep 100
sleep 250
winActivate,	ahk_id %java_id%
controlSend 	, , %userNameSaved%{Tab}%passWordSaved%{Tab}%dbName%{enter}, ahk_id %java_id%
winWaitClose,	ahk_id %java_id%
winClose,		ahk_id %ie_ahk_id%
exitApp
return

SetEnv:
buildSel 	:= 0
stageSel 	:= 0
compassSel	:= 0
trainSel	:= 0
testSel		:= 0
dbName		:= A_GuiControl
%dbName%Sel := 1
GuiControl, , dbName, %dbName%
return

BuildGui(titleStr, btnLabel)
{
	theTitle := titleStr
	saveDataName := regExReplace(theTitle, "[\s]+", "_") . ".cfg"
	stringLower, saveDataName, saveDataName
	saveDataDir := A_AppData . "\Charlie's Scripts"
	ifNotExist %A_AppData%\Charlie's Scripts
		fileCreateDir, %A_AppData%\Charlie's Scripts
	saveDataFile := saveDataDir . "\" . saveDataName
	userNamePreset := userNameSaved
	passWordPreset := passWordSaved
	getSaveData()
	goSub BuildGui	
}

getSaveData()
{
	caseListFile := 	A_ScriptDir . "\cases.txt"
	outputDir := 		A_WorkingDir
	userNameSaved := 	userNamePreset
	passWordSaved := 	passWordPreset
	dbName := 			"stage"
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
	Gui, submit
	if(SaveLogin)
	{
		ifNotExist %saveDataDir%
			fileCreateDir, %saveDataDir%
		fileDelete, %saveDataFile%
		fileAppend, userNameSaved|%userNameSaved%`n,	%saveDataFile%
		fileAppend, passWordSaved|%passWordSaved%`n,	%saveDataFile%
		fileAppend,	compassSel|%compassSel%`n,			%saveDataFile%
		fileAppend,	stageSel|%stageSel%`n,				%saveDataFile%
		fileAppend,	trainSel|%trainSel%`n,				%saveDataFile%
		fileAppend,	testSel|%testSel%`n,				%saveDataFile%
		fileAppend,	buildSel|%buildSel%`n,				%saveDataFile%
		fileAppend, dbName|%dbName%`n,					%saveDataFile%
		fileAppend, winXpos|%winXpos%`n,				%saveDataFile%
		fileAppend, winYpos|%winYpos%`n,				%saveDataFile%
	}
}

GuiClose:
^!+Esc::
setSaveData()
exitApp
return