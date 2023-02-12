SELECT
    geoid,
    p1_001n,
    landuse,
    st_intersection (blocks_2020.GEOMETRY, landuse2018_dissolved_v1.shape) AS geometry,
    st_area (st_intersection (blocks_2020.GEOMETRY, landuse2018_dissolved_v1.shape)) AS intersection_area
FROM
    blocks_2020
    INNER JOIN landuse2018_dissolved_v1 ON st_intersects (blocks_2020.geometry, landuse2018_dissolved_v1.shape)
        AND landuse2018_dissolved_v1.ROWID IN (
            SELECT
                ROWID
            FROM
                SpatialIndex
        WHERE
            f_table_name = 'landuse2018_dissolved_v1'
            AND search_frame = blocks_2020.geometry)
WHERE
    intersection_area IS NOT NULL
ORDER BY
    geoid
