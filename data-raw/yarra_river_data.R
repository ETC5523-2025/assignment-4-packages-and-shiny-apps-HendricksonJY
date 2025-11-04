## code to prepare `yarra_river_data` dataset goes here

yarra_wq <- readxl::read_excel("data-raw/yarra_wq.xls") |>
  janitor::clean_names()   # -> parameter, datetime, site_id, value

yarra_river_data <- yarra_wq |>
  dplyr::filter(
    parameter %in% c("pH", "Water Temperature", "Salinity as EC@25", "Turbidity", "Nitrogen as Total"),
    !is.na(datetime)
  ) |>
  tidyr::pivot_wider(
    id_cols = c(site_id, datetime),
    names_from = parameter,
    values_from = value
  ) |>
  dplyr::rename(
    nitrogen_total    = `Nitrogen as Total`,
    salinity_ec25     = `Salinity as EC@25`,
    water_temperature = `Water Temperature`,
    ph                = `pH`,
    turbidity         = Turbidity
  ) |>
  dplyr::arrange(site_id, datetime)

usethis::use_data(yarra_river_data, overwrite = TRUE)
