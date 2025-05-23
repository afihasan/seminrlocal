% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/theme_current.R
\name{seminr_theme_get}
\alias{seminr_theme_get}
\alias{seminr_theme_set}
\title{Get and set the active theme}
\usage{
seminr_theme_get()

seminr_theme_set(new)
}
\arguments{
\item{new}{new theme (a list of theme elements)}
}
\description{
The current/active theme (see [seminr_theme()]) is automatically applied to every
graph you draw. Use `seminr_theme_get()` to get the current theme, and `seminr_theme_set()` to
completely override it.
}
