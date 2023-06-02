
rm(list = ls())
setwd('C:/Users/teres/OneDrive/Documents/DSTI/RBigDataProcessing/Project')

library(shiny)
library(maps)
library(mapproj)
library(ggplot2)
library(anytime)
library(lubridate)
library(dplyr)
library(plotly)
library(shinydashboard)

# Load AirbnbMerge dataset
merged_data =  read.csv("AirbnbMerge.csv",header=TRUE)
merged_data = merged_data[,-1]
merged_data$date <- as.Date(merged_data$date)


# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Airbnb Project App"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Price per Accommodation Feature", tabName = "app1"),
      menuItem("Number of Apartments per Owner", tabName = "app2"),
      menuItem("Rental Prices according to Location", tabName = "app3"),
      menuItem("Visits according to Arrondissement", tabName = "app4")
    )
  ),
  dashboardBody(
    tabItems(
      # APP 1: Price per Accommodation Features
      tabItem(
        tabName = "app1",
        fluidPage(
          titlePanel("Explore Average Price per Apartment Feature"),
          sidebarLayout(
            sidebarPanel(
              selectInput("feature", "Select Apartment Feature:", 
                          choices = c("bathrooms", "bedrooms", "beds", "bed_type"),
                          selected = "bathrooms"),
              sliderInput("price_range", "Select Price Range:", 
                          min = min(merged_data$price_num), 
                          max = max(merged_data$price_num),
                          value = c(min(merged_data$price_num), max(merged_data$price_num)),
                          step = 10)
            ),
            mainPanel(
              plotOutput("plot_app1")
            )
          )
        )
      ),
      
      # APP 2: Number of Apartments per Owners
      tabItem(
        tabName = "app2",
        fluidPage(
          titlePanel("Explore Hosts and Number of Apartments"),
          sidebarLayout(
            sidebarPanel(
              p("Use the sliders below to select the minimum and maximum number of apartments of the owner."),
              sliderInput("min_apartment_slider", "Minimum Number of Apartments:", min = 1, max = max(table(merged_data$host_id)), value = 1),
              sliderInput("max_apartment_slider", "Maximum Number of Apartments:", min = 1, max = max(table(merged_data$host_id)), value = max(table(merged_data$host_id))),
              p("Select the order:"),
              selectInput("order_select", "Order:", choices = c("Increasing", "Decreasing"), selected = "Decreasing"),
              br()
            ),
            mainPanel(
              plotlyOutput("plot_app2")
            )
          )
        )
      ),
      
      # APP 3: Rental Prices according to Location
      tabItem(
        tabName = "app3",
        fluidPage(
          titlePanel("Explore Rental Prices according to Location"),
          sidebarLayout(
            sidebarPanel(
              selectInput("location_parameter", "Select Location Parameter:",
                          choices = c("arrondissement", "neighbourhood_cleansed")),
              uiOutput("location_values_ui")
            ),
            mainPanel(
              plotOutput("rental_plot")
            )
          )
        )
      ),
      
      # APP 4: Visits according to Arrondissement
      tabItem(
        tabName = "app4",
        fluidPage(
          titlePanel("Explore Visit Frequency according to Location"),
          sidebarLayout(
            sidebarPanel(
              selectInput("location", "Select Location:",
                          choices = sort(unique(merged_data$arrondissement)),
                          selected = sort(unique(merged_data$arrondissement))[1],
                          multiple = TRUE),
              fluidRow(
                column(6,
                       selectInput("start_month", "Start Month:",
                                   choices = month.abb, selected = month.abb[1])
                ),
                column(6,
                       selectInput("end_month", "End Month:",
                                   choices = month.abb, selected = month.abb[12])
                )
              ),
              fluidRow(
                column(6,
                       selectInput("start_year", "Start Year:",
                                   choices = unique(year(merged_data$date)), selected = min(year(merged_data$date)))
                ),
                column(6,
                       selectInput("end_year", "End Year:",
                                   choices = unique(year(merged_data$date)), selected = max(year(merged_data$date)))
                )
              )
            ),
            mainPanel(
              plotOutput("visit_frequency_plot")
            )
          )
        )
      )
    )
  )
)

