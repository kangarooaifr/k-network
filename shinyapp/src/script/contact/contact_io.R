




# -- read
load_contacts <- function(path, file, colClasses){
  
  # build url
  url <- file.path(path, file)
  cat("Reading data from file:", url, "\n")
  
  # read
  data <- read.csv(url, header = TRUE, colClasses = colClasses, fileEncoding = "UTF-8")
  cat("output dim =", dim(data), "\n")
  
  # format
  data$date <- as.Date(data$date)
  
  # return
  data
  
}


# -- write
save_contacts <- function(data, path, file, init = FALSE){

  # check init (drop all rows)
  if(init)
    data <- data[0, ]
  
  # build url
  url <- file.path(path, file)
  cat("Writing data to file:", url, "\n")
  
  # write
  write.csv(data, file = url, row.names = FALSE, fileEncoding = "UTF-8")
  
  # return (init)
  data
  
}
