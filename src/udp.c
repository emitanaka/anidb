#include <Rinternals.h>
#include <R_ext/Rdynload.h>

#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>

SEXP udp_send_impl(SEXP message, SEXP host, SEXP port) {
  const char* msg = CHAR(asChar(message));
  const char* host_ = CHAR(asChar(host));
  int port_ = asInteger(port);

  // Open the socket.
  int sock;
  struct sockaddr_in server;

  if ((sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
    Rf_error("Failed to create UDP socket.");
    return R_NilValue;
  }

  server.sin_family = AF_INET;
  server.sin_addr.s_addr = INADDR_ANY;
  server.sin_port = htons((short) port_);

  if (inet_aton(host_, &server.sin_addr) == 0) {
    Rf_error("Failed to parse host address.");
    close(sock);
    return R_NilValue;
  }

  // Send message.
  if (sendto(sock, msg, strlen(msg), 0, (struct sockaddr *) &server,
             sizeof(server)) < 0) {
    Rf_error("Failed to send message.");
  }

  close(sock);
  return R_NilValue;
}

static const R_CallMethodDef udp_entries[] = {
  {"udp_send_impl", (DL_FUNC) &udp_send_impl, 3},
  {NULL, NULL, 0}
};

void R_init_udp(DllInfo *info) {
  R_registerRoutines(info, NULL, udp_entries, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
}
