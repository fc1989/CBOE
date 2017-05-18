﻿/*
 * PerkinElmer COE Registration API
 *
 * No description provided (generated by Swagger Codegen https://github.com/swagger-api/swagger-codegen)
 *
 * OpenAPI spec version: 1.0.1
 * 
 * Generated by: https://github.com/swagger-api/swagger-codegen.git
 */

using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Web.Http;
using CambridgeSoft.COE.ChemBioViz.Services.COEChemBioVizService;
using CambridgeSoft.COE.Framework;
using CambridgeSoft.COE.Framework.COEHitListService;
using CambridgeSoft.COE.Framework.COESearchCriteriaService;
using CambridgeSoft.COE.Framework.Common;
using CambridgeSoft.COE.RegistrationAdmin.Services;
using Microsoft.Web.Http;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using PerkinElmer.COE.Registration.Server.Code;
using PerkinElmer.COE.Registration.Server.Models;
using Swashbuckle.Swagger.Annotations;

namespace PerkinElmer.COE.Registration.Server.Controllers
{
    [ApiVersion(Consts.apiVersion)]
    public class SearchController : RegControllerBase
    {
        private const string dbName = "REGDB";

        /// <summary>
        /// Returns all hit-lists.
        /// </summary>
        /// <remarks>This call may be used to retrieve all hit-lists</remarks>
        /// <response code="200">Success</response>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists")]
        [SwaggerOperation("GetHitlists")]
        [SwaggerResponse(200, type: typeof(List<Hitlist>))]
        public List<Hitlist> GetHitlists()
        {
            CheckAuthentication();
            var result = new List<Hitlist>();
            var configRegRecord = ConfigurationRegistryRecord.NewConfigurationRegistryRecord();
            configRegRecord.COEFormHelper.Load(COEFormHelper.COEFormGroups.SearchPermanent);
            var formGroup = configRegRecord.FormGroup;
            var tempHitLists = COEHitListBOList.GetRecentHitLists(dbName, COEUser.Name, formGroup.Id, 10);
            foreach (var h in tempHitLists)
            {
                result.Add(new Hitlist(h.ID, h.HitListID, h.HitListType, h.NumHits, h.IsPublic, h.SearchCriteriaID, h.SearchCriteriaType, h.Name, h.Description, h.MarkedHitListIDs, h.DateCreated));
            }

            var savedHitLists = COEHitListBOList.GetSavedHitListList(dbName, COEUser.Name, formGroup.Id);
            foreach (var h in savedHitLists)
            {
                result.Add(new Hitlist(h.ID, h.HitListID, h.HitListType, h.NumHits, h.IsPublic, h.SearchCriteriaID, h.SearchCriteriaType, h.Name, h.Description, h.MarkedHitListIDs, h.DateCreated));
            }

            return result;
        }

        /// <summary>
        /// Deletes a hitlist
        /// </summary>
        /// <remarks>Deletes a hitlist by its ID</remarks>
        /// <param name="id">Id of the hitlist that needs to be deleted</param>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Invalid ID</response>
        /// <response code="404">Hitlist not found</response>
        /// <response code="0">Unexpected error</response>
        [HttpDelete]
        [Route(Consts.apiPrefix + "hitlists/{id}")]
        [SwaggerOperation("DeleteHitlist")]
        public void SearchHitlistsIdDelete(int id)
        {
            CheckAuthentication();
            COEHitListBO.Delete(HitListType.TEMP, id);
            COEHitListBO.Delete(HitListType.SAVED, id);
        }

