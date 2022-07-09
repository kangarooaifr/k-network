
# ------------------------------------------------------------------------------
# Shiny module:
# ------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# UI items section
# -------------------------------------

# -- table
contact_table_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # table
  DTOutput(ns("contact_table"), width = "100%", height = "auto")}


# -- input form
contact_INPUT <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # form
  uiOutput(ns("contact_form"))
  
}


# -- delete btn
delete_BTN <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # form
  uiOutput(ns("btn_delete"))
  
}


# -- delete btn
contact_plot_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # form
  plotOutput(ns("contact_plot"), height = "auto")
  
}

