# Load required libraries
library(shiny)
library(ggplot2)
library(DT)

# Define UI
ui <- fluidPage(
  # Application title
  titlePanel("Sales Dashboard Example"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      # File input for CSV
      fileInput("file", "Choose CSV File",
                accept = c("text/csv", 
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Default file option
      checkboxInput("use_default", "Use Default Sample Data", value = TRUE),
      
      hr(),
      
      # Info text
      helpText("Upload a CSV file with columns: date, product, sales, revenue, region, customer_satisfaction",
               "or use the default sample data.")
    ),
    
    # Main panel with plots and table
    mainPanel(
      # Tabs for better organization
      tabsetPanel(
        tabPanel("Plots",
                 fluidRow(
                   column(6, 
                          h3("Sales by Product"),
                          plotOutput("plot1")
                   ),
                   column(6,
                          h3("Revenue Distribution"),
                          plotOutput("plot2")
                   )
                 )
        ),
        tabPanel("Data Table",
                 h3("Sales Data"),
                 DTOutput("table1")
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive expression to read data
  data <- reactive({
    # Use default data if checkbox is selected
    if (input$use_default) {
      default_file <- "sample_data.csv"
      if (!file.exists(default_file)) {
        showNotification("Default data file not found!", type = "error", duration = 5)
        return(NULL)
      }
      df <- read.csv(default_file, stringsAsFactors = FALSE)
      return(df)
    }
    
    # Otherwise, use uploaded file
    req(input$file)
    
    tryCatch({
      df <- read.csv(input$file$datapath, stringsAsFactors = FALSE)
      
      # Validate required columns
      required_cols <- c("date", "product", "sales", "revenue", "region", "customer_satisfaction")
      missing_cols <- setdiff(required_cols, names(df))
      
      if (length(missing_cols) > 0) {
        showNotification(paste("Missing required columns:", paste(missing_cols, collapse = ", ")), 
                         type = "error", 
                         duration = 5)
        return(NULL)
      }
      
      return(df)
    },
    error = function(e) {
      # Show error notification to user
      showNotification(paste("Error reading file:", e$message), 
                       type = "error", 
                       duration = 5)
      return(NULL)
    })
  })
  
  # Plot 1: Bar chart of sales by product
  output$plot1 <- renderPlot({
    df <- data()
    req(df)
    
    # Aggregate sales by product
    sales_by_product <- aggregate(sales ~ product, data = df, FUN = sum)
    
    ggplot(sales_by_product, aes(x = product, y = sales, fill = product)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Total Sales by Product",
           x = "Product",
           y = "Sales") +
      theme(legend.position = "none",
            plot.title = element_text(hjust = 0.5))
  })
  
  # Plot 2: Box plot of revenue distribution by region
  output$plot2 <- renderPlot({
    df <- data()
    req(df)
    
    ggplot(df, aes(x = region, y = revenue, fill = region)) +
      geom_boxplot() +
      theme_minimal() +
      labs(title = "Revenue Distribution by Region",
           x = "Region",
           y = "Revenue") +
      theme(legend.position = "none",
            plot.title = element_text(hjust = 0.5))
  })
  
  # Table: Display full data
  output$table1 <- renderDT({
    df <- data()
    req(df)
    
    datatable(df, 
              options = list(
                pageLength = 10,
                scrollX = TRUE,
                order = list(list(0, 'desc'))
              ),
              rownames = FALSE)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
