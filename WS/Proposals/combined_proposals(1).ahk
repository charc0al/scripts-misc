global env := "stage"
global userNameSaved := "testsuper"
global passWordSaved := "fortis"

BuildGui("Combined Proposals", "Generate Proposals")

#include ..\..\AHK\case_select_gui.ahk
return

Main:
	findCase:
	navigate("https://" . envString . ".assurantemployeebenefits.com/SASCatLogin/#CaseSearchPlace:", 2000)
	js("var a = document.getElementById('gwt-debug-caseId'); a.value=" . caseID . ";", 500)
	js("document.getElementById('gwt-debug-CaseIdSearch').click();", 500)
	js("el = document.getElementsByClassName('buttonLink')[0]; alert(el.parentElement.parentElement.getElementsByTagName('td')[6].innerText);")
	getMsgText(caseNo, 5)
	if errorLevel
		goto findCase
	sleep 1000
	navigate("https://" . envString . ".assurantemployeebenefits.com/SASCaseDetails/#CaseSummaryPlace:" . caseNo . "&plans", 1500)
	js("document.getElementById('gwt-debug-Propose').click()", 500)
	js("document.getElementById('gwt-debug-ProposeAllNone-input').click();",500)
	clipboard := "Combined proposal"
	js("var notes = document.getElementById('gwt-debug-ProposeNote'); notes.focus();")
	send ^v
	js("document.getElementById('gwt-debug-ProposePlansTable-content').getElementsByClassName('buttonprimary')[0].click();", 1000) ;click Save
	js("function waitReady(){if(document.getElementById('gwt-debug-Propose').disabled)window.setTimeout(waitReady,200);else alert('ready');}waitReady();", 100)
	closeAlert(100)
	navigate("https://" . envString . ".assurantemployeebenefits.com/SASCaseDetails/#CaseSummaryPlace:" . caseNo . "&documents", 500)
	js("function waitProp(){if(document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].childNodes){alert('ready');} else {window.setTimeout(waitProp,200);}} waitProp();", 500)
	closeAlert(5)
	if(A_Index = 1)
		js("var button = document.getElementById('gwt-debug-cwTree-staticTree-root-child0').getElementsByTagName('img')[0];var ev = document.createEvent('MouseEvent');ev.initEvent('mousedown',true,false);button.dispatchEvent(ev);", 100)
	trySavePdf:
	js("var proposal = document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].lastChild;var ev = document.createEvent('MouseEvent');ev.initEvent('mousedown',true,false);proposal.dispatchEvent(ev);",200)
	js("var pdfLink = document.getElementById('gwt-debug-DocumentInfoTable').getElementsByClassName('gwt-Anchor')[0];clickEvent = document.createEvent('MouseEvent');clickEvent.initEvent('click', true, false);pdfLink.dispatchEvent(clickEvent);",200)			
	winWait, Save As, , 5
	if(ErrorLevel)
	{	
		msgBox timed out, trying save again.
		goTo trySavePdf
	}
	saveAs(outputDir . "\" . folderName, "Combined", "pdf")
	sleep 500
	js("function deleteProps(){var proposal = document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].lastChild;var ev = document.createEvent('MouseEvent');ev.initEvent('mousedown',true,false);proposal.dispatchEvent(ev);	document.getElementById('gwt-debug-Delete').click();document.getElementById('gwt-debug-DeleteDocumentYes').click();if(document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].childNodes.length > 1){window.setTimeout(deleteProps,1000);}else{alert('0');}}deleteProps();", 100)
	closeAlert(100)
	navigate("https://" . envString . ".assurantemployeebenefits.com/SASCaseDetails/#CaseSummaryPlace:" . caseNo . "&plans", 2000)
return