

#' The official anime titles
#'
#' @format A data frame that contains the official anime titles and corresponding
#'   anime ID in AniDB. The data frame also contains the attribute `date` which is
#'   the date that the database was downloaded (`attr(officialtitles, "date")`).
#'\describe{
#'  \item{aid}{Anime ID in AniDB}
#'  \item{origin}{The country of origin. There are only three: `JP` = Japan, `CN` = China, `KR` = Korea.}
#'  \item{title_primary}{The primary anime title. Primary titles are generally
#'    the Latin form of the original titles.}
#'  \item{title_en}{Official title in English (if available).}
#'  \item{title_original}{The official title in the country of origin.}
#'}
#'@source \url{https://anidb.net/}
"officialtitles"

#' The full anime titles database
#'
#' @format A data frame that contains. The data frame also contains the attribute `date` which is
#'   the date that the database was downloaded (`attr(animetitles, "date")`).
#'\describe{
#'  \item{aid}{Anime ID in AniDB}
#'  \item{type}{The title type: "short-title", "official", "primary", and "synonym".
#'    There is only one primary title per anime ID. Primary titles are written
#'    in Latin.}
#'  \item{language}{The language of the title. The Latin version of the title
#'    has the prefix "x-" and suffix "t", e.g. "x-jat" means that the corresponding
#'    `title` is the Latin version of Japanese title.}
#'  \item{title}{The anime title.}
#'}
#'@source \url{https://anidb.net/}
"animetitles"