        /// <summary>
        /// Update a hitlist
        /// </summary>
        /// <remarks>Update a hitlist by its ID
        /// If the given hit-list is found only in the temporary list but the type is specified as saved,
        /// it is considered as a request to save the temporary hit-list as a saved hit-list.
        /// </remarks>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Invalid ID</response>
        /// <response code="404">Hitlist not found</response>
        /// <response code="0">Unexpected error</response>
        [HttpPut]
        [Route(Consts.apiPrefix + "hitlists/{id}")]
        [SwaggerOperation("UpdateHitlist")]
        public void UpdateHitlist(int id)
        {
            CheckAuthentication();
            var hitlistData = Request.Content.ReadAsAsync<JObject>().Result;
            var hitlistType = (HitListType)(int)hitlistData["HitlistType"];
            var hitlistBO = COEHitListBO.Get(hitlistType, id);
            if (hitlistBO == null) return;
            bool saveHitlist = false;
            if (hitlistType == HitListType.SAVED && hitlistBO.HitListID == 0)
            {
                // Saving temporary hit-list
                saveHitlist = true;
                hitlistBO = COEHitListBO.Get(HitListType.TEMP, id);
            }

            if (hitlistBO.HitListID > 0)
            {
                hitlistBO.Name = hitlistData["Name"].ToString();
                hitlistBO.Description = hitlistData["Description"].ToString();
                hitlistBO.IsPublic = (bool)hitlistData["IsPublic"];
                if (hitlistBO.SearchCriteriaID > 0)
                {
                    var searchCriteria = COESearchCriteriaBO.Get(hitlistBO.SearchCriteriaType, hitlistBO.SearchCriteriaID);
                    searchCriteria.Name = hitlistBO.Name;
                    searchCriteria.Description = hitlistBO.Description;
                    searchCriteria.IsPublic = hitlistBO.IsPublic;
                    searchCriteria = saveHitlist ? searchCriteria.Save() : searchCriteria.Update();
                    if (saveHitlist)
                    {
                        hitlistBO.SearchCriteriaID = searchCriteria.ID;
                        hitlistBO.SearchCriteriaType = searchCriteria.SearchCriteriaType;
                    }
                }

                hitlistBO = saveHitlist ? hitlistBO.Save() : hitlistBO.Update();
            }
        }

        /// <summary>
        /// Create a hitlist
        /// </summary>
        /// <remarks>Create a hitlist</remarks>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Invalid ID</response>
        /// <response code="0">Unexpected error</response>
        [HttpPost]
        [Route(Consts.apiPrefix + "hitlists")]
        [SwaggerOperation("CreateHitlist")]
        public int CreateHitlist()
        {
            CheckAuthentication();
            var hitlistData = Request.Content.ReadAsAsync<JObject>().Result;
            CambridgeSoft.COE.Framework.COEHitListService.DAL objDAL = null;
            int id;
            var configRegRecord = ConfigurationRegistryRecord.NewConfigurationRegistryRecord();
            configRegRecord.COEFormHelper.Load(COEFormHelper.COEFormGroups.SearchPermanent);
            var formGroup = configRegRecord.FormGroup;
            var genericBO = GenericBO.GetGenericBO("Registration", formGroup.Id);
            string name = hitlistData["Name"].ToString();
            bool isPublic = Convert.ToBoolean(hitlistData["IsPublic"].ToString());
            string dscription = hitlistData["Description"].ToString();
            string userID = COEUser.Name;
            int numHits = Convert.ToInt32(hitlistData["NumHits"].ToString());
            string databaseName = "REGDB";
            int hitListID = Convert.ToInt32(hitlistData["HitListID"].ToString());
            int dataViewID = formGroup.DataViewId;
            HitListType hitlistType = (HitListType)(int)hitlistData["HitlistType"];
            int searchcriteriaId = Convert.ToInt32(hitlistData["SearchcriteriaId"].ToString());
            string searchcriteriaType = hitlistData["SearchcriteriaType"].ToString();
            return objDAL.CreateNewTempHitList(name, isPublic, dscription, userID, numHits, databaseName, hitListID, dataViewID, hitlistType, searchcriteriaId, searchcriteriaType);
        }

