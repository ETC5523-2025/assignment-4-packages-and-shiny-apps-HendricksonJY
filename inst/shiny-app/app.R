# inst/shiny-app/app.R

# load the packaged data
data("yarra_river_data", package = "yarraclean")

# create year column once
yarra_river_data$year <- as.integer(format(yarra_river_data$datetime, "%Y"))

# filter to 2020–2025
yarra_river_data <- yarra_river_data[
  yarra_river_data$year >= 2020 & yarra_river_data$year <= 2025,
]

ui <- shiny::fluidPage(
  shiny::titlePanel("Yarra River — Boxplot by Year (2020–2025)"),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::selectInput(
        "yvar", "Y variable:",
        choices = c(
          "pH"                  = "ph",
          "Salinity (EC @25°C)" = "salinity_ec25",
          "Turbidity (NTU)"     = "turbidity",
          "Total Nitrogen"      = "nitrogen_total",
          "Water Temperature"   = "water_temperature"
        ),
        selected = "ph"
      )
    ),
    shiny::mainPanel(
      shiny::plotOutput("boxplot", height = 420)
    )
  )
)

server <- function(input, output, session) {

  dat <- shiny::reactive({
    df <- yarra_river_data
    df <- df[!is.na(df[[input$yvar]]), ]
    df$value <- df[[input$yvar]]

    # remove outliers using IQR rule
    q1 <- stats::quantile(df$value, 0.25, na.rm = TRUE)
    q3 <- stats::quantile(df$value, 0.75, na.rm = TRUE)
    iqr <- q3 - q1
    lower <- q1 - 1.5 * iqr
    upper <- q3 + 1.5 * iqr
    df <- df[df$value >= lower & df$value <= upper, ]
    df
  })

  output$boxplot <- shiny::renderPlot({
    df <- dat()
    ggplot2::ggplot(df, ggplot2::aes(x = factor(year), y = value)) +
      ggplot2::geom_boxplot(fill = "#4C78A8", alpha = 0.7, outlier.alpha = 0.5) +
      ggplot2::labs(
        x = "Year",
        y = input$yvar,
        title = paste("Yarra River —", input$yvar, "by Year (2020–2025)")
      ) +
      ggplot2::theme_minimal()
  })
}

shiny::shinyApp(ui, server)
