
#' Get the anime ID in AniDB from the anime title
#'
#' @param title The title of the anime.
#' @param exact A logical value indicating whether the match with `title`
#'  should be exact or not.
#' @param ignore_case Whether the case should be ignore or not
#' @param max_distance The max distance for the approximate string matching.
#'   Only used if `exact` is `FALSE`.
#' @export
anime_id <- function(title = NULL, exact = FALSE, ignore_case = TRUE, max_distance = 0.1) {
  out <- lapply(title, function(x) {
    if(exact & ignore_case) {
      unique(animetitles$aid[grep(tolower(x), tolower(animetitles$title))])
    } else if(exact & !ignore_case) {
      unique(animetitles$aid[grep(x, animetitles$title)])
    } else if(!exact & ignore_case) {
      unique(animetitles$aid[agrep(tolower(x), tolower(animetitles$title), max.distance = max_distance)])
    } else {
      unique(animetitles$aid[agrep(x, animetitles$title, max.distance = max_distance)])
    }
  })
  do.call("c", out)
}

#' Get the official anime title
#' @param aid The anime ID.
#' @param type The title type: "primary", "english" (if available) or "original".
#' @export
official_title <- function(aid, type = c("primary", "english", "original")) {
  type <- match.arg(type)
  ind <- map_int(aid, function(x) which(officialtitles$aid %in% x))
  if(type == "primary") return(officialtitles$title_primary[ind])
  if(type == "english") return(officialtitles$title_en[ind])
  if(type == "original") return(officialtitles$title_en[ind])
}