        private JObject GetHitlistRecordsInternal(int id, int? skip = null, int? count = null, string sort = null)
        {
            var hitlistType = HitListType.TEMP;
            var hitlistBO = COEHitListBO.Get(hitlistType, id);
            // This is an error condition.
            // it might be better to throw an exception here.
            if (hitlistBO == null) return new JObject();
            if (hitlistBO.HitListID == 0) hitlistType = HitListType.SAVED;
            var tableName = "vw_mixture_regnumber";
            var whereClause = string.Format(" WHERE mixtureid in (SELECT ID FROM COEDB.{0} WHERE hitlistId=:hitlistId)",
                hitlistType == HitListType.TEMP ? "coetemphitlist" : "coesavedhitlist");
            var query = GetQuery(tableName + whereClause, RecordColumns, sort, "modified", "regid");
            var args = new Dictionary<string, object>();
            args.Add(":hitlistId", id);
            return new JObject(
                new JProperty("temporary", false),
                new JProperty("hitlistId", id),
                new JProperty("totalCount", Convert.ToInt32(ExtractValue("SELECT cast(count(1) as int) c FROM " + tableName + whereClause, args))),
                new JProperty("startIndex", skip == null ? 0 : Math.Max(skip.Value, 0)),
                new JProperty("rows", ExtractData(query, args, skip, count))
            );
        }

        /// <summary>
        /// Returns the list of registry records for a hitlist
        /// </summary>
        /// <remarks>Returns the list of registry records for a hitlist by its ID</remarks>
        /// <param name="id">Id of the hitlist that needs to be fetched</param>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Invalid ID</response>
        /// <response code="404">Hitlist not found</response>
        /// <response code="0">Unexpected error</response>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{id}/records")]
        [SwaggerOperation("GetHitlistRecords")]
        public JObject GetHitlistRecords(int id, int? skip = null, int? count = null, string sort = null)
        {
            CheckAuthentication();
            return GetHitlistRecordsInternal(id, skip, count, sort);
        }

        /// <summary>
        /// Returns a hitlist by its ID
        /// </summary>
        /// <remarks>Returns a hitlist by its ID</remarks>
        /// <param name="id">Id of the hitlist that needs to be fetched</param>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Invalid ID</response>
        /// <response code="404">Hitlist not found</response>
        /// <response code="0">Unexpected error</response>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{id1}/{op}/{id2}/records")]
        [SwaggerOperation("GetAdvHitlistRecords")]
        public JObject GetAdvHitlistRecords(int id1, int op, int id2, int? skip = null, int? count = null, string sort = null)
        {
            CheckAuthentication();
            JObject data = new JObject();
            var configRegRecord = ConfigurationRegistryRecord.NewConfigurationRegistryRecord();
            configRegRecord.COEFormHelper.Load(COEFormHelper.COEFormGroups.SearchPermanent);
            var formGroup = configRegRecord.FormGroup;
            int dataViewID = formGroup.Id;
            switch (op)
            {
                case 1: //intersect      
                   // resultHitListID = objDAL.IntersectHitLists(id1, hitListID1Type, id2, hitListID2Type, dbName, dataViewID);
                   // objJArray = ExtractData("select vw_mixture_regnumber.regid as id, vw_mixture_regnumber.name," +
                   // "vw_mixture_regnumber.created, vw_mixture_regnumber.modified, vw_mixture_regnumber.personcreated as creator, 'record/' || vw_mixture_regnumber.regid || '?' || to_char(vw_mixture_regnumber.modified, 'YYYYMMDDHH24MISS') as structure, vw_mixture_regnumber.regnumber, vw_mixture_regnumber.statusid as status, vw_mixture_regnumber.approved FROM regdb.vw_mixture_regnumber,regdb.vw_batch vw_batch " +
                   // "where vw_mixture_regnumber.mixtureid in (select id from coedb.coetemphitlist s where s.hitlistid=" + resultHitListID + ") and vw_batch.regid = vw_mixture_regnumber.regid");
                    break;
                case 2: //subtract
                   // resultHitListID = objDAL.SubtractHitLists(id1, hitListID1Type, id2, hitListID2Type, dbName, dataViewID);
                   // objJArray = ExtractData("select vw_mixture_regnumber.regid as id, vw_mixture_regnumber.name," +
                   // "vw_mixture_regnumber.created, vw_mixture_regnumber.modified, vw_mixture_regnumber.personcreated as creator, 'record/' || vw_mixture_regnumber.regid || '?' || to_char(vw_mixture_regnumber.modified, 'YYYYMMDDHH24MISS') as structure, vw_mixture_regnumber.regnumber, vw_mixture_regnumber.statusid as status, vw_mixture_regnumber.approved FROM regdb.vw_mixture_regnumber,regdb.vw_batch vw_batch " +
                   // "where vw_mixture_regnumber.mixtureid in (select id from coedb.coetemphitlist s where s.hitlistid=" + resultHitListID + ") and vw_batch.regid = vw_mixture_regnumber.regid");
                    break;
                case 3: //union
                   // resultHitListID = objDAL.SubtractHitLists(id1, hitListID1Type, id2, hitListID2Type, dbName, dataViewID);
                   // objJArray = ExtractData("select vw_mixture_regnumber.regid as id, vw_mixture_regnumber.name," +
                   // "vw_mixture_regnumber.created, vw_mixture_regnumber.modified, vw_mixture_regnumber.personcreated as creator, 'record/' || vw_mixture_regnumber.regid || '?' || to_char(vw_mixture_regnumber.modified, 'YYYYMMDDHH24MISS') as structure, vw_mixture_regnumber.regnumber, vw_mixture_regnumber.statusid as status, vw_mixture_regnumber.approved FROM regdb.vw_mixture_regnumber,regdb.vw_batch vw_batch " +
                   // "where vw_mixture_regnumber.mixtureid in (select id from coedb.coetemphitlist s where s.hitlistid=" + resultHitListID + ") and vw_batch.regid = vw_mixture_regnumber.regid");
                    break;
                default: // Subtract from entire list
                    data = GetHitlistRecordsInternal(id1);
                    break;
            }
            return data;
        }

