Alter table INV_CUSTOM_FIELD_GROUPS
add(
"CUSTOM_FIELD_GROUP_TYPE_ID_FK" Number(4),
CONSTRAINT "INV_CSTM_FLD_GRP_TYP_ID_FK" FOREIGN KEY ("CUSTOM_FIELD_GROUP_TYPE_ID_FK") REFERENCES "INV_CUSTOM_FIELD_GROUP_TYPES" ("CUSTOM_FIELD_GROUP_TYPE_ID") ENABLE 
);
