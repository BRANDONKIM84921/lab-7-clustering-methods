test_that("simple case", {
    set.seed(101)

    test <- data.frame(x = c(19, 8, 13, 52, 2, 13, 15), y = c(1, 13, 12, 43, 1, 2, 17))

    expected <- kmeans(test, 2)

    actual <- k_means(test, 2)

    expect_equal(actual$clustering_vector, expected$cluster)

    expect_equal(actual$cluster_means, as.data.frame(expected$centers))

    expect_equal(actual$sum_of_squares, expected$withinss)
})
