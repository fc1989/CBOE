﻿// The following code was generated by Microsoft Visual Studio 2005.
// The test owner should check each test for validity.
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Text;
using System.Collections.Generic;
using CambridgeSoft.COE.Framework.COEFormService;
using System.Xml;
using CambridgeSoft.COE.Framework.Common;
using CambridgeSoft.COE.Framework.COESecurityService;
namespace CambridgeSoft.COE.Framework.COESecurityService.UnitTests
{
    /// <summary>
    ///This is a test class for CambridgeSoft.COE.Framework.COEFormService.COEFormBOList and is intended
    ///to contain all CambridgeSoft.COE.Framework.COEFormService.COEFormBOList Unit Tests
    ///</summary>
    [TestClass()]
    public class COEUserTests
    {
        private DALFactory _dalFactory = new DALFactory();
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

        [TestInitialize()]
        public void MyTestInitialize()
        {
            COEPrincipal.Logout();
            System.Security.Principal.IPrincipal user = Csla.ApplicationContext.User;

            string userName = "cssadmin";
            string password = "cssadmin";
            bool result = COEPrincipal.Login(userName, password);

        }


        #endregion


        [TestMethod()]
        public void GetUser()
        {

            COEUserReadOnlyBO user = null;
            string userName = "cssadmin";
            user = COEUserReadOnlyBO.Get(userName);

            Assert.IsTrue(user != null, "GetAllUsers did not" +
                    " return the expected value.");
        }

        [TestMethod()]
        public void GetAllUsers()
        {

            COEUserReadOnlyBOList users = null;

            users = COEUserReadOnlyBOList.GetList();

            Assert.IsTrue(users != null, "GetAllUsers did not" +
                    " return the expected value.");
        }
        [TestMethod()]
        public void GetAllUsersByApplicationSingle()
        {

            COEUserReadOnlyBOList users = null;
            List<string> appNames = new List<string>();

            appNames.Add("CHEMINVDB2");

            users = COEUserReadOnlyBOList.GetListByApplication(appNames);

            Assert.IsTrue(users != null, "GetAllUsers did not" +
                    " return the expected value.");
        }

        [TestMethod()]
        public void GetAllUsersByApplicationMulti()
        {

            COEUserReadOnlyBOList users = null;
            List<string> appNames = new List<string>();

            appNames.Add("CHEMINVDB2");
            appNames.Add("SAMPLE");

            users = COEUserReadOnlyBOList.GetListByApplication(appNames);
            Assert.IsTrue(users != null, "GetAllUsers did not" +
                    " return the expected value.");
        }

        [TestMethod()]
        public void GetAllUsersByRoleSingle()
        {

            COEUserReadOnlyBOList users = null;
            List<string> roleNames = new List<string>();

            roleNames.Add("BROWSER");

            users = COEUserReadOnlyBOList.GetListByRole(roleNames);

            Assert.IsTrue(users != null, "GetAllUsers did not" +
                    " return the expected value.");
        }

        [TestMethod()]
        public void GetAllUsersByRoleMulti()
        {

            COEUserReadOnlyBOList users = null;
            List<string> roleNames = new List<string>();

            roleNames.Add("BROWSER");
            roleNames.Add("INVADMIN");

            users = COEUserReadOnlyBOList.GetListByRole(roleNames);
            Assert.IsTrue(users != null, "GetAllUsers did not" +
                    " return the expected value.");
        }


    }
}
