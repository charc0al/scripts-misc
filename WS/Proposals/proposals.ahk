global env := "stage"
global userNameSaved := "testsuper"
global passWordSaved := "fortis"

BuildGui("Proposals", "Generate Proposals")

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
	sleep 100
	navigate("https://" . envString . ".assurantemployeebenefits.com/SASCaseDetails/#CaseSummaryPlace:" . caseNo . "&documents", 2000)
	js("function waitProp(){if(document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].childNodes){alert('ready');} else {window.setTimeout(waitProp,200);}} waitProp();", 500)
	closeAlert(5)
	navigate("https://" . envString . ".assurantemployeebenefits.com/SASCaseDetails/#CaseSummaryPlace:" . caseNo . "&plans")
	clickBtn("Propose")
	js("alert(document.getElementById('gwt-debug-ProposalPlansTable').getElementsByTagName('tr').length)")
	getMsgText(listSize, 5)
	listSize := clipboard-1
	if (listSize <= 0)
		return
	clickDialogBtn("Cancel")
	
	loop %listSize%
	{
		clickBtn("Propose")
		js("checkboxes = document.getElementById('gwt-debug-ProposalPlansTable').getElementsByTagName('input'); for(i = 0; i<checkboxes.length; i++){checkboxes[i].checked = false};", 200)
		js("var theRow = document.getElementById('gwt-debug-ProposalPlansTable').getElementsByTagName('tr')[" . A_Index . "]; theRow.getElementsByTagName('input')[0].click()")
		js("var label = theRow.getElementsByClassName('gwt-Label')[0].innerHTML; alert(label)")
		getMsgText(propDesc, 5)
		clipboard := regExReplace(clipboard, "&amp;", "&")
		propDesc := regExReplace(clipboard, "[^a-zA-Z0-9&, ]", "")
		clickDialogBtn("Save")
		js("function waitReady(){if(document.getElementById('Propose-button').disabled)window.setTimeout(waitReady,200);else alert('ready');}waitReady();", 100)
		closeAlert(10)
		navigate("https://" . envString . ".assurantemployeebenefits.com/SASCaseDetails/#CaseSummaryPlace:" . caseNo . "&documents")
		js("function waitProp(){if(document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].childNodes){alert('ready');} else {window.setTimeout(waitProp,200);}} waitProp();", 1000)
		closeAlert(10)
		if(A_Index = 1)
			mouseEvent("mousedown", "document.getElementById('gwt-debug-cwTree-staticTree-root-child0').getElementsByTagName('img')[0]")
		trySavePdf:
		mouseEvent("mousedown", "document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].lastChild")
		mouseEvent("click", "document.getElementById('gwt-debug-DocumentInfoTable').getElementsByClassName('gwt-Anchor')[0]")
		winWait, Save As, , 5
		if(errorLevel)
			goTo trySavePdf
		saveAs(outputDir . "\" . folderName, A_Index . " - " . propDesc, "pdf")
		js("function deleteProps(){var proposal = document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].lastChild;var ev = document.createEvent('MouseEvent');ev.initEvent('mousedown',true,false);proposal.dispatchEvent(ev); document.getElementById('Delete-button').click();document.getElementById('gwt-debug-DeleteDocumentYes').click();if(document.getElementById('gwt-debug-cwTree-staticTree-root-child0').childNodes[1].childNodes.length > 1){window.setTimeout(deleteProps,1000);}else{alert('0');}}deleteProps();")
		closeAlert(100)
		navigate("https://" . envString . ".assurantemployeebenefits.com/SASCaseDetails/#CaseSummaryPlace:" . caseNo . "&plans", 2000)
	}
return