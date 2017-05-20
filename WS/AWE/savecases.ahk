global env := "stage"
global userNameSaved := "wetest7"
global passWordSaved := "assurant1"
global noOutput := 1
BuildGui("Save cases", "Save Cases")

#include ..\..\AHK\case_select_gui.ahk
return

Main:
	;search for current CaseID and wait for page to process
	searchCase:
	navigate("https://" . envString . ".assurantemployeebenefits.com/enrollment/", 1000)
	js("alert(document.getElementById('gwt-debug-policySearchCaseId').value)",100)
	closeAlert(1)
	if(errorLevel)
		goto searchCase
	js("document.getElementById('gwt-debug-policySearchCaseId').value = " . caseId . ";",100)
	js("document.getElementById('gwt-debug-policySearchSearchButton').click();",1000)
	waitForLoad()
	;hover over "Case"
	js("var mouseOver = document.createEvent('MouseEvent');var click = document.createEvent('MouseEvent');mouseOver.initEvent('mouseover',true,false);click.initEvent('click',true,false);var caseHover = document.getElementById('gwt-uid-7');", 100)
	js("caseHover.dispatchEvent(mouseOver);",100)
	;click "Edit Plan"
	js("var editPlan = document.getElementById('gwt-uid-10');editPlan.dispatchEvent(click);",250)
	waitForLoad()
	;check all boxes, click save, wait for process to finish
	js("checkboxes = document.getElementsByTagName('input');for(var i = 0;i<checkboxes.length;i++){checkboxes[i].checked = true;}", 100)
	js("var buttons = document.getElementsByClassName('gwt-Button');for(var i=0;i<buttons.length;i++){if(buttons[i].innerText=='Save'){buttons[i].click();}}",100)
	waitForLoad()
	js("caseHover.dispatchEvent(mouseOver);",100)
	js("var editClassLoc = document.getElementById('gwt-uid-11');editClassLoc.dispatchEvent(click);",250)
	waitForLoad()
	;define variables, then click Edit
	js("var memberTable = document.getElementsByClassName('tablePrimaryHeader')[0].parentNode;var rows = memberTable.getElementsByTagName('tr');var buttons = rows[1].getElementsByClassName('gwt-Button')",100)
	js("for(var i=0;i<buttons.length;i++){if(buttons[i].innerText=='Edit'){buttons[i].click();}}",100)
	;select all sequences, click Save
	js("var opts = rows[1].getElementsByClassName('gwt-ListBox')[0].getElementsByTagName('option');for(var i=0;i<opts.length;i++){opts[i].selected = true;}",250)
	js("for(var i=0;i<buttons.length;i++){if(buttons[i].innerText=='Save'){buttons[i].click();}}",100)
	waitForLoad()
	navigate("https://stage2.assurantemployeebenefits.com/enrollment/#CaseEditPlace:caseEdit&id=" . caseID, 100)
	waitForLoad()
	js("var buttons = document.getElementsByClassName('buttonsecondary');for(var i=0;i<buttons.length;i++){if(buttons[i].innerText=='Update'){buttons[i].click();}}",100)
	waitForLoad()
	trayTip, Save Cases, %caseID% completed., 2, 1
return