#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# -- init env
source("environment.R")
# source("config.R")


# -- source scripts
cat("Source code from:", path$script, " \n")
for (nm in list.files(path$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
{
  source(nm, encoding = 'UTF-8')
}
rm(nm)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # -- declare r communication object
  r <- reactiveValues()
  
  # -------------------------------------
  # call modules
  # -------------------------------------

  # -- contact
  contact_Server(id = "contact", r = r, path = path)
  
  

})
