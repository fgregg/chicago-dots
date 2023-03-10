full_1=--units-per-dot=1 --population-variable=p1_001n
full_5=--units-per-dot=5 --population-variable=p1_001n
full_10=--units-per-dot=10 --population-variable=p1_001n
full_50=--units-per-dot=50 --population-variable=p1_001n
full_100=--units-per-dot=100 --population-variable=p1_001n
over_18_1=--units-per-dot=1 --population-variable=p3_001n
over_18_5=--units-per-dot=5 --population-variable=p3_001n
over_18_10=--units-per-dot=10 --population-variable=p3_001n
over_18_50=--units-per-dot=50 --population-variable=p3_001n
over_18_100=--units-per-dot=100 --population-variable=p3_001n
under_18_1=--units-per-dot=1 --population-expression='d["p1_001n"] - d["p3_001n"]'
under_18_5=--units-per-dot=5 --population-expression='d["p1_001n"] - d["p3_001n"]'
under_18_10=--units-per-dot=10 --population-expression='d["p1_001n"] - d["p3_001n"]'
under_18_50=--units-per-dot=50 --population-expression='d["p1_001n"] - d["p3_001n"]'
under_18_100=--units-per-dot=100 --population-expression='d["p1_001n"] - d["p3_001n"]'
total=--units-per-dot=1 --population-variable=total
black=--units-per-dot=1 --population-variable=black
asian=--units-per-dot=1 --population-variable=asian
hispanic=--units-per-dot=1 --population-variable=hispanic
white=--units-per-dot=1 --population-variable=white

.PHONY : all
all : points/points_full_1.geojson points/points_full_5.geojson		\
      points/points_full_10.geojson points/points_full_50.geojson	\
      points/points_full_100.geojson points/points_over_18_1.geojson	\
      points/points_over_18_5.geojson					\
      points/points_over_18_10.geojson					\
      points/points_over_18_50.geojson					\
      points/points_over_18_100.geojson					\
      points/points_under_18_1.geojson					\
      points/points_under_18_5.geojson					\
      points/points_under_18_10.geojson					\
      points/points_under_18_50.geojson					\
      points/points_under_18_100.geojson				\
      points/points_cvap_total.geojson					\
      points/points_cvap_black.geojson					\
      points/points_cvap_white.geojson					\
      points/points_cvap_asian.geojson					\
      points/points_cvap_hispanic.geojson

points/points_%.geojson : points_full_precision_%.geojson
	npx geojson-precision -p 5 $< $@

points_full_precision_cvap_%.geojson : landuse_cvap.geojson
	points $($*) $< > $@

points_full_precision_%.geojson : landuse_target.geojson
	points $($*) $< > $@

landuse_cvap.geojson: chicago.db
	ogr2ogr -f GeoJSON $@ $< -sql @scripts/landuse_target_cvap.sql -dialect sqlite

landuse_target.geojson : chicago.db
	ogr2ogr -f GeoJSON $@ $< -sql @scripts/landuse_target.sql -dialect sqlite

chicago.db : raw/blocks_2020.geojson Landuse2018_CMAP_v1.gdb buildings.shp raw/blockgroups.geojson BlockGr.csv
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -t_srs "EPSG:4326" $@ raw/blocks_2020.geojson -nlt PROMOTE_TO_MULTI
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -append -t_srs "EPSG:4326" $@ raw/blockgroups.geojson -nlt PROMOTE_TO_MULTI
	csvs-to-sqlite BlockGr.csv $@
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -append -t_srs "EPSG:4326" $@ Landuse2018_CMAP_v1.gdb -nlt PROMOTE_TO_MULTI
	ogr2ogr -f SQLite -dsco SPATIALITE=YES -append -t_srs "EPSG:4326" $@ buildings.shp -nlt PROMOTE_TO_MULTI
	spatialite $@ < scripts/landuse_buildings.sql
	spatialite $@ < scripts/cvap.sql

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

raw/blockgroups.geojson :
	python scripts/block_groups.py > $@

BlockGr.csv : raw/CVAP_2017-2021_ACS_csv_files.zip
	unzip -p $< $@ > $@

raw/CVAP_2017-2021_ACS_csv_files.zip :
	wget -O $@ https://www2.census.gov/programs-surveys/decennial/rdo/datasets/2021/2021-cvap/CVAP_2017-2021_ACS_csv_files.zip
