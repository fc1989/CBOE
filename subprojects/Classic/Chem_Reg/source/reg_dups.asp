<%@ LANGUAGE="VBSCRIPT" %>
<%Response.Expires=0 
Response.Buffer = true

'Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved
'DO NOT EDIT THIS FILE%>
<html>

<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<!--#INCLUDE FILE = "../source/reg_security.asp"-->

<%
bFBApproved=true

dbkey = "reg"
formgroup = "reg_ctrbt_commit_form_group"
duplicates_found = Session("DuplicatesFound" & dbkey)
tempID=Session("tempUniqueID" & dbkey)
currentindex = Request.querystring("indexValue")

%>
<script language="Javascript">
var cd_plugin_threshold="<%=Application("CD_PLUGIN_THRESHOLD")%>"
var alert_cdax_version = "<%=APPLICATION("ALERT_CDAX_VERSION")%>"

</script>
<script language="JavaScript" src= "/cfserverasp/source/chemdraw.js"></script>
<script language="JavaScript">  cd_includeWrapperFile("/cfserverasp/source/")</script>

<script language="javascript">

theWindow = ""
var duplicate_id=""

OpenerWindow = opener
action_form_path = OpenerWindow.action_form_path

formgroup = "<%=formgroup%>"
dbname = "<%=dbkey%>"
tempID = "<%=tempID%>"
function doDupAction(action, unique_reg_id){
	
	indexvalue=OpenerWindow.document.forms["nav_variables"].elements["BaseActualIndex"].value
	if(action=="edit_structure"){
		OpenerWindow.goRecordEditMode("reg_ctrbt_commit_result_form.asp", "<%=tempID%>", "full_commit", indexvalue)
		window.close()
		}
	else{
		actiontemp = action_form_path + '?uniqueid=' + tempID + '&commit_type=' + 'FULL_COMMIT' + '&dataaction2=register&duplicates_check=true&duplicate_ids='+ unique_reg_id + '&duplicate_action='+ action +'&dbname=' + dbname + '&formgroup=' + formgroup
		OpenerWindow.submitDupsAction(actiontemp)
		
		window.close()
		}
}

function doFalse(){
	return false
}
</script>


<title>Duplicates</title>
<!--#INCLUDE VIRTUAL = "/cfserverasp/source/cows_func_vbs.asp" -->

<!--#INCLUDE FILE = "../reg/universal_ss.asp"-->
</head>

<body><!--#INCLUDE FILE = "app_vbs.asp"-->

<form name="reg_dupform" action="/<%=Application("AppKey")%>/reg/reg_action.asp" Method="post" onsubmit="doFalse()">

<table border="0" width="650">
    <tr>
      <td width="605"> <%  dbkey = "reg"
 formgroup = "reg_ctrbt_commit_form_group"
 formmode = "list"
 duplicate_items_array = Split(duplicates_found, ",", -1)
      theCounter = UBound(duplicate_items_array)

       if theCounter > 0 then%>
      <%=theCounter + 1 %> duplicates where found for the compound you are trying to register.<br>
 
      Please select from the options below to process the 
      duplicate.
      <%else%>
 		A duplicate was found for the compound you are trying to register.<br>
      Please select one of the options below to process the 
      duplicate.

      <%end if%></td>
    </tr>
    <tr>
      <td align="left" width="605">
      <table border="0" width="74%">
        <tr>
          <td width="33%" valign="top" align="left"><%if Session("Edit_Compound_Temp" & dbkey) = True then%>
      <a href="#" onclick="doDupAction('edit_structure','<%=tempID%>')"><img align="left" border="0" src="/<%=Application("AppKey")%>/graphics/editStruc.gif"></a>
      <p>&nbsp;</p>
         <%end if%> </td>
          <td width="33%" valign="top" align="left">
      <a href="#" onclick="doDupAction('skip','<%=tempID%>')"><img border="0" src="/<%=Application("AppKey")%>/graphics/skip.gif"></a>
      <p>&nbsp;</p>
          </td>
          <td width="34%" valign="top" align="left">
      <%if Session("MANAGE_SYSTEM_DUPLICATES" & dbkey) = True then%>
      <a href="#" onclick="doDupAction('new_compound','<%=tempID%>')"><img border="0" src="/<%=Application("AppKey")%>/graphics/new_compound.gif"></a>
      <p>&nbsp;</p>
      <%else%>
      <B>Contact Scientific Support to register this as a new Compound.</B>
      <%end if%>
          </td>
           <td width="34%" valign="top" align="left">
        <a href="#" onclick="window.close();return false;"><img border="0" src="/<%=Application("AppKey")%>/graphics/cancel.gif"></a>
      <p>&nbsp;</p>
          </td>
        </tr>
      </table>
      </td>
    </tr>
    </table>
