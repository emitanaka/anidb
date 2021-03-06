% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find.R
\name{anime_id}
\alias{anime_id}
\title{Get the anime ID in AniDB from the anime title}
\usage{
anime_id(title = NULL, exact = FALSE, ignore_case = TRUE, max_distance = 0.1)
}
\arguments{
\item{title}{The title of the anime.}

\item{exact}{A logical value indicating whether the match with \code{title}
should be exact or not.}

\item{ignore_case}{Whether the case should be ignore or not}

\item{max_distance}{The max distance for the approximate string matching.
Only used if \code{exact} is \code{FALSE}.}
}
\description{
Get the anime ID in AniDB from the anime title
}
