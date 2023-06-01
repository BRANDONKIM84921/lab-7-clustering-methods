Lab 7
================
Aiden Kelly, Brandon Kim, Sam Todd

<!-- README.md is generated from README.Rmd. Please edit that file -->

# clust431

<!-- badges: start -->
<!-- badges: end -->

The goal of clust431 is to provide functions that implement a k-means
algorithm and perform agglomerative hierarchical clustering.

## Installation

You can install the released version of clust431 from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("clust431")
```

``` r
library(clust431)
```

## K-Means Example

This is a basic example which shows you how to use the k_means()
function to obtain cluster assignments for a data set.

``` r
1+1
#> [1] 2
```

## Hierarchical Clustering Example

This is a basic example which shows you how to use the hier_clust()
function to obtain cluster assignments for a data set.

``` r
# first 10 observations from the iris dataset
data <- iris |> 
    head(10)

# remove the categorical variable
# NOTE: the function will automatically select only numeric variables anyway 
data <- subset(data, select = -Species)

# perform hierarchical clustering
iris_hc <- hier_clust(data, 3)

# output the cluster assignments
iris_hc
#>  [1] 1 2 2 2 1 6 2 1 2 2
```

In this example, we perform hierarchical clustering on the first 10
observations from the iris dataset. The function output gives us the
cluster assignments for the data we provided. From the output we can see
that the function successfully grouped the data into clusters as we
supplied k=3 to the function.

``` r
# save a copy without cluster assignments
data2 <- data

# add a new row with the cluster assignments to the original dataset
data$cluster <- iris_hc

# show the new dataset
data
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width cluster
#> 1           5.1         3.5          1.4         0.2       1
#> 2           4.9         3.0          1.4         0.2       2
#> 3           4.7         3.2          1.3         0.2       2
#> 4           4.6         3.1          1.5         0.2       2
#> 5           5.0         3.6          1.4         0.2       1
#> 6           5.4         3.9          1.7         0.4       6
#> 7           4.6         3.4          1.4         0.3       2
#> 8           5.0         3.4          1.5         0.2       1
#> 9           4.4         2.9          1.4         0.2       2
#> 10          4.9         3.1          1.5         0.1       2
```

If we attach the cluster assignments to the original dataset, we can see
that the assignments make sense. Observation 6 is the only observation
in its own cluster. Since it has the largest value for every variable in
the dataset, it make sense that it did find another cluster or
observation that was similar to it.

``` r
# calculate the distance matrix
iris_dist <- dist(data2)

# output matrix
iris_dist
#>            1         2         3         4         5         6         7
#> 2  0.5385165                                                            
#> 3  0.5099020 0.3000000                                                  
#> 4  0.6480741 0.3316625 0.2449490                                        
#> 5  0.1414214 0.6082763 0.5099020 0.6480741                              
#> 6  0.6164414 1.0908712 1.0862780 1.1661904 0.6164414                    
#> 7  0.5196152 0.5099020 0.2645751 0.3316625 0.4582576 0.9949874          
#> 8  0.1732051 0.4242641 0.4123106 0.5000000 0.2236068 0.7000000 0.4242641
#> 9  0.9219544 0.5099020 0.4358899 0.3000000 0.9219544 1.4594520 0.5477226
#> 10 0.4690416 0.1732051 0.3162278 0.3162278 0.5291503 1.0099505 0.4795832
#>            8         9
#> 2                     
#> 3                     
#> 4                     
#> 5                     
#> 6                     
#> 7                     
#> 8                     
#> 9  0.7874008          
#> 10 0.3316625 0.5567764
```

Looking at the distance matrix above, the smallest distance is 0.1414
between observations 1 and 5. We can confirm this by asking hier_clust
to only perform the first iteration of clustering and seeing if those
two observations are put into the same cluster.

``` r
# perform only 1 iteration of hier_clust()
iris_hc_2 <- hier_clust(data2, nrow(data2)-1)

# output the cluster assignments
iris_hc_2
#>  [1]  1  2  3  4  1  6  7  8  9 10
```

As we can see from the hier_clust() output, the 1st and 5th observation
were put in the same cluster after only one iteration. Therefore, the
function is working as expected.
