insert into INV_BARCODE_DESC (BARCODE_DESC_ID, BARCODE_DESC_NAME, PREFIX, PFX_SEPARATOR, SUFFIX, SFX_SEPARATOR, RUN_START, RUN_INCREMENT, RUN_END, NUMBER_SIZE, PAD_CHARACTER)
values (1, 'Plate Barcodes', 'P', null, null, null, 1000, null, 1000000, null, null);
insert into INV_BARCODE_DESC (BARCODE_DESC_ID, BARCODE_DESC_NAME, PREFIX, PFX_SEPARATOR, SUFFIX, SFX_SEPARATOR, RUN_START, RUN_INCREMENT, RUN_END, NUMBER_SIZE, PAD_CHARACTER)
values (2, 'Location Barcodes', 'L', null, null, null, 1000, null, 1000000, null, null);
insert into INV_BARCODE_DESC (BARCODE_DESC_ID, BARCODE_DESC_NAME, PREFIX, PFX_SEPARATOR, SUFFIX, SFX_SEPARATOR, RUN_START, RUN_INCREMENT, RUN_END, NUMBER_SIZE, PAD_CHARACTER)
values (3, 'Container Barcodes', 'C', null, null, null, 1000, null, 1000000, null, null);
commit;