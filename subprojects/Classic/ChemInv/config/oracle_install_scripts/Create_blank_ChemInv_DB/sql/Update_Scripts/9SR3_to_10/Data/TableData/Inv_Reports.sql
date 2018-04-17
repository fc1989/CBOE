INSERT INTO INV_REPORTS(ID,REPORTDISPLAYNAME,REPORTNAME,REPORTTYPE_ID, REPORTSQL, QUERYNAME) 
VALUES (15,'Custom Parameter Report', 'rptTestParameterReport', 4, 'select * from cheminvdb2.inv_locations','qryTestParameterReport');

Update INV_REPORTS set REPORTNAME= 'rptCutomTest' where REPORTDISPLAYNAME = 'Custom Report Test';

INSERT INTO INV_REPORTTYPES(REPORTTYPE_ID, REPORTTYPEDESC)
VALUES (10,'Shipping Label');

INSERT INTO INV_REPORTS(ID,REPORTDISPLAYNAME,REPORTNAME,REPORTTYPE_ID) 
VALUES (100,'Shipping Label', 'rptShippingLabel1', 10);
commit;