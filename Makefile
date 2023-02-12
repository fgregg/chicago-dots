points.geojson : points_full_precision.geojson
	npx geojson-precision $< $@

points_full_precision.geojson : landuse_target.geojson
	points --units-per-dot=200 $< > $@

landuse_target.geojson : chicago.db
	ogr2ogr -f GeoJSON $@ $< -sql @scripts/landuse_target.sql -dialect sqlite

chicago.db : raw/blocks_2020.geojson Landuse2018_CMAP_v1.gdb
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -t_srs "EPSG:4326" $@ raw/blocks_2020.geojson -nlt PROMOTE_TO_MULTI
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -append -t_srs "EPSG:4326" $@ Landuse2018_CMAP_v1.gdb -nlt PROMOTE_TO_MULTI

Landuse2018_CMAP_v1.gdb : Landuse2018_CMAP_v1.gdb.zip
	unzip $<
	touch $@

Landuse2018_CMAP_v1.gdb.zip : raw/LandUseInventory_2018_CMAP.zip
	unzip $<
	touch $@

raw/LandUseInventory_2018_CMAP.zip :
	wget -O $@ "https://stargishub01.blob.core.windows.net/cmap-arcgis-hub01-blob/Open_Data/LandUseInventory_2018_CMAP.zip"

