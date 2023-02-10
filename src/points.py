import json
import click
import earcut.earcut as earcut
import itertools
import random
import sys


def randround(x):
    return int(x + random.random())


def grouper(iterable, n, *, incomplete="fill", fillvalue=None):
    "Collect data into non-overlapping fixed-length chunks or blocks"
    # grouper('ABCDEFG', 3, fillvalue='x') --> ABC DEF Gxx
    # grouper('ABCDEFG', 3, incomplete='strict') --> ABC DEF ValueError
    # grouper('ABCDEFG', 3, incomplete='ignore') --> ABC DEF
    args = [iter(iterable)] * n
    if incomplete == "fill":
        return itertools.zip_longest(*args, fillvalue=fillvalue)
    if incomplete == "strict":
        return zip(*args, strict=True)
    if incomplete == "ignore":
        return zip(*args)
    else:
        raise ValueError("Expected fill, strict, or ignore")


def random_point(triangle):
    ((ax, ay), (bx, by), (cx, cy)) = triangle
    a = (bx - ax, by - ay)
    b = (cx - ax, cy - ay)
    u1, u2 = random.random(), random.random()
    if u1 + u2 > 1:
        u1 = 1 - u1
        u2 = 1 - u2
    w = (u1 * a[0] + u2 * b[0], u1 * a[1] + u2 * b[1])
    return (w[0] + ax, w[1] + ay)


@click.command()
@click.argument("infile", type=click.File("r"), nargs=1)
def main(infile):

    multipoint = []
    blocks = json.load(infile)
    for feature in blocks["features"]:
        geometry = feature["geometry"]
        n_points = randround(feature["properties"]["P1_001N"] / 200)
        if geometry["type"] == "Polygon":
            coords = geometry["coordinates"]
            flattened_coords = earcut.flatten(coords)["vertices"]
            triangle_indices = earcut.earcut(flattened_coords)
            triangles = []
            weights = []
            for each in grouper(triangle_indices, 3):
                try:
                    triangle = (a, b, c) = tuple(coords[0][i] for i in each)
                except IndexError:
                    # something is going wrong with holes
                    continue

                double_area = (
                    a[0] * (b[1] - c[1]) + b[0] * (c[1] - a[1]) + c[0] * (a[1] - b[1])
                )
                triangles.append(triangle)
                weights.append(double_area)

            random_triangles = random.choices(triangles, weights, k=n_points)
            for triangle in random_triangles:
                point = random_point(triangle)
                multipoint.append(point)

    random_points = {
        "type": "FeatureCollection",
        "features": [
            {
                "type": "Feature",
                "geometry": {
                    "type": "MultiPoint",
                    "coordinates": multipoint,
                    "properties": {},
                },
            }
        ],
    }

    json.dump(random_points, sys.stdout)
