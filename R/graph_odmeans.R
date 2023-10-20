#ggplot

od_means_graph <- function(odmeans_data, title="ODMeans Graph", borders=1.2, zoom=4, maptype=c("terrain-lines"), add_cluster=TRUE){

  dfODMeans = data.frame(odmeans_data[["centers"]])
  clusters = c(1:nrow(dfODMeans))
  hierarchy = data.frame("hierarchy" = odmeans_data[["level_hierarchy"]])
  dfODMeans = cbind(dfODMeans, clusters, hierarchy)

  lowerleftlon = min(dfProbando["OriginLongitude"], dfProbando["DestinationLongitude"])*borders
  upperrightlon = max(dfProbando["OriginLongitude"], dfProbando["DestinationLongitude"])*borders
  lowerleftlat = min(dfProbando["OriginLatitude"], dfProbando["DestinationLatitude"])*borders
  upperrightlat = max(dfProbando["OriginLatitude"], dfProbando["DestinationLatitude"])*borders

  coordinates = c(lowerleftlon, lowerleftlat, upperrightlon, upperrightlat)

  map <- tryCatch(
    {
      get_stamenmap(bbox = coordinates, zoom = zoom, maptype = maptype)
    },
    error = function(e) {
      message("An error occurred while getting the map, try changing zoom or data.")
      return(NULL)  # Return NULL or an appropriate value if there's an error
    }
  )

  # Check if map is NULL (indicating an error) and handle it
  if (is.null(map)) {
    # You can add further error handling here or simply return NULL
    return(NULL)
  }
  final_map = ggmap(map)+
    geom_segment(data=dfODMeans,
                 aes(y= OriginLatitude,
                     yend= DestinationLatitude,
                     x= OriginLongitude,
                     xend= DestinationLongitude,
                     color = hierarchy),
                 linewidth= 1,
                 arrow= arrow(length = unit(0.4, "cm"))) +
    scale_fill_manual(aesthetics = "colour", values = c("Local" = "royalblue","Global" = "red")) +
    geom_label_repel(data=dfODMeans, aes(label=as.integer(clusters), y=OriginLatitude, x=OriginLongitude), alpha= 0.7, max.overlaps = 26) +
    theme_minimal() +
    labs(title = paste("ODMeans Graph"))

  return(final_map)

}


# testing = od_means(ODMeansSampleData, 5, 1000, 2500, 500)
# od_means_graph(testing) # zoom 6 y borders 1.2 error




