#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
 
enum { MAXLINE = 1024 };
volatile sig_atomic_t eflag = 0;
char *info = NULL;
 
void log_message(void) {
  fputs(info, stderr);
}
 
void correct_handler(int signum) {
  eflag = 1;
}
 
void invalid_handler(int signum) {
  log_message();
  free(info);
  info = NULL;
}
 
int main(void) {
  if (signal(SIGINT, correct_handler) == SIG_ERR) {
    /* Handle error */
  }
  info = (char *)malloc(MAXLINE);
  if (info == NULL) {
    /* Handle error */
  }
 
  while (!eflag) {
    /* Main loop program code */
 
    log_message();
 
    /* More program code */
  }
 
  log_message();
  free(info);
  info = NULL;
 
  return 0;
}