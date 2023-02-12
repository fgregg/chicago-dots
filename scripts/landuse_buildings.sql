CREATE TABLE landuse_buildings AS
WITH intersection_difference AS (
    SELECT
        landuse2018_dissolved_v1.ogc_fid,
        landuse,
        CastToMultiPolygon (st_union (st_intersection (landuse2018_dissolved_v1.shape, buildings.geometry))) AS intersection,
        CastToMultiPolygon (st_difference (landuse2018_dissolved_v1.shape, st_union (buildings.geometry))) AS difference
    FROM
        landuse2018_dissolved_v1
        INNER JOIN buildings ON st_intersects (landuse2018_dissolved_v1.shape, buildings.geometry)
            AND landuse2018_dissolved_v1.ROWID IN (
                SELECT
                    ROWID
                FROM
                    SpatialIndex
            WHERE
                f_table_name = 'landuse2018_dissolved_v1'
                AND search_frame = buildings.geometry)
        WHERE
            st_area (geometry) IS NOT NULL
        GROUP BY
            landuse2018_dissolved_v1.ogc_fid
)
SELECT
    landuse || '_buildings' AS landuse,
    intersection AS geometry
FROM
    intersection_difference
UNION
SELECT
    landuse || '_no_buildings' AS landuse,
    difference AS geometry
FROM
    intersection_difference;

select RecoverGeometryColumn('landuse_buildings', 'GEOMETRY', 4326, 'MULTIPOLYGON');

SELECT CreateSpatialIndex("landuse_buildings", "geometry");
