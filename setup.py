from setuptools import setup

setup(
    name="dasymetric_chicago",
    version="0.0.1",
    install_requires=["click", "earcut", "pandas", "scikit-learn"],
    packages=["src"],
    entry_points={"console_scripts": ["points=src.points:main"]},
)
