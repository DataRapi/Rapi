
## Rapi
[![R-CMD-check](https://github.com/DataRapi/Rapi/actions/workflows/R_CMD_check.yml/badge.svg)](https://github.com/DataRapi/Rapi/actions/workflows/R_CMD_check.yml)

Rapi download stats
---------

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/Rapi?color=green)](https://cran.r-project.org/package=Rapi)
[![DOI](https://zenodo.org/badge/761353779.svg)](https://zenodo.org/doi/10.5281/zenodo.10800216)

![](https://cranlogs.r-pkg.org/badges/grand-total/Rapi?color=green)
![](https://cranlogs.r-pkg.org/badges/Rapi?color=green)
![](https://cranlogs.r-pkg.org/badges/last-week/Rapi?color=green)

## Overview

Rapi package is an interface to make requests from data providers. 
Current version is able to connect to APIs of [EDDS](https://evds2.tcmb.gov.tr/index.php?/evds/userDocs/) of CBRT (Central Bank of the Republic of Türkiye)
and [FRED API](https://fred.stlouisfed.org/docs/api/fred/) of FED (Federal Reserve Bank). 

## Installation

You can install the package from CRAN using:

``` r
install.packages("Rapi")

```

### Development version

Or you can install the development version from GitHub:

``` r

library(devtools)
install_github("DataRapi/Rapi")
```

## Usage

### set_api_key



``` r
# Set API keys for EDDS
set_api_key("YOUR_EDDS_API_KEY", "evds", "env")
# Set API keys for FRED
set_api_key("YOUR_FRED_API_KEY", "fred", "env")
# Alternatively, you can use file-based configuration
set_api_key("YOUR_EDDS_API_KEY", "evds", "file")
set_api_key("YOUR_FRED_API_KEY", "fred", "file")

```

###  get_series 

> Example 1: Explicit Sources

``` r
# Define a template for series with explicit sources
template <- "
    UNRATE        #fred (series)
    bie_abreserv  #evds (table)
    TP.AB.B1      #evds (series)
"
```


> Example 2: Index-based Definition

``` r
# Define a template for series with indexes
template <- "
    UNRATE         
    bie_abreserv  
    TP.AB.B1      
"
```

In the index-based definition, the package will automatically figure out the source
and base from the provided indexes.

``` r
# Fetch data based on the template
obj <- get_series(template, start_date = "2012/05/22", cache = FALSE)

# Display the results
print(obj)

======================================Rapi_GETPREP=======
  status      : completed
  index       : 
    UNRATE        #fred (series)
    bie_abreserv  #evds (table)
    TP.AB.B1      #evds (series)

  start_date  : 2012/05/22
  end_date    : 2100-01-01
  status [completed]

 lines$data
===================
 ! each line corresponds to a different set of func and data
    data can be reached as below
        --> obj$lines$data
  # A tibble: 3 × 8
  index        source base   comments      freq  fnc_str         fnc          data              
  <chr>        <chr>  <chr>  <chr>         <chr> <chr>           <named list> <list>            
1 UNRATE       fred   series fred (series) null  fred_series_fnc <fn>         <tibble [139 × 2]>
2 bie_abreserv evds   table  evds (table)  null  evds_table_fnc  <fn>         <tibble [138 × 6]>
3 TP.AB.B1     evds   series evds (series) null  evds_series_fnc <fn>         <tibble [138 × 2]>
 data
===================
  (combined) data

    a combined data frame will be constructed
    combined data can be reached as
        --> obj$data
  # A tibble: 138 × 8
   date       UNRATE TP_AB_B1 TP_AB_B2 TP_AB_B3 TP_AB_B4 TP_AB_B6 TP.AB.B1
   <date>      <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
 1 2012-06-01    8.2   12438.   83062.   17704.   95500.  113204.   12438.
 2 2012-07-01    8.2   15068.   85044.   17526.  100113.  117639.   15068.
 3 2012-08-01    8.1   15706.   93006.   16191.  108712.  124903.   15706.
 4 2012-09-01    7.8   17289.   94797    16106.  112086.  128192    17289.
 5 2012-10-01    7.8   17675.   99534.   14575.  117208.  131783.   17675.
 6 2012-11-01    7.7   18200.  100162.   15532.  118362.  133894.   18200.
 7 2012-12-01    7.9   19235.   99933.   18326.  119168.  137493    19235.
 8 2013-01-01    8     19860.  104349.   15466.  124210.  139676    19860.
 9 2013-02-01    7.7   19204.  104023.   14783.  123227.  138010.   19204.
10 2013-03-01    7.5   21037.  105658.   15164.  126695.  141859.   21037.
# ℹ 128 more rows
# ℹ Use `print(n = ...)` to see more rows

=========================================================
  ```
### Additional Usage Examples
``` r
# Fetch data for a specific index
o <- get_series("bie_yssk", start_date = "2010-01-01")
print(o)

# Fetch data for multiple indexes using a vector or template
index_vector <- c("TP_YSSK_A1", "TP_YSSK_A2")
o <- get_series(index_vector)
print(o)

# Remove NA values from the data frame
df_raw <- o$data
df <- remove_na_safe(df_raw)
print(df)

# Create a lagged data frame
df2 <- lag_df(df, list(TP_YSSK_A1 = 1:3, TP_YSSK_A2 = 1:6))
print(df2)

```

``` r
  
o <- get_series("bie_yssk" , start_date = "2010-01-01")
o
# ======================================Rapi_GETPREP=======
#     status      : completed
# index       : bie_yssk
# start_date  : 2010-01-01
# end_date    : 2100-01-01
# ................... resolved [completed] ..............
# 
# ..................................
# .........> lines   .............
# ..................................
# # each line corresponds to a different set of func and data
# data can be reached as below
> obj$lines$data
# # A tibble: 1 × 8
# index    source base  comments freq  fnc_str        fnc          data              
# <chr>    <chr>  <chr> <chr>    <chr> <chr>          <named list> <list>            
#     1 bie_yssk evds   table " "      null  evds_table_fnc <fn>         <tibble [167 × 7]>
#     ..................................
# .........> (combined) data ...
# ..................................
# a combined data frame will be constructed
# combined data can be reached as
> obj$data
# # A tibble: 167 × 7
# date       TP_YSSK_A1 TP_YSSK_A2 TP_YSSK_A3 TP_YSSK_A4 TP_YSSK_A5 TP_YSSK_A6
# <date>          <dbl>      <dbl>      <dbl>      <dbl>      <dbl>      <dbl>
#     1 2010-01-01       7928       6126       5020       5644      51100      75818
# 2 2010-02-01       7619       6030       4911       5521      50088      74168
# 3 2010-03-01       7517       5998       4920       5534      49625      73595
# 4 2010-04-01       7333       5822       4859       5435      49360      72809
# 5 2010-05-01       7136       5510       4922       5266      48108      70942
# 6 2010-06-01       6906       5257       4449       5277      47464      69353
# 7 2010-07-01       6836       5363       4445       5396      49051      71092
# 8 2010-08-01       6758       5291       4411       5281      48407      70148
# 9 2010-09-01       6799       5200       4411       5375      50099      71885
# 10 2010-10-01       6770       5094       4324       5358      51091      72637
# # ℹ 157 more rows
# # ℹ Use print(n = ...) to see more rows
# ...........................................................
# 
# =========================================================
```
### indexes can be given as a vector or a string template 
```r

index_vector  = c( "TP_YSSK_A1" , "TP_YSSK_A2" )
# or as a template it gives same result 
index_template <- "
TP_YSSK_A1
TP_YSSK_A2
"

o <- get_series(index_vector )
o

o <- get_series(index_template )
o
```

Accessing Combined and Lines Data Frames

Once you have retrieved your data using the defined series, you can access the combined data frame and the lines data frame using the following structures:
```r
# Access the combined data frame
combined_data <- obj$data

# Access the 'lines' data frame
lines_data <- obj$lines
```
This structure allows you to easily navigate through the object to access specific data frames.

```r 
df_raw <- o$data

df_raw
# # A tibble: 287 × 3
# date       TP_YSSK_A1 TP_YSSK_A2
# <date>          <dbl>      <dbl>
#     1 2000-01-01         NA         NA
# 2 2000-02-01         NA         NA
# 3 2000-03-01         NA         NA
# 4 2000-04-01         NA         NA
# 5 2000-05-01         NA         NA
# 6 2000-06-01         NA         NA
# 7 2000-07-01         NA         NA
# 8 2000-08-01         NA         NA
# 9 2000-09-01         NA         NA
# 10 2000-10-01         NA         NA
# # ℹ 277 more rows
# # ℹ Use `print(n = ...)` to see more rows
```

### remove_na_safe

This function removes rows from both ends of a data frame until it identifies a row where all columns have non-NA values. The process involves two steps:

1. **Trimming from the Beginning:** It starts from the beginning and removes rows until it encounters a row with complete data in all columns.

2. **Trimming from the End:** After the initial trimming, it proceeds to remove rows from the end of the data frame, eliminating any rows with at least one NA value in any column, until it reaches a row where all columns contain non-NA values.

The process stops when it finds a row where all columns contain non-NA values, and the resulting data frame is returned.

#### Usage:

```R
# Example data frame
example_data <- data.frame(
  A = c(1, 2, 3, NA, 5),
  B = c(NA, 2, 3, 4, 5),
  C = c(1, 2, 3, 4, 5)
)

# Remove NA values from both ends
cleaned_data <- remove_na_safe(example_data)

# View the cleaned data frame
print(cleaned_data)

```

In this example, the function remove_na_safe is applied to the example_data data frame. 
The resulting cleaned_data will have rows removed from both ends until a row with non-NA values in all columns is reached.

```r 
df <- remove_na_safe(df_raw )
df 
# # A tibble: 263 × 3
# date       TP_YSSK_A1 TP_YSSK_A2
# <date>          <dbl>      <dbl>
#     1 2002-01-01       2673       1197
# 2 2002-02-01       3235       1262
# 3 2002-03-01       3561       1432
# 4 2002-04-01       3872       1525
# 5 2002-05-01       4124       1642
# 6 2002-06-01       4432       1748
# 7 2002-07-01       4823       1841
# 8 2002-08-01       4903       1732
# 9 2002-09-01       5155       1706
# 10 2002-10-01       5066       1709
# # ℹ 253 more rows
# ℹ Use `print(n = ...)` to see more rows

```


### lag_df  

The `lag_df` function creates additional columns based on a list of column names and lag sequences. 
This feature is beneficial for scenarios where you need varying lag selections
for certain columns, allowing flexibility in specifying different lags for 
different columns or opting for no lag at all.

#### Usage Example:

```R
# Example data frame
example_data <- data.frame(
  a = c(10, 20, 30, 40, 50),
  b = c(100, 200, 300, 400, 500)
)

# Applying lag_df function with specified lag sequences
lagged_data <- lag_df(example_data, list(a = 1:3, b = 1:2))

# View the lagged data frame
print(lagged_data)

# A tibble: 5 × 7
      a     b a_lag_1 a_lag_2 a_lag_3 b_lag_1 b_lag_2
  <dbl> <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
1    10   100      NA      NA      NA      NA      NA
2    20   200      10      NA      NA     100      NA
3    30   300      20      10      NA     200     100
4    40   400      30      20      10     300     200
5    50   500      40      30      20     400     300
```

In this example, the lag_df function is applied to the example_data data frame with
specified columns (a and b) and corresponding lag sequences (1:3 and 1:6). 
The resulting lagged_data will have additional columns representing the specified lags.


```r
df2 <- lag_df( df , list( TP_YSSK_A1 = 1 : 3 , TP_YSSK_A2 = 1 : 6 ) )
df2
# # A tibble: 263 × 12
# date       TP_YSSK_A1 TP_YSSK_A2 TP_YSSK_A1_lag_1 TP_YSSK_A1_lag_2 TP_YSSK_A1_lag_3 TP_YSSK_A2_lag_1 TP_YSSK_A2_lag_2
# <date>          <dbl>      <dbl>            <dbl>            <dbl>            <dbl>            <dbl>            <dbl>
#     1 2002-01-01       2673       1197               NA               NA               NA               NA               NA
# 2 2002-02-01       3235       1262             2673               NA               NA             1197               NA
# 3 2002-03-01       3561       1432             3235             2673               NA             1262             1197
# 4 2002-04-01       3872       1525             3561             3235             2673             1432             1262
# 5 2002-05-01       4124       1642             3872             3561             3235             1525             1432
# 6 2002-06-01       4432       1748             4124             3872             3561             1642             1525
# 7 2002-07-01       4823       1841             4432             4124             3872             1748             1642
# 8 2002-08-01       4903       1732             4823             4432             4124             1841             1748
# 9 2002-09-01       5155       1706             4903             4823             4432             1732             1841
# 10 2002-10-01       5066       1709             5155             4903             4823             1706             1732
# # ℹ 253 more rows
# # ℹ 4 more variables: TP_YSSK_A2_lag_3 <dbl>, TP_YSSK_A2_lag_4 <dbl>, TP_YSSK_A2_lag_5 <dbl>, TP_YSSK_A2_lag_6 <dbl>
# # ℹ Use `print(n = ...)` to see more rows
```

`get_series` function does not require source names for IDs. The function uses hints 
to figure out which sources to request from for the index IDs given.


```r 
index_template <- "
TP_YSSK_A1
TP_YSSK_A2
UNRATE
"

o <- get_series(index_template )
o

```

Accessing Individual Data Frames

Once you have retrieved your data using the defined series, individual data frames
can be accessed using the following structure:

```r
your_data <- object$lines$data

```

This structure allows you to navigate through the object to access specific data frames.

```r

> o$lines
# # A tibble: 3 × 8
#   index        source base   comments      freq  fnc_str         fnc          data              
#   <chr>        <chr>  <chr>  <chr>         <chr> <chr>           <named list> <list>            
# 1 UNRATE       fred   series fred (series) null  fred_series_fnc <fn>         <tibble [228 × 2]>
# 2 bie_abreserv evds   table  evds (table)  null  evds_table_fnc  <fn>         <tibble [287 × 6]>
# 3 TP.AB.B1     evds   series evds (series) null  evds_series_fnc <fn>         <tibble [287 × 2]>
> o$lines$data
# [[1]]
# # A tibble: 228 × 2
#    date       UNRATE
#    <date>      <dbl>
#  1 2005-01-01    5.3
#  2 2005-02-01    5.4
#  3 2005-03-01    5.2
#  4 2005-04-01    5.2
#  5 2005-05-01    5.1
#  6 2005-06-01    5  
#  7 2005-07-01    5  
#  8 2005-08-01    4.9
#  9 2005-09-01    5  
# 10 2005-10-01    5  
# # ℹ 218 more rows
# # ℹ Use `print(n = ...)` to see more rows
# 
# [[2]]
# # A tibble: 287 × 6
#    date       TP_AB_B1 TP_AB_B2 TP_AB_B3 TP_AB_B4 TP_AB_B6
#    <date>        <dbl>    <dbl>    <dbl>    <dbl>    <dbl>
#  1 2000-01-01    1011    22859.    8943.   23870.   32812.
#  2 2000-02-01    1011    22907.    8296.   23918.   32214.
#  3 2000-03-01    1011.   22926.    9817.   23937.   33754.
#  4 2000-04-01    1011.   22337     8579.   23348.   31926.
#  5 2000-05-01    1011.   22950.    8451.   23961.   32412.
#  6 2000-06-01    1011.   24547.    9270.   25558.   34827.
#  7 2000-07-01    1010.   24477.   10575.   25487    36062.
#  8 2000-08-01    1033    24457    10146.   25490    35636.
#  9 2000-09-01    1025    24160    10715.   25185    35900.
# 10 2000-10-01     988    23593     9970.   24581    34551.
# # ℹ 277 more rows
# # ℹ Use `print(n = ...)` to see more rows
# 
# [[3]]
# # A tibble: 287 × 2
#    date       TP.AB.B1
#    <date>        <dbl>
#  1 2000-01-01    1011 
#  2 2000-02-01    1011 
#  3 2000-03-01    1011.
#  4 2000-04-01    1011.
#  5 2000-05-01    1011.
#  6 2000-06-01    1011.
#  7 2000-07-01    1010.
#  8 2000-08-01    1033 
#  9 2000-09-01    1025 
# 10 2000-10-01     988 
# # ℹ 277 more rows
# # ℹ Use `print(n = ...)` to see more rows
```

### Excel export 
> creates excel file including all data frames of the object 

```r

# Export data frames to an Excel file
obj <- get_series( index = template_test() )
excel(obj, "file_name.xlsx", "somefolder")


```
## Getting API Keys

To access data from EDDS (CBRT) and FRED (FED), users need to obtain API keys by creating accounts on their respective websites.

### EDDS (CBRT) API Key

1. Visit the [EDDS (CBRT) API Documentation](https://evds2.tcmb.gov.tr/index.php?/evds/userDocs).
2. Create an account on the EDDS website if you don't have one.
3. Follow the documentation to generate your API key.

### FRED (FED) API Key

1. Go to the [FRED (FED) API Key Documentation](https://fred.stlouisfed.org/docs/api/api_key.html).
2. Create an account on the FRED website if you haven't done so already.
3. Follow the documentation to obtain your FRED API key.

Make sure to securely store your API keys and never expose them in public repositories.

### Contributing

If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request on GitHub.

