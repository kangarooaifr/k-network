
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
                       'subject' = 'character',
                       'source' = 'character',
                       'mission_title' = 'character',
                       'result' = 'character',
                       'feeling' = 'character',
                       'tjm' = 'character')
    
    
    # -- display names
    col_display <- c('Date',
                     'Entreprise',
                     'Nom',
                     'Type',
                     'Prise de Contact',
                     'Offre de Mission',
                     'Subject',
                     'Source',
                     'Mission_title',
                     'Result',
                     'Feeling',
                     'TJM')
    
    
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
      datatable(contact_table_view(r$contacts(), col_display), 
                escape = FALSE, 
                options = list(pageLength = 10,
                               lengthMenu = c(5, 10, 15, 20), 
                               scrollX = T), 
                selection = "single")
      
      )
    
    
    # plot (basic)
    output$contact_plot <- renderPlot({
      
      p <- get_contact_plot(r$contacts())
      
      p
                            
                            
                            }, width = "auto", height = 300, bg = "transparent")
    

    
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
      
      # subject
      selectInput(inputId = ns("cnt_subject"), label = "Subject", choices = list("Entretien ESN", "Entretien Client 1", "Entretien Client 2"), selected = NULL),
      
      # source
      selectInput(inputId = ns("cnt_source"), label = "Source", choices = list("LinkedIn", "FreeWork", "Portfolio"), selected = NULL),
      
      # description
      textInput(inputId = ns("cnt_mission_title"), label = "Description", value = ""),
      
      # result
      selectInput(inputId = ns("cnt_result"), label = "Outcome", choices = list("OK", "-", "KO"), selected = NULL),
      selectInput(inputId = ns("cnt_feeling"), label = "Feeling", choices = list("Good", "-", "Bad"), selected = NULL),
      
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
                          'subject' = input$cnt_subject,
                          'source' = input$cnt_source,
                          'mission_title' = input$cnt_mission_title,
                          'result' = input$cnt_result,
                          'feeling' = input$cnt_feeling,
                          'tjm' = input$cnt_tjm)
      
      # cast to df
      new_contact <- as.data.frame(new_contact)
      
      # merge & store
      contacts <- rbind(new_contact, r$contacts())
      r$contacts(contacts)
      
      # save
      save_contacts(contacts, path$data, contact_file)
      
      # notify
      showNotification("Contact ajouté")
      
    })
    
    
    # -- in table row selection
    observeEvent(input$contact_table_rows_selected, {
      
      if(!is.null(input$contact_table_rows_selected)){
        
        cat("Selected row =", input$contact_table_rows_selected, "\n")
        output$btn_delete <- renderUI(actionButton(inputId = ns("cnt_button_delete"), label = "Supprimer"))
      
      } else {
        
        output$btn_delete <- NULL
        
      }
      
    }, ignoreNULL = FALSE, ignoreInit = TRUE)
    
    
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

