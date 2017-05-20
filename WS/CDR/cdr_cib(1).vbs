Set objFSO = createObject("Scripting.FileSystemObject")
Set objReadFile = objFSO.openTextFile("cib.sql",1,false)
query = objReadFile.ReadAll
objReadFile.close
Set con=createobject("adodb.connection")
Set rs=createobject("adodb.recordset")

con.Open "Driver=Oracle in OraHome92;Dbq=fd3a;Uid=pj7960;Pwd=compass1;"
query = replace(query, "N_RQST_DT_IN", "'19-JUN-2012'")
query = replace(query, "N_RPT_KEY_IN", "22606")
rs.open query, con

recCount = rs.fields.count
msgBox "Fields: " & recCount

i = 0
Do while (i < rs.fields.count)
      theList = theList & VBCR & i & ") " & rs.fields.Item(i).name & VBTAB & rs.fields.Item(i)
	  i = i + 1
Loop
msgBox theList
con.Close