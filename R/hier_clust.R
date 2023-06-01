#' Implements agglomerative hierarchical clustering
#'
#' @param dat A dataframe
#' @param k Number of clusters
#'
#' @return A vector of cluster assignments
#'
#' @import dplyr
#' @importFrom reshape2 melt
#'
#' @export
hier_clust <- function(data, k) {

    # check if value of k is valid
    if(!is.numeric(k)){
        stop("The value of k must be a number")
    }
    if((k < 1) || (k > nrow(data))){
        stop("Please choose a valid number of clusters")
    }

    # clean data
    data <- data |>
        dplyr::select_if(is.numeric)

    # randomly assign initial clusters
    clusters <- 1:nrow(data)

    # calculate distances
    dist <- as.matrix(dist(data))

    while (length(unique(clusters)) > k) {

        # upper triangular
        dist_upper_tri <- dist
        dist_upper_tri[!upper.tri(dist)] <- NA

        # create dataframe
        dist_df <- reshape2::melt(as.matrix(dist_upper_tri), varnames = c("row", "col")) |>
            dplyr::arrange(row, col) |>
            dplyr::filter(!is.na(value))

        # find the two closest clusters
        min_value <- min(dist_df$value)
        min_row <- subset(dist_df, value == min_value) %>%
            dplyr::select(row, col)

        # vector of the two closest clusters
        merge_clusters <- unname(unlist(min_row))

        # merge the two closest clusters
        min_cluster <- as.numeric(min(merge_clusters))
        max_cluster <- as.numeric(max(merge_clusters))

        # replace all instances of max_cluster with min_cluster
        cluster_indices <- which(clusters == max_cluster)
        clusters[cluster_indices] <- min_cluster

        # update distance matrix using minimum distance
        dist[as.character(min_cluster), ] <- pmin(dist[as.character(min_cluster), ], dist[as.character(max_cluster), ])
        dist[, as.character(min_cluster)] <- pmin(dist[, as.character(min_cluster)], dist[, as.character(max_cluster)])
        dist <- dist[rownames(dist) != as.character(max_cluster), colnames(dist) != as.character(max_cluster)]

    }

    # return the cluster assignments as a vector
    return(clusters)

}
