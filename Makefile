points.geojson : points_full_precision.geojson
	npx geojson-precision $< $@

points_full_precision.geojson : raw/blocks_2020.geojson
	points --units-per-dot=200 $< > $@

