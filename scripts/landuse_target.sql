SELECT
    geoid,
    p1_001n,
    p3_001n,
    landuse,
    st_intersection (blocks_2020.GEOMETRY, landuse_buildings.geometry) AS geometry,
    st_area (st_intersection (blocks_2020.GEOMETRY, landuse_buildings.geometry)) AS intersection_area
FROM
    blocks_2020
    INNER JOIN landuse_buildings ON st_intersects (blocks_2020.geometry, landuse_buildings.geometry)
        AND blocks_2020.ROWID IN (
            SELECT
                ROWID
            FROM
                SpatialIndex
        WHERE
            f_table_name = 'blocks_2020'
            AND search_frame = landuse_buildings.geometry)
WHERE
    intersection_area IS NOT NULL
ORDER BY
    geoid
