get_params_fred_fnc <- function(seriesID) {
  params <- list(
    series_id = seriesID,
    api_key = get_api_key("fred"),
    file_type = "json"
  )
}
get_params_evds_fnc <- function(seriesID) {
  params <- list(
    series = seriesID,
    key = get_api_key("evds"),
    startDate = date_to_str_1(default_start_date()),
    endDate = date_to_str_1(default_end_date()),
    aggregationTypes = "avg",
    formulas = 0,
    frequency = 1,
    type = "json"
  )
}
# EVDS series .................
# Level: 0
# Percentage change: 1
# Difference: 2
# Year-to-year Percent Change: 3
# Year-to-year Differences: 4
# Percentage Change Compared to End-of-Previous Year: 5
# Difference Compared to End-of-Previous Year : 6
# Moving Average: 7
# Moving Sum: 8
#  EVDS freqs  ....................
# Daily: 1
# Business: 2
# Weekly(Friday): 3
# Twicemonthly: 4
# Monthly: 5
# Quarterly: 6
# Semiannual: 7
# Annual: 8
get_params_evds_datagroup_fnc <- function(datagroup = "bie_yssk") {
  params <- list(
    datagroup = datagroup,
    key = get_api_key("evds"),
    startDate = date_to_str_1(default_start_date()),
    endDate = date_to_str_1(default_end_date()),
    type = "json"
  )
}
