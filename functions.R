### This is a script for holding all of my functions used in occurrence mapping.

taxa_filter <- function(data, kingdom = NULL, phylum = NULL, class = NULL, order = NULL, family = NULL, genus = NULL, specificEpithet = NULL) {
  if(!is.null(kingdom)) {
    data <- data[data$kingdom %in% kingdom,]
  }
  if(!is.null(phylum)) {
    data <- data[data$phylum %in% phylum,]
  }
  if(!is.null(class)){
    data <- data[data$class %in% class,]
  }
  if(!is.null(order)){
    data <- data[data$order %in% order,]
  }
  if(!is.null(family)){
    data <- data[data$family %in% family,]
  }
  if(!is.null(genus)){
    data <- data[data$genus %in% genus,]
  }
  if(!is.null(specificEpithet)){
    data <- data[data$specificEpithet %in% specificEpithet,]
  }
  return(data)
  
}
