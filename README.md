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
library(tidyverse) # <- for examples
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.1     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.1     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

## K-Means Example

This is a basic example which shows you how to use the k_means()
function to obtain cluster assignments for a data set.

``` r
set.seed(20)
iris_km <- iris %>%
    select(Petal.Length, Petal.Width) %>%
    k_means(k = 3)
iris_km
#> $cluster_means
#>   Petal.Length Petal.Width
#> 1     1.462000    0.246000
#> 2     4.292593    1.359259
#> 3     5.626087    2.047826
#> 
#> $clustering_vector
#>   [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#>  [38] 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
#>  [75] 2 2 2 3 2 2 2 2 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 2 3 3 3 3
#> [112] 3 3 3 3 3 3 3 3 2 3 3 3 2 3 3 2 2 3 3 3 3 3 3 3 3 3 3 2 3 3 3 3 3 3 3 3 3
#> [149] 3 3
#> 
#> $sum_of_squares
#> [1]  2.02200 14.22741 15.16348
```

In this example, we performed k means clustering on the Iris dataset,
using petal length and width. The function output gives us a vector of
each group that the flowers are in, the sum of squares for each group,
and the centroids of each group. Since we specified k = 3, we can see
that it made 3 clusters.

We will see how accurately our k_means algorithm clustered the species
together

``` r
iris %>%
    mutate(cluster = as.character(iris_km$clustering_vector)) %>%
    ggplot(aes(x = Petal.Length, y = Petal.Width, color = cluster)) +
    geom_point()
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
iris %>%
    ggplot(aes(x = Petal.Length, y = Petal.Width, color = Species)) +
    geom_point()
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

As you can see, it was able to predict the species pretty well.

We can also apply PCA to the same data as well, and use all the
variables.

``` r
iris %>%
    select(-Species) %>%
    k_means(k = 3, PCA = T)
#> Warning: `as_data_frame()` was deprecated in tibble 2.0.0.
#> ℹ Please use `as_tibble()` (with slightly different semantics) to convert to a
#>   tibble, or `as.data.frame()` to convert to a data frame.
#> ℹ The deprecated feature was likely used in the clust431 package.
#>   Please report the issue to the authors.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> $cluster_means
#>      Comp.1      Comp.2
#> 1  1.406133 -0.05734426
#> 2 -2.395725 -0.41647304
#> 3 -2.571337  0.45835798
#> 
#> $clustering_vector
#>   [1] 3 2 2 2 3 3 2 3 2 2 3 3 2 2 3 3 3 3 3 3 3 3 3 3 2 2 3 3 3 2 2 3 3 3 2 3 3
#>  [38] 3 2 3 3 2 2 3 3 2 3 2 3 3 1 1 1 1 1 1 1 2 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1
#>  [75] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1
#> [112] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#> [149] 1 1
#> 
#> $sum_of_squares
#> [1] 105.683170  17.221058   4.749377
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
