
#include "Rapi.h"
#include "sp_df.cpp"
using namespace Rapi;

// [[Rcpp::export]]
Rcpp::DataFrame as_tibblex(Rcpp::DataFrame &df)
{
  Rcpp::Environment pkg = Rcpp::Environment::namespace_env("tibble");
  Rcpp::Function as_tibble = pkg["as_tibble"];
  return as_tibble(df);
}
// [[Rcpp::export]]
Rcpp::DataFrame lag_df_c(Rcpp::DataFrame &df2, const Rcpp::List &lag_list)
{
  sp_data_frame o = df2;
  auto df3 = o.transform_df_cpp_internal(lag_list);
  return df3;
}
// [[Rcpp::export]]
Rcpp::DataFrame lag_df2_c(Rcpp::DataFrame &df2, const Rcpp::List &lag_list)
{
  sp_data_frame o = df2;
  auto df3 = o.transform_df_cpp_internal(lag_list);
  return as_tibblex(df3);
}
// [[Rcpp::export]]
Rcpp::DataFrame remove_column_cpp(Rcpp::DataFrame &df, std::string column)
{
  sp_data_frame o = df;
  auto dfr = o.remove_column_df(o.get_df(), column);
  return as_tibblex(dfr);
}


