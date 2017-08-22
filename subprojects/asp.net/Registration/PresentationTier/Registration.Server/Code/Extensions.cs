﻿using System.Collections.Generic;
using System.Reflection;
using System.Xml;
using CambridgeSoft.COE.Registration.Services.Types;

namespace PerkinElmer.COE.Registration.Server.Code
{
    public static class Extensions
    {
        private static void UpdateFromXml(object obj, XmlNode node)
        {
            var args = new object[] { node };
            obj.GetType().GetMethod("UpdateFromXml", BindingFlags.NonPublic | BindingFlags.Instance).Invoke(obj, args);
        }

        private static void RemoveItem(object obj, int index)
        {
            var args = new object[] { index };
            obj.GetType().GetMethod("RemoveItem", BindingFlags.NonPublic | BindingFlags.Instance).Invoke(obj, args);
        }

        public static void UpdateFromXmlEx(this RegistryRecord record, string xml)
        {
            var doc = new XmlDocument();
            doc.LoadXml(xml);
            var rootNode = doc.DocumentElement;

            // RegistryRecord itself only update properties that are allowed to be updated not auto-generated fields like person created
            var matchingChild = rootNode.SelectSingleNode("SubmissionComments");
            if (matchingChild != null && !string.IsNullOrEmpty(matchingChild.InnerText) && (record.SubmissionComments != matchingChild.InnerText))
                record.SubmissionComments = matchingChild.InnerText;

            record.PropertyList.UpdateFromXmlEx(rootNode.SelectSingleNode("PropertyList"));
            record.ProjectList.UpdateFromXmlEx(rootNode.SelectSingleNode("ProjectList"));
            record.IdentifierList.UpdateFromXmlEx(rootNode.SelectSingleNode("IdentifierList"));
            record.BatchList.UpdateFromXmlEx(rootNode.SelectSingleNode("BatchList"));
            record.ComponentList.UpdateFromXmlEx(rootNode.SelectSingleNode("ComponentList"));
        }

        public static void UpdateFromXmlEx(this PropertyList list, XmlNode dataNode)
        {
            if (dataNode == null) return;
            UpdateFromXml(list, dataNode);
        }

        public static void UpdateFromXmlEx(this ProjectList list, XmlNode dataNode)
        {
            if (dataNode == null) return;
            var nodes = dataNode.SelectNodes("Project");
            var itemsToRemove = new List<int>();
            var index = 0;
            foreach (var p in list)
            {
                XmlNode matchingChild = dataNode.SelectSingleNode(string.Format("Project[ID='{0}']", p.ID));
                // If a node matches this ID, we should update the matching object.
                if (matchingChild != null)
                    UpdateFromXml(p, matchingChild);
                else
                    itemsToRemove.Insert(0, index);
                ++index;
            }
            foreach (var itemIndex in itemsToRemove)
            {
                RemoveItem(list, itemIndex);
            }
            foreach (XmlNode node in nodes)
            {
                XmlNode idNode = node.SelectSingleNode("ID");
                if (idNode == null || idNode.InnerText == "0" || idNode.InnerText == string.Empty)
                {
                    list.Add(Project.NewProject(node.OuterXml, false, true));
                }
            }
        }

        public static void UpdateFromXmlEx(this IdentifierList list, XmlNode dataNode)
        {
            if (dataNode == null) return;
            UpdateFromXml(list, dataNode);
        }

        public static void UpdateFromXmlEx(this BatchList list, XmlNode dataNode)
        {
            if (dataNode == null) return;
            UpdateFromXml(list, dataNode);
        }

        public static void UpdateFromXmlEx(this ComponentList list, XmlNode dataNode)
        {
            if (dataNode == null) return;
            UpdateFromXml(list, dataNode);
        }
    }
}