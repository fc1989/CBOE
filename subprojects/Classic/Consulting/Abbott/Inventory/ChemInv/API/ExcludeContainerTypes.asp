<%@ EnableSessionState=False Language=VBScript%>
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/ado.inc"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/server_const_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cheminv/api/apiUtils.asp"-->
<Script RUNAT="Server" Language="VbScript">
Dim Conn
Dim Cmd
Dim strError
Dim bWriteError
Dim PrintDebug
Dim LocationID


bDebugPrint = false
bWriteError = False
strError = "Error:DeleteLocation<BR>"

LocationID = Request("LocationID")
ContainerTypeIDList = Request("ContainerTypeIDList")
AllowContainers = Request("AllowContainers")
if AllowContainers = "true" then 
	pClear = 1 
else
	pClear = 0
end if
' Redirect to help page if no parameters are passed
If Len(Request.QueryString) = 0 AND Len(Request.Form)= 0 then
	Response.Redirect "/cheminv/help/admin/api/ExcludeContainerTypes.htm"
	Response.end
End if

'Echo the input parameters if requested
If NOT isEmpty(Request.QueryString("Echo")) then
	Response.Write "FormData = " & Request.form & "<BR>QueryString = " & Request.QueryString
	Response.end
End if

' Check for required parameters
If IsEmpty(LocationID) then
	strError = strError & "LocationID is a required parameter<BR>"
	bWriteError = True
End if
If IsEmpty(ContainerTypeIDList) OR ContainerTypeIDList = "" then
	ContainerTypeIDList = NULL
End if
If bWriteError then
	' Respond with Error
	Response.Write strError
	Response.end
End if

' Set up and ADO command
Call GetInvCommand(Application("CHEMINV_USERNAME") & ".Exclude_ContainerTypes", adCmdStoredProc)

' Code generated by QueryProcParams.asp helper page
Cmd.Parameters.Append Cmd.CreateParameter("RETURN_VALUE",adNumeric, adParamReturnValue, 0, NULL)
Cmd.Parameters("RETURN_VALUE").Precision = 9
Cmd.Parameters.Append Cmd.CreateParameter("PLOCATIONID",131, 1, 0, LocationID)
Cmd.Parameters("PLOCATIONID").Precision = 9
Cmd.Parameters.Append Cmd.CreateParameter("PCONTAINERTYPEIDLIST", 200, 1, 2000, ContainerTypeIDList)
Cmd.Parameters.Append Cmd.CreateParameter("PCLEAR", 200, 1, 2000, pClear)

if bDebugPrint then
	For each p in Cmd.Parameters
		Response.Write p.name & " = " & p.value & "<BR>"
	Next	
Else
	Call ExecuteCmd(Application("CHEMINV_USERNAME") & ".Exclude_ContainerTypes")
End if

' Return code
Response.Write Cmd.Parameters("RETURN_VALUE")

'Clean up
Conn.Close
Set Conn = Nothing
Set Cmd = Nothing
</SCRIPT>