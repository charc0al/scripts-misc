global env := "stage"
global userNameSaved := "wetest7"
global passWordSaved := "assurant1"

BuildGui("Participation Summaries", "Get Part. Summaries")

#include ..\..\AHK\case_select_gui.ahk
return

Main:
	navigate("https://" . envString . ".assurantemployeebenefits.com/enrollment/#ParticipationSummaryPlace:participationSummary&id=" . caseID, 500)
	waitForLoad()
	js("window.location.reload();", 500)
	waitForLoad()
	sleep 5000
	saveHTML(outputDir . "\" . caseID, "Participation_Summary_" . caseID)
return