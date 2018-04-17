CREATE TABLE INV_REPORTTYPES (
	REPORTTYPE_ID NUMBER(6,0) NOT NULL,
	REPORTTYPEDESC VARCHAR2(255) NULL, 
	CONSTRAINT "INV_REPORTTYPES_PK" 
		PRIMARY KEY ("REPORTTYPE_ID") USING INDEX TABLESPACE &&indexTableSpaceName
	); 

CREATE SEQUENCE SEQ_INV_REPORTTYPES INCREMENT BY 1 START WITH 10 MAXVALUE 1.0E28 MINVALUE 1 NOCYCLE CACHE 20 NOORDER;

CREATE OR REPLACE TRIGGER TRG_REPORTTYPES
    BEFORE INSERT 
    ON INV_REPORTTYPES
    FOR EACH ROW 
begin
  if :new.REPORTTYPE_ID is null then
    select SEQ_INV_REPORTTYPES.nextval into :new.REPORTTYPE_ID from dual;
  end if;
end;  
/