<table border="0" width="100%">

  <tr>
    <td width="100%">&nbsp;<b>Duplicate Registry Information</b></td>
  </tr>
  <tr>
    <td width="100%">
		  <table border="1" width="600">
  
 <% 
 on error resume next



 duplicate_items_array = Split(duplicates_found, ",", -1)

    ' Response.Write duplicates_found
For j = 0 to  UBound(duplicate_items_array)%>
<tr>
		    <td align="middle" width="21"><%
  Set DataConn = GetConnection(dbkey, formgroup, "Reg_Numbers")

	duplicates_array = split(duplicate_items_array(j), ":", -1)
	duplicate_type = trim(duplicates_array(0))
	duplicate_id = Trim(duplicates_array(1))
		commit_type = duplicate_type%>
		<script language = "javascript">
		duplicate_id = "<%=duplicate_id%>"
		</script>
 	 <%Select Case UCase(duplicate_type)
		Case "BATCH_COMMIT"
			reg_id = duplicate_id
			
			Reg_Number = getValueFromTablewConn(DataConn,"Reg_Numbers", "reg_id", reg_id, "reg_number")	
			cpdDBCounter = 	getValueFromTablewConn(DataConn,"Reg_Numbers", "reg_id", reg_id, "cpd_internal_id")
			display_type = "reg_number"
			'registered compound information recordset generation 
			'assumes cpdDBCounter and reg_id variables are populated
			
			if CBool(Application("APPROVED_FLAG_USED")) = True and CBool(Application("ALLOW_BATCH_FOR_UNAPPROVED_CMPD")) = false then
				
				firstBatchID = getFirstBatchID(DataConn, reg_ID)
				bFBApproved = getApprovedFlag(DataConn, reg_ID, firstBatchID)
			else
				bFBApproved=true
			end if
			getRegData DataConn, reg_id, cpdDBCounter,display_type 
			bShowRegIdentifiers = true
			bShowRegCmpds = true
			bShowBatchData = true
			bShowRegSalt = true
			
			
			Set cmd = Server.CreateObject("ADODB.COMMAND")
			Set MoleculesRS = Server.CreateObject("ADODB.RECORDSET")
			cmd.commandtype = adCmdText
			cmd.ActiveConnection = DataConn
			sql = "Select * from Structures where cpd_internal_id = ?"
			cmd.CommandText = sql
			cmd.Parameters.Append cmd.CreateParameter("pCPD", 5, 1, 0, cpdDBCounter) 
			MoleculesRS.Open cmd


	Case "ADD_SALT"

			cpdDBCounter  = duplicate_id
			Reg_Number = getValueFromTablewConn(DataConn,"Compound_Molecule", "cpd_database_counter", cpdDBCounter, "root_number")	
			reg_id = ""
			display_type = "root_number"
			bShowRegIdentifiers = False
			bShowRegCmpds = true
			bShowBatchData = true
			bShowRegSalt = false
			'registered compound information recordset generation 
			'assumes cpdDBCounter and reg_id variables are populated
			getRegData DataConn, reg_id, cpdDBCounter, display_type 
			
			Set cmd = Server.CreateObject("ADODB.COMMAND")
			Set MoleculesRS = Server.CreateObject("ADODB.RECORDSET")
			cmd.commandtype = adCmdText
			cmd.ActiveConnection = DataConn
			sql = "Select * from Structures where cpd_internal_id = ?"
			cmd.CommandText = sql
			cmd.Parameters.Append cmd.CreateParameter("pCPD", 5, 1, 0, cpdDBCounter) 
			MoleculesRS.Open cmd
			
	End Select
