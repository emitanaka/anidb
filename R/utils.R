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

map_mold <- function(x, f, type, name = FALSE) {
  vapply(x, function(x) f(x), type, USE.NAMES = name)
}

map_chr <- function(x, f, name = FALSE) {
  map_mold(x, f, character(1), name)
}

# coerces to be integer so different to typical map
cmap_int <- function(x, f, name = FALSE) {
  map_mold(x, function(x) as.integer(f(x)), integer(1), name)
}

map_int <- function(x, f, name = FALSE) {
  map_mold(x, f, integer(1), name)
}

map_dbl <- function(x, f, name = FALSE) {
  map_mold(x, f, numeric(1), name)
}
