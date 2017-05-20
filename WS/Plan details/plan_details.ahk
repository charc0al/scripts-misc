#include .\plan_details_gui.ahk

Main:
	findCase:
	navigate("https://" . envString . ".assurantemployeebenefits.com/SASCatLogin/#CaseSearchPlace:", 2000)
	if not (browserName = "IE")
		js("var a = document.getElementById('gwt-debug-caseId'); a.value=" . caseID . ";", 500)
	else
	{
		js("var a = document.getElementById('gwt-debug-caseId'); a.focus();", 200)
		send %caseID%
	}
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
		js("var c = rows[" . A_Index . "].getElementsByTagName('td'); var planName = c[1].innerText + ' ' + c[3].innerText + ' ' + c[2].innerText + ' - ' + c[0].innerText;alert(planName);", 100)
		getMsgText(planName, 5)
		planName := regExReplace(planName, "[\/\\:]+", "-")
		planName := regExReplace(planName, "[\s]+", " ")
		planName := regExReplace(planName, "[\s]*-[\s]*Created[\s]*by[\s*]conv[a-zA-Z]*", "")
		js("var link = rows[" . A_Index . "].getElementsByTagName('td')[0].getElementsByTagName('a')[0];clickEvent = document.createEvent('MouseEvent');clickEvent.initEvent('click', true, false);link.dispatchEvent(clickEvent);",1000)
		if(Stage)
			saveHTML(outputDir . "\" . folderName, planName)
		if(Dev)
			saveHTML(outputDir . "\" . folderName, planName, "txt")
		winActivate, ahk_id %browser%
		sleep 100
		send ^w
		sleep 100
		navigate(caseURL, 500)
		waitForLoad()
	}
return