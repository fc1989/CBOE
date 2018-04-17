--Copyright Cambridgesoft Corp 2001-2005 all rights reserved

SET verify off
connect &&securitySchemaName/&&securitySchemaPass@&&serverName;

-- INV_BROWSE_ALL
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_CONTAINER_BATCHES');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_UNIT_CONVERSION_FORMULA');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_GRAPHICS');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_GRAPHIC_TYPES');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_DOCS');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_DOC_TYPES');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_ORG_UNIT');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_ORG_ROLES');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'SELECT', '&&SchemaName', 'INV_ORG_USERS');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'EXECUTE', '&&SchemaName', 'RACKS');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'EXECUTE', '&&SchemaName', 'DOCS');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'EXECUTE', '&&SchemaName', 'ORGANIZATION');
INSERT INTO CS_SECURITY.OBJECT_PRIVILEGES VALUES ('INV_BROWSE_ALL', 'EXECUTE', '&&SchemaName', 'BATCH');

COMMIT;

Connect &&schemaName/&&schemaPass@&&serverName
GRANT SELECT ON "&&SchemaName".INV_CONTAINER_BATCHES TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_UNIT_CONVERSION_FORMULA TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_GRAPHICS TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_GRAPHIC_TYPES TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_DOCS TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_DOC_TYPES TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_ORG_UNIT TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_ORG_ROLES TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_ORG_USERS TO CS_SECURITY WITH GRANT OPTION;
GRANT SELECT ON "&&SchemaName".INV_VW_GRID_LOCATION_LITE TO CS_SECURITY WITH GRANT OPTION;
GRANT EXECUTE ON "&&SchemaName".UPDATECONTAINERBATCHES to CS_SECURITY WITH GRANT OPTION;
GRANT EXECUTE ON "&&SchemaName".UPDATEBATCHSTATUS to CS_SECURITY WITH GRANT OPTION;
GRANT EXECUTE ON "&&SchemaName".RACKS TO CS_SECURITY WITH GRANT OPTION;
GRANT EXECUTE ON "&&SchemaName".DOCS TO CS_SECURITY WITH GRANT OPTION;
GRANT EXECUTE ON "&&SchemaName".ORGANIZATION TO CS_SECURITY WITH GRANT OPTION;
GRANT EXECUTE ON "&&SchemaName".BATCH TO CS_SECURITY WITH GRANT OPTION;