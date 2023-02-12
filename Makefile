full=--units-per-dot=200 --population-variable=p1_001n
over_18=--units-per-dot=100 --population-variable=p3_001n
under_18=--units-per-dot=25 --population-expression='d["p1_001n"] - d["p3_001n"]'

all : points_full.geojson points_over_18.geojson points_under_18.geojson

points_%.geojson : points_full_precision_%.geojson
	npx geojson-precision $< $@

points_full_precision_%.geojson : landuse_target.geojson
	points $($*) $< > $@

landuse_target.geojson : chicago.db
	ogr2ogr -f GeoJSON $@ $< -sql @scripts/landuse_target.sql -dialect sqlite

chicago.db : raw/blocks_2020.geojson Landuse2018_CMAP_v1.gdb buildings.shp
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -t_srs "EPSG:4326" $@ raw/blocks_2020.geojson -nlt PROMOTE_TO_MULTI
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -append -t_srs "EPSG:4326" $@ Landuse2018_CMAP_v1.gdb -nlt PROMOTE_TO_MULTI
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -append -t_srs "EPSG:4326" $@ buildings.shp -nlt PROMOTE_TO_MULTI
	spatialite $@ < scripts/landuse_buildings.sql

buildings.shp : raw/buildings.zip
	unzip $<
	touch $@

raw/buildings.zip :
	wget -O $@ "https://data.cityofchicago.org/api/geospatial/hz9b-7nh8?method=export&format=Original"

Landuse2018_CMAP_v1.gdb : Landuse2018_CMAP_v1.gdb.zip
	unzip $<
	touch $@

Landuse2018_CMAP_v1.gdb.zip : raw/LandUseInventory_2018_CMAP.zip
	unzip $<
	touch $@

raw/LandUseInventory_2018_CMAP.zip :
	wget -O $@ "https://stargishub01.blob.core.windows.net/cmap-arcgis-hub01-blob/Open_Data/LandUseInventory_2018_CMAP.zip"

