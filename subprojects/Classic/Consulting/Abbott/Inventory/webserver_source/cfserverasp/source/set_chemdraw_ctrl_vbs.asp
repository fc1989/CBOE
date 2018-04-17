<%' Copyright 1999-2003 CambridgeSoft Corporation. All rights reserved
'DO NOT EDIT THIS FILE%>

<%'access the ini file if the application variables are not yet set. Will only happen one time after an applicaiton has been restarted.


if Application("CD_ACTIVEX_THRESHOLD_IE")="" then
	Application.Lock
	Application("CD_ACTIVEX_THRESHOLD_IE")=GetINIValue( "optional", "GLOBALS", "CD_ACTIVEX_THRESHOLD_IE", "web_app", "cfserver")
	if (Application("CD_ACTIVEX_THRESHOLD_IE")="INIEmpty" or Application("CD_ACTIVEX_THRESHOLD_IE") = "NULL" or Application("CD_ACTIVEX_THRESHOLD_IE") = "") then
		Application("CD_ACTIVEX_THRESHOLD_IE")=6.0
	end if
	Application.UnLock
end if

if Application("PRE_THRESHOLD_CHEM_CONTROL_IE")="" then
	Application.Lock
	Application("PRE_THRESHOLD_CHEM_CONTROL_IE")=GetINIValue( "optional", "GLOBALS", "PRE_THRESHOLD_CHEM_CONTROL_IE", "web_app", "cfserver")
	if (Application("PRE_THRESHOLD_CHEM_CONTROL_IE")="INIEmpty"  or Application("PRE_THRESHOLD_CHEM_CONTROL_IE") = "NULL" or Application("PRE_THRESHOLD_CHEM_CONTROL_IE") = "") then
		Application("PRE_THRESHOLD_CHEM_CONTROL_IE")="PLUGIN"
	end if
	Application.UnLock
end if

if Application("THRESHOLD_CHEM_CONTROL_IE")="" then
	Application.Lock
	Application("THRESHOLD_CHEM_CONTROL_IE")=GetINIValue( "optional", "GLOBALS", "THRESHOLD_CHEM_CONTROL_IE", "web_app", "cfserver")
	if (Application("THRESHOLD_CHEM_CONTROL_IE")="INIEmpty"  or Application("THRESHOLD_CHEM_CONTROL_IE") = "NULL" or Application("THRESHOLD_CHEM_CONTROL_IE") = "") then
		Application("THRESHOLD_CHEM_CONTROL_IE")="PLUGIN"
	end if
	Application.UnLock
end if

'set the chemdraw control session variable
'called from cows_func_js which is loaded on all input, list and result view. Sets the control for the currently users session. Will only be done once
'for an active session.
function SetCD_Ctrl(theCurrCtrl)
	if Not theCurrCtrl <> "" then
		UserAgent = Request.ServerVariables("HTTP_USER_AGENT")
		if Instr(UCase(UserAgent), "MSIE")>0 then
			UserAgentArray = Split(Request.ServerVariables("HTTP_USER_AGENT"),";", -1)
			UserAgentArray2= Split(UserAgentArray(1), "MSIE", -1)
			version = Trim(UserAgentArray2(1))
			version = replace(version, "*", "0")
			on error resume next
			userversion = cDbl(version)
			if err.number > 0 then 'unknow brwoser use threshold IE control
				theCurrCtrl = Application("THRESHOLD_CHEM_CONTROL_IE")
				exit function
			end if
			on error goto 0
				on error resume next
					thresVersion = CDbl(Application("CD_ACTIVEX_THRESHOLD_IE"))
				if err.number > 0 then
					thresVersion = 6.0
				end if
				on error goto 0
				If userversion >= thresVersion then
					theCurrCtrl = Application("THRESHOLD_CHEM_CONTROL_IE")
				else
					theCurrCtrl =Application("PRE_THRESHOLD_CHEM_CONTROL_IE")
				end if	
		else
			'this means the browser is netscape and the plugin is always used at this time.
			theCurrCtrl="PLUGIN"
		end if
	end if
	SetCD_Ctrl=theCurrCtrl
end function


%>