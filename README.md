# ODMeans R Package

## Description 

This package is the implementation of a new hierarchical clustering model that captures global and local patterns called OD-means. Global patterns consist of general travel patterns, for example, the movement from an airport to the city downtown. That is, patterns between main attractors/generators of trips which are usually at different transportation analysis zones. On the other side, local patterns corresponds to trips between minor attractors/generators, such as small trips in local neighbors.

## Installation

Install from CRAN:

```R
install.packages("ODMeans")
```

## Getting started

To apply OD-Means model to data, you can use the function od_means(). It will return an S3 class type ODMeans.

For example:

```R
data(ODMeansTaxiData)
odmeans(ODMeansTaxiData, 10, 30, 1000, 2200, 3, 5, 100)
```

To graph the ODMeans data, you can use the function odmeans_graph(). It will return a ggplot2 plot.

For example:
```R
data(ODMeansTaxiData)
odmeans_clusters = odmeans(ODMeansTaxiData, 10, 30, 1000, 2200, 3, 5, 100)
odmeans_graph = odmeans_graph(odmeans_clusters, "ODMeans Taxi Graph", "roadmap", 11, FALSE)
```

## License

This project is licensed under GPL >= 3.
