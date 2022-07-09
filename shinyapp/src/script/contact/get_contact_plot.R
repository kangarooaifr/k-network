
library(ggplot2)


get_contact_plot <- function(data){

  p <- ggplot(data = data, aes(x = date, fill = ..count..)) + 
    
    # daily count
    geom_histogram() +
   
    # cumulative
    stat_bin(aes(y = cumsum(..count..)), geom = "step")
  
}