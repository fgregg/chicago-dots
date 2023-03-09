WITH blockgroups_cvap AS (
    SELECT
        blockgroups.*,
	landuse_buildings.ROWID as landuse_buildings_id,
        cvap.*,
        landuse,
        st_intersection (blockgroups.geometry, landuse_buildings.geometry) AS geometry
    FROM
        blockgroups
        INNER JOIN cvap USING (geoid)
        INNER JOIN landuse_buildings ON st_intersects (blockgroups.geometry, landuse_buildings.geometry)
            AND blockgroups.ROWID IN (
                SELECT
                    ROWID
                FROM
                    SpatialIndex
            WHERE
                f_table_name = 'blockgroups'
                AND search_frame = landuse_buildings.geometry)),
filtered_blockgroups AS (
    SELECT
        blockgroups_cvap.geoid,
	total,
	white,
	black,
	hispanic,
	asian,
	landuse,
        st_intersection (blockgroups_cvap.geometry, st_union (blocks_2020.geometry)) AS geometry
    FROM
        blockgroups_cvap
        LEFT JOIN blocks_2020 ON blockgroups_cvap.state = blocks_2020.state
            AND blockgroups_cvap.county = blocks_2020.county
            AND blockgroups_cvap.tract = blocks_2020.tract
            AND blockgroups_cvap.blkgrp = blocks_2020.blkgrp
            AND blocks_2020.p1_001n > 0
    GROUP BY
        blockgroups_cvap.geoid, landuse_buildings_id
)		
SELECT
    *,
    st_area (geometry) AS intersection_area
FROM
    filtered_blockgroups
WHERE
    intersection_area IS NOT NULL
ORDER BY
    geoid






