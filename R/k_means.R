#' k means clustering function
#'
#' @param dataframe Dataframe in which k means clustering is performed
#' @param k Number of clusters
#'
#' @param PCA Boolean value whether you want pca
#'
#' @return list with cluster assignments and sum of squares for each cluster
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

    results <- list(cluster_means = new_clusters, clustering_vector = df_assign$cluster)
}
