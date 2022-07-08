
# ------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny web application
# ------------------------------------------------------------------------------

# -- Library

library(shiny)
library(shinydashboard)


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


# -- Define Header
header <- dashboardHeader(title = "Network")


# -- Define Sidebar UI
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Contacts", tabName = "contact", icon = icon("address-card"), selected = TRUE)),
  collapsed = FALSE)


# -- Define Body UI
body <- dashboardBody(
  
  tabItems(
    
    # -- item
    tabItem(tabName = "contact", NULL)
    
    )
)


# -- Put them together into a dashboard
dashboardPage(header, sidebar, body)

