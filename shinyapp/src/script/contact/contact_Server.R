
# ------------------------------------------------------------------------------
# Shiny module:
# ------------------------------------------------------------------------------

# -- Library
library(DT)


# -------------------------------------
# Server logic
# -------------------------------------

contact_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    module <- paste0("[", id, "]")
    ns <- NS(id)
    cat(module, "Starting module server... \n")
    
    
    # -------------------------------------
    # Config
    # -------------------------------------
    
    # -- declare data model
    colClasses <- list('date' = 'character',
                       'entreprise' = 'character',
                       'nom' = 'character',
                       'type' = 'character',
                       'prise_contact' = 'logical',
                       'offre_mission' = 'logical',
                       'interview_esn' = 'logical',
                       'interview_cust_1' = 'logical',
                       'interview_cust_2' = 'logical',
                       'source' = 'character',
                       'mission_title' = 'character',
                       'Result' = 'character',
                       'Feeling' = 'character',
                       'tjm' = 'character')
    
    # -- file
    contact_file <- "contacts.csv"
    
    # -- reactive values
    r$contacts <- reactiveVal(NULL)
    
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    # load or init
    if(file.exists(file.path(path$data, contact_file)))
      contacts <- load_contacts(path = path$data, file = contact_file, colClasses = colClasses)
    else
      contacts <- save_contacts(as.data.frame(colclasses), path$data, contact_file, init = TRUE)
    
    # store
    r$contacts <- reactiveVal(contacts)
    
    
    # -------------------------------------
    # Outputs
    # -------------------------------------
    
    # table
    output$contact_table <- renderDT(
      datatable(r$contacts(), options = list(pageLength = 5,lengthMenu = c(5, 10, 15, 20), scrollX = T), selection = "single"))
    
    # input form
    output$contact_form <- renderUI({
      
      tagList(
        
      
      # date
      dateInput(inputId = ns("cnt_date"), label = "Date", value = Sys.Date(), format = "yyyy-mm-dd", weekstart = 0),
      
      # business & name
      textInput(inputId = ns("cnt_company"), label = "Entreprise", value = ""),
      textInput(inputId = ns("cnt_name"), label = "Nom", value = ""),
      
      # type
      selectInput(inputId = ns("cnt_type"), label = "Type", choices = list("Call", "InMail", "Email"), selected = NULL),
      
      # logical
      checkboxInput(inputId = ns("cnt_first"), label = "Prise de contact", value = FALSE),
      checkboxInput(inputId = ns("cnt_mission"), label = "Offre de mission", value = FALSE),
      checkboxInput(inputId = ns("cnt_interview_esn"), label = "Interview ESN", value = FALSE),
      checkboxInput(inputId = ns("cnt_interview_cust_1"), label = "Interview Client 1", value = FALSE),
      checkboxInput(inputId = ns("cnt_interview_cust_2"), label = "Interview Client 2", value = FALSE),
      
      # type
      selectInput(inputId = ns("cnt_source"), label = "Source", choices = list("LinkedIn", "FreeWork", "Portfolio"), selected = NULL),
      
      # description
      textInput(inputId = ns("cnt_mission_title"), label = "Description", value = ""),
      
      # result
      selectInput(inputId = ns("cnt_result"), label = "Outcome", choices = list("Bad", "Neutral", "Good"), selected = NULL),
      selectInput(inputId = ns("cnt_feeling"), label = "Feeling", choices = list("Bad", "Neutral", "Good"), selected = NULL),
      
      # tjm
      numericInput(inputId = ns("cnt_tjm"), label = "TJM", value = 600),
      
      # action button
      actionButton(inputId = ns("cnt_button_create"), label = "Ajouter")
      
      )
      
    })
    
    
    # -------------------------------------
    # Event observers
    # -------------------------------------
    
    # -- create btn
    observeEvent(input$cnt_button_create, {
      
      # check
      
      # get values
      new_contact <- list('date' = input$cnt_date,
                      'entreprise' = input$cnt_company,
                      'nom' = input$cnt_name,
                      'type' = input$cnt_type,
                      'prise_contact' = input$cnt_first,
                      'offre_mission' = input$cnt_mission,
                      'interview_esn' = input$cnt_interview_esn,
                      'interview_cust_1' = input$cnt_interview_cust_1,
                      'interview_cust_2' = input$cnt_interview_cust_2,
                      'source' = input$cnt_source,
                      'mission_title' = input$cnt_mission_title,
                      'Result' = input$cnt_result,
                      'Feeling' = input$cnt_feeling,
                      'tjm' = input$cnt_tjm)
      
      # cast to df
      new_contact <- as.data.frame(new_contact)
      
      # merge & store
      contacts <- rbind(r$contacts(), new_contact)
      r$contacts(contacts)
      
      # save
      save_contacts(contacts, path$data, contact_file)
      
      # notify
      showNotification("Contact ajouté")
      
    })
    
    
    # -- in table row selection
    observeEvent(input$contact_table_rows_selected, {
      
      cat("Selected row =", input$contact_table_rows_selected, "\n")
      
      output$btn_delete <- renderUI(actionButton(inputId = ns("cnt_button_delete"), label = "Supprimer"))
      
    })
    
    
    # -- delete btn
    observeEvent(input$cnt_button_delete, {
      
      # get value
      index <- input$contact_table_rows_selected
      contacts <- r$contacts()
      
      # drop row(s)
      contacts <- contacts[-c(index), ]
      
      # save & store
      save_contacts(contacts, path$data, contact_file)
      r$contacts(contacts)
      
      # notify
      showNotification("Contact supprimé")
      
    })
    

  })
}

