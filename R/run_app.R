#' Launch the Shiny App
#'
#' This function starts the Shiny app included in the package.
#'
#' @return A running Shiny app
#' @export
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function() {
  app_dir <- system.file("shiny-app", package = "yarraclean")
  if (app_dir == "") {
    stop("Could not find Shiny app directory. Try reinstalling the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
