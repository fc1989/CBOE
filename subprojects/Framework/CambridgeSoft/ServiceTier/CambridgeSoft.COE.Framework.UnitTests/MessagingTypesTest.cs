﻿// The following code was generated by Microsoft Visual Studio 2005.
// The test owner should check each test for validity.
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Text;
using System.Collections.Generic;
using System.Xml;
using CambridgeSoft.COE.Framework.Common;
using CambridgeSoft.COE.Framework.Common.Messaging;
using System.IO;
namespace CambridgeSoft.COE.Framework.Common.UnitTests
{
    /// <summary>
    ///This is a test class for CambridgeSoft.COE.Framework.Common.DataView and is intended
    ///to contain all CambridgeSoft.COE.Framework.Common.DataView Unit Tests
    ///</summary>
    [TestClass()]
    public class SerializationTest
    {
        private TestContext testContextInstance;
        private string pathToXmls = Utilities.GetProjectBasePath("CambridgeSoft.COE.Framework.UnitTests") + @"\Serialization XML";

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }
        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //
        //[TestInitialize()]
        //public void MyTestInitialize() {
        //	
        //}
        //
        //Use TestCleanup to run code after each test has run
        //
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion
        /// <summary>
        ///A test for GetFromXML (string)
        ///</summary>
        [TestMethod()]
        public void COEFormGeneratorSerializationTest()
        {
            try
            {
                XmlDocument document = new XmlDocument();
                document.Load(pathToXmls + @"\COEForm.xml");

                FormGroup.Form form = FormGroup.Form.GetForm(document.OuterXml);

                string xml = form.ToString();
                document.LoadXml(xml);
            }
            catch(Exception exception)
            {
                Assert.Fail(exception.Message);
            }

        }
        /// <summary>
        ///A test for GetFromXML (string)
        ///</summary>
        [TestMethod()]
        public void SQLGeneratorSerializationTest()
        {
            try
            {
                //DeSerialize Original DataView.XML
                System.Xml.Serialization.XmlSerializer dataViewSerializer = new System.Xml.Serialization.XmlSerializer(typeof(COEDataView));
                System.IO.FileStream inputStream = File.OpenRead(pathToXmls + "\\DataView.xml");
                COEDataView dataview = (COEDataView) dataViewSerializer.Deserialize(inputStream);
                inputStream.Close();
                COEDataView alternateDataview = Utilities.XmlDeserialize<COEDataView>(File.ReadAllText(pathToXmls + "\\DataView.xml"));
                Assert.IsTrue(AreEqual(dataview, alternateDataview));

                //Serialize it
                System.IO.FileStream outputStream = new System.IO.FileStream(pathToXmls + "\\DataViewSerialized.xml", System.IO.FileMode.Create);
                dataViewSerializer.Serialize(outputStream, dataview);
                outputStream.Close();
                alternateDataview = Utilities.XmlDeserialize<COEDataView>(File.ReadAllText(pathToXmls + "\\DataViewSerialized.xml"));
                Assert.IsTrue(AreEqual(dataview, alternateDataview));

                //Load DataViewSerialized.XML
                XmlDocument doc = new XmlDocument();
                doc.Load(pathToXmls + "\\DataViewSerialized.xml");
                dataview.GetFromXML(doc);

                outputStream = new System.IO.FileStream(pathToXmls + "\\DataViewSaved.xml", System.IO.FileMode.Create);
                outputStream.Write(UTF8Encoding.UTF8.GetBytes(dataview.ToString()), 0,
                                            UTF8Encoding.UTF8.GetByteCount(dataview.ToString()));
                outputStream.Close();
                alternateDataview = Utilities.XmlDeserialize<COEDataView>(File.ReadAllText(pathToXmls + "\\DataViewSaved.xml"));
                Assert.IsTrue(AreEqual(dataview, alternateDataview));

                //DeSerialize Original SearchCriteria.XML
                System.Xml.Serialization.XmlSerializer searchCriteriaSerializer = new System.Xml.Serialization.XmlSerializer(typeof(SearchCriteria));
                inputStream = File.OpenRead(pathToXmls + "\\SearchCriteria.xml");
                SearchCriteria searchcriteria = (SearchCriteria) searchCriteriaSerializer.Deserialize(inputStream);
                inputStream.Close();
                SearchCriteria alternateSearchCriteria = Utilities.XmlDeserialize<SearchCriteria>(File.ReadAllText(pathToXmls + "\\SearchCriteria.xml"));
                Assert.IsTrue(AreEqual(searchcriteria, alternateSearchCriteria));

                //Serialize it
                outputStream = new System.IO.FileStream(pathToXmls + "\\SearchCriteriaSerialized.xml", System.IO.FileMode.Create);
                searchCriteriaSerializer.Serialize(outputStream, searchcriteria);
                outputStream.Close();
                alternateSearchCriteria = Utilities.XmlDeserialize<SearchCriteria>(File.ReadAllText(pathToXmls + "\\SearchCriteriaSerialized.xml"));
                Assert.IsTrue(AreEqual(searchcriteria, alternateSearchCriteria));

                //Load SearchCriteriaSerialized.XML
                doc = new XmlDocument();
                doc.Load(pathToXmls + "\\SearchCriteriaSerialized.xml");
                searchcriteria.GetFromXML(doc);

                outputStream = new System.IO.FileStream(pathToXmls + "\\SearchCriteriaSaved.xml", System.IO.FileMode.Create);
                outputStream.Write(UTF8Encoding.UTF8.GetBytes(searchcriteria.ToString()), 0,
                                            UTF8Encoding.UTF8.GetByteCount(searchcriteria.ToString()));
                outputStream.Close();
                alternateSearchCriteria = Utilities.XmlDeserialize<SearchCriteria>(File.ReadAllText(pathToXmls + "\\SearchCriteriaSaved.xml"));
                Assert.IsTrue(AreEqual(searchcriteria, alternateSearchCriteria));

                //DeSerialize Original ResultsCriteria.XML
                System.Xml.Serialization.XmlSerializer resultsCriteriaSerializer = new System.Xml.Serialization.XmlSerializer(typeof(ResultsCriteria));
                inputStream = File.OpenRead(pathToXmls + "\\ResultCriteria.xml");
                ResultsCriteria resultscriteria = (ResultsCriteria) resultsCriteriaSerializer.Deserialize(inputStream);
                inputStream.Close();
                ResultsCriteria alternateResultsCriteria = Utilities.XmlDeserialize<ResultsCriteria>(File.ReadAllText(pathToXmls + "\\ResultCriteria.xml"));
                Assert.IsTrue(AreEqual(resultscriteria, alternateResultsCriteria));

                //Serialize it
                outputStream = new System.IO.FileStream(pathToXmls + "\\ResultsCriteriaSerialized.xml", System.IO.FileMode.Create);
                resultsCriteriaSerializer.Serialize(outputStream, resultscriteria);
                outputStream.Close();
                alternateResultsCriteria = Utilities.XmlDeserialize<ResultsCriteria>(File.ReadAllText(pathToXmls + "\\ResultsCriteriaSerialized.xml"));
                Assert.IsTrue(AreEqual(resultscriteria, alternateResultsCriteria));

                //Load ResultsCriteriaSerialized.XML
                doc = new XmlDocument();
                doc.Load(pathToXmls + "\\ResultsCriteriaSerialized.xml");
                resultscriteria.GetFromXML(doc);

                outputStream = new System.IO.FileStream(pathToXmls + "\\ResultsCriteriaSaved.xml", System.IO.FileMode.Create);
                outputStream.Write(UTF8Encoding.UTF8.GetBytes(resultscriteria.ToString()), 0,
                                            UTF8Encoding.UTF8.GetByteCount(resultscriteria.ToString()));
                outputStream.Close();
                alternateResultsCriteria = Utilities.XmlDeserialize<ResultsCriteria>(File.ReadAllText(pathToXmls + "\\ResultsCriteriaSaved.xml"));
                Assert.IsTrue(AreEqual(resultscriteria, alternateResultsCriteria));
                
                //DeSerialize Original SearchResponse.XML
                System.Xml.Serialization.XmlSerializer searchResponseSerializer = new System.Xml.Serialization.XmlSerializer(typeof(SearchResponse));
                inputStream = File.OpenRead(pathToXmls + "\\SearchResponse.xml");
                SearchResponse searchresponse = (SearchResponse) searchResponseSerializer.Deserialize(inputStream);
                inputStream.Close();

                //Serialize it
                outputStream = new System.IO.FileStream(pathToXmls + "\\SearchResponseSerialized.xml", System.IO.FileMode.Create);
                searchResponseSerializer.Serialize(outputStream, searchresponse);
                outputStream.Close();

                //Load SearchResponseSerialized.XML
                searchResponseSerializer = new System.Xml.Serialization.XmlSerializer(typeof(SearchResponse));
                inputStream = File.OpenRead(pathToXmls + "\\SearchResponseSerialized.xml");
                searchresponse = (SearchResponse) searchResponseSerializer.Deserialize(inputStream);
                inputStream.Close();

                outputStream = new System.IO.FileStream(pathToXmls + "\\SearchResponseSaved.xml", System.IO.FileMode.Create);
                outputStream.Write(UTF8Encoding.UTF8.GetBytes(searchresponse.ToString()), 0,
                                            UTF8Encoding.UTF8.GetByteCount(searchresponse.ToString()));
                outputStream.Close();

            }
            catch(System.UnauthorizedAccessException unauthorizedException)
            {
                Assert.Fail("You must set the file permissions to writable - " + unauthorizedException.Message);
            }
            catch(Exception exception)
            {
                Assert.Fail(exception.Message);
            }

        }

