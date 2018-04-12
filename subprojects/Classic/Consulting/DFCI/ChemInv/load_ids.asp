<%@ LANGUAGE="VBScript" %>
<%'Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved
'DO NOT EDIT THIS FILE%>
<html>
<head>
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/cows_func_vbs.asp" -->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/upload.asp"-->
<% dbkey="ChemInv" %>

<script language = "javascript">
var readFile =  ""
function dosubmit(){
if (document.formx.browsefile.value.length > 0){
	var fieldname = "<%=request("fieldname")%>"
	setCookie("Loadfieldname", fieldname, 1)
	document.formx.submit()
	

	}else{
		alert("please enter a full path before clicking the Load File button.")
	}
}

function setCookie(name,value,days_expires){
	//var today =new Date
	//var nowGMT = today.getTime()
	//expires = nowGMT + (1 * 24 * 60 * 60 * 1000)
	//var expires_date=new Date(expires)
	//expires_date = expires_date.toGMTString()
	//document.cookie = name + "="  + escape(value) + "; expires=" + expires_date
	expires_date=new Date 
	expires_date.setYear("2100")
	document.cookie = name + "="  + escape(value) + "; expires=" + expires_date.toGMTString() + ";"

	
}



function getCookie(name){
	var cname = name  + "=";
	var dc= document.cookie;
	if(dc.length > 0){
		begin = dc.indexOf(cname);
			if(begin != -1){
				begin += cname.length;
				end = dc.indexOf(";",begin);
					if(end == -1) end = dc.length;
						 temp = unescape(dc.substring(begin,end));
						 theResult = temp
						 
						  return theResult
			}
		}
	return null;	
}

</script>

<%Dim fieldname

Function SaveUploadAsFile(Fields)
stop

	dim Field
	For Each Field In Fields.Items
		If Field.FileName <> "" Then 'This field is uploaded file. Save the file in temp directory
			fileName = Field.FileName
			'SYAN modified on 2/14/2005 to fix CSBR-50932
			if Not (instr(UCase(fileName), ".TXT") > 0 or instr(UCase(fileName), ".SDF") > 0) then
			'End of SYAN modification
				fullfilename = "error"
			else
				'SYAN modified on 2/14/2005 to fix CSBR-50932
				Session("sdfFileName") = fileName
				'Begin: SM modified to fix CSBR-72282 
				if instr(UCase(fileName), ".SDF") > 0 then
					fullfilename = Application("TempFileDirectory" & dbkey) & "SessionDir" & "\" & CStr(Session.SessionID) & "\" & fileName 
				else
					fullfilename = Application("TempFileDirectory" & dbkey) & fileName 
				end if
				'End: SM modified to fix CSBR-72282 
				'End of SYAN modification
				Field.Value.SaveAs fullfilename
			end if
		End If
	Next
	SaveUploadAsFile=fullfilename
End Function

'after the submit button is click the this will be picked up and run. It gets the file name and reads the lines
'each line is added to a variable to create a comma delimeted string
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
	'filename = request.form("browsefile")
	Dim Upload
	Set Upload = GetUpload() 'function in upload.asp
	filename = SaveUploadAsFile(Upload)
	if filename <> "" then
		'SYAN modified on 2/14/2005 to fix CSBR-50932
		if instr(UCase(filename), "TXT") > 0 then
		'End of SYAN modification
			ReadAllTextFile=ReadFile(filename)
			'replace line feed, carriage return and tabs to commas
			'chr(10) line feed
			'chr(13) carriage return
			'chr(9) tab
			'chr(44) comma
			ReadAllTextFile = replace(ReadAllTextFile, Chr(10), Chr(44))
			ReadAllTextFile = replace(ReadAllTextFile, Chr(13), Chr(44))
			ReadAllTextFile = replace(ReadAllTextFile, Chr(9), Chr(44))
			On Error GoTo 0
			Upload = Empty
		'SYAN modified on 2/14/2005 to fix CSBR-50932
		elseif instr(UCase(filename), "SDF") > 0 then
			
			molServVer =  Application("MOLSERVER_VERSION")
			On Error GoTo 0
			set msdoc = Server.CreateObject("MolServer" & molServVer & ".Document")
			if err then
				On Error GoTo 0
				Response.Write "Error creating molserver while reading size of uploaded sdf"
			end if
			on error goto 0
			msdoc.open filename, 1, ""
			if err then
				On Error GoTo 0
				Response.Write "Error opening document while reading size of uploaded sdf"
			end if
			cnt = msdoc.count
			msdoc.close
			Set msdoc = Nothing
			ReadAllTextFile = cnt & " structures read"
		elseif filename = "error" then
		'End of SYAN modification
			ReadAllTextFile = "error"
		end if
	else
		ReadAllTextFile = "error"
	end if
	
	%>
	<script language = "javascript">
		//this variable is picked up in FilePicker_onload and place in reg_number.reg_number in the main window
		readFile =  "<%=ReadAllTextFile%>"
	</script>
