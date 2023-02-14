# Chicago Dots
*the finest dots for Chicago*

<img src="https://user-images.githubusercontent.com/536941/218774150-04f2121d-d834-4eb7-8437-a384659d422c.png" height="300">

| | Full Population | Over-18 Population | Under-18 Population |
|-|-|-|-|
| 1 point per person | points_full_1.geojson (54M) | points_over_18_1.geojson (44M) | points_under_18_1.geojson (11M) |
| 5 points per person | points_full_5.geojson (11M) | points_over_18_5.geojson (8.7M) | points_under_18_5.geojson (2.2M) |
| 10 points per person | points_full_10.geojson (5.4M) | points_over_18_10.geojson (4.4M) | points_under_18_10.geojson (1.1M) |


[Dot density maps](https://en.wikipedia.org/wiki/Dot_distribution_map) are a great way to show the distribution of countable things across a map. 

The usual approach is to randomly generate N points within a boundary, where N is proportional to the number you want to show, i.e. the number of people who live in a census block or the number of people who voted for a candidate in election precinct.

But, boundaries often quite weird, and that approach can mean we put dots in the lake or the middle of the highway, or other places we know people don't live. 

It would be nice if we could put the dots where people likely **do** live, and that's what this project is here to help you do, at least for Chicago.

## Approach
The U.S. Decennial Census gives us high-resolution data on the number of people who live in a census "block," which often looks like a real city block in Chicago. 

We start with this block data and then use [dasymetric mapping](https://en.wikipedia.org/wiki/Dasymetric_map) to refine the block data with auxillary data.

First we use [CMAP's remarkable land use data set](https://www.cmap.illinois.gov/data/land-use) that classifies how land is being used at the parcel level.

We then further subdivide the landuse data into the portions that intersect with [buildings footprints](https://data.cityofchicago.org/Buildings/Building-Footprints-current-/hz9b-7nh8) and the portions that do not intersect with any buildings. We use [non-negative linear regression](https://en.wikipedia.org/wiki/Non-negative_least_squares) to estimate the population density of the different classes of landuses in both their building-intersection and building-difference variants.

With all this data prepared, we then take the following steps:

1. For each 2020 census block in Chicago, divide it into subareas of different land uses, building footprints, and non-empty land.
2. Then, allocate the block population to each subarea in rough proportion to the area of the subarea multiplied by the estimated population density of that land use category. 
3. Finally, randomly generate points in each subarea.

## How To use
Basically, the way to use these points for 


## to install
```console
> pip install .
```

## to run
```console
> make
```
