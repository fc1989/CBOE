
<%
Response.Expires = -1
Dim colName_arr
Dim cellWidth
Dim regConn
'To fix CSBR-152262
Dim fieldLength
Dim oString
Dim strText, Length
Set oString = New ASPString

bCheckSelected = false

'plateID = request("PlateID")
if Application("RegServerName") <> "NULL" then

'-- SMathur: CSBR-99335, selecting MW of a reg compound using a select statement to fix the oracle 9i specific issue.    
SQL =	"SELECT DISTINCT v.WELL_ID, " & _
		"		v.REG_ID_FK, " & _
		"		v.BATCH_NUMBER_FK, " & _
		"		Decode(v.REG_ID_FK,NULL,NULL,inv_vw_reg_batches.RegBatchID) as RegBatchID, " & _
		"		(SELECT enum_value from inv_enumeration where enum_id = v.WELL_FORMAT_ID_FK) AS WellFormat, " & _
		"		v.CAS, " & _
		"		v.SUBSTANCE_NAME, " & _
		"		v.COMPOUND_ID_FK, " & _
		"		v.QTY_INITIAL, " & _
		"		v.QTY_REMAINING, " & _
		"		DECODE(v.Qty_Initial, NULL, NULL, v.Qty_Initial||' '||UOM.Unit_Abreviation) AS Amount_Initial, " & _
		"		DECODE(v.Qty_Remaining, NULL, NULL, v.Qty_Remaining||' '||UOM.Unit_Abreviation) AS Amount_Remaining, " & _
		"		v.WEIGHT, " & _
		"		DECODE(v.WEIGHT, NULL, NULL, v.WEIGHT||' '||UOW.Unit_Abreviation) AS Weight_String , " & _
		"		v.SOLVENT, " & _
		"		DECODE(v.concentration, NULL, NULL, v.concentration||' '||UOC.Unit_Abreviation) AS Concentration_String , " & _
		"		v.CONCENTRATION, " & _
		"		v.ROW_INDEX, " & _
		"		v.COL_INDEX, " & _
		"		v.ROW_NAME AS RowName," & _
		"		v.COL_NAME AS ColName, " & _
		"		v.NAME, " & _
		"		v.SORT_ORDER,  " & _
		"		DECODE(v.COMPOUND_ID_FK,NULL,DECODE(v.REG_ID_FK, NULL, NULL, (select Cscartridge.MolWeight(to_clob(inv_vw_reg_structures.BASE64_CDX)) from dual)), Cscartridge.MolWeight(inv_compounds.base64_cdx)) as mw " & _
		"FROM	CHEMINVDB2.INV_VW_WELL v, cheminvdb2.inv_vw_reg_batches , inv_compounds " & _
		"		, cheminvdb2.inv_vw_reg_structures " & _
		"		, INV_UNITS UOM " & _
		"		, INV_UNITS UOC " & _
		"		, INV_UNITS UOW " & _
		"WHERE v.reg_id_fk = inv_vw_reg_batches.regid (+) " & _
		"		AND	v.batch_number_fk = inv_vw_reg_batches.batchnumber (+)  " & _	
		"		AND	inv_vw_reg_batches.regid = inv_vw_reg_structures.regid (+) " & _	
		"		AND v.compound_id_fk = compound_id (+) " &_
		"		AND v.qty_unit_fk = UOM.unit_id(+) " & _
		"		AND v.conc_unit_fk = UOC.unit_id(+) " & _
		"		AND v.weight_unit_fk = UOW.unit_id(+) " & _
		"		AND v.plate_id_fk = ? " & _
		"ORDER BY sort_order"
'		"		0 as mw " & _
'		"		cscartridge.molweight(DECODE(v.COMPOUND_ID_FK,NULL,structures.base64_cdx,inv_compounds.base64_cdx)) as mw " & _
else
	SQL =	"SELECT DISTINCT v.WELL_ID, " & _
		"		inv_compounds.REG_ID_FK, " & _
		"		inv_compounds.BATCH_NUMBER_FK, " & _
		"		(SELECT enum_value from inv_enumeration where enum_id = v.WELL_FORMAT_ID_FK) AS WellFormat, " & _
		"		v.CAS, " & _
		"		v.SUBSTANCE_NAME, " & _
		"		v.COMPOUND_ID_FK, " & _
		"		v.QTY_INITIAL, " & _
		"		v.QTY_REMAINING, " & _
		"		DECODE(v.Qty_Initial, NULL, NULL, v.Qty_Initial||' '||UOM.Unit_Abreviation) AS Amount_Initial, " & _
		"		DECODE(v.Qty_Remaining, NULL, NULL, v.Qty_Remaining||' '||UOM.Unit_Abreviation) AS Amount_Remaining, " & _
		"		v.WEIGHT, " & _
		"		DECODE(v.WEIGHT, NULL, NULL, v.WEIGHT||' '||UOW.Unit_Abreviation) AS Weight_String , " & _
		"		v.SOLVENT, " & _
		"		v.CONCENTRATION, " & _
		"		DECODE(v.concentration, NULL, NULL, v.concentration||' '||UOC.Unit_Abreviation) AS Concentration_String , " & _
		"		v.ROW_INDEX, " & _
		"		v.COL_INDEX, " & _
		"		v.ROW_NAME AS RowName," & _
		"		v.COL_NAME AS ColName, " & _
		"		v.NAME, " & _
		"		v.SORT_ORDER,  " & _
		"		Cscartridge.MolWeight(inv_compounds.base64_cdx) as mw " & _
		"FROM	CHEMINVDB2.INV_VW_WELL v, inv_compounds " & _
		"		, INV_UNITS UOM " & _
		"		, INV_UNITS UOC " & _
		"		, INV_UNITS UOW " & _
		"WHERE v.compound_id_fk = compound_id (+) " &_
		"		AND v.qty_unit_fk = UOM.unit_id(+) " & _
		"		AND v.conc_unit_fk = UOC.unit_id(+) " & _
		"		AND v.weight_unit_fk = UOW.unit_id(+) " & _
		"		AND v.plate_id_fk = ? " & _
		"ORDER BY sort_order"

