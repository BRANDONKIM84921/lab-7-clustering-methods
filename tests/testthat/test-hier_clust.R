test_that("hier_clust() works", {

    fed <- read.csv("federalist.txt")

    fed_hc <- hier_clust(fed, k = 10)

    expect_equal(10,
                 length(unique(fed_hc)))

})
