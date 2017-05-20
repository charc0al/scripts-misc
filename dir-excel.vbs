Dim chtChart, objWorkbook, objExcel
const xlValue = 2
const xlColumnClustered = 51
const xlCategory = 1

currentDirectory = left(WScript.ScriptFullName,(Len(WScript.ScriptFullName))-(len(WScript.ScriptName)))
runDirectory = "T:\DHA\Dentistat\out\"

Set WshShell = CreateObject("WScript.Shell")
WshShell.currentDirectory = runDirectory
WshShell.Run "CMD /C dir /b /a:A > " & chr(34) & WshShell.SpecialFolders("Desktop") & "\files.txt" & chr(34), , True

FileDate = Date
dateString = DatePart("yyyy",FileDate) & "-" & Right("0" & DatePart("m",FileDate), 2) & "-" & Right("0" & DatePart("d",FileDate), 2) & "-" & Right("0" & Hour(Now), 2) & "." & Right("0" & Minute(Now) , 2) & "." & Right("0" & Second(Now) , 2)
dateStamp = DatePart("yyyy",FileDate) & "-" & Right("0" & DatePart("m",FileDate), 2) & "-" & Right("0" & DatePart("d",FileDate), 2) & " " & Right("0" & Hour(Now), 2) & ":" & Right("0" & Minute(Now) , 2) & ":" & Right("0" & Second(Now) , 2)

Dim outFile, FSO

Set FSO = CreateObject("Scripting.FileSystemObject")

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(WshShell.SpecialFolders("Desktop") & "\files.txt", ForReading)

strFileName = WshShell.SpecialFolders("Desktop") & "\file_list " & dateString & ".xls"
Set objExcel = CreateObject("Excel.Application")
objExcel.Visible = True

Set objWorkbook = objExcel.Workbooks.Add()
Set objWorksheet1 = objWorkbook.Worksheets(1)

Const ForReading = 1

Dim arrFileLines()
fileNum = 0
Do Until objFile.AtEndOfStream
Redim Preserve arrFileLines(fileNum)
arrFileLines(fileNum) = objFile.ReadLine
fileName = arrFileLines(fileNum)
fileNum = fileNum + 1
	fileClean = split(fileName, ".")(0)
	objWorksheet1.rows(fileNum).columns(1).value = fileClean
Loop

objWorkbook.SaveAs(strFileName)
objExcel.Quit

Set WshShell = CreateObject("WScript.Shell")
WshShell.currentDirectory = WshShell.SpecialFolders("Desktop")
WshShell.Run "CMD /C erase files.txt", , True