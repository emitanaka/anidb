

#' Get the time series for the ratings
#'
#' @param aid The vector of anime aid.
#' @param include_title A logical value indicating whether to include the title in the
#'  output data frame.
#' @return A data frame containing the columns `votes`, `date`, `rating`, and the
#'  anime ID (`aid`). Optionally it may include the primary `title`.
#' @export
anime_ratings_ts <- function(aid = NULL, include_title = TRUE) {
  pgsession <- anidb_session_login()
  out <- list()
  for(i in seq_along(aid)) {
    said <- as.character(aid[i])
    xaid <- as.integer(said)
    if(!exists_and_same_date(.ANIDB_ENV$ANIME_RATINGS_TS[[said]])) {
      page <- session_jump_to(pgsession,
                              sprintf("https://anidb.net/anime/%s/vote/statistic",
                                      said))
      graph <- html_nodes(page, "#timeseries")
      res <- html_attr(graph, "data-anidb-json")
      out[[i]] <- jsonlite::fromJSON(res)
      out[[i]]$aid <- xaid
      .ANIDB_ENV$ANIME_RATINGS_TS[[said]] <- add_download_date(out[[i]])
    } else {
      out[[i]] <- .ANIDB_ENV$ANIME_RATINGS_TS[[said]]
    }
    if(include_title) {
      title <- primarytitles$title_primary[primarytitles$aid==xaid]
      out[[i]]$title <- title
    } else {
      out[[i]]$title <- NULL
    }
  }
  add_download_date(do.call("rbind", out))
}


#' Get the rating distribution for an anime
#'
#' @inheritParams anime_ratings_ts
#' @param type A single string `"permanent"` or `"temporary"` to indicate the
#'   type of rating distribution.
#' @export
anime_ratings_dist <- function(aid = NULL, type = c("permanent", "temporary"), include_title = TRUE) {
  pgsession <- anidb_session_login()
  type <- match.arg(type)
  out <- list()
  for(i in seq_along(aid)) {
    said <- as.character(aid[i])
    xaid <- as.integer(said)
    if(!exists_and_same_date(.ANIDB_ENV$ANIME_RATINGS_DIST[[said]])) {
      page <- session_jump_to(pgsession,
                              sprintf("https://anidb.net/anime/%s/vote/statistic",
                                      said))
      graphs <- html_nodes(page, ".container.g_bubblewrap")
      data <- graphs[[as.numeric(type=="temporary") + 1L]]
      counts <- html_nodes(data, ".header.count")
      counts <- as.integer(html_text(counts)[-1])
      out[[i]] <- data.frame(vote = 1:10, count = counts, aid = xaid)
      .ANIDB_ENV$ANIME_RATINGS_DIST[[said]] <- add_download_date(out[[i]])
    } else {
      out[[i]] <- .ANIDB_ENV$ANIME_RATINGS_DIST[[said]]
    }
    if(include_title) {
      title <- primarytitles$title_primary[primarytitles$aid==xaid]
      out[[i]]$title <- title
    } else {
      out[[i]]$title <- NULL
    }
  }
  add_download_date(do.call("rbind", out))
}

#' Get the rating distribution for an anime
#'
#' @inheritParams anime_ratings_ts
#' @param type Whether to get the raw average ratings or the weighted average ratings.
#' @export
anime_ratings_gender_dist <- function(aid = NULL,
                                      type = c("raw", "weighted"),
                                      include_title = TRUE) {
  pgsession <- anidb_session_login()
  type <- match.arg(type)
  out <- list()
  for(i in seq_along(aid)) {
    said <- as.character(aid[i])
    xaid <- as.integer(said)
    if(!exists_and_same_date(.ANIDB_ENV$ANIME_RATINGS_GENDER_DIST[[said]])) {
      page <- session_jump_to(pgsession,
                              sprintf("https://anidb.net/anime/%s/vote/statistic",
                                      said))
      tables <- html_nodes(page, ".demographics")
      data <- tables[[as.numeric(type=="weighted") + 1L]]
      clean_vector <- function(identifier) {
        x <- html_text(html_nodes(data, paste(".row", identifier)))
        res <- x[-1]
        res <- gsub("(\\t|\\n)", "", res)
        res[res==""] <- NA
        res
      }
      agerange <- clean_vector(".agerange")
      gender <- clean_vector(".gender")
      ratingsx <- clean_vector(".rating")
      out[[i]] <- strcapture("([0-9][.][0-9]+) [(]([0-9]+)[)]", ratingsx,
                             data.frame(rating = numeric(), count = integer()))
      out[[i]]$gender <- gender
      out[[i]]$agerange <- agerange
      out[[i]]$aid <- xaid
      .ANIDB_ENV$ANIME_RATINGS_GENDER_DIST[[said]] <- add_download_date(out[[i]])
    } else {
      out[[i]] <- .ANIDB_ENV$ANIME_RATINGS_GENDER_DIST[[said]]
    }
    if(include_title) {
      title <- primarytitles$title_primary[primarytitles$aid==xaid]
      out[[i]]$title <- title
    } else {
      out[[i]]$title <- NULL
    }
  }
  add_download_date(do.call("rbind", out))
}
