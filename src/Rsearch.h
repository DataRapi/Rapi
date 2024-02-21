
#ifndef Rapi_MAIN_H
#define Rapi_MAIN_H
#include <RcppCommon.h>
#include <algorithm>
#include <array>
#include <iostream>
#include <Rcpp.h>
using namespace Rcpp;
namespace Rapi
{
    SEXP lag_df(SEXP df, SEXP lag_list);
    typedef Rcpp::DataFrame Rc_df;
    typedef Rcpp::CharacterVector Rc_vec_char;
    typedef Rcpp::NumericVector Rc_vec_num;
    typedef Rcpp::List Rc_list;
    typedef std::string s_string;
    typedef std::vector<std::string> vector_string;
}
#endif