<%end if%>
</head>
<BODY onload="FilePicker_onload()">
<script Language="JavaScript">
<!--
function FilePicker_onload(){
var strString = readFile

	if (readFile != "error"){
		var fieldname=getCookie("Loadfieldname")
		
		var objParent = window.opener;
		var theAction = "<%=Request.ServerVariables("REQUEST_METHOD")%>"
			if (theAction.toLowerCase() == "post"){
			
				var myField = objParent.document.forms["cows_input_form"].elements[fieldname]
				myField.value = strString
				myField.focus()
				
				//SYAN added on 3/4/2005 to fix CSBR-50932
				if (typeof(objParent.document.forms["cows_input_form"].elements['MultipleExactSearch']) != 'undefined' && fieldname.indexOf('.SDF') != -1) {
					objParent.document.forms["cows_input_form"].elements['MultipleExactSearch'].value = fieldname;
				}
				//End of SYAN modification
				close();
			}
	}else
		{
		alert("Invalid file extension.")
			window.close();
		}
}

//-->
</script>

<form name = "formx" action="Load_IDs.asp" method="post"  ENCTYPE="multipart/form-data">
Click browse to select a text file containing ids or a sd-file containing query molecules.
<table border = "1"><tr><td nowrap>
			<input type="file" name="browsefile" onChange="dosubmit()" size = "30">
			
				<font face="Arial" size="2" color="#182889"><strong>
				<input type="button" value="Load File" onClick="dosubmit()">
				<input type="hidden" value="fieldname" value = "<%=fieldname%>">
				<input type="hidden" value="dbname" value = "<%=dbkey%>" ID="Text1" NAME="Text1"></font></strong>
			
			
			</td></tr></table>
</form>



<%Function detectIE6()
	IEBrowser = false

	UserAgent = Request.ServerVariables("HTTP_USER_AGENT")
			'response.write UserAgent

		If InStr(UCASE(UserAgent), "MSIE")>0 then
			If InStr(UCASE(UserAgent), "6.")>0 then
				IEBrowser = true
			end if
		end if
		'IEBrowser = false
	detectIE6 = IEBrowser
End Function

Function detectNetscape()
	Netscape = false

	UserAgent = Request.ServerVariables("HTTP_USER_AGENT")

		If NOT InStr(UCASE(UserAgent), "MSIE")>0 then
			Netscape = true
		end if
		
	detectNetscape = Netscape
End Function

Function ReadFile(filename)
   Const ForReading = 1, ForWriting = 2
   Dim fso, MyFile
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set MyFile = fso.OpenTextFile(filename, ForReading, True)
   Do While MyFile.AtEndOfStream <> True
   currentLine = myFile.ReadLine
		if finalRead <> "" then
			finalRead = finalRead & "," & Trim(currentLine)
		else
			finalRead = Trim(currentLine)
		end if
	loop
	
	finalRead = replace(finalRead, ",,", ",")
	finalRead = replace(finalRead, " ", "")
	rightmost_char = Right(finalRead,1)
	if rightmost_char = "," then
		string_len = Len(finalRead)
		finalRead = Mid(finalRead,1,string_len-1)
	end if
	ReadFile =finalRead

End Function
%>
</body>
</html>