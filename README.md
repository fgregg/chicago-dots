# Chicago Dots
*the finest dots for Chicago*

<img src="https://user-images.githubusercontent.com/536941/218774150-04f2121d-d834-4eb7-8437-a384659d422c.png" height="300">

[Dot density maps](https://en.wikipedia.org/wiki/Dot_distribution_map) are a great way to show the distribution of countable things across a map. 

The usual approach is to randomly generate N points within a boundary, where N is proportional to the number you want to show, i.e. the number of people who live in a census block or the number of people who voted for a candidate in election precinct.

But, boundaries often quite weird, and that approach can mean we put dots in the lake or the middle of the highway, or other places we know people don't live. 

It would be nice if we could put the dots where people likely **do** live, and that's what this project is here to help you do. For Chicago.



random point generation inspired by Ben Schmidt's [Dot Density Code](https://observablehq.com/@bmschmidt/dot-density)

## to install
```console
> pip install .
```

## to run
```console
> make
```
