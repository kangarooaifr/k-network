


contact_table_view <- function(data, col_display){
  
  
  # replace logical by checkmark
  data$prise_contact <- ifelse(data$prise_contact == TRUE, as.character(icon("ok", lib = "glyphicon")), "-")
  data$offre_mission <- ifelse(data$offre_mission == TRUE, as.character(icon("ok", lib = "glyphicon")), "-")
  
  
  # replace good/bad by thumbs
  data$feeling[data$feeling == "Good"] <- as.character(icon("thumbs-up", lib = "glyphicon"))
  data$feeling[data$feeling == "Bad"] <- as.character(icon("thumbs-down", lib = "glyphicon"))

  
  # set colnames with display value
  colnames(data) <- col_display
  
  
  # return
  data
  
  
}