<%'Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved
'DO NOT EDIT THIS FILE%>
<%Session("LastCurrentLocation" & dbkey & formgroup) = Session("CurrentLocation" & dbkey & formgroup)
Session("CurrentLocation" & dbkey & formgroup) = request.servervariables("path_info") & "?"  & request.servervariables("query_string")
if UCase(formmode) = "SEARCH" then
	defaultaction = "search"
	default_action_path = Application("ActionForm" & dbkey)& "?formmode=" & request("formmode") & "&formgroup="& request("formgroup") & "&dataaction=" & defaultaction & "&dbname=" & request("dbname")
else
	default_action_path=Session("CurrentLocation" & dbkey & formgroup)
end if
%>


<!--#INCLUDE VIRTUAL = "/cfserverasp/source/cows_func_vbs.asp" -->


<%
Select Case UCase(formmode)
	Case "SEARCH"
%>
<form name="cows_input_form" method="post" Action="<%=default_action_path%>" onsubmit="getAction('search');return false;" >
	<%If DetectIE = true then%>
	<input Type="Image"  name="default_action_image" src="/cfserverasp/source/graphics/navbuttons/pixel.gif" border="0" WIDTH="1" HEIGHT="1">
	<%end if%>
<%Case "REFINE"%>
<form name="cows_input_form" method="post" Action="<%=default_action_path%>" onsubmit="getAction('apply');return false;" >
	<%If DetectIE = true then%>
	<input Type="Image"  name="default_action_image" src="/cfserverasp/source/graphics/navbuttons/pixel.gif" border="0" WIDTH="1" HEIGHT="1">
	<%end if%>
<%Case Else%>
	<form name="cows_input_form" method="post" Action="<%=default_action_path%>">
<%End Select%>

<input type = "hidden" name="CurrentLocation" value ="<%=Session("CurrentLocation" & dbkey & formgroup)%>">
<input Type="hidden"  name="blank_cdx" value = "<%=Application("blank_cdx")%>">

<input type = "hidden" name="LastCurrentLocation" value ="<%=Session("LastCurrentLocation" & dbkey & formgroup)%>">
<input type="hidden" name="CurrentRecord" value = "<%=Session("CurrentRecord" & dbkey & formgroup)%>">
<input type="hidden" name="RefineType" value="<%=request.querystring("refinetype")%>">
<input type="hidden" name="MarkedHit" value="">
<input type="hidden" name="DataAction" value="">
<input type="hidden" name="version" value="">
<input type="hidden" name="Plugin" value = "<%=Session("Plugin" & dbkey & formgroup)%>">
<input type="hidden" name="Mac3" value="">
<input type="hidden" name="DBName" value="<%=dbkey%>">
<input type="hidden" name="SubSearchFields" value="">
<input type="hidden" name="ExactSearchFields" value="">
<input type="hidden" name="SimSearchFields" value="">
<input type="hidden" name="IdentitySearchFields" value="">
<input type="hidden" name="FormulaSearchFields" value="">
<input type="hidden" name="MolWeightSearchFields" value="">
<input type="hidden" name="RelationalSearchFields" value="">
<input type="hidden" name="SQLEngine" value="CFW">
<input type="hidden" name="SearchStrategy" value="">

<input type = "hidden" name = "CurrentIndex" Value = <%=Request.QueryString("BaseCurrentIndex")%>>
<input type = "hidden" name = "NumberListView" Value = <%=GetFormGroupVal(dbkey, formgroup, kNumListView)%>>
<input type = "hidden" name = "RecordCount" Value = <%=Session("Base_RSRecordCount" & dbkey & formgroup)%>>
<input type="hidden" name="CurrentSingleRecord" value = "<%=Request.QueryString("BaseCurrentRecord")%>">
<input type = "hidden" name = "row_id_table_names" value = "">

<script language = "javascript">
table_names = "<%=Application("TableNames" & dbkey)%>"
table_names_array = table_names.split(",")
for (i=0;i<table_names_array.length;i++){

	document.write ('<input type = "hidden" name ="' + table_names_array[i].toLowerCase() + '_ROW_IDS" value = "">')
}
</script>
<%'formgroup=Request.QueryString("formgroup")
formgroupflag = GetFormGroupVal(dbkey, formgroup, kFormGroupFlag)
if formgroupflag= "GLOBAL_SEARCH"then
	Select Case UCase(formmode)
		' DGB 06/2003 look for a comma in SearchDBNames to show multiDB controls
		Case "LIST", "EDIT"
			if inStr(Session("SearchData" & "SearchDBNames"), ",")>0 then
				GetMultiDBResultList formmode, formgroup 
				
			end if
		Case "SEARCH", "REFINE"
			if inStr(Application("GlobalSearchDBs"), ",")>0 then
				GetMultiDBSelectList()
			else
				'DJP 06/2004 If there is only one db in a global search formgroup then hide the search button
				Response.Write "<span style=""display:none"">"
				GetMultiDBSelectList()
				Response.Write "</span>"
			end if
	end Select
end if
%>