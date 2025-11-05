# yarraclean

### Cleaned Yarra River Water Quality Dataset + Shiny Explorer App

`yarraclean` provides a cleaned, analysis-ready version of the Yarra River water quality dataset sourced from the Victorian Department of Energy, Environment, and Climate Action.\
The package includes one dataset (`yarra_river_data`) and a Shiny app launcher (`run_app()`) that allows interactive exploration of trends in pH, turbidity, salinity, nitrogen and water temperature. The package is intended for teaching, environmental visualization, and reproducible research

------------------------------------------------------------------------

## Installation

You can install the package using:

``` r
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-HendricksonJY")
library(yarraclean)
```

## What's in the data?

Each row represents a single water-quality reading taken at a specific site and datetime.

### Variables

-   site_id: monitoring site code
-   datetime: timestamp of observation
-   ph: Acidity/alkalinity (0–14)
-   salinity_ec25: Electrical conductivity \@ 25°C (µS/cm)
-   turbidity: Water cloudiness (NTU)
-   nitrogen_total: Total nitrogen (mg/L)
-   water_temperature: Water temperature (°C)

## Quick Example

load the dataset and view the first rows

``` r
data("yarra_river_data")
head(yarraclean::yarra_river_data)
```

## launch Shiny explorer

`run_app()`
