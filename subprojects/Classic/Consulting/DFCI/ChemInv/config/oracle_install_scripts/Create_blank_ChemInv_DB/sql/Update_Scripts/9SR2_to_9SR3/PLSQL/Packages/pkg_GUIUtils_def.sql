CREATE OR REPLACE PACKAGE "GUIUTILS" AS
	TYPE CURSOR_TYPE IS REF CURSOR;

	PROCEDURE GETKEYCONTAINERATTRIBUTES(pContainerIDList IN VARCHAR2 := NULL,
								 pContainerBarcodeList IN VARCHAR2 := NULL,
								 O_RS OUT CURSOR_TYPE);

	PROCEDURE GETKEYPLATEATTRIBUTES(pPlateIDList IN VARCHAR2 := NULL,
							  pPlateBarcodeList IN VARCHAR2 := NULL,
							  O_RS OUT CURSOR_TYPE);

	PROCEDURE DISPLAYCREATEDCONTAINERS(p_Containerlist IN VARCHAR2 := NULL,
								O_RS OUT CURSOR_TYPE);

	FUNCTION GETLOCATIONPATH(pLocationID IN inv_locations.location_id%TYPE)
		RETURN VARCHAR2;

	FUNCTION GETRACKLOCATIONPATH(pLocationID IN inv_locations.location_id%TYPE)
		RETURN VARCHAR2;

	FUNCTION GETFULLRACKLOCATIONPATH(pLocationID IN inv_locations.location_id%TYPE)
		RETURN VARCHAR2;

	PROCEDURE GETRECENTLOCATIONS(pContainerID IN inv_containers.container_id%TYPE,
						    pNumRows IN INTEGER := 5,
						    O_RS OUT CURSOR_TYPE);

	FUNCTION GETPARENTPLATEIDS(pPlateID inv_plates.plate_id%TYPE) RETURN VARCHAR2;

	FUNCTION GETPARENTPLATEBARCODES(pPlateID inv_plates.plate_id%TYPE)
		RETURN VARCHAR2;

	FUNCTION GETPARENTPLATELOCATIONIDS(pPlateID inv_plates.plate_id%TYPE)
		RETURN VARCHAR2;

	FUNCTION GETPARENTWELLIDS(pWellID inv_wells.well_id%TYPE) RETURN VARCHAR2;

	FUNCTION GETPARENTWELLLABELS(pWellID inv_wells.well_id%TYPE) RETURN VARCHAR2;

	FUNCTION GETPARENTWELLNAMES(pWellID inv_wells.well_id%TYPE) RETURN VARCHAR2;

	FUNCTION GETPARENTPLATEIDS2(pWellID inv_wells.well_id%TYPE) RETURN VARCHAR2;

	FUNCTION GETPARENTPLATELOCATIONIDS2(pWellID inv_wells.well_id%TYPE)
		RETURN VARCHAR2;

	FUNCTION GETPARENTPLATEBARCODES2(pWellID inv_wells.well_id%TYPE)
		RETURN VARCHAR2;

	/* Returns the sum of qty_available for all child containers of the given container */
	FUNCTION GETBATCHAMOUNTSTRING(pContainerID inv_containers.container_id%TYPE,
							p_DryWeightUOM VARCHAR2) RETURN VARCHAR2;

	FUNCTION IS_NUMBER(p VARCHAR2) RETURN NUMBER;

	PROCEDURE GetRootNodes(p_selectedID IN NUMBER,
					   p_assetType IN VARCHAR2,
					   O_RS OUT CURSOR_TYPE);

	PROCEDURE GetLineage(p_rootID IN NUMBER,
					 p_assetType IN VARCHAR2,
					 O_RS OUT CURSOR_TYPE);

	--FUNCTION GetLocationId(p_locationIds VARCHAR2)
--		RETURN inv_locations.location_id%TYPE;
	FUNCTION GetLocationId(p_locationIds VARCHAR2, p_containerId inv_containers.container_id%TYPE, p_plateId inv_plates.plate_id%TYPE, p_currLocationId inv_locations.location_id%TYPE)
		RETURN inv_locations.location_id%TYPE ;

	FUNCTION GetRefreshLocationID(p_locationId inv_locations.location_id%TYPE)
     RETURN inv_locations.location_id%TYPE;

	FUNCTION UseGetLocation(p_locationIds VARCHAR2)
  RETURN NUMBER;


END GUIUTILS;
/
show errors;


