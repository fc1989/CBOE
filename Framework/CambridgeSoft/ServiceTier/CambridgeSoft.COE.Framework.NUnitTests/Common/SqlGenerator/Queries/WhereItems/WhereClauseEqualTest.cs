﻿// The following code was generated by Microsoft Visual Studio 2005.
// The test owner should check each test for validity.
using NUnit.Framework;
using System;
using System.Text;
using System.Collections.Generic;
using CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems;
using CambridgeSoft.COE.Framework.Common.SqlGenerator;
using CambridgeSoft.COE.Framework.Common;
using CambridgeSoft.COE.Framework.Common.SqlGenerator.Utils;
namespace CambridgeSoft.COE.Framework.Common.SqlGenerator.UnitTests
{
    /// <summary>
    ///This is a test class for CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseEqual and is intended
    ///to contain all CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseEqual Unit Tests
    ///</summary>
    [TestFixture]
    public class WhereClauseEqualTest
    {


        private TestContext testContextInstance;

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
        //[TestFixtureSetUp]
        //public static void MyClassInitialize()
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //
        //[TestFixtureTearDown]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //
        //[SetUp]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //
        //[TearDown]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion


        /// <summary>
        ///A test for GetDependantString (DBMSType, ref List&lt;Value&gt;)
        ///</summary>
       // [DeploymentItem("CambridgeSoft.COE.Framework.dll")]
        [Test]
        public void GetDependantStringWhereClauseEqualTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.CaseSensitive = true;
            clause.TrimPosition = SearchCriteria.Positions.Left;
            clause.NormalizeChemicalName = true;

