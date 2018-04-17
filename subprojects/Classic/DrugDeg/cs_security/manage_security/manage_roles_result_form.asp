<%@ LANGUAGE=VBScript%>
<%Response.expires=0
'Copyright 1998-2001 CambridgeSoft Corporation All Rights Reserved
'DO NOT EDIT THIS FILE

if not dbkey <> "" then dbkey=request("dbname")
if Not Session("UserValidated" & dbkey) = 1 then  response.redirect "/" & Application("Appkey") & "/logged_out.asp"%>
<html>

<head>
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/cows_func_js.asp"-->
<!--#INCLUDE FILE = "../../source/secure_nav.asp"-->
<!--#INCLUDE FILE = "../../cs_security/admin_utils_vbs.asp"-->
<!--#INCLUDE FILE = "../../cs_security/admin_utils_js.js"-->

<%
formmode = UCase(request("formmode"))

%>



<title>Manage Roles </title>
</head>

<body <%=Application("BODY_BACKGROUND")%>>
<!--#INCLUDE FILE = "../../source/app_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/header_vbs.asp"-->
<!--#INCLUDE VIRTUAL ="/cfserverasp/source/recordset_vbs.asp"-->

<%'BaseID represents the primary key for the recordset from the base array for the current row
'BaseActualIndex is the actual id for the index the record is at in the array
'BaseRunningIndex if the id based on the number shown in list view
'BastTotalRecords is the recordcount for the array
'BaseRS (below is the recordset that is pulled for each record generated
on error resume next
	if formmode = "ADD_RECORD" then
		bAdd = true
		bUpdate = false
	else
		bAdd = false
		bUpdate = true
	end if
	
	uniqueid = BaseID
	commit_type = "full_commit_ns"
	PrivTable = Application("PRIV_TABLE_NAME")
	table_name = PrivTable
	Set DataConn = GetConnection(dbkey, formgroup, table_name)
	if DataConn.State=0 then ' assume user has been logged out
		DoLoggedOutMsg()
	end if
	if bUpdate = true then
		baseid_name = GetTableVal(dbkey, table_name, kPrimaryKey)
		datatype =getDataType(dbkey,  formgroup,  table_name & "." & baseid_name)
		delimiter = GetFieldDelimiter(datatype)
		sql = "Select * from " & table_name & " where " & baseid_name & "=" & delimiter&  BaseID & delimiter
		Set BaseRS = DataConn.Execute(sql)

	end if
	if bAdd = true then
		sql = "Select * from " & table_name
		Set BaseRS= DataConn.Execute(sql)
		BaseRS.MoveFirst
		sql = "Select * from security_roles"
		Set RolesRS= DataConn.Execute(sql)
		Do While NOT RolesRS.EOF
			if current_role_names <> "" then
				current_role_names = current_role_names & "," & RolesRS("ROLE_NAME")
			else
				current_role_names=RolesRS("ROLE_NAME")
			end if
			RolesRS.MoveNext
		loop
		CloseRS(RolesRS)
		sql = "Select Privilege_Table_ID from Privilege_Tables where Upper(privilege_table_name) = '" & UCase(Application("PRIV_TABLE_NAME")) & "'"
		Set SecurityRS =  DataConn.Execute(sql)
		if not (SecurityRS.BOF and SecurityRS.EOF) then
		Priv_table_id = SecurityRS("Privilege_Table_ID")
		end if
		CloseRS(SecurityRS)
	end if
	role_internal_ID = BaseRS("Role_internal_ID")
	sql = "select * from security_roles where role_ID=" & role_internal_ID
	Set RolesRS = DataConn.Execute(sql)
	if formmode = "EDIT_RECORD" then
		rolename_out = "raw_no_edit" 
	else
		rolename_out = "raw"
	end if
%>


<script language = "javascript">
formmode = "<%=formmode%>"
</script>







<table border = 0>
<tr><td>Role_Name</td><td><input type = "hidden" name = "Add_Order" value = "Security_Roles,<%=Application("PRIV_TABLE_NAME")%>"><input type = "hidden" name = "table_delete_order" value = "<%=Application("PRIV_TABLE_NAME")%>,Security_Roles"><%if UCase(formmode) = "EDIT_RECORD" then%>  
<input type = "hidden" name = "role_name" value = "<%=RolesRS("Role_Name")%>">
<%else%>
<input type = "hidden" name = "role_name" value = "">

<%end if%>
<input type = "hidden" name = "<%=Application("PRIV_TABLE_NAME")%>.Role_Internal_ID" value = "<%=RolesRS("Role_ID")%>"><%ShowResult dbkey, formgroup, RolesRS,"Security_Roles.Role_Name", rolename_out, "", "35"%></td></tr>
<input type = "hidden" name="Current_Role_Names" value= "<%=current_role_names%>"><input type = "hidden" name="Security_Roles.Privilege_Table_Int_ID" value= "<%=Priv_table_id%>">

<%

set field =BaseRS.Fields
on error resume next
for i =1 to BaseRS.Fields.Count-1 'skip i= 0 which is the role_internal_id
if not instr("CAMSOFT_LOG_ON:SET_APPROVED_FLAG:SET_QUALITY_CHECK_FLAG:TOGGLE_QUALITY_CHECK_FLAG:TOGGLE_APPROVED_FLAG",Field.Item(i).Name)>0 then
	fieldname = Field.Item(i).Name
	fullfieldname = Application("PRIV_TABLE_NAME") & "." & fieldname%>
	<tr><td> <%=fieldname%></td><td><%ShowResult dbkey, formgroup, BaseRS,fullfieldname, "raw", "CHECKBOX:0", "50%"%></td></tr>
<%end if%>
<%next%>
<%'the following fields are not shown to the user
if UCase(formmode) = "ADD_RECORD" then%>
<input type = "hidden" name = "<%=Application("PRIV_TABLE_NAME") & ".CAMSOFT_LOG_ON"%>" value="1">
<input type = "hidden" name = "<%=Application("PRIV_TABLE_NAME") & ".SET_QUALITY_CHECK_FLAG"%>" value="0">
<input type = "hidden" name = "<%=Application("PRIV_TABLE_NAME") & ".SET_APPROVED_FLAG"%>" value="0">
<input type = "hidden" name = "<%=Application("PRIV_TABLE_NAME") & ".TOGGLE_QUALITY_CHECK_FLAG"%>" value="0">
<input type = "hidden" name = "<%=Application("PRIV_TABLE_NAME") & ".TOGGLE_APPROVED_FLAG"%>" value="0">
<%AddtoRelLoadedFields(Application("PRIV_TABLE_NAME") & ".CAMSOFT_LOG_ON")
AddtoRelLoadedFields(Application("PRIV_TABLE_NAME") & ".SET_QUALITY_CHECK_FLAG")
AddtoRelLoadedFields(Application("PRIV_TABLE_NAME") & ".SET_APPROVED_FLAG")
AddtoRelLoadedFields(Application("PRIV_TABLE_NAME") & ".TOGGLE_QUALITY_CHECK_FLAG")
AddtoRelLoadedFields(Application("PRIV_TABLE_NAME") & ".TOGGLE_APPROVED_FLAG")%>
<%end if%>

</table>



	


<!--#INCLUDE VIRTUAL ="/cfserverasp/source/recordset_footer_vbs.asp"-->


<%CloseRS(BaseRS)
CloseConn(DataConn)%>

</body>
</html>























