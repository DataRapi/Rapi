API_List <- function() {
  fred <- list(
    name = "fred",
    api_key_name = "FRED_API_KEY",
    url = "https://api.stlouisfed.org/",
    observations_url = "fred/series/observations",
    series_fnc = get_params_fred_fnc,
    responseFnc = response_fnc_fred,
    check_api_key_fnc = function() check_api_key_was_set("fred"),
    requires_proxy = F
  )
  evds <- list(
    name = "evds",
    api_key_name = "EVDS_API_KEY",
    url = "https://evds2.tcmb.gov.tr/",
    observations_url = "service/evds/",
    series_fnc = get_params_evds_fnc,
    responseFnc = response_fnc_evds,
    check_api_key_fnc = function() check_api_key_was_set("evds"),
    requires_proxy = FALSE
  )
  evds_datagroup <- list(
    name = "evds_datagroup",
    api_key_name = "EVDS_API_KEY",
    url = "https://evds2.tcmb.gov.tr/",
    observations_url = "service/evds/",
    series_fnc = get_params_evds_datagroup_fnc,
    responseFnc = response_fnc_evds,
    check_api_key_fnc = function() check_api_key_was_set("evds"),
    requires_proxy = FALSE
  )
  list(
    fred = fred,
    evds = evds,
    evds_datagroup = evds_datagroup
  )
}
