global env := "stage"
global userNameSaved := "testsuper"
global passWordSaved := "fortis"
BuildGui("SAS Rate Sheets", "Get Rate Sheets")

#include ..\..\AHK\browser_controls.ahk
#include ..\..\AHK\case_select_gui.ahk
return

Main:
	findCase:
	navigate("https://" . envString . ".assurantemployeebenefits.com/SASCatLogin/#CaseSearchPlace:", 2000)
	js("var a = document.getElementById('gwt-debug-caseId'); a.value=" . caseID . ";", 500)
	js("document.getElementById('gwt-debug-CaseIdSearch').click();", 500)
	js("el = document.getElementsByClassName('buttonLink')[0]; alert(el.parentElement.parentElement.getElementsByTagName('td')[6].innerText);", 0)
	getMsgText(caseNo, 5)
	if errorLevel
		goto findCase
	getPlans:
	caseURL := "https://" . envString . ".assurantemployeebenefits.com/SASCaseDetails/#CaseSummaryPlace:" . caseNo . "&plans"
	navigate(caseURL, 500)
	waitForLoad()
	sleep 500
	js("rows = document.getElementsByClassName('tablePrimaryHeader')[1].parentNode.getElementsByTagName('tr');alert(rows.length)", 100)
	getMsgText(numPlans, 5)
	if (errorLevel or (numPlans <= 1))
		goto getPlans
	loop % (numPlans-1)
	{
		savePlanDetails:
		js("rows = document.getElementsByClassName('tablePrimaryHeader')[1].parentNode.getElementsByTagName('tr');", 500)
		js("var c = rows[" . A_Index . "].getElementsByTagName('td');alert(c[0].innerText);", 100)
		getMsgText(planName,5)
		StringSplit, title, planName, %A_Space%
		if title1 <> WS
			continue
		js("var link = rows[" . A_Index . "].getElementsByTagName('td')[0].getElementsByTagName('a')[0];clickEvent = document.createEvent('MouseEvent');clickEvent.initEvent('click', true, false);link.dispatchEvent(clickEvent);",1000)
		saveHTML(outputDir . "\" . folderName, planName)
		winActivate, ahk_id %browser%
		sleep 100
		send ^w
		sleep 100
		navigate(caseURL, 500)
		waitForLoad()
	}
return

