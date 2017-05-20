global env := "stage"
global userNameSaved := "wetest7"
global passWordSaved := "assurant1"
global outputDir := A_Desktop
BuildGui("AWE B&W", "Request Docs")

#include ..\..\AHK\case_select_gui.ahk
GuiControl, , Stage, 1
return

Main:
	caseStr := regExReplace(caseID, "[\s]+", "|")
	stringSplit, caseVals, caseStr, "|"
	caseID := caseVals1
	freq := caseVals2
	type := caseVals3
	navigate("https://" . envString . ".assurantemployeebenefits.com/WorksiteMaterials/enrollmentMaterials.html?solarId=" . caseID, 1000)
	js("document.getElementsByClassName('wideBox')[0].value = " . freq . ";", 500)
	js("function a(){document.getElementsByClassName('wideBox')[1].value = '" . type . "';}a();", 500)
	js("document.getElementsByName('_id10:_id67')[0].click()",2000)
	waitForLoad()
return