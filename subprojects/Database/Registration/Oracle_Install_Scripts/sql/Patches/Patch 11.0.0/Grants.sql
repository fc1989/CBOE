
prompt 
prompt Starting "Grants.sql"...
prompt 

--&&securitySchemaName
	GRANT EXECUTE ON &&schemaName..COMPOUNDREGISTRY TO &&securitySchemaName WITH GRANT OPTION;
-- SUBMITTER	
	GRANT EXECUTE ON &&schemaName..COMPOUNDREGISTRY TO SUBMITTER;

-- SUPERVISING_SCIENTIST	
	GRANT EXECUTE ON &&schemaName..COMPOUNDREGISTRY TO SUPERVISING_SCIENTIST;
		
-- CHEMICAL_ADMINISTRATOR
	GRANT EXECUTE ON &&schemaName..COMPOUNDREGISTRY TO CHEMICAL_ADMINISTRATOR;
	
-- SUPERVISING_CHEMICAL_ADMIN
	GRANT EXECUTE ON &&schemaName..COMPOUNDREGISTRY TO SUPERVISING_CHEMICAL_ADMIN;
	GRANT EXECUTE ON &&schemaName..CONFIGURATIONCOMPOUNDREGISTRY TO SUPERVISING_CHEMICAL_ADMIN;

-- PERFUME_CHEMIST
	GRANT EXECUTE ON &&schemaName..COMPOUNDREGISTRY TO PERFUME_CHEMIST;

GRANT SELECT ON &&schemaName..NOTEBOOKS TO BROWSER;
GRANT DELETE,INSERT,UPDATE ON &&schemaName..ALT_IDS TO SUBMITTER;
GRANT DELETE,INSERT,UPDATE ON &&schemaName..ALT_IDS TO SUPERVISING_SCIENTIST;
GRANT DELETE,INSERT,UPDATE ON &&schemaName..ALT_IDS TO CHEMICAL_ADMINISTRATOR;
GRANT DELETE,INSERT,UPDATE ON &&schemaName..ALT_IDS TO SUPERVISING_CHEMICAL_ADMIN;
GRANT SELECT ON &&schemaName..FRAGMENTS TO BROWSER;
GRANT SELECT, INSERT, UPDATE ON &&schemaName..FRAGMENTS TO SUBMITTER;
GRANT SELECT, INSERT, UPDATE ON &&schemaName..FRAGMENTS TO PERFUME_CHEMIST;
GRANT SELECT, INSERT, UPDATE, DELETE ON &&schemaName..FRAGMENTS TO SUPERVISING_SCIENTIST;
GRANT SELECT, INSERT, UPDATE, DELETE ON &&schemaName..FRAGMENTS TO CHEMICAL_ADMINISTRATOR;
GRANT SELECT, INSERT, UPDATE, DELETE ON &&schemaName..FRAGMENTS TO SUPERVISING_CHEMICAL_ADMIN;
GRANT SELECT ON &&schemaName..PEOPLE_PROJECT TO BROWSER;
GRANT SELECT ON &&schemaName..PEOPLE_PROJECT TO SUBMITTER;
GRANT SELECT ON &&schemaName..PEOPLE_PROJECT TO SUPERVISING_SCIENTIST;
GRANT SELECT,INSERT,UPDATE ON &&schemaName..PEOPLE_PROJECT TO CHEMICAL_ADMINISTRATOR;
GRANT SELECT,INSERT,DELETE,UPDATE ON &&schemaName..PEOPLE_PROJECT TO SUPERVISING_CHEMICAL_ADMIN;
GRANT SELECT ON &&schemaName..PEOPLE_PROJECT TO PERFUME_CHEMIST;

ALTER USER T1_84 GRANT CONNECT THROUGH COEUSER;
ALTER USER T2_84 GRANT CONNECT THROUGH COEUSER;
ALTER USER T3_84 GRANT CONNECT THROUGH COEUSER;
ALTER USER T4_84 GRANT CONNECT THROUGH COEUSER;
ALTER USER T5_84 GRANT CONNECT THROUGH COEUSER;
ALTER USER T6_84 GRANT CONNECT THROUGH COEUSER;
ALTER USER T1_85 GRANT CONNECT THROUGH COEUSER;
ALTER USER T2_85 GRANT CONNECT THROUGH COEUSER;
ALTER USER T3_85 GRANT CONNECT THROUGH COEUSER;
ALTER USER T4_85 GRANT CONNECT THROUGH COEUSER;
ALTER USER T5_85 GRANT CONNECT THROUGH COEUSER;
ALTER USER T6_85 GRANT CONNECT THROUGH COEUSER;

--RLS
exec &&schemaName..RegistrationRLS.ActivateRLS('&&ActivateRLS'); 