chemdata = GetChemData(MoleculesRS("BASE64_CDX"))
chemdata_array = split(chemdata, ":", -1)
MoleculesRS.movefirst
	%>
  <td align="middle" width="109">
		    <%if UCase(commit_type) = "BATCH_COMMIT" then
				if bFBApproved=true then
			%>
					<a href="#" onclick="doDupAction('Batch_Commit', '<%=duplicate_id%>')"><img border="0"  id="IMG1" src="/<%=Application("AppKey")%>/graphics/add_batch_reg_dups.gif" ></a>
				 <%else%>
					 <%="Unapproved compound.<br>Batch can't be added"%>
				<%end if%>
				<%else%>
				<a href="#" onclick="doDupAction('Add_Salt', '<%=duplicate_id%>')"><img border="0" id="Img2" src="/<%=Application("AppKey")%>/graphics/add_salt_reg_dups.gif" ></a>
 <%end if%>
</td><td width="430">
				<%'start registered compound information%>
<%if UCase(Commit_type) = "ADD_SALT" then 
   RegOutput= Session("Root_Number")
   else 
	if UCase(getbasetable(dbkey, formgroup, "basetable")) = "BATCHES" then
		 RegOutput= Session("Reg_Number_W_BATCH")
	else
		 RegOutput= Session("Reg_Number")
	end if
   end if%> 

