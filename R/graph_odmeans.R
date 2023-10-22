
coordinates

custom_source <- list(
  url = "AIzaSyDHnRGnUBfhwEjZ7l_X9G54ojjvgugFAYI",
  zoom = 10,
  extent = "custom",
  bbox =c(left = -70.2, bottom =  -34.1, right = -70.2, top = -32.9 )
)



a = c(left = lowerleftlon, bottom = lowerleftlat, right = upperrightlon, top = upperrightlat )
map = get_googlemap(bbox = a)

ggmap(map)



d_means_graph <- function(odmeans_data, title="ODMeans Graph", borders=0.2, zoom=4, maptype=c("roadmap"), add_cluster=TRUE){

  # Obtain all information to graph
  #odmeans_data = testing
  dfODMeans = data.frame(odmeans_data[["centers"]])
  colnames(dfODMeans) <- c("OriginLatitude", "OriginLongitude", "DestinationLatitude", "DestinationLongitude")

  clusters = c(1:nrow(dfODMeans))

  if (is.null(odmeans_data[["level_hierarchy"]]) != TRUE)
    Hierarchy = data.frame("Hierarchy" = odmeans_data[["level_hierarchy"]])
  else
    Hierarchy = rep("no_hierarchy", nrow(dfODMeans))

  dfODMeans = cbind(dfODMeans, clusters, Hierarchy)


  # Coordinates of the map
  lowerleftlon = min(dfODMeans["OriginLongitude"], dfODMeans["DestinationLongitude"])
  upperrightlon = max(dfODMeans["OriginLongitude"], dfODMeans["DestinationLongitude"])
  lowerleftlat = min(dfODMeans["OriginLatitude"], dfODMeans["DestinationLatitude"])
  upperrightlat = max(dfODMeans["OriginLatitude"], dfODMeans["DestinationLatitude"])

  lon_size = upperrightlon - lowerleftlon
  lat_size = upperrightlat - lowerleftlat

  lowerleftlon = lowerleftlon - lon_size*borders*sign(lon_size)
  upperrightlon = upperrightlon +lon_size*borders*sign(lon_size)
  lowerleftlat = lowerleftlat - lat_size*borders*sign(lat_size)
  upperrightlat = upperrightlat + lat_size*borders*sign(lat_size)


  location = c(left = lowerleftlon, bottom = upperrightlon, right = lowerleftlat, top = upperrightlat )

  map <- tryCatch(
    {
      get_googlemap(location = location, zoom = zoom, maptype = maptype)
    },
    error = function(e) {
      message("An error occurred while getting the map, try changing zoom, maptype or data.")
      message(e)
      return(NULL)  # Return NULL or an appropriate value if there's an error
    }
  )

  # Check if map is NULL and return a NULL map
  if (is.null(map)) {
    return(NULL)
  }

  ## Add cluster include number of clusters
  if (add_cluster == TRUE)
    final_map = ggmap(map)+
      geom_segment(data=dfODMeans,
                   aes(y= OriginLatitude,
                       yend= DestinationLatitude,
                       x= OriginLongitude,
                       xend= DestinationLongitude,
                       color = Hierarchy),
                   linewidth= 1,
                   arrow= arrow(length = unit(0.4, "cm"))) +
      scale_fill_manual(aesthetics = "colour", values = c("Local" = "royalblue","Global" = "red")) +
      geom_label_repel(data=dfODMeans,
                       aes(label=as.integer(clusters), y=OriginLatitude, x=OriginLongitude),
                       alpha= 0.7,
                       max.overlaps = 26,
                       na.rm=TRUE,
                       xlim = c(lowerleftlon, upperrightlon),
                       ylim = c (lowerleftlat, upperrightlat)) +
      theme_minimal() +
      labs(title = paste(title))
  else {
    final_map = ggmap(map)+
      geom_segment(data=dfODMeans,
                   aes(y= OriginLatitude,
                       yend= DestinationLatitude,
                       x= OriginLongitude,
                       xend= DestinationLongitude,
                       color = Hierarchy),
                   linewidth= 1,
                   arrow= arrow(length = unit(0.4, "cm"))) +
      scale_fill_manual(aesthetics = "colour", values = c("Local" = "royalblue","Global" = "red")) +
      theme_minimal() +
      labs(title = paste(title))
  }

  return(final_map)
}




#function(data, numK, limitsSeparation, maxDist, distHierarchical)

od_means_graph(testing_2, title="ODMeans Taxi Graph", borders=0.2, zoom=11, maptype=c("roadmap"), add_cluster=TRUE)


testing = od_means(ODMeansTaxiData, 10, 30, 2200, 367)
testing_2 = od_means(ODMeansTaxiData, 10, 30, 2200, 700)


testing = od_means(ODMeansSampleData, 5, 1000, 2500, 500)

od_means_graph(testing, borders=0.2, zoom=4, maptype=c("terrain-lines"), add_cluster=FALSE)

od_means_graph(testing, borders=0.2, zoom=11, maptype=c("terrain-lines"), add_cluster=TRUE)


testing_kmeans = kmeans(ODMeansTaxiData, 30)




