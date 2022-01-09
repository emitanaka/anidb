
#' Attributes of anime
#'
#' @inheritParams anime_ratings_ts
#' @return Return a data frame that contains information about anime.
#' @export
anime_info <- function(aid = NULL) {
  out <- list()
  for(i in seq_along(aid)) {
    said <- as.character(aid[i])
    xaid <- as.integer(said)
    if(!exists_and_same_date(.ANIDB_ENV$ANIME_INFO[[said]])) {
      resp <- httr::GET("http://api.anidb.net:9001/httpapi",
                        query = list(request = "anime",
                                     client = .ANIDB_ENV$CLIENT_HTTP,
                                     clientver = .ANIDB_ENV$CLIENT_HTTP_VERSION,
                                     protover = 1L,
                                     aid = xaid))
      #cont <- content(resp, as = "parsed", type = "text/xml", encoding = "UTF-8")
      cont <- content(resp, as = "text")
      if(grepl("banned", tolower(cont))) {
        abort("You have been banned. This is likely because you requested the same dataset multiple times on a single day.")
      }

      res <- XML::xmlTreeParse(cont)
      info <- XML::xmlToList(res)
      titles <- list(unique(vapply(info$titles[c(TRUE, FALSE)], function(x) x[[1]], character(1))))

      related_aid <- cmap_int(info$relatedanime[".attrs",], function(x) x['id'])
      related_type <- map_chr(info$relatedanime[".attrs",], function(x) x['type'])
      related_df <- data.frame(aid = related_aid, type = related_type, stringsAsFactors = FALSE)

      similar_aid <- cmap_int(info$similaranime[".attrs",], function(x) x['id'])
      similar_approval <- cmap_int(info$similaranime[".attrs",], function(x) x['approval'])
      similar_total <- cmap_int(info$similaranime[".attrs",], function(x) x['total'])
      similar_df <- data.frame(aid = similar_aid,
                               approval = similar_approval,
                               total = similar_total,
                               stringsAsFactors = FALSE)

      startdate <- ifelse(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", info$startdate),
                          info$startdate,
                          paste0(info$startdate, "-01"))
      enddate <- info$enddate %||% NA
      enddate <- ifelse(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", enddate) | is.na(enddate),
                        enddate,
                        paste0(enddate, "-01"))
      if(is.null(info$ratings)) {
        info$ratings <- matrix(c(NA, 0L, NA, 0L), nrow = 2,
                               dimnames = list(c("text", ".attrs"),
                                               c("permanent", "temporary")))
      }
      out[[i]] <- data.frame(aid = xaid,
                             type = info$type,
                             episode_count = info$episodecount,
                             start_date = as.Date(startdate),
                             end_date = as.Date(enddate),
                             titles = I(titles),
                             rating = as.numeric(info$ratings["text", "permanent"]),
                             rating_votes = as.integer(info$ratings[".attrs", "permanent"]),
                             rating_temp = as.numeric(info$ratings["text", "temporary"]),
                             rating_temp_votes = as.integer(info$ratings[".attrs", "temporary"]),
                             rating_review = ifelse("review" %in% colnames(info$ratings),
                                                    as.numeric(info$ratings["text", "review"]),
                                                    NA),
                             rating_review_votes = ifelse("review" %in% colnames(info$ratings),
                                                          as.integer(info$ratings[".attrs", "review"]),
                                                          0L),
                             related_anime = I(list(related_df)),
                             similar_anime = I(list(similar_df)))

      .ANIDB_ENV$ANIME_INFO[[said]] <- add_download_date(out[[i]])
    } else {
      out[[i]] <- .ANIDB_ENV$ANIME_INFO[[said]]
    }
  }

  add_download_date(do.call("rbind", out))
}
