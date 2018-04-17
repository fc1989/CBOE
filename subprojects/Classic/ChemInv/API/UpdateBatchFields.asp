<%@ EnableSessionState=False Language=VBScript%>
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/ado.inc"-->
<!--#INCLUDE VIRTUAL = "/cheminv/api/apiUtils.asp"-->
<Script RUNAT="Server" Language="VbScript">
Dim Conn
Dim Cmd
Dim strError
Dim bWriteError
Dim bDebugPrint

bDebugPrint = false
bWriteError = false
strError = "Error:UpdateBatchFields<BR>"
field1 = Request("field1")
field2 = Request("field2")
field3 = Request("field3")
displayName1 = Request("displayName1")
displayName2 = Request("displayName2")
displayName3 = Request("displayName3")
field1_2 = Request("field1_2")
displayName1_2 = Request("displayName1_2")
field2_2 = Request("field2_2")
displayName2_2 = Request("displayName2_2")
field3_2 = Request("field3_2")
displayName3_2 = Request("displayName3_2")

field1_3 = Request("field1_3")
displayName1_3 = Request("displayName1_3")
field2_3 = Request("field2_3")
displayName2_3 = Request("displayName2_3")
field3_3 = Request("field3_3")
displayName3_3= Request("displayName3_3")
' Redirect to help page if no parameters are passed
If Len(Request.QueryString) = 0 AND Len(Request.Form)= 0 then
	Response.Redirect "/cheminv/help/admin/api/UpdateBatchFields.htm"
	Response.end
End if

'Echo the input parameters if requested
If NOT isEmpty(Request.QueryString("Echo")) then
	Response.Write "FormData = " & Request.form & "<BR>QueryString = " & Request.QueryString
	Response.end
End if

' Check for required parameters
If IsEmpty(field1) then
	strError = strError & "Field1 is a required parameter<BR>"
	bWriteError = True
End if
If IsEmpty(displayField1) then
	strError = strError & "DisplayField1 is a required parameter<BR>"
	bWriteError = True
End if

' Set up and ADO command
Call GetInvCommand(Application("CHEMINV_USERNAME") & ".Batch.UpdateBatchingFields", adCmdStoredProc)
Cmd.Parameters.Append Cmd.CreateParameter("pField1", 200 , adParamInput, 50, field1)
Cmd.Parameters.Append Cmd.CreateParameter("pField2", 200 , adParamInput, 50, field2)
Cmd.Parameters.Append Cmd.CreateParameter("pField3", 200 , adParamInput, 50, field3)
Cmd.Parameters.Append Cmd.CreateParameter("displayName1", 200 , adParamInput, 50, displayName1)
Cmd.Parameters.Append Cmd.CreateParameter("displayName2", 200 , adParamInput, 50, displayName2)
Cmd.Parameters.Append Cmd.CreateParameter("displayName3", 200 , adParamInput, 50, displayName3)
Cmd.Parameters.Append Cmd.CreateParameter("p_field1_2", 200 , adParamInput, 50, field1_2)
Cmd.Parameters.Append Cmd.CreateParameter("p_displayName1_2", 200 , adParamInput, 50, displayName1_2)
Cmd.Parameters.Append Cmd.CreateParameter("p_field2_2", 200 , adParamInput, 50, field2_2)
Cmd.Parameters.Append Cmd.CreateParameter("p_displayName2_2", 200 , adParamInput, 50, displayName2_2)
Cmd.Parameters.Append Cmd.CreateParameter("p_field3_2", 200 , adParamInput, 50, field3_2)
Cmd.Parameters.Append Cmd.CreateParameter("p_displayName3_2", 200 , adParamInput, 50, displayName3_2)
Cmd.Parameters.Append Cmd.CreateParameter("p_field1_3", 200 , adParamInput, 50, field1_3)
Cmd.Parameters.Append Cmd.CreateParameter("p_displayName1_3", 200 , adParamInput, 50, displayName1_3)
Cmd.Parameters.Append Cmd.CreateParameter("p_field2_3", 200 , adParamInput, 50, field2_3)
Cmd.Parameters.Append Cmd.CreateParameter("p_displayName2_3", 200 , adParamInput, 50, displayName2_3)
Cmd.Parameters.Append Cmd.CreateParameter("p_field3_3", 200 , adParamInput, 50, field3_3)
Cmd.Parameters.Append Cmd.CreateParameter("p_displayName3_3", 200 , adParamInput, 50, displayName3_3)
if bDebugPrint then
	For each p in Cmd.Parameters
		Response.Write p.name & " = " & p.value & "<BR>"
	Next	
Else
	Call ExecuteCmd(Application("CHEMINV_USERNAME") & ".Batch.UpdateBatchingFields")
End if

if err.number = 0 then
	Response.Write "1"
    Set Cmd = nothing
    '-- update batch fields dict which stores the batching fields and their display name
	Dim RS
	Set Cmd = Server.CreateObject("ADODB.Command")
	Set Cmd.ActiveConnection = Conn
	Cmd.CommandText = "{CALL " & Application("CHEMINV_USERNAME") & ".BATCH.GETBATCHFIELDS()}"
	Cmd.CommandType = adCmdText

    Cmd.Properties ("PLSQLRSet") = TRUE  
    Set RS = Cmd.Execute
    Cmd.Properties ("PLSQLRSet") = FALSE
    
	Application.Lock
    call isaRegBatch(rs)
    batching_fields_dict.RemoveAll
    while not RS.EOF
        batching_fields_dict.add cstr(RS("sort_order"))&"_"&cstr(RS("BATCH_TYPE_ID_FK")), cstr(RS("display_name"))
        RS.MoveNext
    wend
    Application.UnLock
	
else
	Response.Write "0"
end if

'Clean up
Conn.Close
Set Conn = Nothing
Set Cmd = Nothing
</SCRIPT>