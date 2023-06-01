# Test case 1: Check if the function returns the correct number of clusters
test_that("The function returns the correct number of clusters", {
    # Create a sample dataframe
    df <- data.frame(x = c(1, 2, 3, 10, 11, 12),
                     y = c(1, 2, 3, 10, 11, 12))

    # Perform k-means clustering with k = 2
    result <- k_means(df, k = 2)

    # Check if the number of clusters is equal to k
    expect_equal(length(result$cluster_means), 2)
})

# Test case 2: Check if the function assigns each data point to a cluster
test_that("The function assigns each data point to a cluster", {
    # Create a sample dataframe
    df <- data.frame(x = c(1, 2, 3, 10, 11, 12),
                     y = c(1, 2, 3, 10, 11, 12))

    # Perform k-means clustering with k = 2
    result <- k_means(df, k = 2)

    # Check if the length of clustering vector is equal to the number of data points
    expect_equal(length(result$clustering_vector), nrow(df))
})

# Test case 3: Check if the function returns the correct sum of squares for each cluster
test_that("The function returns the correct sum of squares for each cluster", {
    # Create a sample dataframe
    df <- data.frame(x = c(1, 2, 3, 10, 11, 12),
                     y = c(1, 2, 3, 10, 11, 12))

    # Perform k-means clustering with k = 2
    result <- k_means(df, k = 2)

    # Calculate the expected sum of squares manually
    expected_ss <- sum((df[1:3, ] - result$cluster_means[[1]])^2) +
        sum((df[4:6, ] - result$cluster_means[[2]])^2)

    # Check if the sum of squares is equal to the expected value
    expect_equal(result$sum_of_squares, expected_ss)
})
