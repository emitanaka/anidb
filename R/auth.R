#' Authenticate AniDB user
#'
#' @param user The username for AniDB
#' @param password The password used for AniDB
#' @export
anidb_authenticate_user <- function(user = NULL, password = askpass::askpass("user password")) {
  .ANIDB_ENV$USER <- user
  .ANIDB_ENV$PW <- password
  message("User authenticated")
}

.ANIDB_ENV <- new.env()
.ANIDB_ENV$CLIENT_UDP <- "anidbr"
.ANIDB_ENV$CLIENT_HTTP <- "anidbrh"
.ANIDB_ENV$CLIENT_UDP_VERSION <- 1L
.ANIDB_ENV$CLIENT_HTTP_VERSION <- 1L
.ANIDB_ENV$UASTRING <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36"
.ANIDB_ENV$LOGIN_URL <- "https://anidb.net/user/login"

anidb_session_login <- function(force = NULL) {
  already_logged_in <- force %||% .ANIDB_ENV$LOGIN_SUCCESS %||% FALSE
  if(!already_logged_in) {
    pgsession <- session(.ANIDB_ENV$LOGIN , user_agent(.ANIDB_ENV$UASTRING))
    pgform <- html_form(pgsession)[[1]]
    user <- .ANIDB_ENV$USER %||% getOption("anidb.user")
    password <- .ANIDB_ENV$PASSWORD %||% getOption("anidb.password")
    filled_form <- html_form_set(pgform, xuser = user, xpass = password)
    is_success <- function(x) {
      x$response$url=="https://anidb.net/user/login"
      # if failed the response url is "https://anidb.net/perl-bin/animedb.pl"
    }
    res <- session_submit(pgsession, filled_form)
    success <- is_success(res)
    .ANIDB_ENV$LOGIN_SUCCESS <- success
    .ANDIB_ENV$LOGIN_SESSION <- pgsession
    if(!success) {
      warning("The login was unsuccessful.")
    }
    return(success)
  }
  TRUE
}
