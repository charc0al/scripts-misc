global EffDate := A_MM . "/" . A_DD . "/" . A_YYYY
BuildGui("Solar B&W", "Save Documents")

#include ..\..\AHK\case_select_gui.ahk
guiControl, +gSolarMainButton , MainButton
guiControl, ,TabsMain, |Cases
guiControl, move, ListViewMain, h230
gui, tab, 1
gui, add, text, yp+80 x28,Eff. Date:
gui, add, edit, yp-3 xp+55 w90 vEffDate, %effDate%

#include solar_functions.ahk
return


Main:
archiveSearch(caseID)
return

SolarMainButton:
Gui, Submit, NoHide
fileAppend, effDate|%effDate%`n, %saveDataFile%
goTo AltMainButton
return