            string chemicalName = "1,2 Dichlorobenzene";
            string normalizedChemicalName = NormalizationUtils.CleanTheSyns(ref chemicalName);
            Assert.AreEqual("12bichlorbenzen", normalizedChemicalName, "CleanTheSyns Failed");
            clause.DataField = new Field();
            clause.DataField.FieldName = "Substance_Name";
            clause.DataField.FieldType = System.Data.DbType.String;
            clause.Val.Type = System.Data.DbType.String;
            clause.Val.Val = "1,2-Dichlorobenzene";
            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("12bichlorbenzen", clause.DataField.FieldType));
            string expected = "(LTRIM(\"Substance_Name\") = COEDB.Normalize(:0))";
            string actual = clause.Execute(DBMSType.ORACLE, values);
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");

        }


        /// <summary>
        ///A test for GetDependantString (DBMSType, ref List&lt;Value&gt;) CaseSensitive:False and SearchCriteria.Positions:Both
        ///</summary>
       // [DeploymentItem("CambridgeSoft.COE.Framework.dll")]
        [Test]
        public void GetDependantStringWhereClauseEqual_CaseSensitiveFalseTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.CaseSensitive = false;
            clause.TrimPosition = SearchCriteria.Positions.Both;
            clause.NormalizeChemicalName = true;

            string chemicalName = "1,2 Dichlorobenzene";
            string normalizedChemicalName = NormalizationUtils.CleanTheSyns(ref chemicalName);
            Assert.AreEqual("12bichlorbenzen", normalizedChemicalName, "CleanTheSyns Failed");
            clause.DataField = new Field();
            clause.DataField.FieldName = "Substance_Name";
            clause.DataField.FieldType = System.Data.DbType.String;
            clause.Val.Type = System.Data.DbType.String;
            clause.Val.Val = "1,2-Dichlorobenzene";
            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("12bichlorbenzen", clause.DataField.FieldType));
            string expected = "(LOWER(TRIM(\"Substance_Name\")) = COEDB.Normalize(:0))";
            string actual = clause.Execute(DBMSType.ORACLE, values);
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");

        }

        /// <summary>
        ///A test for GetDependantString (DBMSType, ref List&lt;Value&gt;) CaseSensitive:False and SearchCriteria.Positions:Both
        ///</summary>
       // [DeploymentItem("CambridgeSoft.COE.Framework.dll")]
        [Test]
        public void GetDependantStringWhereClauseEqual_CaseSensitiveMsAccessTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.CaseSensitive = false;
            clause.TrimPosition = SearchCriteria.Positions.Right;
            clause.NormalizeChemicalName = true;
            string chemicalName = "1,2 Dichlorobenzene";
            string normalizedChemicalName = NormalizationUtils.CleanTheSyns(ref chemicalName);
            Assert.AreEqual("12bichlorbenzen", normalizedChemicalName, "CleanTheSyns Failed");
            clause.DataField = new Field();
            clause.DataField.FieldName = "Substance_Name";
            clause.DataField.FieldType = System.Data.DbType.String;
            clause.Val.Type = System.Data.DbType.String;
            clause.Val.Val = "1,2-Dichlorobenzene";
            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("12bichlorbenzen", clause.DataField.FieldType));
            string expected = "(LCASE(RTRIM(\"Substance_Name\")) = COEDB.Normalize(:0))";
            string actual = clause.Execute(DBMSType.MSACCESS, values);
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");

        }


        /// <summary>
        /// Unit Test For Integer Type
        /// </summary>
        [Test]
        public void GetDependantIntegerWhereClauseEqualTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.CaseSensitive = true;
            clause.TrimPosition = SearchCriteria.Positions.Left;
            clause.NormalizeChemicalName = false;

            clause.DataField = new Field();
            clause.DataField.FieldName = "Substance_Name";
            clause.DataField.FieldType = System.Data.DbType.Int16;

            clause.Val.Type = System.Data.DbType.Int16;
            clause.Val.Val = "1";

            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("1", clause.DataField.FieldType));
            string expected = "(\"Substance_Name\" = :0)";
            string actual = clause.Execute(DBMSType.ORACLE, values);
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");

        }

        /// <summary>
        /// Unit Test For Real Type
        /// </summary>
        [Test]
        public void GetDependantRealWhereClauseEqualTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.CaseSensitive = true;
            clause.TrimPosition = SearchCriteria.Positions.Left;
            clause.NormalizeChemicalName = false;

            clause.DataField = new Field();
            clause.DataField.FieldName = "Substance_Name";
            clause.DataField.FieldType = System.Data.DbType.Double;

            clause.Val.Type = System.Data.DbType.Double;
            clause.Val.Val = "1.2";

            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("1", clause.DataField.FieldType));
            string expected = "(\"Substance_Name\" BETWEEN :0 AND :1)";
            string actual = clause.Execute(DBMSType.ORACLE, values);
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");

        }


        /// <summary>
        /// Unit Test For Date Type & DB :ORACLE
        /// </summary>
        [Test]
        public void GetDependantDateORACLEWhereClauseEqualTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.CaseSensitive = true;
            clause.TrimPosition = SearchCriteria.Positions.Both;
            clause.NormalizeChemicalName = false;
            clause.DataField = new Field();
            clause.DataField.FieldName = "DATE_CREATED";
            clause.DataField.FieldType = System.Data.DbType.Date;
            clause.Val.Type = System.Data.DbType.Date;
            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("1", clause.DataField.FieldType));
            string expected = "(\"DATE_CREATED\" = TO_DATE(:0,'yyyy/MM/dd hh24:mi:ss'))";
            string actual = clause.Execute(DBMSType.ORACLE, values);
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");

        }

        /// <summary>
        /// Unit Test For Date Type & DB :SQLSERVER
        /// </summary>
        [Test]
        public void GetDependantDateSQLSERVERWhereClauseEqualTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.CaseSensitive = true;
            clause.TrimPosition = SearchCriteria.Positions.Both;
            clause.NormalizeChemicalName = false;
            clause.DataField = new Field();
            clause.DataField.FieldName = "DATE_CREATED";
            clause.DataField.FieldType = System.Data.DbType.Date;
            clause.Val.Type = System.Data.DbType.Date;
            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("1", clause.DataField.FieldType));
            string expected = "(\"DATE_CREATED\" = CONVERT(DATETIME,True0,101))";
            string actual = clause.Execute(DBMSType.SQLSERVER, values);
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");

        }

        /// <summary>
        /// Unit Test For Date Type & DB :MSACCESS
        /// </summary>
        [Test]
        public void GetDependantDateMSACCESSWhereClauseEqualTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.CaseSensitive = true;
            clause.TrimPosition = SearchCriteria.Positions.Both;
            clause.NormalizeChemicalName = false;
            clause.DataField = new Field();
            clause.DataField.FieldName = "DATE_CREATED";
            clause.DataField.FieldType = System.Data.DbType.Date;
            clause.Val.Type = System.Data.DbType.Date;
            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("1", clause.DataField.FieldType));
            string expected = "(\"DATE_CREATED\" = FORMAT(:0,'yyyy/MM/dd HH:mm:ss'))";
            string actual = clause.Execute(DBMSType.MSACCESS, values);
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");

        }

        /// <summary>
        ///A test for GetDependantString (DBMSType, ref List&lt;Value&gt;)
        ///</summary>
       // [DeploymentItem("CambridgeSoft.COE.Framework.dll")]
        [Test]
        public void GetDependantStringISNULLWhereClauseEqualTest()
        {
            WhereClauseEqual clause = new WhereClauseEqual();
            clause.DataField = new Field();
            clause.DataField.FieldName = "Substance_Name";
            clause.DataField.FieldType = System.Data.DbType.String;

            clause.Val.Type = System.Data.DbType.String;
            clause.Val.Val = "NULL";

            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();

            string expected = "(\"Substance_Name\" IS NULL)";
            string actual;

            actual = clause.Execute(DBMSType.ORACLE, values);

            Assert.IsTrue(CompareElements(values_expected, values), "values_GetDependantString_expected was not set correctly.");
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");


            clause.Val.Val = "NOT NULL";
            expected = "(\"Substance_Name\" IS NOT NULL)";
            actual = clause.Execute(DBMSType.ORACLE, values);

            Assert.IsTrue(CompareElements(values_expected, values), "values_GetDependantString_expected was not set correctly.");
            Assert.AreEqual(expected, actual, "WhereClauseEqual.GetDependantString did not return the expected value.");
        }

        private bool CompareElements(List<Value> values_expected, List<Value> values)
        {
            if (values_expected.Count != values.Count)
                return false;
            for (int i = 0; i < values.Count; i++)
            {

                if (values_expected[i] != values[i])
                    return false;
            }
            return true;
        }

    }


}