        /// <summary>
        ///A test for GetFromXML (string)
        ///</summary>
        [TestMethod()]
        public void SearchResponseConstructorTest()
        {
            try
            {
                //DeSerialize Original SearchResponse.XML
                XmlDocument doc = new XmlDocument();
                doc.Load(pathToXmls + "\\SearchResponse.xml");
                SearchResponse searchresponse = new SearchResponse(doc);
                searchresponse = Utilities.XmlDeserialize<SearchResponse>(File.ReadAllText(pathToXmls + "\\SearchResponse.xml"));
            }
            catch(Exception exception)
            {
                Assert.Fail(exception.Message);
            }
        }

        /// <summary>
        /// A test for serializing in binary format a FormGroup. Specifically needed for ConfigInfo property.
        /// </summary>
        [TestMethod()]
        public void FormGroupBinarySerialization()
        {
            XmlDocument document = new XmlDocument();
            document.Load(pathToXmls + @"\COEFormGroup.xml");
            FormGroup formGroup = FormGroup.GetFormGroup(document.OuterXml);
            /* Prepare for serialization */
            System.Runtime.Serialization.IFormatter formatter = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            Stream stream = new FileStream(pathToXmls + @"\COEFormGroup.bin", FileMode.Create, FileAccess.Write, FileShare.Write);

            /* Serialize the object */
            formatter.Serialize(stream, formGroup);
            stream.Close();

            /* Prepare for deserialization */
            System.Runtime.Serialization.IFormatter formatter2 = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            Stream stream2 = File.OpenRead(pathToXmls + @"\COEFormGroup.bin");

            /* Unserialize the object */
            FormGroup formGroup2 = (FormGroup) formatter2.Deserialize(stream2);
        }

