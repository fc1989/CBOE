<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest = "false" CodeFile="COEDataViewManagerTest.aspx.cs" Inherits="COEDataViewManagerTest" %>

<%@ Register Assembly="CambridgeSoft.COE.Framework" Namespace="CambridgeSoft.COE.Framework.Controls.COEDataViewManager"
    TagPrefix="COEDataViewManger" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>COEDataViewManager Server Control Sample Application</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <coedataviewmanger:coedataviewmanager id="COEDataViewManager1" runat="server" height="300px"
            width="400px"></coedataviewmanger:coedataviewmanager>
    
    </div>
    </form>
</body>
</html>
