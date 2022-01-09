add_download_date <- function(x) {
  attr(x, "date") <- Sys.Date()
  x
}

download_date <- function(x) {
  attr(x, "date")
}

exists_and_same_date <- function(x) {
  if(is.null(x)) return(FALSE)
  download_date(x)==Sys.Date()
}
