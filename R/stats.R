

#' Get the time series for the ratings
#'
#' @param aid The anime aid
#' @export
anime_ratings_ts <- function(aid = NULL) {
  pgsession <- anidb_session_login()
  page <- session_jump_to(pgsession,
                          sprintf("https://anidb.net/anime/%s/vote/statistic",
                                  as.character(aid)))
  graph <- html_nodes(page, "#timeseries")
  res <- html_attr(graph, "data-anidb-json")
  res$aid <- aid
  jsonlite::fromJSON(res)
}


#' Get the rating distribution for an anime
#'
#' @param aid The anime id
#' @param type A single string `"permanent"` or `"temporary"` to indicate the
#'   type of rating distribution.
anime_ratings_dist <- function(aid = NULL, type = c("permanent", "temporary")) {

}



anime_ratings_gender_dist <- function(aid = NULL, type = c("raw", "weighted")) {
  pgsession <- anidb_session_login()
  page <- session_jump_to(pgsession,
                          sprintf("https://anidb.net/anime/%s/vote/statistic",
                                  as.character(aid)))
  page %>%
    html_nodes(".demographics") %>%
    purrr::pluck(2) %>%
    html_nodes(".row")
}
