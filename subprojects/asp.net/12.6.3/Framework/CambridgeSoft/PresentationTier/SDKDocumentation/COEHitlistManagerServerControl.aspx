<%@ Page Language="C#" AutoEventWireup="true" CodeFile="COEHitlistManagerServerControl.aspx.cs" Inherits="COEHitlistManagerServerControl" %>

<%@ Register Assembly="CambridgeSoft.COE.Framework" Namespace="CambridgeSoft.COE.Framework.Controls.COEHitlistManager"
    TagPrefix="COECntrl" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>COEHitListManager Server Control</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <coecntrl:coehitlistmanager id="COEHitlistManager1" runat="server" AppName="SAMPLE"></coecntrl:coehitlistmanager>
    
    </div>
    </form>
</body>
</html>