import numpy
import pandas
from sklearn.linear_model import LinearRegression


def prepare_data(features):
    df = pandas.DataFrame(features)
    landuse_narrow = pandas.DataFrame(df["properties"].to_list(), index=df.index)
    return (
        landuse_narrow.groupby(["geoid", "p1_001n", "landuse"])
        .agg({"intersection_area": "sum"})
        .reset_index()
        .pivot(
            index=["geoid", "p1_001n"], columns="landuse", values="intersection_area"
        )
        .reset_index()
        .fillna(0)
    )


def densities(features):

    df = prepare_data(features)
    y = df["p1_001n"]
    X = df.drop(columns=["geoid", "p1_001n"])

    nnls = LinearRegression(positive=True, fit_intercept=False)
    nnls.fit(X, y)

    params = numpy.where(nnls.coef_ == 0.0, 1, nnls.coef_)

    return dict(zip(X.columns, params))
