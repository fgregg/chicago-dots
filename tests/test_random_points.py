import numpy

from src.points import random_points


def test_points_within_triangle():
    # Generate a fixed triangle
    triangle = numpy.array([[0, 0], [0, 1], [-1, 0]])
    # Generate random points inside triangle
    k = 10000
    points = random_points(triangle, k)
    # Assert that all points are within the triangle
    assert np.all(
        numpy.logical_and(
            numpy.logical_and(points[:, 0] >= -1, points[:, 1] <= 1),
            numpy.logical_and(points[:, 0] <= 0, points[:, 1] >= 0),
        )
    )
    assert numpy.all(numpy.absolute(points[:, 0]) + numpy.absolute(points[:, 1]) <= 1)
