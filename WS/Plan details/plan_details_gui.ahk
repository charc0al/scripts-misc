global vbsDirectory := "T:\Test Services\Charlie's Scripts\src\WS\Plan details"
global env := "dev"
global userNameSaved := "testsuper"
global passWordSaved := "fortis"
global userNameSaved_dev := "testsuper"
global passWordSaved_dev := "fortis"
global userNameSaved_prod := "py68014"
global passWordSaved_prod := "gagan161"

BuildGui("Plan Details", "Get Plan Details")

#include ..\..\AHK\case_select_gui.ahk
GuiControl, , ListViewMain, |Prod|Dev
GuiControl, +gSelectDev2 , Dev
GuiControl, +gSelectProd2 , Stage
GuiControl, , Stage, Prod
GuiControl, , Stage, %ProdSel%
GuiControl, ,TabsMain, |Cases|Settings|Compare
Gui, Tab, 3
Gui, Add, Button, w150 gCompPlans, Compare Plans
Gui, show
LV_ModifyCol(1, "","Prod")
Gui, show
return

SelectProd2:
env := "prod"
GuiControl, , userNameSaved, %userNameSaved_prod%
GuiControl, , passWordSaved, %passWordSaved_prod%
return

SelectDev2:
env := "dev"
GuiControl, , userNameSaved, %userNameSaved_dev%
GuiControl, , passWordSaved, %passWordSaved_dev%
return

compPlans:
run, `"%vbsDirectory%\sas-rate-compare.vbs`" `"%outputDir%`"
return