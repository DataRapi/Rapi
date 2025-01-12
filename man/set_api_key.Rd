% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api_keys.R
\name{set_api_key}
\alias{set_api_key}
\title{set_api_key}
\usage{
set_api_key(key = null, source_name = null, option = c("env", "file"), ...)
}
\arguments{
\item{key}{API key of the source}

\item{source_name}{\code{evds} or \code{fred}}

\item{option}{choice of later usage. \code{env} or file should be given to
save API key for later use. Default is env which
saves API key as environment variable.
if \code{env} default value is selected it will save API key
as an environment variable
if \code{file} was selected it will save API key to current folder.}

\item{...}{for future versions}
}
\value{
The function has no return value.
}
\description{
set_api_key
}
\examples{
\dontrun{

set_api_key("ABCDEFGHIJKLMOP", "evds", "env")
set_api_key("ABCDEFGHIJKLMOP", "fred", "env")
set_api_key("ABCDEFGHIJKLMOP", "fred", "file")
}
}
