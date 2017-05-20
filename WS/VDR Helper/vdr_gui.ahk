global vbsDirectory := "T:\Test Services\Charlie's Scripts\WS\VDR Helper"
global env := "dev"
global userNameSaved := "wetest7"
global passWordSaved := "assurant1"
global vdrQuery := "CreateVdrPlace:createVdr"
BuildGui("VDR Helper", "Get VDRs")

#include ..\..\AHK\case_select_gui.ahk
Gui, Tab, 2
Gui, Add, Text, x20 yp+30, VDR Type:
Gui, Add, Checkbox, Checked vXLS gSelectXLS, XLS
Gui, Add, Checkbox, Checked vHTML gSelectHTML, HTML
goSub selectHTML
Gui, Add, Text, x120 y110, Freqs:
Gui, Add, Checkbox, Checked vFreqSelected1, 12
Gui, Add, Checkbox, Checked vFreqSelected2, 24
Gui, Add, Checkbox, Checked vFreqSelected3, 26
Gui, Add, Checkbox, Checked vFreqSelected4, 48
Gui, Add, Checkbox, Checked vFreqSelected5, 52
GuiControl, ,TabsMain, |Cases|Settings|Compare
Gui, Tab, 3
Gui, Add, Button, w150 gCompDev, XLS/HTML (dev)
Gui, Add, Button, w150 gCompStage, XLS/HTML (stage)
Gui, Add, Button, w150 gCompHTML, Dev/Stage HTML
Gui, Add, Button, w150 gCompXLS, Dev/Stage XLS
Gui, show
return

selectXLS:
;vdrQuery := "ExportVdrPlace:exportVdr"
return

selectHTML:
;vdrQuery := "CreateVdrPlace:createVdr"
return

compDev:
run, `"%vbsDirectory%\vdr-compare-html-xls.vbs`" 0 `"%outputDir%`"
return

compStage:
run, `"%vbsDirectory%\vdr-compare-html-xls.vbs`" 1 `"%outputDir%`"
return

compHTML:
run, `"%vbsDirectory%\vdr-compare-dev-stage(html).vbs`" `"%outputDir%`"
return

compXLS:
run, `"%vbsDirectory%\vdr-compare-dev-stage(xls).vbs`" `"%outputDir%`"
return