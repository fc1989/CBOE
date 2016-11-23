<%@ Page Language="C#" AutoEventWireup="true" CodeFile="COEChemDrawEmbedTest.aspx.cs" Inherits="COEChemDrawEmbedTest" %>

<%@ Register Assembly="CambridgeSoft.COE.Framework" Namespace="CambridgeSoft.COE.Framework.Controls.ChemDraw"
    TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>COEChemDrawEmbed Server Control Sample Application</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <cc1:COEChemDrawEmbed ID="COEChemDrawEmbed1" runat="server" BorderColor="ActiveBorder"
            BorderStyle="Solid" EditOutOfPlace="False" ShrinkToFit="True">
        </cc1:COEChemDrawEmbed>
        <br />
        <br />
        <input id="btn_getAnalysis" name="btn_getAnalysis" onclick="alert(cd_getAnalysis('COEChemDrawEmbed1',0))"
                        type="button" value=" Get Analysis" /><br />
                            <input id="btn_getformula" name="btn_getformula" onclick="alert(cd_getFormula('COEChemDrawEmbed1',0))"
                        type="button" value="Get Molecular Formula" /><br />
        <input id="btn_getmolecularweight" name="btn_getmolecularweight" onclick="alert(cd_getMolWeight('COEChemDrawEmbed1',0))"
                        type="button" value=" Get Molecular Weight " />&nbsp;<br />
                        

        <br />
        </div>
    </form>
</body>
</html>