# Define server
server <- function(input, output, session) {
  # APP 1: Price per Accommodation Features
  output$plot_app1 <- renderPlot({
    filtered_data <- merged_data[merged_data$price_num >= input$price_range[1] & 
                                   merged_data$price_num <= input$price_range[2], ]
    
    # Calculate average price for each level of the selected feature
    avg_price <- aggregate(price_num ~ ., data = filtered_data[, c(input$feature, "price_num")], FUN = mean)
    
    ggplot(avg_price, aes_string(x = input$feature, y = "price_num")) +
      geom_bar(stat = "identity", fill = "darkseagreen", color = "darkseagreen") +
      labs(x = input$feature, y = "Price", title = "Relationship between Average Price and Apartment Features") +
      coord_cartesian(ylim = range(avg_price$price_num))  
  })
  
  # APP 2: Number of Apartments per Owners
  output$plot_app2 <- renderPlotly({
    owner_counts <- table(merged_data$host_id)
    data <- data.frame(Owner = names(owner_counts), Apartments = as.numeric(owner_counts))
    filtered_data <- subset(data, Apartments >= input$min_apartment_slider & Apartments <= input$max_apartment_slider)
    
    if (input$order_select == "Increasing") {
      filtered_data$Owner <- factor(filtered_data$Owner, levels = filtered_data$Owner[order(filtered_data$Apartments)])
    } else {
      filtered_data$Owner <- factor(filtered_data$Owner, levels = filtered_data$Owner[order(filtered_data$Apartments, decreasing = TRUE)])
    }
    
    plot <- plot_ly(filtered_data, x = ~Owner, y = ~Apartments, type = "bar",
                    marker = list(color = ~Apartments, colorscale = "Viridis")) %>%
      layout(xaxis = list(title = "Owner"),
             yaxis = list(title = "Number of Apartments"),
             title = "Number of Apartments per Owner")
    
    plot
  })
  
  # APP 3: Rental Prices according to Location
  output$location_values_ui <- renderUI({
    location_parameter <- input$location_parameter
    if (is.null(location_parameter)) {
      return()
    }
    location_values <- switch(location_parameter,
                              arrondissement = sort(unique(merged_data$arrondissement)),
                              neighbourhood_cleansed = sort(unique(merged_data$neighbourhood_cleansed)))
    selectInput("location_value", paste("Select", location_parameter, ":"), choices = location_values)
  })
  
  filtered_data <- reactive({
    location_parameter <- input$location_parameter
    location_value <- input$location_value
    if (is.null(location_parameter) || is.null(location_value)) {
      return(merged_data)
    }
    if (location_parameter == "arrondissement") {
      merged_data %>%
        filter(arrondissement == location_value, price_num >= input$price_range[1], price_num <= input$price_range[2])
    } else if (location_parameter == "neighbourhood_cleansed") {
      merged_data %>%
        filter(neighbourhood_cleansed == location_value, price_num >= input$price_range[1], price_num <= input$price_range[2])
    } else {
      merged_data
    }
  })
  
  output$rental_plot <- renderPlot({
    ggplot(filtered_data(), aes_string(x = input$location_parameter, y = "price_num")) +
      geom_boxplot(fill = "lavender", color = "black", outlier.colour = "orange") +
      labs(x = input$location_parameter, y = "Rental Price") +
      ggtitle(paste("Rental Prices by", input$location_parameter, ":", input$location_value)) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
  })
  
  # APP 4: Visits according to Arrondissement
  filtered_data_app4 <- reactive({
    merged_data %>%
      filter(arrondissement %in% input$location,
             month(date) >= match(input$start_month, month.abb) & month(date) <= match(input$end_month, month.abb),
             year(date) >= input$start_year & year(date) <= input$end_year) %>%
      arrange(date)
  })
  
  visit_freq <- reactive({
    filtered_data_app4() %>%
      mutate(month = format(date, "%b %Y"),
             year = format(date, "%Y")) %>%
      group_by(month, year) %>%
      summarise(visits = n()) %>%
      arrange(as.Date(paste("01", month), format = "%d %b %Y"), year)
  })
  
  unique_years <- reactive({
    unique(visit_freq()$year)
  })
  
  visit_freq_ordered <- reactive({
    visit_freq() %>%
      arrange(year, as.Date(paste("01", month), format = "%d %b %Y"))
  })
  
  output$visit_frequency_plot <- renderPlot({
    ggplot(visit_freq_ordered(), aes(x = factor(month, levels = unique(visit_freq_ordered()$month)), y = visits, fill = year)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = c("lavender", "thistle", "paleturquoise3", "yellowgreen", "snow3", "lightgoldenrod1", "tan2", "lightcoral")) +
      labs(x = "Month", y = "Visit Frequency",
           title = paste("Visit frequency of arrondissement:", input$location,
                         "from", input$start_month, input$start_year,
                         "to", input$end_month, input$end_year)) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
}

# Run the app
shinyApp(ui, server)
