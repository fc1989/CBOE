<!--#INCLUDE VIRTUAL = "/cfserverasp/source/ado.inc"-->
<!--#INCLUDE VIRTUAL = "/cheminv/gui/GetContainerAttributes.asp"-->
<!--#INCLUDE VIRTUAL = "/cheminv/custom/gui/GetEHSAttributes.asp"-->
<!--#INCLUDE VIRTUAL = "/cheminv/gui/guiUtils.asp"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/display_func_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/server_const_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/search_func_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/csdo_utils_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cheminv/gui/compound_utils_vbs.asp"-->
<!--#INCLUDE VIRTUAL = "/cheminv/api/apiUtils.asp"-->
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/xml_source/RS2HTML.asp"-->
<%
dbkey = "ChemInv"%>
<html>
<head>
<title><%=Application("appTitle")%> -- Create a New Inventory Container</title>
<script language="javascript" type="text/javascript" src="/cheminv/Choosecss.js"></script>
<script language="javascript" type="text/javascript" src="/cheminv/utils.js"></script>
<script language="javascript" type="text/javascript" src="CalculateFromPlugin.js"></script>
<script language="javascript" type="text/javascript" src="/cheminv/gui/refreshGUI.js"></script>
<% if Session("isCDP") = "TRUE" then %>
<script language="javascript" type="text/javascript" src= "/cfserverasp/source/chemdraw.js"></script>
<script language="javascript" type="text/javascript">cd_includeWrapperFile("/cfserverasp/source/")</script>
<% end if %>
<script language="javascript" type="text/javascript" >
<!--Hide JavaScript
   var cd_plugin_threshold= <%=Application("CD_PLUGIN_THRESHOLD")%>;
   var CD_AUTODOWNLOAD_PLUGIN = "<%=APPLICATION("CD_PLUGIN_DOWNLOAD_PATH")%>";
   var ContainerName = "<%=replace(ContainerName,vbLf, "'\n'")%>"  
   var LocationID = "<%=LocationID%>"
   // Posts the form when a tab is clicked
   /*function postDataFunction(sTab) {
	document.form1.action = "ViewContainer.asp?TB=" + sTab
	document.form1.submit()
	}*/
	//DJP: this is a copy of a function in navbar_js that is necessary for chemdraw_js to check for the plugin properly
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
	function getsource()
	{
		var thesource= "view-source:" + window.location.href;
		window.location= thesource;
	}
	
	// move the menu over to the right so it doesn't render below the CD control
	if( cd_getBrowserVersion() <= 6 )
	{
	    AlterCSS('.firstList','margin','0px 0px 0px 100px');
	}
	else if( cd_getBrowserVersion() >= 7 )
	{
	    // IE7 handles the spacing differently from previous versions
	    AlterCSS('.firstList','margin','0px 0px 0px 200px');
	}
	
//-->
</script>
</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
 <% 'This Check is here to stop loading DHTML menu while viewing a Container from a Batch.
  if Session("isBatchSearch") = "" Then 
    if Application("UseCustomTabFrameLinks") then%>
	    <!--#INCLUDE VIRTUAL = "/cheminv/custom/gui/tab_frame_links.asp"-->
    <%else%>
	    <!--#INCLUDE VIRTUAL = "/cheminv/gui/tab_frame_links.asp"-->
    <%end if%>
 <%END IF%>   
<div style="border-bottom-color:#CFD8E6; border-left-color:#fff; border-top-color:#fff; border-style: solid; border-left-width: 0px; border-bottom-width: 2px; border-right-width: 0px;">
<!--#INCLUDE VIRTUAL = "/cheminv/gui/ContainerViewTabs.asp"-->
</div>
<form name="form1" action="echo.asp" xaction="NewLocation_action.asp" method="POST">
<input type="hidden" name="ContainerID" value="<%=ContainerID%>">
<table border="0">
	<tr>
		<td>
