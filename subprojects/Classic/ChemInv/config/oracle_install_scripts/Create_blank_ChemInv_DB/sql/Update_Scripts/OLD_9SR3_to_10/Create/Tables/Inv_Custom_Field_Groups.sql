CREATE TABLE "INV_CUSTOM_FIELD_GROUPS"(
    "CUSTOM_FIELD_GROUP_ID" NUMBER(4) NOT NULL,
    "CUSTOM_FIELD_GROUP_NAME" VARCHAR2(30) NOT NULL,
    CONSTRAINT "CUSTOM_FIELD_GROUP_ID_PK"
        PRIMARY KEY("CUSTOM_FIELD_GROUP_ID") USING INDEX TABLESPACE &&indexTableSpaceName
)
;

ALTER TABLE INV_CUSTOM_FIELD_GROUPS ADD CONSTRAINT CustomFieldGroups_U UNIQUE (CUSTOM_FIELD_GROUP_NAME);

CREATE SEQUENCE SEQ_INV_CUSTOM_FIELD_GROUPS INCREMENT BY 1 START WITH 1000 MAXVALUE 1.0E28 MINVALUE 1 NOCYCLE;

CREATE OR REPLACE TRIGGER "TRG_INV_CUSTOM_FIELD_GROUPS"
    BEFORE INSERT
    ON "INV_CUSTOM_FIELD_GROUPS"
    FOR EACH ROW
    begin
        if :new.Custom_Field_Group_ID is null then
            select seq_Inv_Custom_Field_Groups.nextval into :new.Custom_Field_Group_ID from dual;
        end if;
    end;
/