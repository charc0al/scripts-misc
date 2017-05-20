Set WshShell = CreateObject("WScript.Shell")
if (wScript.arguments.count > 0) then
	currentDirectory = wScript.arguments(0) & "\"
	WshShell.currentDirectory = currentDirectory
else
	currentDirectory = left(WScript.ScriptFullName,(Len(WScript.ScriptFullName))-(len(WScript.ScriptName)))
end if
WshShell.Run "CMD /C dir /b /a:D > " & chr(34) & currentDirectory & "dir_list.txt" & chr(34), , True

Dim chtChart, objWorkbook, objExcel
const xlValue = 2
const xlColumnClustered = 51
const xlCategory = 1

Dim vdrArray
vdrArray = Array("12","24","26","48","52")

FileDate = Date
dateString = DatePart("yyyy",FileDate) & "-" & Right("0" & DatePart("m",FileDate), 2) & "-" & Right("0" & DatePart("d",FileDate), 2) & "-" & Right("0" & Hour(Now), 2) & "." & Right("0" & Minute(Now) , 2) & "." & Right("0" & Second(Now) , 2)
dateStamp = DatePart("yyyy",FileDate) & "-" & Right("0" & DatePart("m",FileDate), 2) & "-" & Right("0" & DatePart("d",FileDate), 2) & " " & Right("0" & Hour(Now), 2) & ":" & Right("0" & Minute(Now) , 2) & ":" & Right("0" & Second(Now) , 2)

Dim outFile, FSO

'Save error log to text file
Set FSO = CreateObject("Scripting.FileSystemObject")
Set outFile = FSO.OpenTextFile(currentDirectory & "log_HTM_" & dateString & ".txt", 8, True)
text = "VDR Compare " & dateStamp
outFile.WriteLine(text)


Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(currentDirectory & "dir_list.txt", ForReading)

Const ForReading = 1

Dim arrFileLines()
caseNum = 0
Do Until objFile.AtEndOfStream
Redim Preserve arrFileLines(caseNum)
arrFileLines(caseNum) = objFile.ReadLine
caseID = arrFileLines(caseNum)
caseNum = caseNum + 1

	for v = 0 to 4
		n = vdrArray(v)
		errors = false

		Set objExcel = CreateObject("Excel.Application")
		objExcel.DisplayAlerts = false
		Set objWorkbook = objExcel.Workbooks.Open(currentDirectory & caseID & "\VDR" & n & "_dev.htm")
		Set objWorkbook2 = objExcel.Workbooks.Open(currentDirectory & caseID & "\VDR" & n & "_stage.htm")

		Set objWorksheet1 = objWorkbook.Worksheets(1)
		Set objWorksheet2 = objWorkbook2.Worksheets(1)

		objExcel.Visible = True
		
		for i = 6 to objWorksheet1.UsedRange.Rows.Count
			if (objWorksheet1.Rows(i).Columns(2).Value <> "DOB") and (objWorksheet1.Rows(i).Columns(2).Value <> "") then
				objWorksheet1.Rows(i).Columns(1).Interior.ColorIndex = 4
				
				firstName = split(split(objWorksheet1.Rows(i).Columns(1).value,", ")(1), " ")(0)
				lastName = split(objWorksheet1.Rows(i).Columns(1).value,", ")(0)
				nameRow = lookup(lastName & ", " & firstName)
				
				j = i
				k = nameRow
				while objWorksheet1.Rows(j).Columns(1).Value <> "Total"
					for b = 2 to objWorksheet1.UsedRange.Columns.Count
						coverage = objWorksheet1.Rows(j).Columns(3).Value
						if objWorksheet1.Rows(j).Columns(b).Value = objWorksheet2.Rows(k).Columns(b).Value then
							objWorksheet1.Rows(j).Columns(b).interior.colorindex = 4
							objWorksheet2.Rows(k).Columns(b).interior.colorindex = 4
						else
							logError(objWorksheet1.Rows(j).Columns(b).value & "(dev) != " & objWorksheet2.Rows(k).Columns(b).value & "(stage)")
							objWorksheet1.Rows(j).Columns(b).interior.colorindex = 3
							objWorksheet2.Rows(k).Columns(b).interior.colorindex = 3
							'MsgBox objWorksheet1.Rows(j).Columns(b).Value & " != " & objWorksheet2.Rows(k).Columns(b+1).Value
						end if
					next
					j = j + 1
					k = k + 1
				wend
			end if
		next

		if not errors then
			outFile.WriteLine(caseID & "(" & n & ") - OK")
		end if
		
		if v = 4 then outFile.write(VBCR) end if

		objWorkbook.close
		objWorkbook2.close
		'objWorkbook2.SaveAs caseID & "-" & n & "html.xls"
		'objWorkbook2.close
	next
Loop
text = VBCR & VBCR
outFile.WriteLine(text)
objFile.Close
outFile.Close

function logError(str)
	if not errors then outFile.WriteLine(VBCR & caseID & "(" & n & ") - The following errors were found:") end if
	errors = true
	numTabs1 = (24 - (len(lastName & firstName) + 2))/4
	numTabs2 = (30 - (len(coverage) + 2))/4
	tab1 = ""
	tab2 = ""
	for tabC = 0 to ceil(numTabs1)
		tab1 = tab1 & VbTab
	next 
	for tabC = 0 to ceil(numTabs2)
		tab2 = tab2 & VbTab
	next 
	outFile.WriteLine(lastName & ", " & firstName & tab1 & "[" & coverage & "] " & tab2 & str)
	'objWorkbook2.save
end function


function toNum(obj)
	if (obj <> "") then
		toNum = CDbl(Replace(split(obj, " ")(0),"$",""))
	else
		toNum = 0
	end if
end function

function lookup(str)
	notFound = true
	for m = 7 to objWorksheet2.UsedRange.Rows.Count
		if (inStr(objWorksheet2.rows(m).columns(1).value,str) and notFound) then
			lookup = m
			notFound = false
			'MsgBox "Found " & str & " at row " & m
		end if
	next
end function

function ceil(number)
  ceil = int(number)
  if ceil <> number then
    ceil = ceil + 1
  end if
end function