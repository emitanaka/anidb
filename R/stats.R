

#' Get the time series for the ratings
#'
#' @param aid The anime aid
#' @export
anime_ratings_ts <- function(aid = NULL) {
  anidb_session_login()
  pgsession <- .ANIDB_ENV$LOGIN_SESSION
  page <- session_jump_to(pgsession,
                          sprintf("https://anidb.net/anime/%s/vote/statistic",
                                  as.character(aid)))
  page %>%
    html_nodes("#timeseries") %>%
    html_attr("data-anidb-json") %>%
    jsonlite::fromJSON()
}


#' Get the rating distribution for an anime
#'
#' @param aid The anime id
#' @param type A single string `"permanent"` or `"temporary"` to indicate the
#'   type of rating distribution.
anime_ratings_dist <- function(aid = NULL, type = c("permanent", "temporary") {

}



anime_ratings_gender_dist <- function(aid = NULL, type = c("raw", "weighted")) {
  page %>%
    html_nodes(".demographics") %>%
    purrr::pluck(2) %>%
    html_nodes(".row")
}