        /// <summary>
        /// A test for serializing in binary format a SearchCriteria. Specifically needed for Custom clauses.
        /// </summary>
        [TestMethod()]
        public void SearchCriteriaBinarySerialization()
        {
            XmlDocument document = new XmlDocument();
            document.Load(pathToXmls + @"\CustomSearchCriteria.xml");
            SearchCriteria searchCriteria = new SearchCriteria(document);
            /* Prepare for serialization */
            System.Runtime.Serialization.IFormatter formatter = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            Stream stream = new FileStream(pathToXmls + @"\CustomSearchCriteria.bin", FileMode.Create, FileAccess.Write, FileShare.Write);

            /* Serialize the object */
            formatter.Serialize(stream, searchCriteria);
            stream.Close();

            /* Prepare for deserialization */
            System.Runtime.Serialization.IFormatter formatter2 = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            Stream stream2 = File.OpenRead(pathToXmls + @"\CustomSearchCriteria.bin");

            /* Unserialize the object */
            SearchCriteria formGroup2 = (SearchCriteria) formatter2.Deserialize(stream2);
        }

        /// <summary>
        /// A test for serializing in binary format a ResultsCriteria. Specifically needed for Custom clauses.
        /// </summary>
        [TestMethod()]
        public void ResultsCriteriaBinarySerialization()
        {
            XmlDocument document = new XmlDocument();
            document.Load(pathToXmls + @"\CustomResultsCriteria.xml");
            ResultsCriteria resultsCriteria = new ResultsCriteria(document);
            /* Prepare for serialization */
            System.Runtime.Serialization.IFormatter formatter = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            Stream stream = new FileStream(pathToXmls + @"\CustomResultsCriteria.bin", FileMode.Create, FileAccess.Write, FileShare.Write);

            /* Serialize the object */
            formatter.Serialize(stream, resultsCriteria);
            stream.Close();

            /* Prepare for deserialization */
            System.Runtime.Serialization.IFormatter formatter2 = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
            Stream stream2 = File.OpenRead(pathToXmls + @"\CustomResultsCriteria.bin");

            /* Unserialize the object */
            ResultsCriteria formGroup2 = (ResultsCriteria) formatter2.Deserialize(stream2);
        }

