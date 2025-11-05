#' Yarra River Water Quality (Cleaned Dataset)
#'
#' A processed water-quality dataset for analyzing environmental trends in the
#' Yarra River. The data is suitable for visualization, exploratory data
#' analysis, statistical modelling, and interactive applications. The dataset
#' is provided in a wide format, where each row represents a single
#' observation at a monitoring site and each column corresponds to a measured
#' water-quality variable.
#'
#' The cleaning and reshaping steps are fully reproducible and recorded in
#' \code{data-raw/yarra_river_data.R}. The original raw Excel file is also
#' stored in \code{data-raw/}.
#'
#' @format A data frame with N rows and 7 variables:
#' \describe{
#'   \item{site_id}{Character. Monitoring site identifier.}
#'   \item{datetime}{POSIXct. Timestamp of the observation (local time).}
#'   \item{ph}{Numeric. Acidity/alkalinity of water (0–14 scale).}
#'   \item{salinity_ec25}{Numeric. Electrical conductivity at 25°C (\eqn{\mu}S/cm), used as a proxy for salinity.}
#'   \item{turbidity}{Numeric. Turbidity (NTU), higher values indicate murkier water.}
#'   \item{nitrogen_total}{Numeric. Total nitrogen concentration (mg/L), a key nutrient linked to algal growth.}
#'   \item{water_temperature}{Numeric. Water temperature (°C), affects dissolved oxygen and species tolerance.}
#' }
#'
#' @details
#' This dataset was created via the script \code{data-raw/yarra_river_data.R}
#' using \code{readxl}, \code{dplyr}, and \code{tidyr}. Variables were cleaned,
#' filtered to key water-quality indicators, and reshaped to wide format using
#' \code{tidyr::pivot_wider()}.
#'
#' @source Yarra River monitoring dataset provided for ETC5523 (Monash University).
#'
#' @seealso \code{\link{run_app}} for an optional interactive visualisation,
#'   or simply load the data with \code{data("yarra_river_data")}.
#'
#' @examples
#' data("yarra_river_data", package = "yarraclean")
#' str(yarra_river_data)
#'
#' # Example: median turbidity by year
#' # yr <- as.integer(format(yarra_river_data$datetime, "%Y"))
#' # tapply(yarra_river_data$turbidity, yr, median, na.rm = TRUE)
#'
#' @keywords datasets
"yarra_river_data"
