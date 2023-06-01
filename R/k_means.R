#' k means clustering function
#'
#' @param dataframe Dataframe in which k means clustering is performed
#' @param k Number of clusters
#'
#' @param PCA Boolean value whether you want pca
#'
#' @return list with cluster means, cluster assignments and sum of squares for each cluster
k_means <- function(df, k, PCA = F) {

    clust_ind <- sample(1:nrow(df), k)
    clusters <- list()
    for (i in 1:length(clust_ind)) {
        clusters[[i]] <- as.numeric(df[clust_ind[i],])
    }
    old_clusters <- list()
    df_clusters <- df

    while(!setequal(old_clusters, clusters)) {

        old_clusters <- clusters
        centers <- c()
        cmeans <- list()

        for (i in 1:nrow(df)) {
            distances <- c()
            for (j in 1:length(clusters)) {
                distances <- append(distances, sqrt(sum((as.numeric(df[i,]) - clusters[[j]]) ^ 2)))
            }
            centers <- append(centers, which.min(distances))
        }

        df_clusters$cluster <- centers

        df_center <- df_clusters %>%
            group_by(cluster) %>%
            summarize(across(everything(), mean))

        clusters <- as.list(as.data.frame(t(df_center[,-1])))
    }

    ss <- rep(0, k)

    for (i in 1:nrow(df)) {
        ss[df_clusters$cluster[i]] <-
            ss[df_clusters$cluster[i]] + sum((as.numeric(df[i,]) - clusters[[df_clusters$cluster[i]]]) ^ 2)
    }

    return(list(cluster_means = unname(clusters),
                clustering_vector = df_clusters$cluster,
                sum_of_squares = ss))
}
