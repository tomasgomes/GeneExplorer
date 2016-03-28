library(shiny)

# Define UI for application
shinyUI(fluidPage(
  
  # Application title
  titlePanel(h1("Gene Explorer")),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
        # Expression Matrix
        fileInput('file1', 'Choose Expression Table',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        
        # Subgroups (optional)
        fileInput('file2', 'Choose Subgroups Table',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        
        # Choosing which subgroup
        uiOutput("cell_class"),
        
        # Gene name
        textInput("gene", 'Choose a Gene', value = "", 
                  width = NULL, placeholder = "Input gene here"),
        
        # Expression threshold
        numericInput("thres", 'Choose expression threshold', 0, min = 0, max = NA)
    , width = 3),
    
    # Show plots and tables
    mainPanel(
      
      tabsetPanel(
        tabPanel("Violin", plotOutput("vioPlot")), 
        tabPanel("%Table", dataTableOutput("perc_group"))
      )
      
    )
  )
))