        private bool AreEqual(COEDataView dataView, COEDataView dataView1)
        {
            if (dataView.Basetable != dataView1.Basetable)
                return false;
            if (dataView.BaseTablePrimaryKey != dataView1.BaseTablePrimaryKey)
                return false;
            if (dataView.DataViewID != dataView1.DataViewID)
                return false;
            if (dataView.XmlNs != dataView1.XmlNs)
                return false;

            for (int i = 0; i < dataView.Relationships.Count; i++)
            {
                if (dataView.Relationships[i].Child != dataView1.Relationships[i].Child)
                    return false;
                if (dataView.Relationships[i].Parent != dataView1.Relationships[i].Parent)
                    return false;
                if (dataView.Relationships[i].ChildKey != dataView1.Relationships[i].ChildKey)
                    return false;
                if (dataView.Relationships[i].ParentKey != dataView1.Relationships[i].ParentKey)
                    return false;
                if (dataView.Relationships[i].JoinType != dataView1.Relationships[i].JoinType)
                    return false;
            }

            for (int i = 0; i < dataView.Tables.Count; i++)
            {
                if (dataView.Tables[i].Alias != null && dataView.Tables[i].Alias != dataView1.Tables[i].Alias)
                    return false;
                if (dataView.Tables[i].Database != null && dataView.Tables[i].Database != dataView1.Tables[i].Database)
                    return false;
                if (dataView.Tables[i].Id != -1 && dataView.Tables[i].Id != dataView1.Tables[i].Id)
                    return false;
                if (dataView.Tables[i].Name != null && dataView.Tables[i].Name != dataView1.Tables[i].Name)
                    return false;
                if (dataView.Tables[i].PrimaryKey != null && dataView.Tables[i].PrimaryKey != dataView1.Tables[i].PrimaryKey)
                    return false;
                for (int j = 0; j < dataView.Tables[i].Fields.Count; j++)
                {
                    if (dataView.Tables[i].Fields[j].DataType != dataView1.Tables[i].Fields[j].DataType)
                        return false;
                    if (dataView.Tables[i].Fields[j].Id != -1 && dataView.Tables[i].Fields[j].Id != dataView1.Tables[i].Fields[j].Id)
                        return false;
                    if (dataView.Tables[i].Fields[j].Name != null && dataView.Tables[i].Fields[j].Name != dataView1.Tables[i].Fields[j].Name)
                        return false;
                }
            }

            return true;
        }

        private bool AreEqual(SearchCriteria searchCriteria, SearchCriteria alternateSearchCriteria)
        {
            if (searchCriteria.SearchCriteriaID != alternateSearchCriteria.SearchCriteriaID)
                return false;
            if (searchCriteria.XmlNS != alternateSearchCriteria.XmlNS)
                return false;
            if (searchCriteria.Items.Count != alternateSearchCriteria.Items.Count)
                return false;

            for (int i = 0; i < searchCriteria.Items.Count; i++)
            {
                if (searchCriteria.Items[i].GetType() != alternateSearchCriteria.Items[i].GetType())
                    return false;
                if (searchCriteria.Items[i].ToString() != alternateSearchCriteria.Items[i].ToString())
                    return false;
            }
            return true;
        }

        private bool AreEqual(ResultsCriteria resultsCriteria, ResultsCriteria alternateResultsCriteria)
        {
            if (resultsCriteria.SortByHitList != alternateResultsCriteria.SortByHitList)
                return false;
            if (resultsCriteria.XmlNS != alternateResultsCriteria.XmlNS)
                return false;
            if (resultsCriteria.Tables.Count != alternateResultsCriteria.Tables.Count)
                return false;

            for (int i = 0; i < resultsCriteria.Tables.Count; i++)
            {
                if (resultsCriteria.Tables[i].Id != alternateResultsCriteria.Tables[i].Id)
                    return false;
                if (resultsCriteria.Tables[i].Criterias.Count != alternateResultsCriteria.Tables[i].Criterias.Count)
                    return false;
                for (int j = 0; j < resultsCriteria.Tables[i].Criterias.Count; j++)
                {
                    if (resultsCriteria.Tables[i].Criterias[j].GetType() != alternateResultsCriteria.Tables[i].Criterias[j].GetType())
                        return false;
                    if (resultsCriteria.Tables[i].Criterias[j].Alias != alternateResultsCriteria.Tables[i].Criterias[j].Alias)
                        return false;
                    if (resultsCriteria.Tables[i].Criterias[j].Direction != alternateResultsCriteria.Tables[i].Criterias[j].Direction)
                        return false;
                    if (resultsCriteria.Tables[i].Criterias[j].OrderById != alternateResultsCriteria.Tables[i].Criterias[j].OrderById)
                        return false;
                    if (resultsCriteria.Tables[i].Criterias[j].Visible != alternateResultsCriteria.Tables[i].Criterias[j].Visible)
                        return false;
                    if (resultsCriteria.Tables[i].Criterias[j].ToString() != alternateResultsCriteria.Tables[i].Criterias[j].ToString())
                        return false;
                }
            }
            return true;
        }
    }

}