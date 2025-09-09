#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

char write_buf[10] = {0};
char buffer[1024] = {0};

#define INIT_NOP();
#define INIT_UNBUFFERED() \
  setvbuf(stdout, NULL, _IONBF, 0);
#define INIT_LINE_BUFFERED() \
  setvbuf(stdout, buffer, _IOLBF, 1024);
#define INIT_FULLY_BUFFERED() \
  setvbuf(stdout, buffer, _IOFBF, 1024);

#define PRINT_NOP();
#define PRINT_PRINTF() \
  printf("%d", i);
#define PRINT_PRINTF_FFLUSH() \
  printf("%d", i); \
  fflush(stdout);
#define PRINT_PRINTF_NEWLINE() \
  printf("%d\n", i);
#define PRINT_PRINTF_NEWLINE_FFLUSH() \
  printf("%d\n", i); \
  fflush(stdout);
#define PRINT_WRITE() \
  snprintf(write_buf, 10, "%d", i); \
  if (write(1, write_buf, strlen(write_buf)) == -1) \
    perror("write");
#define PRINT_WRITE_NEWLINE() \
  snprintf(write_buf, 10, "%d\n", i); \
  if (write(1, write_buf, strlen(write_buf)) == -1) \
    perror("write");

#define EXIT_EXIT() \
  exit(0);
#define EXIT__EXIT() \
  _exit(0);
#define EXIT_SEGFAULT() \
  raise(SIGSEGV);

#define FIN_NOP();
#define FIN_WAITALL() \
  while (wait(NULL) != -1);

int main(void) {
  (void) write_buf;
  (void) buffer;

  INIT();

  for (int i = 0; i < 10; ++i) {
    switch(fork()) {
      case -1:
        perror("fork");
        exit(1);
      case 0:
        PRINT();
        EXIT();
    }
  }

  FIN();
  _exit(0);
}
