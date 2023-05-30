#' k means clustering function
#'
#' @param dataframe Dataframe in which k means clustering is performed
#' @param k Number of clusters
#'
#' @param PCA Boolean value whether you want pca
#'
#' @return list with cluster means, cluster assignments and sum of squares for each cluster
k_means <- function(df, k, PCA = F) {

    clust_ind <- sample(k, 1:nrow(df))
    clusters <- list()
    for (i in 1:length(clust_ind)) {
        clusters[[i]] <- as.numeric(df[clust_ind[i],])
    }
    new_clusters <- list()

    while(!set_equal(new_clusters, clusters)) {
        df_assign <- df %>%
            mutate(cluster = {
                for (cluster in clusters) {
                    distances <- append(distances, sqrt(sum((as.numeric(df[i,]) - cluster) ^ 2)))
                }
                which.min(distances)
            })

        clusters <- new_clusters

        df_center <- df_assign %>%
            group_by(cluster) %>%
            summarize(across(everything(), mean))

        new_clusters <- as.list(as.data.frame(t(df_center[,-1])))
    }

    ss <- rep(0, k)

    for (i in 1:length(df)) {
        ss[df_assign$cluster[i]] <-
            ss[df_assign$cluster[i]] + sqrt(sum((as.numeric(df[i,]) - clustering_means[i]) ^ 2))
    }

    return(list(cluster_means = new_clusters,
                clustering_vector = df_assign$cluster,
                sum_of_squares = ss))
}