end if

'show the benzene gif in case writing this xml island takes a long time
Response.Write "<DIV ID=""waitGIF"" ALIGN=""center""><img src=""" & Application("ANIMATED_GIF_PATH") & """ WIDTH=""130"" HEIGHT=""100"" BORDER=""""></DIV>"
Response.Flush

'Response.Write(SQL)
'Response.end
Call GetInvCommand(SQL, adCmdText)
Cmd.Parameters.Append Cmd.CreateParameter("PlateID", 131, 1, 0, plateID)
Set RS = Server.CreateObject("ADODB.Recordset")
RS.CursorLocation = aduseClient
RS.LockType = adLockOptimistic

RS.Open Cmd
RS.ActiveConnection = Nothing

RS.filter = "COL_INDEX=1"

rowName_arr = RS.GetRows(adGetRowsRest, , "RowName")

numRows = Ubound(rowName_arr,2) + 1 
RS.filter = 0
RS.Movefirst
RS.filter = "ROW_INDEX=1"
colName_arr = RS.GetRows(adGetRowsRest, , "ColName")
NumCols = Ubound(colName_arr,2) + 1
cellWidth = 600/NumCols
cellWidthLucidaChars = cellWidth/6
FldArray = split(lcase(displayFields),",")


'To fix CSBR-152262
fieldLength=0

With oString
.Append("<xml ID=""xmlDoc""><plate>")
For currRow = 1 to numRows
.Append(currRow&":test")
	For i = 0 to Ubound(FldArray)
		FldName = FldArray(i)
		RS.filter = 0
		RS.Movefirst
		RS.filter = "ROW_INDEX=" & currRow
		rowName = RS("ROWNAME")
		.Append("<"&cStr(FldName)&">"&vblf&"<rowname>"&rowname&"</rowname>")
		wellCriterion = Request("WellCriterion")
		if len(wellCriterion) > 0 then
			key = left(wellCriterion,instr(wellCriterion,",")-1)
			value = right(wellCriterion,len(wellCriterion) - instr(wellCriterion,","))
			.Append("key="&cStr(key)&":value="&cStr(value)&"<BR>")
			bCheckSelected = true
		end if

		While NOT RS.EOF
			well_ID = RS("well_id").value	
			theValue = RS(FldName).value
			'To fix CSBR-152262: Get the maximum length field and set fields length of the value to the max length and let it display the full value
			'Making this configurable through ini
			if len(theValue) > fieldLength and lcase(Application("UseDefaultPlateViewerCellSize")) = "false" then
				fieldLength = len(theValue)
				cellWidthLucidaChars = cellWidthLucidaChars + fieldLength
			end if
			isSelected = false
			if bCheckSelected then
				keyValue = RS(key).Value
				if isNull(keyValue) then keyValue = ""	
				if cstr(keyValue) = cstr(value) then isSelected = true
			end if
			strText = theValue
			Length = cellWidthLucidaChars
			colIndex = RS("COL_INDEX")
			.Append("<col"&cStr(colIndex)&"><![CDATA[")
			
	if (strText = "") OR IsNull(strText) then strText = "-"			
		str="<span"
	if (len(strText) > Length) AND (strText <> "&nbsp;") then
		.Append(str&" title="""&strText&"""><a style=""font-size:7pt;"" href=""ViewWellFrame.asp?wellID="&cStr(well_ID)&"&filter="&cStr(FldName)&""" target=""wellJSFrame"">"&cStr(left(strText, Length))&"</a>")
	else
		if isSelected then		
			.Append(str&"><a style=""font-size:7pt;"" class=""plateView"" style=""color:red;"" href= ""ViewWellFrame.asp?wellID="&cStr(well_ID)&"&filter="&cStr(FldName)&""" target=""wellJSFrame"">"&cStr(left(strText, Length))&"</a>")		
		else
			.Append(str&"><a style=""font-size:7pt;"" class=""plateView"" href=""ViewWellFrame.asp?wellID="&cStr(well_ID)&"&filter="&cStr(FldName)&""" target=""wellJSFrame"">"&cStr(left(strText, Length))&"</a>")										
		end if		
	end if	
			.Append("</span>]]></col"&cStr(colIndex)&">"&vblf)				

			RS.MoveNext		
		Wend
		.Append("</"&cStr(FldName)&">"&vblf)				

	Next
Next
End with

With oString
.Append("</plate></xml>")
xmlHtml = oString.ToString
End With
Set oString = Nothing

%>




