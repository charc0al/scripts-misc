if wScript.Arguments(0) = 0 then
	envString = "dev"
else
	envString = "stage"
end if

Set WshShell = CreateObject("WScript.Shell")

if (wScript.arguments.count > 1) then
	currentDirectory = wScript.arguments(1) & "\"
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

Set outFile = FSO.OpenTextFile(currentDirectory & "log_" & dateString & "(" & envString & ").txt", 8, True)
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
		Set objWorkbook = objExcel.Workbooks.Open(currentDirectory & caseID & "\VDR" & n & "_" & envString & ".htm")
		Set objWorkbook2 = objExcel.Workbooks.Open(currentDirectory & caseID & "\ExportVDR" & n & "_" & envString & ".xls")

		Set objWorksheet1 = objWorkbook.Worksheets(1)
		Set objWorksheet2 = objWorkbook2.Worksheets(1)

		objExcel.Visible = True

		for i = 6 to objWorksheet1.UsedRange.Rows.Count
			if (objWorksheet1.Rows(i).Columns(2).Value <> "DOB") and (objWorksheet1.Rows(i).Columns(2).Value <> "") then
				objWorksheet1.Rows(i).Columns(1).Interior.ColorIndex = 4
				
				firstName = split(split(objWorksheet1.Rows(i).Columns(1).value,", ")(1), " ")(0)
				lastName = split(objWorksheet1.Rows(i).Columns(1).value,", ")(0)
				
				j = i
				while objWorksheet1.Rows(j).Columns(1).Value <> "Total"
					coverage = objWorksheet1.Rows(j).Columns(3).Value
					if (objWorksheet1.Rows(j).Columns(7).value <> "") then 
						electionAmt = toNum(objWorksheet1.Rows(j).Columns(7).value)
					else
						electionAmt = toNum(objWorksheet1.Rows(j).Columns(4).value)
					end if
					
					if (objWorksheet1.Rows(j).Columns(8).value <> "") then 
						payrollDed = toNum(objWorksheet1.Rows(j).Columns(9).value)
					else		
						payrollDed = toNum(objWorksheet1.Rows(j).Columns(6).value)
					end if
					estPremium = toNum(objWorksheet1.Rows(j).Columns(6).value)
					
					for k = 6 to objWorksheet2.UsedRange.Rows.Count+3
						if inStr(objWorksheet2.rows(k).columns(1).value, firstName) and inStr(objWorksheet2.rows(k).columns(2), lastName) then
							objWorksheet2.rows(k).columns(1).Interior.ColorIndex = 4
							objWorksheet2.rows(k).columns(2).Interior.ColorIndex = 4

							amtCol = -1
							pdCol = 100
							vDLI = false
							if inStr(coverage,"Vol Life EE") then 
								amtCol = lookup("Employee Life Benefit Elected")
								pdCol = lookup("Employee Life Monthly Cost")
								elseif inStr(coverage,"Vol ADD EE") then 
									amtCol = lookup("Employee AD&D Benefit Elected")
									pdCol = lookup("Employee AD&D Monthly Cost")
								elseif inStr(coverage,"Vol STD") then
									amtCol = lookup("Employee Short Term Disability Benefit Elected")
									pdCol = lookup("Employee Short Term Disability Monthly Cost")
								elseif inStr(coverage,"Vol LTD") then
									amtCol = lookup("Employee Long Term Disability Benefit Elected")
									pdCol = lookup("Employee Long Term Disability Monthly Cost")
								elseif inStr(coverage,"Vol ADD SP") then 
									amtCol = lookup("Spouse AD&D Benefit Elected")
									pdCol = lookup("Spouse AD&D Monthly Cost")
								elseif inStr(coverage,"Vol ADD CH") then
									amtCol = lookup("Child AD&D Benefit Elected")
									pdCol = lookup("Child AD&D Monthly Cost")
								elseif inStr(coverage,"Vol Life SP") then
									amtCol = lookup("Spouse Life Benefit Elected")
									pdCol = lookup("Spouse Life Monthly Cost")
								elseif inStr(coverage,"Vol Life CH") then
									amtCol = lookup("Child Life Benefit Elected")
									pdCol = lookup("Child Life Monthly Cost")
							end if
							if inStr(coverage,"Vol Critical Ill EE") then
								amtCol = lookup("Employee Critical Illness Benefit Elected")
								pdCol = lookup("Employee Critical Illness Monthly Cost")
								elseif inStr(coverage,"Vol Critical Ill CH") then
									amtCol = lookup("Child Critical Illness Benefit Elected")
									pdCol = lookup("Child Critical Illness Monthly Cost")
								elseif inStr(coverage,"Vol Critical Ill SP") then
									amtCol = lookup("Spouse Critical Illness Benefit Elected")
									pdCol = lookup("Spouse Critical Illness Monthly Cost")
							end if
							
							if inStr(coverage,"Vol DEN EE") then 
								pdCol = lookup("Employee Dental Monthly Cost")
								if inStr(coverage,"Vol DEN EE + 2") then 
									pdCol = lookup("Employee + 2 Dental Monthly Cost")
									elseif inStr(coverage,"Vol DEN EE + 1") then pdCol = lookup("Employee + 1 Dental Monthly Cost")
									elseif inStr(coverage,"Vol DEN EE + SP") then pdCol = lookup("Spouse Dental Monthly Cost")
									elseif inStr(coverage,"Vol DEN EE + CH") then pdCol = lookup("Child Dental Monthly Cost")
									elseif inStr(coverage,"Vol DEN EE + Family") then pdCol = lookup("Family Dental Monthly Cost")
								end if
							end if
							
							if inStr(coverage,"PPD DEN EE") then 
								pdCol = lookup("Employee PPD Monthly Cost")
								if inStr(coverage,"PPD DEN EE + Family") then 
									pdCol = lookup("Family PPD Monthly Cost")
									elseif inStr(coverage,"PPD DEN EE + SP") then pdCol = lookup("Spouse PPD Monthly Cost")
									elseif inStr(coverage,"PPD DEN EE + CH") then pdCol = lookup("Child PPD Monthly Cost")
									elseif inStr(coverage,"PPD DEN EE + 1") then pdCol = lookup("Employee + 1 PPD Monthly Cost")
									elseif inStr(coverage,"PPD DEN EE + 2") then pdCol = lookup("Employee + 2 PPD Monthly Cost")
								end if
							end if
							
							if inStr(coverage,"Insured Vision") then 
								pdCol = lookup("Employee Insured Vision Monthly Cost")
								if inStr(coverage,"1") or (coverage = "Insured Vision Core EE + 1") then 
									pdCol = lookup("Employee + 1 Insured Vision Monthly Cost")
									elseif inStr(coverage,"2") or (coverage = "Insured Vision Core EE + 2") then pdCol = lookup("Employee + 2 or more Insured Vision Monthly Cost")
									elseif inStr(coverage,"Family") or (coverage = "Insured Vision Core EE + Family") then pdCol = lookup("Family Insured Vision Monthly Cost")
									elseif inStr(coverage,"CH") or (coverage = "Insured Vision Core EE + CH") then pdCol = lookup("Child Insured Vision Monthly Cost")
									elseif inStr(coverage,"SP") then pdCol = lookup("Spouse Insured Vision Monthly Cost")
								end if
							end if
							
							if inStr(coverage,"Vol Accident EE") then 
								pdCol = lookup("Employee Accident Monthly Cost")
								elseif inStr(coverage,"Vol Accident CH") then pdCol = lookup("Child Accident Monthly Cost")
								elseif inStr(coverage,"Vol Accident SP DIS") then pdCol = lookup("Spouse Accident Disability Monthly Cost") 
								elseif inStr(coverage,"Vol Accident SP") then pdCol = lookup("Spouse Accident Monthly Cost")
							end if
							
							if inStr(coverage,"Vol Cancer EE") then 
								pdCol = lookup("Employee Cancer Monthly Cost") 
								'if inStr(coverage,"+ CH") then pdCol = lookup("Employee + Child Cancer Monthly Cost") end if
								if inStr(coverage,"+ CH") then pdCol = lookup("Total Cancer Monthly Cost") end if
								'if inStr(coverage,"+ SP") then pdCol = lookup("Employee + Spouse Cancer Monthly Cost") end if
								if inStr(coverage,"+ SP") then pdCol = lookup("Total Cancer Monthly Cost") end if
								'if inStr(coverage,"+ Family") then pdCol = lookup("Employee + Family Cancer Monthly Cost") end if
								if inStr(coverage,"+ Family") then pdCol = lookup("Total Cancer Monthly Cost") end if
							end if
							
							if inStr(coverage,"Vol Gap EE") then 
								pdCol = lookup("Employee Gap Monthly Cost")
								if inStr(coverage,"Vol Gap EE + Family") then 
									pdCol = lookup("Family Gap Monthly Cost")
									elseif inStr(coverage,"Vol Gap EE + SP") then pdCol = lookup("Spouse Gap Monthly Cost")
									elseif inStr(coverage,"Vol Gap EE + CH") then pdCol = lookup("Child Gap Monthly Cost")
								end if
							end if
							
							if inStr(coverage,"CDC DEN EE") then 
								pdCol = lookup("Employee Dental Monthly Cost")
								if inStr(coverage,"CDC DEN EE + Family") then 
									pdCol = lookup("Family Dental Monthly Cost")
									elseif inStr(coverage,"CDC DEN EE + SP") then pdCol = lookup("Spouse Dental Monthly Cost")
									elseif inStr(coverage,"CDC DEN EE + CH") then pdCol = lookup("Child Dental Monthly Cost")
									elseif inStr(coverage,"CDC DEN EE + 1") then pdCol = lookup("Employee + 1 Dental Monthly Cost")
									elseif inStr(coverage,"CDC DEN EE + 2") then pdCol = lookup("Employee + 2 Dental Monthly Cost")
									elseif inStr(coverage, "CDC DEN Super") then pdCol = lookup("Super Composite Dental Monthly Cost")
								end if
							end if
							
							if inStr(coverage,"V DLI") then
								vDLI = true
								pdCol = 15
							end if
							
							'objWorksheet2.rows(k).columns(amtCol).value = toNum(objWorksheet2.rows(k).columns(amtCol).value)
							if vDLI then
								sp = toNum(objWorksheet2.rows(k).columns(10).value)
								ch = toNum(objWorksheet2.rows(k).columns(11).value)
								if electionAmt = (sp + ch) then
									objWorksheet1.Rows(j).Columns(4).interior.colorindex = 4
									objWorksheet2.Rows(k).Columns(10).interior.colorIndex = 4
									objWorksheet2.Rows(k).Columns(11).interior.colorIndex = 4
									if (objWorksheet1.Rows(j).Columns(7).value <> "") then objWorksheet1.Rows(j).Columns(7).interior.colorindex = 4 end if
								else
									logError(electionAmt & "(html) != " & sp + ch & " (" & sp & "+" & ch & ")(xls)" )
									objWorksheet1.Rows(j).Columns(4).interior.colorindex = 3
									objWorksheet2.Rows(k).Columns(10).interior.colorIndex = 3
									objWorksheet2.Rows(k).Columns(11).interior.colorIndex = 3
									if (objWorksheet1.Rows(j).Columns(7).value <> "") then objWorksheet1.Rows(j).Columns(7).interior.colorindex = 3 end if
								end if
							else
								'============ Check Election Amount===================================
								if amtCol > 0 then 
									if electionAmt = toNum(objWorksheet2.rows(k).columns(amtCol).value) then
										objWorksheet1.Rows(j).Columns(4).interior.colorindex = 4
										objWorksheet2.rows(k).columns(amtCol).interior.colorindex = 4
										if (objWorksheet1.Rows(j).Columns(7).value <> "") then objWorksheet1.Rows(j).Columns(7).interior.colorindex = 4 end if
									else
										logError(electionAmt & "(html) != " & toNum(objWorksheet2.rows(k).columns(amtCol).value) & "(xls)")
										objWorksheet1.Rows(j).Columns(4).interior.colorindex = 3
										objWorksheet2.rows(k).columns(amtCol).interior.colorindex = 3
										if (objWorksheet1.Rows(j).Columns(7).value <> "") then objWorksheet1.Rows(j).Columns(7).interior.colorindex = 3 end if
									end if
								end if
							end if
							
							'============ Check Payroll Ded Amount ===============================
							'MsgBox "payrollDed: " & payrollDed  & "   objWorksheet2[" & k & "][" & pdCol & "]: " & objWorksheet2.rows(k).columns(pdCol).value
							if payrollDed = toNum(objWorksheet2.rows(k).columns(pdCol).value) then
								objWorksheet1.Rows(j).Columns(6).interior.colorindex = 4
								objWorksheet1.Rows(j).Columns(5).interior.colorindex = 4
								objWorksheet2.rows(k).columns(pdCol).interior.colorindex = 4
								if (objWorksheet1.Rows(j).Columns(8).value <> "") then objWorksheet1.Rows(j).Columns(8).interior.colorindex = 4 end if
							else
								logError(payrollDed & "(html) != " & toNum(objWorksheet2.rows(k).columns(pdCol).value) & "(xls)")
								objWorksheet1.Rows(j).Columns(6).interior.colorindex = 3
								objWorksheet1.Rows(j).Columns(5).interior.colorindex = 3
								objWorksheet2.rows(k).columns(pdCol).interior.colorindex = 3
								if (objWorksheet1.Rows(j).Columns(8).value <> "") then objWorksheet1.Rows(j).Columns(8).interior.colorindex = 3 end if
							end if
							
							exit for
						end if
					next
					
					j = j + 1
				wend
				coverage = objWorksheet1.Rows(i).Columns(3).Value
			end if
		next
		
		if not errors then
			outFile.WriteLine(caseID & "(" & n & ") - OK")
		end if
		
		if v = 4 then outFile.write(VBCR) end if
		
		objWorkbook.close
		objWorkbook2.close
	next
Loop
text = VBCR & VBCR
outFile.WriteLine(text)
objFile.Close
outFile.Close

function logError(str)
	if not errors then outFile.WriteLine(VBCR & caseID & "(" & n & ") - The following errors were found:") end if
	errors = true
	numTabs1 = (34 - (len(lastName & firstName) + 3))/4
	'Msgbox lastName & "(" & len(lastName) & ") + " & firstName & "(" & len(firstName) & ") = " & len(lastName & firstName) & VBCR & "30 - (" & len(lastName & firstName) & "+ 3 = " & (len(lastName & firstName) + 3) & ") = " & (30 - (len(lastName & firstName) + 3)) & VBCR & (30 - (len(lastName & firstName) + 3)) & "/4 = " & numTabs1
	numTabs2 = (30 - (len(coverage) + 3))/4
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
	for m = 3 to objWorksheet2.UsedRange.Columns.Count
		if inStr(objWorksheet2.rows(5).columns(m).value,str) then
			lookup = m
			'MsgBox "Found " & str & " at column " & m
		end if
	next
end function

function ceil(number)
  ceil = int(number)
  if ceil <> number then
    ceil = ceil + 1
  end if
end function

function floor(number)
  floor = int(number)
end function