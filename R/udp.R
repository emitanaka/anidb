#' UDP send
#'
#' @param message The messaage
#' @param host The host name.
#' @param port The port number
#' @export
#' @useDynLib udp udp_send_impl
udp_send <- function(message, host = "localhost", port) {
  stopifnot(is.character(message))
  stopifnot(is.character(host))
  stopifnot(is.numeric(port))
  .Call(udp_send_impl, message, host, as.integer(port))
  invisible(NULL)
}