<%
'Response.Write sTab
Select Case sTab
	Case "Summary"

		Set oTemplate = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.4.0")
		oTemplate.load(server.MapPath("/" & Application("AppKey") & "/config/xml_templates/ViewContainer_Summary.xml"))
		Set mainTable = oTemplate.selectSingleNode("/DOCUMENT/DISPLAY/TABLE_ELEMENT")
		'Response.Write mainTable.xml & "=xml<BR>"
		'Set newNode = oTemplate.createNode(1, "FIELD", "")

		if BatchID <> "" then
		    '-- adds the batch amount as the last element
			Set currentUserNode = oTemplate.selectSingleNode("/DOCUMENT/DISPLAY/TABLE_ELEMENT/FIELD[last()]")
			'create the node, can't call the core function "CreateFieldNode" b/c need to create a cdata section
			Set newNode = oTemplate.createNode(1, "FIELD", "")
			With newNode
				.setAttribute "VALUE_COLUMNS", "TOTALBATCHAMT,BATCH_ID_FK"
				.setAttribute "VALUE_CLASS", "GrayedText"
				.setAttribute "HEADER_NAME", ""
				.setAttribute "HEADER_CLASS", ""
				.setAttribute "SORT_COLUMN", ""
				.setAttribute "DISPLAY_NAME", "Batch Amount:"
				.setAttribute "NAME_CLASS", "RightAlign"
				.setAttribute "COLSPAN", "1"
				.setAttribute "WIDTH", ""
				.setAttribute "HEIGHT", ""
				.setAttribute "SHOW", "1"
			end with

			Set newNode2 = oTemplate.createNode(4,"test","") 'CDATA node
			Text = "<a class=""MenuLink"" href=""#"" title=""Batch Amount"" onclick=""OpenDialog('/Cheminv/GUI/ViewBatchInfo.asp?BatchID=#BATCH_ID_FK#', 'MenuDiag', 2); return false;"" onmouseover=""javascript:this.style.cursor='hand';"" onmouseout=""javascript:this.style.cursor='default';"">#TOTALBATCHAMT#</a>"
			newNode2.text = Text
			newNode.appendChild(newNode2)
			'Set currNode = mainTable.insertBefore(newNode,currentUserNode)
			Set currNode = mainTable.appendChild(newNode)
			Set newNode = nothing
			Set newNode2 = nothing
		end if
		For each key in custom_fields_dict
			Set newNode = CreateFieldNode(oTemplate, ucase(key), "GrayedText", null, null, null, custom_fields_dict.Item(key) & ":", "RightAlign", 1, null, null, 1, "#" & ucase(key) & "#")
			Set currNode = mainTable.insertBefore(newNode,null)
		Next
		if Application("ShowCertify") = "TRUE" then
			Set currentUserNode = oTemplate.selectSingleNode("/DOCUMENT/DISPLAY/TABLE_ELEMENT/FIELD[@VALUE_COLUMNS='CURRENT_USER_ID_FK']")
			Set newNode = CreateFieldNode(oTemplate, "DATE_CERTIFIED", "GrayedText", null, null,null, "Date Certified:", "RightAlign", 1, null, null, 1, "#DATE_CERTIFIED#")
			Set currNode = mainTable.insertBefore(newNode,currentUserNode)
			Set newNode2 = CreateFieldNode(oTemplate, "DATE_APPROVED", "GrayedText", null, null,null, "Date Approved:", "RightAlign", 1, null, null, 1, "#DATE_APPROVED#")
			Set currNode2 = mainTable.insertBefore(newNode2, currentUserNode)
		end if
		'expiration date goes in red if its passed
		if isDate(expDate) then
			if cDate(expDate) < date() then
				Set currentUserNode = oTemplate.selectSingleNode("/DOCUMENT/DISPLAY/TABLE_ELEMENT/FIELD[@VALUE_COLUMNS='DATE_EXPIRES']")
				currentUserNode.text = "<span class=""required"">#DATE_EXPIRES#</span>"
			end if
		end if
		'-- show RegCAS if it exists
		if not isEmpty(RegCAS) then
			Set currentUserNode = oTemplate.selectSingleNode("/DOCUMENT/DISPLAY/TABLE_ELEMENT/FIELD[@VALUE_COLUMNS='CAS']")
			currentUserNode.text = RegCAS
		end if
		'if there is no plugin generate a gif for the structure
		if Session("isCDP") <> "TRUE" then
		'if true then
			Set currentUserNode = oTemplate.selectSingleNode("/DOCUMENT/DISPLAY/FIELD[1]/@IS_STRUCTURE")
			currentUserNode.text = "0"
			Set currentUserNode = oTemplate.selectSingleNode("/DOCUMENT/DISPLAY/FIELD[1]")
			SessionDir = Application("TempFileDirectory" & "ChemInv") & "Sessiondir"  & "\" & Session.sessionid & "\"
			fileURL = SessionURLDir & "structure" & "_" & 160 & "x" & 140 & ".gif"
			ConvertCDXtoGif_Inv filePath, BASE64_CDX, 160, 140
			SessionURLDir = "chemoffice" & Application("TempFileDirectoryHTTP" & "ChemInv") & "Sessiondir"  & "/" & Session.sessionid & "/"
			fileURL = "/" & SessionURLDir & "structure" & "_" & CompoundID & "_" & 160 & "x" & 140 & ".gif"
			currentUserNode.text = "<img src=""" & fileURL & """ width=""160"" height=""140"" border=""1"">"
		end if

		'oTemplate.save "c:\temp\test.xml"
		'Set currNode = mainTable.insertBefore(newNode,null)

		'HTML = RS2HTML(RS,oTemplate,null,null,null,null,null,null,null)

		HTML = DOM2HTML(Session("oViewContainerData"), oTemplate)
		Response.Write HTML
%>
		</td>
		<td valign ="bottom">
			<table border="0">
				<tr>
					<td>
						<%
						if BatchID <> "" then
						    GetURLs BatchID, "inv_container_batches", "batch_id", "", "", "", "Batch Links"
						end if
						GetURLs ContainerID, "inv_containers", "container_id", "", "", "", "Container Links"
						%>
					</td>
				</tr>
				<tr>
					<td>
						<!--#INCLUDE VIRTUAL = "/cheminv/custom/gui/custom_container_links.asp"-->
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<%
Case "Substance"
	'this is an inventory substance.  Show details form inv_compounds table

if Session("isCDP") = "TRUE" then
%>
<script language="javascript" type="text/javascript">
<!--
// calculates the formula and molw from plugin data
	var holdTime = 3000;
	if (cd_getBrowserVersion() >= 6) holdTime = 1;
	window.onload = function(){setTimeout("GetFormula();GetMolWeight();",holdTime)}
//-->
</script>
<%
end if
%>

<center>
<table border="0" cellspacing=0 cellpadding=0>
	<tr>
		<td>
<%

	if NOT IsEmpty(CompoundID) then
		GetSubstanceAttributesFromDb(CompoundID)
		hdrText = ""
		bConflicts = false
		if ConflictingFields <> "" then
			hdrText = "<font color=red>Warning: Duplicate Substance</font>"
			bConflicts = true
		End if
		if dbstructure <> "" then
			inLineStruc = inLineMarker & dBStructure
		else
			inLineStruc = ""
		end if

        DisplaySubstance "", hdrText, false, false, false, false, bConflicts, inLineStruc
		'DisplaySubstance "", hdrText, false, false, false, false, bConflicts, inLineMarker & dBStructure


%>
	</td>
	<td valign="bottom">
			<table border="0">
				<tr>
					<td>
						<%
						GetURLs CompoundID, "inv_compounds", "compound_id", "", "", "", "Compound Links"
						%>
					</td>
				</tr>
				<tr>
					<td>
						<!--#INCLUDE VIRTUAL = "/cheminv/custom/gui/custom_compound_links.asp"-->
					</td>
				</tr>
				<%If Session("INV_MANAGE_LINKS" & dbkey) then%>
					<%'SYAN added 11/17/2003 to link to docmanager%>
					<%IF CBool(Application("SHOW_DOCMANAGER_LINK")) then%>
						<%if Session("SEARCH_DOCS" & dbkey) then%>
						<%If Session("SUBMIT_DOCS" & dbkey) then%>
						<tr>
							<td>
								<a class="MenuLink" href="Manage%20Documents%20for%20this%20substance" onclick="OpenDialog('/cheminv/gui/manageDocuments.asp?FK_value=<%=CompoundID%>&FK_name=COMPOUND_ID&Table_Name=INV_COMPOUNDS&LINK_TYPE=CHEMINVCOMPOUNDID', 'Documents_Window', 2); return false;" title="Manage documents associated to this compound">Manage Documents</a>
							</td>
						</tr>
						<%else%>
						<tr>
							<td>
								<a class="MenuLink" href="Manage%20Documents%20for%20this%20substance" onclick="alert('You do not have the appropriate privileges to add or view documents. Please ask the administrators to grant you DOCMGR_EXTERNAL role and log back in to try again.'); return false;">Manage Documents</a>
							</td>
						</tr>
						<%end if%>
						<%end if%>
					<%end if%>
					<%'End of SYAN modification%>
				<tr>
					<td>
						<a class="MenuLink" href="Manage%20Links%20for%20this%20container" onclick="OpenDialog('/cheminv/gui/manageLinks.asp?FK_value=<%=CompoundID%>&FK_name=COMPOUND_ID&Table_Name=INV_COMPOUNDS', 'Links_Window', 2); return false;" title="Manage links associated to this compound">Manage Links</a>
					</td>
				</tr>
				<%end if%>
				<%if CompoundID <> "" then%>
				<tr>
					<td>
						<a class="MenuLink" href="Lookup synonyms for this substance" onclick="OpenDialog('/cheminv/cheminv/Synlookup.asp?CompoundID=<%=CompoundID%>&recordNum=1', 'Diag', 3); return false;" title="Look up synonyms for this substance">Synonyms</a></td>
					</td>
				</tr>
				<%  If Session("INV_MANAGE_SUBSTANCES" & dbkey) then %>
				<tr>
					<td>
						<a class="MenuLink" href="Manage this substance" onclick="OpenDialog('/cheminv/gui/CreateOrEditSubstance.asp?ManageMode=2&action=edit&CompoundID=<%=CompoundID%>', 'Diag', 2); return false;" title="Manage this substance">Manage Substance</a></td>
					</td>
				</tr>
				<%
				    end if
				end if
				%>
			</table>
		</td>
	</tr>
</table>
<%
	Else
		Response.Write "<BR><BR><span class=""GUIFeedback"">No substance associated with this container</span></td></tr></table>"
	End if%>
</center>
<%
'-- REGISTRATION SUBSTANCE TAB
'-- -----------------------------------------------------------------------
Case "RegSubstance"
%>

<%if Session("isCDP") = "TRUE" then%>
<SCRIPT LANGUAGE=javascript>
<!--
// calculates the formula and molw from plugin data
	var holdTime = 3000;
	if (cd_getBrowserVersion() >= 6) holdTime = 1;
	window.onload = function(){setTimeout("GetFormula();GetMolWeight();",holdTime)}
//-->
</SCRIPT>
<%end if%>
<table border="0">
	<tr>
		<td>
			<table border="1">
				<tr>
					<!-- Structure -->
					<td>
						<%
						if Session("isCDP") = "TRUE" then
							specifier = 185
						else
							specifier = "185:gif"
						end if
						Base64DecodeDirect "invreg", "base_form_group", BASE64_CDX, "Structures.BASE64_CDX", RegID, RegID, specifier, 130
						'=ShowRegStructure(RegID, 130,185)
						%> &nbsp;</td>
				</tr>
			</table>
		</td>
		<td valign="top">
			<table border="0" cellpadding="1" cellspacing="2">
			<tr><!-- Header Row -->
					<td colspan="4" align="center">
						&nbsp;<em><b><%=TruncateInSpan(RegName, 50, "")%></b></em>
					</td>
				</tr>
				<tr>
					<%=ShowField("Molecular Weight:", "MOLWEIGHT0", 15, "MOLWEIGHT0")%>
					<%=ShowField("Molecular Formula:", "FORMULA0", 15, "FORMULA0")%>
				</tr>
				<%
				k = 0
				for each key in reg_fields_dict
					if key <> "BASE64_CDX" and key <> "REGNAME" then
						if k = 0 then
							Response.Write("<tr>")
						end if
						if key = "REGBATCHID" then
							tempstr = "<td align=right valign=top nowrap>"
							tempstr = tempstr & reg_fields_dict.item(key)
							tempstr = tempstr & "</td>"
							tempstr = tempstr & "<td class=""grayBackground"" align=right>"	
							tempstr2 = "<A CLASS=""MenuLink"" HREF=""/cheminv/gui/ViewRegDetails.asp?reg_number=" & regnumber & """  TITLE=""Registration Details"" target=""_blank"">" & Eval(key) &" </a>"
							tempstr= tempstr & tempstr2
							tempstr= tempstr & "</td>"
							Response.Write tempstr 		
						else
						Response.Write(ShowField(reg_fields_dict.item(key), key, 15, ""))
						end if 
						if k = cInt(1) then
							Response.write("</tr>")
							k = 0
						else
							k = k + 1
						end if
					end if
				next
				%>
			</table>
		</td>
	</tr>
