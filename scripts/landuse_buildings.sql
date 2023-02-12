CREATE TABLE landuse_buildings AS
SELECT
    landuse2018_dissolved_v1.ogc_fid,
    landuse,
    CastToMultiPolygon(st_union (st_intersection (landuse2018_dissolved_v1.shape, buildings.geometry))
) AS geometry
FROM
    landuse2018_dissolved_v1
    INNER JOIN buildings ON st_intersects (
        landuse2018_dissolved_v1.shape,
        buildings.geometry)
        AND landuse2018_dissolved_v1.ROWID IN (
            SELECT
                ROWID
            FROM
                SpatialIndex
        WHERE
            f_table_name = 'landuse2018_dissolved_v1'
            AND search_frame = buildings.geometry)
WHERE
    st_area (
        geometry) IS NOT NULL
GROUP BY
    landuse2018_dissolved_v1.ogc_fid;

select RecoverGeometryColumn('landuse_buildings', 'GEOMETRY', 4326, 'MULTIPOLYGON');

SELECT CreateSpatialIndex("landuse_buildings", "geometry");
