#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>

char buffer[4096];

int main(void) {
  time_t now = time(NULL);
  for (int i = 0; i < 10; ++i) {
    switch(fork()) {
      case -1:
        perror("fork");
        exit(1);
      case 0:
        // the 2 last processes want to optimize how they write to the terminal specifically.
        // they expect the stream to be line-buffered (this is the default on terminal)
        // so they fflush(stdout) accordingly before exiting
        if (i >= 8)
          setvbuf(stdout, buffer, _IOFBF, 4096);

        printf("%d\n", i);

        // unfortunately, the last 2 processes can crash randomly before fflushing :(
        srand(now * i);
        if (i >= 8 && rand() % 2 == 0)
          _exit(1);

        if (i >= 8)
          fflush(stdout);
        _exit(0);
    }
  }

  // wait for the termination of all child processes
  while(wait(NULL) != -1);

  exit(0);
}