</table>
<%
'-- SUPPLIER TAB
'-- -----------------------------------------------------------------------
	Case "Supplier"
		Set oTemplate = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.4.0")
		oTemplate.load(server.MapPath("/" & Application("AppKey") & "/config/xml_templates/ViewContainer_Supplier.xml"))
		'only show supplier contact information to users with
		if Session("INV_EDIT_CONTAINER" & dbkey) then
			Set mainTable = oTemplate.selectSingleNode("/DOCUMENT/DISPLAY/TABLE_ELEMENT")
			Set newNode = CreateFieldNode(oTemplate, "CONTACTNAME", "GrayedText", null, null, null, "Contact Name:", "RightAlign", 1, null, null, 1, "#CONTACTNAME#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "ADDRESS1", "GrayedText", null, null, null, "Address 1:", "RightAlign", 1, null, null, 1, "#ADDRESS1#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "ADDRESS2", "GrayedText", null, null, null, "Address 2:", "RightAlign", 1, null, null, 1, "#ADDRESS2#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "ADDRESS3", "GrayedText", null, null, null, "Address 3:", "RightAlign", 1, null, null, 1, "#ADDRESS3#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "ADDRESS4", "GrayedText", null, null, null, "Address 4:", "RightAlign", 1, null, null, 1, "#ADDRESS4#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "CITY", "GrayedText", null, null, null, "City:", "RightAlign", 1, null, null, 1, "#CITY#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "STATE_NAME", "GrayedText", null, null, null, "State:", "RightAlign", 1, null, null, 1, "#STATE_NAME#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "COUNTRY_NAME", "GrayedText", null, null, null, "Country:", "RightAlign", 1, null, null, 1, "#COUNTRY_NAME#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "ZIP", "GrayedText", null, null, null, "ZIP:", "RightAlign", 1, null, null, 1, "#ZIP#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "FAX", "GrayedText", null, null, null, "Fax:", "RightAlign", 1, null, null, 1, "#FAX#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "PHONE", "GrayedText", null, null, null, "PHONE:", "RightAlign", 1, null, null, 1, "#PHONE#")
			Set currNode = mainTable.insertBefore(newNode,null)
			Set newNode = CreateFieldNode(oTemplate, "EMAIL", "GrayedText", null, null, null, "Email:", "RightAlign", 1, null, null, 1, "<a class=""MenuLink"" href=""mailto:#EMAIL#"">#EMAIL#</a>")
			Set currNode = mainTable.insertBefore(newNode,null)
		end if
		HTML = DOM2HTML(Session("oViewContainerData"), oTemplate)
		Response.Write HTML

	Case "Quantities"
		HTML = DOM2HTML(Session("oViewContainerData"), server.MapPath("/" & Application("AppKey") & "/config/xml_templates/ViewContainer_Quantities.xml"))
		Response.Write HTML

	Case "Comments"
%>
<table border="0">
	<tr>
		<td align="right" valign="top" nowrap>
			Comments:
		</td>
		<td class="grayBackground">
			<textarea rows="7" cols="60" onfocus="blur()" wrap="hard" id=textarea1 name=textarea1><%=Comments%></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" valign="top" nowrap>
			Storage Conditions:
		</td>
		<td class="grayBackground">
			<textarea rows="7" cols="60" onfocus="blur()" wrap="hard" id=textarea1 name=textarea1><%=StorageConditions%></textarea>
		</td>
	</tr>
	<tr>
		<td align="right" valign="top" nowrap>
			Handling Procedures:
		</td>
		<td class="grayBackground">
			<textarea rows="7" cols="60" onfocus="blur()" wrap="hard" id=textarea1 name=textarea1><%=HandlingProcedures%></textarea>
		</td>
	</tr>
</table>
<%
'-- RESERVATIONS TAB
'-- -----------------------------------------------------------------------
	Dim Cmd
	Case "Reservations"
	Call GetInvCommand("{CALL " & Application("CHEMINV_USERNAME") & ".RESERVATIONS.GetReservations(?)}", adCmdText)
	Cmd.Parameters.Append Cmd.CreateParameter("PCONTAINERID",131, 1, 0, ContainerID)
	Cmd.Parameters("PCONTAINERID").Precision = 9
	Cmd.Properties ("PLSQLRSet") = TRUE
	Set RS = Cmd.Execute
	Cmd.Properties ("PLSQLRSet") = FALSE
%>
	<center><table border=1>
	<Tr>
		<th>
			Reservation ID
		</th>
		<th>
			Quantity
		</th>
		<th>
			Reserved By
		</th>
		<th>
			Date
		</th>
		<th>
			Reservation Type
		</th>
		<th>
			Status
		</th>
		<%if Session("INV_RESERVE_CONTAINER" & dbkey) then%>
		<th align="center">
			<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/Reserve.asp?QtyAvailable=<%=QtyAvailable%>&UOMAbv=<%=UOMAbv%>&ContainerID=<%=ContainerID%>&ContainerName=' + ContainerName, 'Diag', 1); return false">New</a>
		</td>
		<%end if%>
	</Tr>
<%
	If (RS.EOF AND RS.BOF) then
		Response.Write ("<TR><TD align=center colspan=6><span class=""GUIFeedback"">No reservations found for this container</Span></TD></tr>")
	Else
		While (Not RS.EOF)
			ReservationID = RS("Reservation_ID")
			ReservationUserID = RS("User_ID_FK")
			QtyReserved = RS("Qty_Reserved")
			ReservationTypeID = RS("Reservation_Type_ID_FK")
			editData = "ContainerID=" & ContainerID & "&ContainerName=" & ContainerName & "&UOMAbv=" & UOMAbv&  "&ReservationID=" & ReservationID & "&ReservationUserID=" & ReservationUserID & "&QtyReserved=" & QtyReserved & "&ReservationTypeID=" & ReservationTypeID
%>
			<tr>
				<td align=center>
					<%=ReservationID%> &nbsp;</td>
				<td align=right>
					<%=QtyReserved & " " & UOMAbv%> &nbsp;</td>
				<td align=center>
					<%=TruncateInSpan(ReservationUserID, 15, "")%> &nbsp;</td>
				<td align=center>
					<%=TruncateInSpan(RS("Date_Reserved"), 10, "")%> &nbsp;</td>
				<td align=center>
					<%=RS("Reservation_Type_Name")%> &nbsp;</td>
				<td align=center>
					<%
					If CBool(RS("Is_Active")) then
						Response.Write "Active"
					Else
						Response.Write "<span class=""required"">Inactive</span>"
					End if
					%> &nbsp;</td>
				<%if Session("INV_RESERVE_CONTAINER" & dbkey) then%>
				<td align=center>
					<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/Reserve.asp?<%=editData%>', 'Diag', 1); return false">&nbsp;Edit</a>
					|
					<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/Reserve.asp?action=delete&<%=editData%>', 'Diag',1); return false">Delete&nbsp;</a>
				</td>
				<%end if%>
			</tr>
			<%rs.MoveNext
		Wend
		Response.Write "</table></center>"
	End if
	RS.Close
	'Conn.Close
	Set RS = nothing
	Set Cmd = nothing
	'Set Conn = nothing


'-- REQUESTS TAB
'-- -----------------------------------------------------------------------

	Case "Requests"
	Session("sTab") = ""
	dateFormatString = Application("DATE_FORMAT_STRING")
	if Session("INV_CREATE_LOCATION" & dbkey) then
		privUserName = null
	else
		privUserName = Request.Cookies("CS_SEC_UserName")
	end if
	if Application("AllowRequests") then

		'-- Show container requests
		RequestTypeID = 1
		Call GetInvCommand("{CALL " & Application("CHEMINV_USERNAME") & ".REQUESTS.GetRequest2(?,?,?,?)}", adCmdText)
		Cmd.Parameters.Append Cmd.CreateParameter("PCONTAINERID",131, 1, 0, ContainerID)
		Cmd.Parameters("PCONTAINERID").Precision = 9
		Cmd.Parameters.Append Cmd.CreateParameter("PREQUESTTYPEID",131, 1, 0, RequestTypeID)
		Cmd.Parameters("PREQUESTTYPEID").Precision = 9
		Cmd.Parameters.Append Cmd.CreateParameter("PUSERID",200, 1, 30, uCase(privUserName))
		Cmd.Parameters.Append Cmd.CreateParameter("PDATEFORMAT",200,1,30, dateFormatString)
		Cmd.Properties ("PLSQLRSet") = TRUE
		Set RS = Cmd.Execute
		Cmd.Properties ("PLSQLRSet") = FALSE
		If (RS.EOF AND RS.BOF) then
			Response.Write ("<table><tr><td>")
			Response.Write("<div><span class=""GUIFeedback"">Container Requests</span><br /><hr noshade size=""1"" />")
			Response.Write("No Container requests found for this container.</div></td></tr></table>")
		Else
%>
		<table border="0">
		<tr><td>
			<span class="GUIFeedback">Container Requests</span><br /><hr noshade size="1" />
		</td></tr>
		<tr><td><table border="1">
		<tr>
			<th>Created By</th>
			<th>Requested For</th>
			<th>Delivery Location</th>
			<th>Amount</th>
			<th>Date Requested</th>
			<th>Date Required</th>
			<th>&nbsp;</td>
		</tr>
<%
			While (Not RS.EOF)
				RequestID = RS("Request_ID")
				CreatorUserID = RS("Creator")
				RequestUserID = RS("RUserID")
				QtyRequired = RS("Qty_Required")
				DateRequested = RS("timestamp")
				DateRequired = RS("Date_Required")
				DestinationLocationID = RS("delivery_Location_ID_FK")
				DestinationLocationName = RS("Location_Name")
				editData = "ContainerID=" & ContainerID & "&ContainerName=" & ContainerName & "&UOMAbv=" & UOMAbv &  "&RequestID=" & RequestID
				Comments = RS("request_comments")
				RequestTypeID = RS("request_type_id_fk")
				NumContainers = RS("number_containers")
				ContainerTypeID = RS("container_type_id_fk")
				QtyList = RS("quantity_list")
				ShipToName = RS("ship_to_name")
				 if (Session("INV_CHECKOUT_CONTAINER" & dbkey)) then
					allowContainerRequest="1"
				 end if
				if Application("ShowRequestSample") and Session("INV_CHECKOUT_CONTAINER" & dbkey) then
					allowSampleRequest="1"
			    end if  

%>
				<tr>
					<td align=center>
						<%=TruncateInSpan(CreatorUserID, 15, "")%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(RequestUserID, 15, "")%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(DestinationLocationName, 15, "")%> &nbsp;</td>
					<td align=right>
						<%=QtyRequired & " " & UOMAbv%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(DateRequested, 10, "")%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(DateRequired, 10, "")%> &nbsp;</td>
					<td align=center>
						<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/requestsample.asp?LocationID=<%=LocationID%>&action=edit&allowContainerRequest=<%=allowContainerRequest%>&allowSampleRequest=<%=allowSampleRequest%>&<%=editData%>', 'Diag', 1); return false">&nbsp;Edit</a>
						|
						<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/requestsample.asp?LocationID=<%=LocationID%>&action=delete&<%=editData%>', 'Diag',1); return false">Delete&nbsp;</a>
					</td>
				</tr>
<%
				rs.MoveNext
			Wend
			Response.Write "</table></td></tr></table>"
%>
		</table>
			<br>
			<table border="0">
				<tr>
					<td align="right" valign="top" nowrap>
						Comments:
					</td>
					<td class="grayBackground">
						<textarea rows="4" cols="50" onfocus="blur()" wrap="hard" name="RequestComments"><%=Comments%></textarea>
					</td>
				</tr>
			</table>
		<br />
<%
		End if
		RS.Close
		'Conn.Close
		Set RS = nothing
		Set Cmd = nothing
		'Set Conn = nothing
	end if

	if Application("ShowRequestSample") then

        RequestSampleByAmount = false
        if Application("RequestSampleByAmount") = "1" then RequestSampleByAmount = true

		'-- Show sample requests
		RequestTypeID = 2

		'-- Admin user can see all requests
		if Session("INV_APPROVE_CONTAINER" & dbkey) then
			CurrentUserID = null
		else
			CurrentUserID = Ucase(Session("UserNameChemInv"))
		end if

		Call GetInvCommand("{CALL " & Application("CHEMINV_USERNAME") & ".REQUESTS.GetRequestByBatch(?,?,?,?,?)}", adCmdText)	
        Cmd.Parameters.Append Cmd.CreateParameter("PBATCHID",131, 1, 0, BatchID) 
        Cmd.Parameters.Append Cmd.CreateParameter("P_REQUESTTYPEID",131, 1, 0, cInt(RequestTypeID)) 
        Cmd.Parameters("P_REQUESTTYPEID").Precision = 9	
        Cmd.Parameters.Append Cmd.CreateParameter("P_USERID",200, 1, 30, uCase(privUserName))
        Cmd.Parameters.Append Cmd.CreateParameter("P_DATEFORMAT",200,1,30, dateFormatString)		
        Cmd.Parameters.Append Cmd.CreateParameter("P_REGSERVER", 200, 1, 30, Application("RegServerName"))

		'Call GetInvCommand("{CALL " & Application("CHEMINV_USERNAME") & ".REQUESTS.GetRequest2(?,?,?,?)}", adCmdText)
		'Cmd.Parameters.Append Cmd.CreateParameter("PCONTAINERID",131, 1, 0, ContainerID)
		'Cmd.Parameters("PCONTAINERID").Precision = 9
		'Cmd.Parameters.Append Cmd.CreateParameter("PREQUESTTYPEID",131, 1, 0, RequestTypeID)
		'Cmd.Parameters("PREQUESTTYPEID").Precision = 9
		'Cmd.Parameters.Append Cmd.CreateParameter("PUSERID",200, 1, 30, uCase(privUserName))
		'Cmd.Parameters.Append Cmd.CreateParameter("PDATEFORMAT",200,1,30, dateFormatString)
		Cmd.Properties ("PLSQLRSet") = TRUE
		Set RS = Cmd.Execute
		Cmd.Properties ("PLSQLRSet") = FALSE
		
		If (RS.EOF AND RS.BOF) then
			Response.Write ("<br /><table><tr><td>")
			Response.Write("<div><span class=""GUIFeedback"">Sample Requests</span><br /><hr noshade size=""1"" />")
			Response.Write("No sample requests found for this container.</div></td></tr></table>")
		Else
		%>

		<table border="0">
		<tr><td>
			<span class="GUIFeedback">Sample Requests</span><br /><hr noshade size="1" />
			This container is associated with the following sample requests:
		</td></tr>
		<tr><td><table border="1">
		<tr>
    		<th>Request ID</th>
			<th>Created by</th>
			<th>Requested For</th>
			<th>Delivery Location</th>
            <%if RequestSampleByAmount then%>
			<th>Amount</th>
			<%else %>
			<th>Ship To Name</th>
			<th>Container Type</th>
			<th>Num Samples</th>
			<th>Quantity List</th>
			<%end if %>
			<th>Date Requested</th>
			<th>Date Required</th>
			<th>Status</th>
			<% 'if NumShippedContainers = 0 and instr("filled,cancelled,closed,declined",lcase(RequestStatusName)) = 0 then %>
			<th>&nbsp;</th>
			<%'end if %>
		</tr>
<%
			While (Not RS.EOF)
				RequestID = RS("Request_ID")
				tempBatchID = RS("Batch_ID_FK")
				CreatorUserID = RS("Creator")
				RequestUserID = RS("RUserID")
				QtyRequired = RS("Qty_Required")
				DateRequested = RS("timestamp")
				DateRequired = RS("Date_Required")
				DestinationLocationID = RS("delivery_Location_ID_FK")
				DestinationLocationName = RS("Location_Name")
				editData = "ContainerID=" & ContainerID & "&ContainerName=" & ContainerName & "&UOMAbv=" & UOMAbv &  "&RequestID=" & RequestID
				Comments = RS("request_comments")
				RequestTypeID = RS("request_type_id_fk")
				NumContainers = RS("number_containers")
				ContainerTypeID = RS("container_type_id_fk")
				QtyList = RS("quantity_list")
				ShipToName = RS("ship_to_name")
				ContainerTypeName = RS("container_type_name")
				RequestStatusName = RS("request_status_name")
				RequestCreator = RS("Creator")
				NumShippedContainers = cint(RS("NumShippedContainers"))
				LocationPath = RS("LocationPath")
				Status = RS("request_status_name")
				UOMAbv = RS("RequiredUOMabbrv") & ""

       			if not IsEmpty(Application("DEFAULT_SAMPLE_REQUEST_CONC")) and UOMAbv="" then
	        		arrUOM = split(Application("DEFAULT_SAMPLE_REQUEST_CONC"),"=")
			        UOMAbv = arrUOM(1)
		        end if
%>
				<tr>
					<td align=center>
						<%=TruncateInSpan(RequestID, 15, "")%> &nbsp;
					</td>
					<td align=center>
						<%=TruncateInSpan(CreatorUserID, 15, "")%> &nbsp;
					</td>
					<td align=center>
						<%=TruncateInSpan(RequestUserID, 15, "")%> &nbsp;
					</td>
					<td align=center>
						<%=TruncateInSpan(LocationPath, 15, "")%> &nbsp;
					</td>
					<%if RequestSampleByAmount then%>
	    				<td align=right>
    						<%=QtyRequired & " " & UOMAbv%> &nbsp;
    					</td>
					<%else %>
					    <td align=right>
						    <%=TruncateInSpan(ShipToName, 15, "")%> &nbsp;
						</td>
					    <td align=right>
						    <%=TruncateInSpan(ContainerTypeName, 15, "")%> &nbsp;
						</td>
					    <td align=right>
						    <%=NumContainers%> &nbsp;
						</td>
					    <td align=right>
						    <%=QtyList & " " & UOMAbv%> &nbsp;
						</td>
					<%end if %>
					<td align=center>
						<%=TruncateInSpan(DateRequested, 10, "")%> &nbsp;
					</td>
					<td align=center>
						<%=TruncateInSpan(DateRequired, 10, "")%> &nbsp;
					</td>
					<td align=center>
						<%
						if RequestStatusName="Declined" then
							Response.Write "<a Class=""MenuLink"" Href=""#"" onclick=""OpenDialog('/Cheminv/GUI/DeclineRequestSample.asp?DeclinedRequestIDList=" & RequestID & "&action=edit', 'Diag', 1); return false"">" & TruncateInSpan(RequestStatusName, 15, "") & "</a>&nbsp;</td>"
						else
						%>
							<%=TruncateInSpan(RequestStatusName, 15, "")%> &nbsp;</td>
						<%
						end if
						%>
					</td>
					<% if NumShippedContainers = 0 and instr("filled,cancelled,closed,declined",lcase(RequestStatusName)) = 0 then %>
					<td align=center>
        					<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/RequestSample.asp?BatchID=<%=BatchID%>&LocationID=<%=LocationID%>&action=edit&<%=editData%>', 'Diag',2); return false">&nbsp;Edit</a> |
							<!--<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/RequestBatch.asp?BatchID=<%=BatchID%>&RequestID=<%=RequestID%>&action=edit', 'Diag', 1); return false">&nbsp;Edit</a> |-->
                            <a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/RequestSample.asp?BatchID=<%=BatchID%>&LocationID=<%=LocationID%>&action=cancel&<%=editData%>&Family=<%=Family%>', 'Diag',2); return false">Cancel&nbsp;</a>							
							<!--<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/RequestBatch.asp?BatchID=<%=BatchID%>&RequestID=<%=RequestID%>&action=cancel', 'Diag', 1); return false">Cancel</a>-->
					</td>
					<%else%>
					<td align=center> &nbsp;</td>
					
					<% end if %>
				</tr>
<% 
				rs.MoveNext
			Wend
%>			
			</table>
			</td></tr>
			</table>
<%
		End if
		RS.Close
		Set RS = nothing
		Set Cmd = nothing

        if false then
		'-- Show BATCH Sample requests
		RequestTypeID = 2

		'-- Admin user can see all requests
		if Session("INV_APPROVE_CONTAINER" & dbkey) then
			CurrentUserID = null
		else
			CurrentUserID = Ucase(Session("UserNameChemInv"))
		end if

		Call GetInvCommand("{CALL " & Application("CHEMINV_USERNAME") & ".REQUESTS.GETBATCHREQUEST2(?,?,?,?)}", adCmdText)
		Cmd.Parameters.Append Cmd.CreateParameter("P_REQUESTTYPEID",131, 1, 0, cInt(RequestTypeID))
		Cmd.Parameters("P_REQUESTTYPEID").Precision = 9
		Cmd.Parameters.Append Cmd.CreateParameter("P_USERID",200, 1, 30, uCase(privUserName))
		Cmd.Parameters.Append Cmd.CreateParameter("P_DATEFORMAT",200,1,30, dateFormatString)
		Cmd.Parameters.Append Cmd.CreateParameter("P_REGSERVER", 200, 1, 30, Application("RegServerName"))

		Cmd.Properties ("PLSQLRSet") = TRUE
		Set RS = Cmd.Execute
		Cmd.Properties ("PLSQLRSet") = FALSE
		If (RS.EOF AND RS.BOF) or Session("BatchID") = "" then
			Response.Write ("<table><tr><td colspan=6>")
			Response.Write("<div><span class=""GUIFeedback"">Batch Requests</span><br /><hr noshade size=""1"" />")
			Response.Write("No Batch sample requests found for this container.</div></td></tr></table>")
		Else
%>
		<br />
		<table border="0">
		<tr><td>
			<span class="GUIFeedback">Batch Requests</span><br /><hr noshade size="1" />
			The container is associated with the following Batch requests
		</td></tr>
		<tr><td><table border="1">
		<tr>
			<th>Created by</th>
			<th>Requested For</th>
			<th>Delivery Location</th>
			<th>Amount</th>
			<th>Date Requested</th>
			<th>Date Required</th>
			<th>Status</th>
			<th>&nbsp;</th>
		</tr>
<%
			While (Not RS.EOF)
				RequestID = RS("Request_ID")
				BatchID = RS("Batch_ID_FK")
				CreatorUserID = RS("Creator")
				RequestUserID = RS("RUserID")
				QtyRequired = RS("Qty_Required")
				DateRequested = RS("timestamp")
				DateRequired = RS("Date_Required")
				DestinationLocationID = RS("delivery_Location_ID_FK")
				DestinationLocationName = RS("Location_Name")
				Comments = RS("request_comments")
				RequestTypeID = RS("request_type_id_fk")
				NumContainers = RS("number_containers")
				ContainerTypeID = RS("container_type_id_fk")
				QtyList = RS("quantity_list")
				ShipToName = RS("ship_to_name")
				Status = RS("request_status_name")
                UOMAbv = RS("RequiredUOMabbrv") & ""
                
         		if BatchID <> "" then
				if cInt(BatchID) = cInt(Session("BatchID")) then

				if not IsEmpty(Application("DEFAULT_SAMPLE_REQUEST_CONC")) and UOMAbv="" then
					arrUOM = split(Application("DEFAULT_SAMPLE_REQUEST_CONC"),"=")
					UOMAbv = arrUOM(1)
				end if

%>
				<tr>
					<td align=center>
						<%=TruncateInSpan(CreatorUserID, 15, "")%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(RequestUserID, 15, "")%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(DestinationLocationName, 15, "")%> &nbsp;</td>
					<td align=right>
						<%=QtyRequired & " " & UOMAbv%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(DateRequested, 10, "")%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(DateRequired, 10, "")%> &nbsp;</td>
					<td align=center>
						<%=TruncateInSpan(Status, 10, "")%> &nbsp;</td>
					<td align=center>
						<% if BatchID <> "" then %>
							<% if Status = "New" then %>
								<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/RequestBatch.asp?BatchID=<%=BatchID%>&RequestID=<%=RequestID%>&action=edit', 'Diag', 1); return false">&nbsp;Edit</a> |
								<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/RequestBatch.asp?BatchID=<%=BatchID%>&RequestID=<%=RequestID%>&action=cancel', 'Diag', 1); return false">Cancel</a>
							<% elseif Status = "Approved" then %>
								<a Class="MenuLink" Href="#" onclick="OpenDialog('/Cheminv/GUI/RequestBatch.asp?BatchID=<%=BatchID%>&RequestID=<%=RequestID%>&action=cancel', 'Diag', 1); return false">Cancel</a>
							<% else %>
							&nbsp;
							<% end if %>
						<% end if %>
					</td>
				</tr>
<%
				end if
				end if
				rs.MoveNext
			Wend
			Response.Write "</table></td></tr></table>"
		End if
		RS.Close
		Set RS = nothing
		Set Cmd = nothing
	end if
    end if


'-- OTHER TAB
'-- -----------------------------------------------------------------------
Case Application("OtherTabText")

'Set FieldNamesDict = Session("CustomFieldNamesDict")
Response.Write "<table border=0 cellpadding=1 cellspacing=2>" & vblf
Response.Write "<TR>" & vblf
j= 0
For each key in custom_fields_dict
	Response.write ShowField(custom_fields_dict.Item(key), Key, 20, "") & vblf
	j = j + 1
	if (j/2 - int(j/2)) = 0 then Response.Write "</TR>" & vblf & "<tr>" & vblf
Next
Response.Write "</table>" & vblf
%>
<!--#INCLUDE VIRTUAL = "/cheminv/custom/gui/custom_container_tab_cases.asp"-->
<%
End Select
if Session("ClickEdit") then
	Session("ClickEdit") = false
	Response.Write "<SCRIPT language=javascript>document.all.EditContainerLnk.click();</SCRIPT>"
End if

'Conn.Close
'Set Conn = nothing

%>

</form>
<!--#INCLUDE VIRTUAL = "/cheminv/custom/gui/custom_links_code.asp"-->

<% if ContainerID <> "" then %>
<script language="javascript">
// Highlight correct item, pause to make sure
if (parent.ListFrame){
	if (parent.ListFrame.highlightGrid) {
	setTimeout("parent.ListFrame.highlightGrid(<%=ContainerID%>);",550);
	//parent.ListFrame.highlightGrid("<%=ContainerID%>");
	}
}

</script>

<% end if %>

</body>
</html>
