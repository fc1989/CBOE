﻿//// The following code was generated by Microsoft Visual Studio 2005.
//// The test owner should check each test for validity.
using Microsoft.VisualStudio.TestTools.UnitTesting;
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
    ///This is a test class for CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNotEqual and is intended
    ///to contain all CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNotEqual Unit Tests
    ///</summary>
    [TestClass()]
    public class WhereClauseNotEqualTest
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
        //public void MyTestInitialize()
        //{
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
        ///A test for GetDependantString (DBMSType, ref List&lt;Value&gt;)
        ///</summary>
        [DeploymentItem("CambridgeSoft.COE.Framework.dll")]
        [TestMethod()]
        public void GetDependantStringWhereClauseNotEqualTest()
        {
            WhereClauseNotEqual target = new WhereClauseNotEqual();

            target.DataField = new Field();
            target.DataField.FieldName = "MolWeight";
            target.DataField.FieldType = System.Data.DbType.Int32;
            target.CaseSensitive = true;
            target.TrimPosition = SearchCriteria.Positions.Both;

            target.Val = new Value();
            target.Val.Val = "   00000018	";
            target.Val.Type = System.Data.DbType.Int32;

            NormalizationUtils.TrimValue(target.Val.Val, target.Val.Type, target.TrimPosition);

            //CambridgeSoft.COE.Framework.Common.UnitTests.CambridgeSoft_COE_Framework_Common_SqlGenerator_Queries_WhereItems_WhereClauseNotEqualAccessor accessor = new CambridgeSoft.COE.Framework.Common.UnitTests.CambridgeSoft_COE_Framework_Common_SqlGenerator_Queries_WhereItems_WhereClauseNotEqualAccessor(target);

            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("18", target.DataField.FieldType));

            string expected = "(\"MolWeight\" <> :0)";
            string actual;

            actual = target.Execute(DBMSType.ORACLE, values);

            Assert.IsTrue(CompareElements(values_expected, values), "values_GetDependantString_expected was not set correctly.");
            Assert.AreEqual(expected, actual, "CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNot" +
                    "Equal.GetDependantString did not return the expected value.");
        }

        [TestMethod()]
        public void GetDependantStringWhereClauseNotEqual_TextNullTest()
        {
            WhereClauseNotEqual target = new WhereClauseNotEqual();

            target.DataField = new Field();
            target.DataField.FieldName = "MolWeight";
            target.DataField.FieldType = System.Data.DbType.String;
            target.CaseSensitive = true;
            target.TrimPosition = SearchCriteria.Positions.Both;

            target.Val = new Value();
            target.Val.Val = "null";
            target.Val.Type = System.Data.DbType.String;
            NormalizationUtils.TrimValue(target.Val.Val, target.Val.Type, target.TrimPosition);

            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("18", target.DataField.FieldType));

            string expected = "\"MolWeight\" IS NOT NULL";
            string actual;

            actual = target.Execute(DBMSType.ORACLE, values);


            Assert.AreEqual(expected, actual, "CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNot" +
                    "Equal.GetDependantString did not return the expected value.");
        }



        [TestMethod()]
        public void GetDependantStringWhereClauseNotEqual_TextNotNullTest()
        {
            WhereClauseNotEqual target = new WhereClauseNotEqual();

            target.DataField = new Field();
            target.DataField.FieldName = "MolWeight";
            target.DataField.FieldType = System.Data.DbType.String;
            target.CaseSensitive = true;
            target.TrimPosition = SearchCriteria.Positions.Both;

            target.Val = new Value();
            target.Val.Val = "not null";
            target.Val.Type = System.Data.DbType.String;
            NormalizationUtils.TrimValue(target.Val.Val, target.Val.Type, target.TrimPosition);

            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("18", target.DataField.FieldType));

            string expected = "\"MolWeight\" IS NULL";
            string actual;

            actual = target.Execute(DBMSType.ORACLE, values);


            Assert.AreEqual(expected, actual, "CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNot" +
                    "Equal.GetDependantString did not return the expected value.");
        }

        [TestMethod()]
        public void GetDependantStringWhereClauseNotEqual_TextTest()
        {
            WhereClauseNotEqual target = new WhereClauseNotEqual();

            target.DataField = new Field();
            target.DataField.FieldName = "MolWeight";
            target.DataField.FieldType = System.Data.DbType.String;
            target.CaseSensitive = false;
            target.TrimPosition = SearchCriteria.Positions.Both;

            target.Val = new Value();
            target.Val.Val = "Value";
            target.Val.Type = System.Data.DbType.String;
            NormalizationUtils.TrimValue(target.Val.Val, target.Val.Type, target.TrimPosition);

            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("18", target.DataField.FieldType));

            string expected = "(LOWER(TRIM(\"MolWeight\")) <> :0)";
            string actual;

            actual = target.Execute(DBMSType.ORACLE, values);


            Assert.AreEqual(expected, actual, "CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNot" +
                    "Equal.GetDependantString did not return the expected value.");
        }

        [TestMethod()]
        public void GetDependantStringWhereClauseNotEqual_RealTest()
        {
            WhereClauseNotEqual target = new WhereClauseNotEqual();

            target.DataField = new Field();
            target.DataField.FieldName = "MolWeight";
            target.DataField.FieldType = System.Data.DbType.Double;
            target.CaseSensitive = false;
            target.TrimPosition = SearchCriteria.Positions.Both;

            target.Val = new Value();
            target.Val.Val = "1.2";
            target.Val.Type = System.Data.DbType.Double;
            NormalizationUtils.TrimValue(target.Val.Val, target.Val.Type, target.TrimPosition);

            List<Value> values = new List<Value>();
            List<Value> values_expected = new List<Value>();
            values_expected.Add(new Value("18", target.DataField.FieldType));

            string expected = "(\"MolWeight\" NOT BETWEEN :0 AND :1)";
            string actual;

            actual = target.Execute(DBMSType.ORACLE, values);


            Assert.AreEqual(expected, actual, "CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNot" +
                    "Equal.GetDependantString did not return the expected value.");
        }

        [TestMethod()]
        public void GetDependantStringWhereClauseNotEqualDate_OracleTest()
        {
            try
            {
                WhereClauseNotEqual target = new WhereClauseNotEqual();
                target.DataField = new Field();
                target.DataField.FieldName = "DateCreation";
                target.DataField.FieldType = System.Data.DbType.Date;
                target.CaseSensitive = true;
                target.TrimPosition = SearchCriteria.Positions.Both;
                target.Val = new Value();
                target.Val.Val = "01/01/1000";
                target.Val.Type = System.Data.DbType.Date;
                NormalizationUtils.TrimValue(target.Val.Val, target.Val.Type, target.TrimPosition);
                List<Value> values = new List<Value>();
                List<Value> values_expected = new List<Value>();
                values_expected.Add(new Value("01/01/1000", target.DataField.FieldType));
                string expected = "(\"DateCreation\" <> TO_DATE(:0,'yyyy/MM/dd hh24:mi:ss'))";
                string actual;
                actual = target.Execute(DBMSType.ORACLE, values);
                Assert.AreEqual(expected, actual, "CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNot" +
        "Equal.GetDependantString did not return the expected value.");
            }
            catch
            {
                throw;
            }


        }


        [TestMethod()]
        public void GetDependantStringWhereClauseNotEqualDate_SqlTest()
        {
            try
            {
                WhereClauseNotEqual target = new WhereClauseNotEqual();
                target.DataField = new Field();
                target.DataField.FieldName = "DateCreation";
                target.DataField.FieldType = System.Data.DbType.Date;
                target.CaseSensitive = true;
                target.TrimPosition = SearchCriteria.Positions.Both;
                target.Val = new Value();
                target.Val.Val = "01/01/1000";
                target.Val.Type = System.Data.DbType.Date;
                NormalizationUtils.TrimValue(target.Val.Val, target.Val.Type, target.TrimPosition);
                List<Value> values = new List<Value>();
                List<Value> values_expected = new List<Value>();
                values_expected.Add(new Value("01/01/1000", target.DataField.FieldType));
                string expected = "(\"DateCreation\" <> CONVERT(DATETIME,:0,101))";
                string actual;
                actual = target.Execute(DBMSType.SQLSERVER, values);
                Assert.AreEqual(expected, actual, "CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNot" +
        "Equal.GetDependantString did not return the expected value.");
            }
            catch
            {
                throw;
            }
        }

        [TestMethod()]
        public void GetDependantStringWhereClauseNotEqualDate_AccessTest()
        {
            try
            {
                WhereClauseNotEqual target = new WhereClauseNotEqual();
                target.DataField = new Field();
                target.DataField.FieldName = "DateCreation";
                target.DataField.FieldType = System.Data.DbType.Date;
                target.CaseSensitive = true;
                target.TrimPosition = SearchCriteria.Positions.Both;
                target.Val = new Value();
                target.Val.Val = "01/01/1000";
                target.Val.Type = System.Data.DbType.Date;
                NormalizationUtils.TrimValue(target.Val.Val, target.Val.Type, target.TrimPosition);
                List<Value> values = new List<Value>();
                List<Value> values_expected = new List<Value>();
                values_expected.Add(new Value("01/01/1000", target.DataField.FieldType));
                string expected = "(\"DateCreation\" <> FORMAT(:0,'yyyy/MM/dd HH:mm:ss'))";
                string actual;
                actual = target.Execute(DBMSType.MSACCESS, values);
                Assert.AreEqual(expected, actual, "CambridgeSoft.COE.Framework.Common.SqlGenerator.Queries.WhereItems.WhereClauseNot" +
        "Equal.GetDependantString did not return the expected value.");
            }
            catch
            {
                throw;
            }
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