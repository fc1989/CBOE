<%@ EnableSessionState=False Language=VBScript%>
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/ado.inc"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/server_const_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cheminv/api/apiUtils.asp"-->
<Script RUNAT="Server" Language="VbScript">
Dim Conn
Dim Cmd
Dim strError
Dim bWriteError
Dim bDebugPrint

bDebugPrint = false
bWriteError = False
strError = "Error:ApproveContainer<BR>"

ApprovedRequestIDList = Request("ApprovedRequestIDList")
DeclinedRequestIDList = Request("DeclinedRequestIDList")
DeclineReasonList = Request("DeclineReasonList")

' Redirect to help page if no parameters are passed
If Len(Request.QueryString) = 0 AND Len(Request.Form)= 0 then
	Response.Redirect "/cheminv/help/admin/api/ApproveContainer.htm"
	Response.end
End if

'Echo the input parameters if requested
If NOT isEmpty(Request.QueryString("Echo")) then
	Response.Write "FormData = " & Request.form & "<BR>QueryString = " & Request.QueryString
	Response.end
End if

' Check for required parameters
If IsEmpty(ApprovedRequestIDList) and IsEmpty(DeclinedRequestIDList) then
	strError = strError & "Either ApprovedRequestIDList or DeclinedRequestIDList is a required parameter<BR>"
	bWriteError = True
End if

If bWriteError then
	' Respond with Error
	Response.Write strError
	Response.end
End if

' Set up and ADO command
Call GetInvCommand(Application("CHEMINV_USERNAME") & ".Requests.ApproveAndDeclineRequests", adCmdStoredProc)
Cmd.Parameters.Append Cmd.CreateParameter("RETURN_VALUE",200, adParamReturnValue, 2000, NULL)
Cmd.Parameters("RETURN_VALUE").Precision = 9			
Cmd.Parameters.Append Cmd.CreateParameter("PAPPROVEDREQUESTIDLIST",200, adParamInput, 2000, ApprovedRequestIDList) 
Cmd.Parameters.Append Cmd.CreateParameter("PDECLINEREQUESTLIST",200, adParamInput, 2000, DeclinedRequestIDList) 
Cmd.Parameters.Append Cmd.CreateParameter("PDECLINEREASONLIST",200, adParamInput, 255, DeclineReasonList) 
if bDebugPrint then
	For each p in Cmd.Parameters
		Response.Write p.name & " = " & p.value & "<BR>"
	Next	
Else
	Call ExecuteCmd(Application("CHEMINV_USERNAME") & ".Requests.ApproveAndDeclineRequests")
End if

' Return code
Response.Write Cmd.Parameters("RETURN_VALUE")

'Clean up
Conn.Close
Set Conn = Nothing
Set Cmd = Nothing
</SCRIPT>