        /// <summary>
        /// Save a hitlist
        /// </summary>
        /// <remarks>Save a hitlist</remarks>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Invalid ID</response>
        /// <response code="404">Hitlist not found</response>
        /// <response code="0">Unexpected error</response>
        [HttpPost]
        [Route(Consts.apiPrefix + "markedhits")]
        [SwaggerOperation("MarkedHitsSave")]
        public int MarkedHitsSave()
        {
            CheckAuthentication();
            var hitlistData = Request.Content.ReadAsAsync<JObject>().Result;
            var configRegRecord = ConfigurationRegistryRecord.NewConfigurationRegistryRecord();
            configRegRecord.COEFormHelper.Load(COEFormHelper.COEFormGroups.SearchPermanent);
            var formGroup = configRegRecord.FormGroup;
            var genericBO = GenericBO.GetGenericBO("Registration", formGroup.Id);
            var hitlistBO = genericBO.MarkedHitList;
            hitlistBO.Name = hitlistData["Name"].ToString();
            hitlistBO.Description = hitlistData["Description"].ToString();
            hitlistBO.HitListType = HitListType.SAVED;
            hitlistBO.Save();
            int markedCount = genericBO.GetMarkedCount();
            return markedCount;
        }

        /// <summary>
        /// Returns a hitlist by its ID
        /// </summary>
        /// <remarks>Returns a hitlist by its ID</remarks>
        /// <param name="id">Id of the hitlist that needs to be fetched</param>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Invalid ID</response>
        /// <response code="404">Hitlist not found</response>
        /// <response code="0">Unexpected error</response>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{id}")]
        [SwaggerOperation("SearchHitlistsIdGet")]
        [SwaggerResponse(200, type: typeof(Hitlist))]
        public virtual Hitlist SearchHitlistsIdGet(int? id)
        {
            string exampleJson = null;

            var example = exampleJson != null
            ? JsonConvert.DeserializeObject<Hitlist>(exampleJson)
            : default(Hitlist);
            return example;
        }

    }
}
