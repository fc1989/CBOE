ALTER TABLE "INV_PICKLISTS" ADD (
    "PICKLIST_CODE" VARCHAR2(8) NOT NULL
)
;

ALTER TABLE "INV_PICKLISTS" MODIFY (
    "PICKLIST_DISPLAY" NOT NULL
)
;
-- PICKLIST_DOMAIN should actually be PICKLIST_TYPE_ID_FK
ALTER TABLE "INV_PICKLISTS" MODIFY (
    "PICKLIST_DOMAIN" NUMBER(4) NOT NULL
)
;

-- Make primary key only PICKLIST_ID
ALTER TABLE "INV_PICKLISTS" DROP CONSTRAINT PickList_PK;
ALTER TABLE "INV_PICKLISTS" ADD CONSTRAINT PickList_PK PRIMARY KEY (PICKLIST_ID);
-- Constraint PICKLIST_DOMAIN
ALTER TABLE "INV_PICKLISTS" ADD CONSTRAINT Inv_Picklists_FK FOREIGN KEY(PICKLIST_DOMAIN) REFERENCES &&schemaName..INV_PICKLIST_TYPES(PICKLIST_TYPE_ID);

-- Constrain for uniqueness
ALTER TABLE INV_PICKLISTS ADD CONSTRAINT Inv_Picklist_U1 UNIQUE (PICKLIST_DOMAIN, PICKLIST_DISPLAY);
ALTER TABLE INV_PICKLISTS ADD CONSTRAINT Inv_Picklist_U2 UNIQUE (PICKLIST_DOMAIN, PICKLIST_CODE);

Connect &&InstallUser/&&sysPass@&&serverName

-- Drop existing sequence, if it exists
Declare 
SEQ_EXISTS integer := 0;

begin	
  begin    
    select 1 into SEQ_EXISTS from sys.dba_sequences
    where sequence_owner = '&&schemaName' and sequence_name = 'SEQ_INV_PICKLISTS';
  exception 
    when NO_DATA_FOUND then SEQ_EXISTS := 0;
  end;
        
  if SEQ_EXISTS = 1 then
    execute immediate 'drop sequence SEQ_INV_PICKLISTS';  
  end if;
end;
/	

Connect &&schemaName/&&schemaPass@&&serverName

-- Allow for test data that is explicitly inserted later
CREATE SEQUENCE SEQ_INV_PICKLISTS INCREMENT BY 1 START WITH 1100 MAXVALUE 1.0E28 MINVALUE 1 NOCYCLE;


CREATE OR REPLACE TRIGGER "TRG_INV_PICKLISTS"
    BEFORE INSERT
    ON "INV_PICKLISTS"
    FOR EACH ROW
    begin
        if :new.Picklist_ID is null then
            select seq_INV_PICKLISTS.nextval into :new.Picklist_ID from dual;
        end if;
    end;
/