#include .\vdr_gui.ahk

Main:
	navigate("https://" . envString . ".assurantemployeebenefits.com/enrollment/#" . vdrQuery . "&id=" . caseID, 0)
	waitForLoad()
	js("window.location.reload();", 1500)
	waitForLoad()
	arrayStr := "12 24 26 48 52"
	stringSplit, freqs, arrayStr, %A_Space%
	loop 5
	{
		if not FreqSelected%A_Index%
			continue
		if(XLS)
		{
			navigate("https://" . envString . ".assurantemployeebenefits.com/enrollment/enrollment/vdrExcelServlet?solarId=" . caseID . "&payPeriod=" . freqs%A_Index%,0)
			saveAs(outputDir . "\" . folderName, "ExportVDR" . freqs%A_Index% . suffix, "xls")
		}
		if (HTML)
		{
			js("document.getElementsByClassName('gwt-ListBox')[0].value = " . freqs%A_Index% . ";", 500)
			clickBtn("Run Report")
			waitForLoad(500)
			saveHTML(outputDir . "\" . folderName, "VDR" . freqs%A_Index% . suffix)
			js("history.go(-1);",0)
			waitForLoad()
		}
	}
return