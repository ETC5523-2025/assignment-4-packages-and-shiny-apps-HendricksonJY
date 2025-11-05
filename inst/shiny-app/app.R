# inst/shiny-app/app.R

# load the packaged data
data("yarra_river_data", package = "yarraclean")

# create year column once
yarra_river_data$year <- as.integer(format(yarra_river_data$datetime, "%Y"))

# filter to 2020–2025
yarra_river_data <- yarra_river_data[
  yarra_river_data$year >= 2020 & yarra_river_data$year <= 2025,
]

# ✅ field-level descriptions (what the variable measures)
field_desc <- list(
  ph                = "pH is a measure of how acidic or alkaline the water is (0–14 scale). Natural healthy rivers are typically between pH 6.5 and 8.5.",
  salinity_ec25     = "Electrical conductivity (EC @ 25°C) measures salinity — higher values indicate more dissolved salts and ions in the water.",
  turbidity         = "Turbidity measures water cloudiness caused by suspended particles such as sediment, algae, or organic matter.",
  nitrogen_total    = "Total nitrogen represents nutrients (mg/L) entering the waterway from agriculture, sewage, stormwater, or industry.",
  water_temperature = "Water temperature (°C) affects oxygen levels and the types of aquatic organisms that can survive."
)

# ✅ plot interpretation text (how to read the boxplot)
plot_desc <- list(
  ph = "The boxplot shows the distribution of pH readings for each year. Stable pH values within the 6.5–8.5 range generally indicate a healthy aquatic environment, while downward shifts suggest increasing acidity and upward shifts indicate alkalinity stress. Large variation or changes across years may reflect pollution events, acidification, or altered buffering capacity in the river system.",

  salinity_ec25 = "The boxplot displays yearly distributions of electrical conductivity (EC), a proxy for salinity and dissolved ions. Higher median or widening EC values may signal increased runoff, wastewater discharge, or saline intrusion. Sudden or persistent increases in salinity can affect species tolerance, disrupt osmoregulation in freshwater organisms, and indicate declining water quality.",

  turbidity = "Turbidity boxplots show how cloudy the river water is across years. Higher median turbidity or large yearly variation can indicate erosion, algal blooms, or contaminated stormwater events. Lower turbidity is typically associated with healthier river ecosystems.",

  nitrogen_total = "The boxplot shows distribution of total nitrogen for each year, a key driver of algal blooms. Higher medians or heavier spread indicate nutrient loading from agriculture or wastewater. Years with consistently high nitrogen pose increased risk of eutrophication and oxygen depletion.",

  water_temperature = "The boxplot displays yearly distributions of water temperature. Varying teperatures affect dissolved oxygen availability and species tolerance. Higher or rising temperature ranges may reflect climate change, low flows, or lack of shading vegetation. Wider spreads indicate unstable or rapidly fluctuating thermal conditions."
)

ui <- shiny::fluidPage(
  shiny::tags$head(
    shiny::tags$link(
      rel = "stylesheet", type = "text/css", href = "style.css")
  ),
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
      ),
      shiny::checkboxInput(
        "show_violin",
        label = "Overlay violin (distribution)",
        value = TRUE
      ),
      shiny::uiOutput("field_desc")   # ✅ variable meaning
    ),
    shiny::mainPanel(
      shiny::div(
        id = "plot-container",
        shiny::plotOutput("boxplot", height = 420)
      ),
      shiny::uiOutput("plot_desc")    # ✅ how to interpret plot
    )
  )
)

server <- function(input, output, session) {

  output$field_desc <- shiny::renderUI({
    shiny::tags$p(
      style = "margin-top: 5px; font-size: 13px; color: #444;",
      field_desc[[input$yvar]]
    )
  })

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

    p <- ggplot2::ggplot(df, ggplot2::aes(x = factor(year), y = value))

    # Violin first (so it renders underneath)
    if (isTRUE(input$show_violin)) {
      p <- p + ggplot2::geom_violin(
        fill  = "blue",     # same hue as boxes
        alpha = 0.15,          # translucent
        color = NA,
        width = 0.9,
        scale = "width",
        trim  = TRUE
      )
    }

    # Boxplot on top
    p <- p + ggplot2::geom_boxplot(
      fill = "#4C78A8",
      alpha = 0.7,
      outlier.shape = NA
    ) +
      ggplot2::labs(
        x = "Year",
        y = input$yvar,
        title = paste("Yarra River —", input$yvar, "by Year (2020–2025)")
      ) +
      ggplot2::theme_minimal()

    p
  })

  output$plot_desc <- shiny::renderUI({
    shiny::tags$p(
      style = "margin-top: 12px; font-size: 15px; font-weight: 500; color: #333;",
      plot_desc[[input$yvar]]
    )
  })
}

shiny::shinyApp(ui, server)