<table  <%=registered_compound_table%> width = "650">
	<tr>
		<td >
			<table>
				<tr>
					<td colspan="5" <%=td_header_bgcolor%>><strong><font <%=font_header_default_2%>>Registered&nbsp;
					 Compound&nbsp;Information:&nbsp;&nbsp;</td></tr><tr>
					<td width="20%"><table><tr><td <%=td_bgcolor%>  nowrap><strong><font <%=font_header_default_2%>><%=RegOutput%></font></td>
					<td colspan="1" <%=td_bgcolor%> nowrap><strong><font <%=font_default_caption%>>&nbsp;&nbsp;&nbsp;&nbsp;Registered:</font>
					<strong><font <%=font_default%>><%=Session("RegDate")%></font></td>
                    <td colspan="1" <%=td_bgcolor%> nowrap><strong><font <%=font_default_caption%>>&nbsp;&nbsp;&nbsp;&nbsp;By:</font>
                    <strong><font <%=font_default%>><%=Session("RegPerson")%></font></td></tr></table>

                    </b></font>
				  </td>
				</tr>
				
				<tr>
					<table>
						<tr>
							<td align="left">
							    <table >
									<tr>
										<td valign="top" align="left"><table border = "1"><tr><td><%Base64DecodeDirect dbkey, formgroup, Session("Base64_cdx"), "Structures.BASE64_CDX", Session("reg_id") , Session("cpdDBCounter"), "330" & ":BASE64CDX_NO_EDIT", "200"%>
										</tr></td></table>
										</td>
										
										<td valign="top" align="left">
											<table width = "320">
												
												<%if Application("Batch_Level") = "SALT" and CBool(Application("Salts_Used")) = True then %>
													<tr>
													  <td <%=td_caption_bgcolor%> align = "right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("SALT_NAME")%></b></font></td>
													  <td <%=td_bgcolor%>><font <%=font_default%>><%=Session("Salt_Name")%>
													    </font></td>
													</tr>
												<%end if%>
												<%if CBOOL(Application("PROJECTS_USED")) = True then%><tr>
													<tr>
													  <%if CBOOL(Application("PROJECTS_NAMED_OWNER")) = true then%>
													  <td <%=td_caption_bgcolor%> align = "right" width="160"><font <%=font_default_caption%>><b>Owner</b></font></td>
													  <%else%>
													  <td <%=td_caption_bgcolor%> align = "right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("Project_Internal_ID")%></b></font></td>
													  <%end if%>
													  <td <%=td_bgcolor%>><font <%=font_default%>><%=Session("Project_Name")%>
													    </font></td>
													</tr>
												<%end if%>
                           
												<%if not checkHideField("COLLABORATOR_ID") then%>
														<tr>
															<td <%=td_caption_bgcolor%> nowrap align="right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("COLLABORATOR_ID")%></b></font>
															</td>
															
															<td <%=td_bgcolor%> width="160">  <font <%=font_default%>><%=Session("Collaborator_ID") %></font>
															</td>
														</tr>
												<%end if%>
											
												<%if not checkHideField("PRODUCT_TYPE") then%>
													<tr>
														<td <%=td_caption_bgcolor%> align="right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("PRODUCT_TYPE")%></b></font>
														</td>
														
														<td <%=td_bgcolor%> width="160">  <font <%=font_default%>><%=Session("Product_Type") %>
														</td>
													</tr>
												<%end if%>
												<%if not checkHideField("CAS_NUMBER") then%>
													<tr>
														<td <%=td_caption_bgcolor%> align="right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("CAS_NUMBER")%></b></font>
														</td>
														
														<td  <%=td_bgcolor%> width="160">  <font <%=font_default%>><%=Session("CasNums")%></font>
														</td>
													</tr>
												<%end if%>
												<%if not checkHideField("RNO_NUMBER") then%>
													<tr>
														<td <%=td_caption_bgcolor%> align="right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("RNO_NUMBER")%></b></font>
														</td>
														
														<td <%=td_bgcolor%> width="160">  <font <%=font_default%>><%=Session("RNO-No")%></font>
														</td>
													</tr>
												<%end if%>
												
												<%if not checkHideField("GROUP_CODE") then%>
													<tr>
														<td <%=td_caption_bgcolor%> align="right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("GROUP_CODE")%></b></font>
														</td>
														
														<td <%=td_bgcolor%> width="160">  <font <%=font_default%>><%=Session("GroupCode")%></font>
														</td>
													</tr>
												<%end if%>
												<%if not checkHideField("FEMA_GRAS_NUMBER") then%>
													<tr>
														<td <%=td_caption_bgcolor%> align="right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("FEMA_GRAS_NUMBER")%></b></font>
													    </td>
														
														<td <%=td_bgcolor%> width="160">  <font <%=font_default%>><%=Session("FEMA-No")%></font>
														</td>
													</tr>
												<%end if%>
												
												
												

												<%if not checkHideField_Ignore_Derived("MW") then%>
													<tr>
														<td <%=td_caption_bgcolor%> align="right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("MW")%></b></font>
													    </td>
														
														<td  <%=td_bgcolor%> width="160">  <font <%=font_default%>><%=Session("MW")%></font>
														</td>
													</tr>
												<%end if%>

												<%if not checkHideField_Ignore_Derived("FORMULA") then%>
													<tr>
														<td <%=td_caption_bgcolor%> align="right" width="160"><font <%=font_default_caption%>><b><%=getLabelName("FORMULA")%></b></font>
														</td>
														
														<td  <%=td_bgcolor%> width="160">  <font <%=font_default%>><%=GetHTMLStringForFormula(Session("FORMULA"))%>
														</td>
													</tr>
												<%end if%>
											
											</table>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<td <%=td_default%> valign="top" align="left">
                        
							<table width="650">
								<%if not checkHideField("MW_TEXT") then%>
									<tr>
										<td <%=td_caption_bgcolor%>><font <%=font_default_caption%>><b><%=getLabelName("MW_TEXT")%></b></font>
										</td>
									</tr>
									
									<tr>
										<td <%=td_bgcolor%>><font <%=font_default%>>&nbsp;<%=Session("MW_TEXT")%></font>
										</td>
									</tr>
								<%end if %>
								
								<%if not checkHideField("MF_TEXT") then%>
									<tr>
										<td <%=td_caption_bgcolor%>><font <%=font_default_caption%>><b><%=getLabelName("MF_TEXT")%></b></font>
										</td>
									</tr>
									
									<tr>
										<td <%=td_bgcolor%>><font <%=font_default%>>&nbsp;<%=Session("MF_TEXT")%></font>
										</td>
									</tr>
								<%end if %>
                   
								
								
								<%if CBool(application("compound_types_used")) = True then%>
                   
									<tr>
										<td <%=td_caption_bgcolor%>><font <%=font_default_caption%>><b><%=getLabelName("Compound_Type")%></b></font>
										</td>
									</tr>
									
									<tr>
										<td<%=td_bgcolor%>><font <%=font_default%>>&nbsp;<%=Session("Compound_Type")%></font>
										</td>
									</tr>
								<%end if %>
								
								<%if CBool(application("structure_comments_text")) = True then%>
									<tr>
										<td  <%=td_caption_bgcolor%>><font <%=font_default_caption%>><b><%=getLabelName("STRUCTURE_COMMENTS_TXT")%></b></font>
										</td>
									</tr>

									<tr>
									    <td  <%=td_bgcolor%> ><font <%=font_default%>>&nbsp;<%=Session("Struc_Comments_Text")%></font>
									    </td>
									 </tr>
								<%end if%>
								
								
						
								<%if not checkHideField("CHEMICAL_NAME") then%>

									<tr>
										<td <%=td_caption_bgcolor%>><strong><font <%=font_default_caption%>><%=getLabelName("CHEMICAL_NAME")%></font></strong>
										</td>
									</tr>
              
									<tr>
										<td  <%=td_bgcolor%>>
											
											<font <%=font_default%>>&nbsp;<%=Session("ChemNames")%></font>
										</td>
									</tr>
								<%end if%>
								
								<%if CBool(Application("AUTOGENERATED_CHEMICAL_NAME")) = True then%>
									<%if not checkHideField_Ignore_Derived("CHEM_NAME_AUTOGEN") then%>
										<%if  checkHideField("CHEMICAL_NAME") then
											add_gen_text = "" 
										else
											add_gen_text = "autogenerated"
										end if
									end if
								end if%>

								<%if not checkHideField_Ignore_Derived("CHEM_NAME_AUTOGEN") then %>
									<tr>
										<td  <%=td_caption_bgcolor%>>  <font <%=font_default_caption%>><b><%=getLabelName("CHEM_NAME_AUTOGEN")%>&nbsp; <%=add_gen_text%></b></font>
										</td>
									</tr>
								  
									<tr>
										<td  <%=td_bgcolor%>><font <%=font_default%>>&nbsp;<%=Session("ChemNamesAutoGen")%></font>
										</td>
									</tr>
								<%end if%>

								<%if not checkHideField("Synonym_R") then%>
									<tr>
										<td  <%=td_caption_bgcolor%>><strong><font <%=font_default_caption%>><%=getLabelName("Synonym_R")%></font></strong><br>
										</td>
									</tr>

									<tr>
										<td  <%=td_bgcolor%>><font <%=font_default%>>&nbsp;<%=Session("Synonyms")%></font>
										</td>
									</tr>
								<%end if%>
								
							
							</table>
                        </div>
					</td>
				</tr>
			
                
            </table>
        </div>
	</td>
</tr>
</table>
	
<%'end registered compound information%>
</td>
		
	<%

	CloseRS(MoleculesRS)


CloseConn(DataConn)
next 'i


%>
</td></tr></table></td></tr></table></form>
</body>

</html>
