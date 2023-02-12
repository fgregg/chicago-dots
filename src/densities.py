import logging
import pprint

import numpy
import pandas
from sklearn.linear_model import LinearRegression


def prepare_data(features, population_variable):
    df = pandas.DataFrame(features)
    landuse_narrow = pandas.DataFrame(df["properties"].to_list(), index=df.index)
    return (
        landuse_narrow.groupby(["geoid", population_variable, "landuse"])
        .agg({"intersection_area": "sum"})
        .reset_index()
        .pivot(
            index=["geoid", population_variable],
            columns="landuse",
            values="intersection_area",
        )
        .reset_index()
        .fillna(0)
    )


def densities(features, population_variable):

    df = prepare_data(features, population_variable)
    y = df[population_variable]
    X = df.drop(columns=["geoid", population_variable])

    nnls = LinearRegression(positive=True, fit_intercept=False)
    nnls.fit(X, y)

    params = numpy.where(nnls.coef_ == 0.0, 1, nnls.coef_)

    densities = dict(zip(X.columns, params))
    logging.info(pprint.pformat(densities))

    return densities
